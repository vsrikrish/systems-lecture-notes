class: center, middle

.title[Using JuMP For Optimization in Julia]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[September 28, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Questions?
2. Using JuMP

---
name: poll-answer

layout: true

class: left

# Poll
<hr>

.left-column[{{content}}

URL: <https://pollev.com/vsrikrish>

Text: **VSRIKRISH** to 22333, then message]

.right-column[.center[![Poll Everywhere QR Code](figures/vsrikrish-polleverywhere.png)]]

---
name: questions

template: poll-answer

***Any questions?***

---
layout: false

# Last Class
<hr>

- Introduction to Optimization
- Search Algorithms
- Constrained Problems and Lagrange Multipliers
- Linear Programs

---
class: left

# Solving Optimization Problems in Julia
<hr>

The key package is [`JuMP.jl`](https://jump.dev/JuMP.jl/stable/).

`JuMP` provides tools to solve various types of optimization problems.

--

The key advantage of `JuMP` is that it allows for specification of optimization problems in a very intuitive syntax.

---
class: left

# Using `JuMP.jl`
<hr>


Need to load `JuMP` and a *solver* package. Table of solvers available [here](https://jump.dev/JuMP.jl/stable/installation/#Supported-solvers).

--

Which solver you pick depends on:
- Type of problem (LP, etc)
- License (we'll stick with non-commercial licenses)

.left-column[
  ```@example pesticide
using JuMP
using HiGHS
nothing # hide
```
]

.right-column[We'll use `HiGHS` for LPs. But it doesn't work for nonlinear problems!]

---
class: left

# Example: Pesticide Application
<hr>

Let's use a pesticide application LP example to illustrate how to use `JuMP`.

This is an example of a *resource allocation* problems.

.center[![Resource Allocation Problem Schematic](figures/resource-allocation-schematic.svg)]

---
class: left

name: pesticide-data

# Pesticide Example
<hr>

A farmer has access to a pesticide which can be used on corn, soybeans, and wheat fields and costs $\$70/\text{ha-yr}$ to apply. 

.left-column[The following crop yields can be obtained:

Pesticide Application (kg/ha) | Soybean Yields (kg/ha) | Wheat Yields (kg/ha) | Corn Yields (kg/ha)
:---------------------------: | :--------------------: | :------------------: | :----------------: | 
0              |       2900 | 3500 | 5900
1 | 3800 | 4100 | 6700
2 | 4400 | 4200 | 7900
]

.right-column[Production costs, *excluding pesticide*, and selling prices:

Crop | Annual Production Costs (\$/ha-yr) | Selling Prices (\$/kg)
:------------: | :-------------: | :------------:
Soybeans | 350 | 0.36 
Wheat | 280 | 0.27 
Corn | 390 | 0.22 
]

---
class: left

# Pesticide Example
<hr>

Recently, environmental authorities have declared that the farmer's *average* application rate on corn, soybeans, and wheat cannot exceed 0.6 kg/ha, 0.8 kg/ha, and 0.7 kg/ha, respectively.

How should the farmer plant crops and apply pesticides to maximize profits over 130 total ha if demand for each crop is 250,000 kg?

---
class: left

# Pesticide Example
<hr>

Now, let's create our model with `JuMP`.

```@example pesticide
farm_model = Model(HiGHS.Optimizer)
```

---
class: left

# Pesticide Example: Notation
<hr>

First, let's establish some notation.

---
template: poll-answer

***What are our decision variables?***

---
class: left

# Pesticide Example: Notation
<hr>

First, let's establish some notation.


**Decision Variables**:

Variable | Meaning
:-------:|:-------
$S_j$ | ha planted with soybeans with pesticide rate $j=0, 1, 2$
$C_j$ | ha planted with corn with pesticide rate $j=0, 1, 2$
$W_j$ | ha planted with wheat with pesticide rate $j=0, 1, 2$.

---
class: left

# Pesticide Example: Notation
<hr>

To add these variables into our `JuMP` model, use `@variable`:

```@example pesticide
@variable(farm_model, S[1:3] >= 0) # soy
@variable(farm_model, W[1:3] >= 0) # wheat
@variable(farm_model, C[1:3] >= 0) # corn
```
---
class: left

# Pesticide Example: Formulate Objective
<hr>

Next, let's formulate the objective function with the goal of maximizing profits. 

---
template: poll-answer

***What information is relevant for the objective?***

---
class: left

# Pesticide Example: Formulate Objective
<hr>

Next, let's formulate the objective function with the goal of maximizing profits. 

**Take some time to work on this.**

---
template: pesticide-data

---
class: left

# Pesticide Example: Formulate Objective
<hr>

**Key**: Compute profit for each hectare by crop and pesticide rate:

$$Z = \sum_{\text{crop}, i} \left[\left(\text{yield} \times \text{selling price}\right) - \text{total cost}\right]$$

--

After some algebra:

$$\begin{aligned}
Z = & 694S_0 + 948S_1 + 1164S_2 \\\\
& + 665W_0+757W_1+784W_2 \\\\
& + 908C_0+1014C_1+1278C_2
\end{aligned}$$

---
class: left

# Pesticide Example: Formulate Objective
<hr>

To put this objective into our `JuMP` model, use `@objective`:

```@example pesticide
@objective(farm_model, Max, 694S[1] + 948S[2] + 1164S[3] + 665W[1] + 757W[2] + 
  784W[3] + 908C[1] + 1014C[2] + 1278C[3])
```

Another way to write this, using vector arithmetic:

```julia
@objective(farm_model, Max, [694; 948; 1164]' * S + [665; 757; 784]' * 
  W + [908; 1014; 1278]' * C)
```

---
class: left

# Pesticide Example: Constraints
<hr>

What are our constraints?

---
template: poll-answer

***What information is relevant for constraints?***

---

class: left

# Pesticide Example: Constraints
<hr>

What are our constraints?

--

- **Land area**: total used farmland area cannot exceed 130 ha.
- **Demand**: No reason to grow more than 250,000 kg of any single crop.
- **Regulation**: Average pesticide rates cannot exceed limit for each crop.
- **Non-negativit**y**: No land allocation can be less than 0.

---
class: left

layout: true

# Pesticide Example: Constraints
<hr>

{{content}}

---

Let's develop these constraints and put them into `JuMP`.

---

## Land Area

--

$$S_0 + S_1 + S_2 + W_0 + W_1 + W_2 + C_0 + C_1 + C_2 \leq 130$$

```@example pesticide
@constraint(farm_model, area, sum(S) + sum(W) + sum(C) <= 130)
```

---

## Demand

--

$$2900S_0 + 3800S_1 + 4400S_2   \leq 250000$$

$$3500W_0 + 4100W_1 + 4200W_2 \leq 250000$$

$$5900C_0 + 6700C_1 + 7900C_2 \leq 250000$$

```@example pesticide
@constraint(farm_model, soy_demand, [2900; 3800; 4400]' * S <= 250000)
@constraint(farm_model, wheat_demand, [3500; 4100; 4200]' * W <= 250000)
@constraint(farm_model, corn_demand, [5900; 6700; 7900]' * C <= 250000)
```

---

## Regulatory Limits

--

$$\frac{S_1 + 2S_2}{S_0+S_1+S_2} \leq 0.8$$

--

But these need to be linear! So:

$$S_1 + 2S_2 \leq 0.8(S_0 + S_1 + S_2) \Rightarrow -0.8 S_0 + 0.2 S_1 + 1.2S_2 \leq 0$$

---

Similarly,

$$\begin{aligned}
& W_1 + 2W_2 \leq 0.7(W_0 + W_1 + W_2) \\\\
& \Rightarrow -0.7 W_0 + 0.3 W_1 + 1.3 W_2 \leq 0
\end{aligned}$$
$$C_1 + 2C_2 \leq 0.6(C_0 + C_1 + C_2) \Rightarrow -0.6 C_0 + 0.4 C_1 + 1.4 C_2 \leq 0$$

```@example pesticide
@constraint(farm_model, soy_pesticide, [-0.8; 0.2; 1.2]' * S <= 0)
@constraint(farm_model, wheat_pesticide, [-0.7; 0.3; 1.3]' * W <= 0)
@constraint(farm_model, corn_pesticide, [-0.6; 0.4; 1.4]' * C <= 0)
```

---
 
## Non-Negativity

We actually imposed the non-negativity constraints

$$S_i, W_i, C_i >= 0$$

when we defined the variables!

---
class: left

layout: false

# Final Model: Printing

```@example pesticide
print(farm_model)
```

---
class: left

# Final Model: LaTeX
<hr>

```@example pesticide
latex_formulation(farm_model)
```

---
class: left

# Let's Solve!
<hr>

To solve, run `optimize!()`.

```@example pesticide
optimize!(farm_model)
```

---
class: left

# Exploring the Solution
<hr>

```@example pesticide
solution_summary(farm_model)
```

---
class: left

# Exploring the Solution
<hr>


To get the optimal objective value, use `objective_value()`.

```@example pesticide
objective_value(farm_model)
```

---
class: left

# Exploring the Solution
<hr>

Optimal variable values can be accessed with `value()`.
```@example pesticide
value.(S)
```

`value()` is broadcasted over `S` above because `S` is a vector of variables.

---
class: left

# Exploring the Solution
<hr>

```@example pesticide
value.(C)
```

---
class: left

# Exploring the Solution
<hr>

```@example pesticide
value.(W)
```

---
class: left

# Exploring the Solution
<hr>

So, to optimize profits, the farmer should allocate land accordingly:

Pesticide Application (kg/ha) | Soybean Area (ha) | Wheat Area (ha) | Corn Area (ha) |
:--------: | --------: | --------: | --------: 
0 |   13.9 | 26.9 | 6.7
1 | 55.2 | 0 | 15.7
2 | 0 | 11.5 | 0

This will result in a profit of \$117,549.

---
class: left

# Binding Constraints
<hr>

Recall that the solution will be found at one of the corner points of the feasible polytope.

This means that one or more constraint is **binding**: if we *relaxed* the constraint, we could improve the solution.

---
class: left

# Shadow Prices
<hr>

The *marginal cost* of the constraints, or the rate at which the solution could improve if the constraint capacity was relaxed by one unit, is captured by the *shadow price*.

Non-zero shadow prices tell us that the constraint is binding.

The value tells us which is most impactful on a per-unit basis. 

---
class: left

# Shadow Prices
<hr>

The shadow prices are the *dual variables* of the constraints. We can access those with `shadow_price()` when they exist (which we can check with `has_duals()`).

```@example pesticide
has_duals(farm_model)
```

---
class: left

# Shadow Prices
<hr>

```@example pesticide
shadow_price(soy_pesticide)
```

```@example pesticide
shadow_price(corn_pesticide)
```

```@example pesticide
shadow_price(wheat_pesticide)
```

---
class: left

# Shadow Prices
<hr>

```@example pesticide
shadow_price(soy_demand)
```

```@example pesticide
shadow_price(wheat_demand)
```

```@example pesticide
shadow_price(corn_demand)
```

---
class: left

# Shadow Prices
<hr>

```@example pesticide
shadow_price(area)
```

---
class: left

# Shadow Prices
<hr>

What can we learn from this analysis?

- The farmer is meeting demand for soy and corn, but not wheat.
- All of the pesticide constraints are binding. 
- The farmer is using all possible farmland (binding area constraint).
- The most valuable change would be to increase land (\$729/ha), then increasing the soy and corn pesticide limits.
- The demand shadow prices look small, but think about scale (they're still the least impactful)!

---
class: left

# Shadow Prices and Lagrange Multipliers
<hr>

Where do shadow prices come from? They are the Lagrange Multipliers!

If our inequality constraints $X \geq A$ and $X \leq B$ are written as $X - S_1^2 = A$  and $X + S_2^2 = B$:

$$H(X, S_1, S_2, \lambda_1, \lambda_2) = Z(X) - \lambda_1(X - S_1^2 - A) - \lambda_2(X + S_2^2 - B)$$ 

and 

$$\frac{\partial H}{\partial A }= \lambda_1 \text{ and } \frac{\partial H}{\partial B} = \lambda_2.$$

---
class: left

# A `JuMP` tip
<hr>

`JuMP` is great, because it lets us construct models with a very intuitive syntax.

However,`JuMP` does not like it when you try to redefine variables and constraints by overwriting ones that already exist with `@variable` and `@constraint`. For example:

```julia
@constraint(farm_model, area, sum(S) + sum(W) + sum(C) <= 150)
```
would return an error.

---
class: left

# Updating Models
<hr>

Instead, if you need to redefine a model, you can create a new model, `delete()` the relevant component, or use the modification commands, such as:
- [`set_normalized_coefficient`](https://jump.dev/JuMP.jl/stable/reference/constraints/#JuMP.set_normalized_coefficient): change a variable coefficient in a constraint
- [`set_normalized_rhs`](https://jump.dev/JuMP.jl/stable/reference/constraints/#JuMP.set_normalized_rhs): change constraint capacity
- [`set_lower_bound`](https://jump.dev/JuMP.jl/stable/reference/variables/#JuMP.set_lower_bound): change variable lower bound
- [`set_upper_bound`](https://jump.dev/JuMP.jl/stable/reference/variables/#JuMP.set_upper_bound): change variable upper bound

As always, make sure to look at the documentation!

---
class: middle, center

<hr>
# Next Class
<hr>

- Hands-on example with `JuMP`.
- Bring laptop, and `git pull` the class examples repository!