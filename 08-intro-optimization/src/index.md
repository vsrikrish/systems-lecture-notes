class: center, middle

.title[Introduction to Optimization]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[September 21, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Questions?
2. Components of Optimization Problems
3. Approaches to Solutions

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

- Decision Models
- Revisited CRUD Wastewater Example
- Waste Load Allocation Modeling

---
class: left

# Components of an Optimization Model
<hr>

- **Objective Function**: The "target" function to be minimized or maximized.
- **Decision Variables**: Variables which can be changed to affect objective.
- **Constraints**: Limits on decision variable values.
- **Feasible Solution**: Decision variable values satisfying constraints.
- **Optimal Solution**: The "best" feasible solution or solutions (with respect to the objective)

---
template: poll-answer

***How do we solve an optimization problem?***

---
class: left

# Solution Approach 1: Trial and Error
<hr>

**What are some challenges?**

---
class: left

# Solution Approach 1: Trial and Error
<hr>

Challenges:
- Many possible solutions (infinitely many when a problem is continuous)
- Feasible region may not be intuitive
- How do we know when we've found an optimal solution?

---
class: left

# Solution Approach 2: Generalized Search Algorithms
<hr>

```@eval
using Plots
using Measures

f(x) = 4 .* x.^4 - 10 .* (x.+2).^3 - 6 .* (x.-15).^2 + 2 .* (x.+4).^2
x = -4:0.01:5
plot(x, f(x), grid=false, linewidth=3, label=false, yticks=false, xticks=false, ylabel="Objective", xlabel="Decision Variable", left_margin=8mm)
scatter!([-2.36 3.69], f.([-2.36 3.69]), color=[:blue :red], markersize=[8 12], label=["Local Optimum" "Global Optimum"])
ylims!((-1800, -1100))
xlims!((-4, 5))

savefig("multiple-optima.svg")
nothing # hide
```

.left-column[![Function with Multiple Minima](figures/multiple-optima.svg)]

.right-column[Most search algorithms look for critical points to find candidate optima. Then the "best" of the critical points is the **global optimum**.]

---
class: left

# Solution Approach 2: Generalized Search Algorithms
<hr>

.left-column[![Function with Multiple Minima](figures/multiple-optima.svg)]

.right-column[Two common approaches:
- **Gradient-based methods**
- **Evolutionary algorithms**

These methods work pretty well, but can require a lot of evaluations and/or may get stuck at local optima.
]

---
class: left

# Solution Approach 2: Generalized Search Algorithms
<hr>

```@eval
using Plots
using Measures

f(x) = 4 .* x.^4 - 10 .* (x.+2).^3 - 6 .* (x.-15).^2 + 2 .* (x.+4).^2
x1 = -4:0.01:3.1
x2 = 3.1:0.01:5
plot(x1, f(x1), grid=false, linewidth=3, label=false, yticks=false, xticks=false, ylabel="Objective", xlabel="Decision Variable", left_margin=8mm)
plot!(x2, f(x2), linestyle=:dash, color=:purple, linewidth=3, label=false)
vline!([3.1], color=:orange, linewidth=5, label=false)
scatter!([-2.36 3.1], f.([-2.36 3.1]), color=[:blue :red], markersize=[8 12], label=["Local Optimum" "Constrained Optimum"])
ylims!((-1800, -1100))
xlims!((-4, 5))

savefig("multiple-optima-constrained.svg")
nothing # hide
```

.left-column[![Function with Multiple Minima and a Constraint](figures/multiple-optima-constrained.svg)]

.right-column[Now, notice the effect of a constraint!

For a constrained problem, we also have to look along the constraint to see if that creates a solution.]

---
class: left

# Lagrange Multipliers
<hr>

We can solve some constrained problems using Lagrange Multipliers!

Recall (maybe) that the Lagrange Multipliers method requires *equality* constraints. But we can easily create those with "dummy" variables.

--

.left-column[
**Original Problem**

$$\begin{aligned}
& \min &&f(x_1, x_2) \notag \\\\
& \text{subject to:} && x_1 \geq A \notag \\\\
& && x_2 \leq B \notag
\end{aligned}$$
]

.right-column[
**With Dummy Variables**

$$\begin{aligned}
& \min &&f(x_1, x_2) \notag \\\\
& \text{subject to:} && x_1 - S_1^2 = A \notag \\\\
& && x_2 + S_2^2 = B \notag
\end{aligned}$$
]

---
class: left

# Lagrange Multipliers
<hr>

Then the Lagrangian function becomes:

$$H(\mathbf{x}, S_1, S_2, \lambda_1, \lambda_2) = f(\mathbf{x}) - \lambda_1(x_1 - S_1^2 - A) - \lambda_2(x_2 + S_2^2 - B)$$

where $\lambda_1$, $\lambda_2$ are penalties for violating the constraints.

The $\lambda_i$ are the eponymous *Lagrange multipliers*.

---
class: left

# Lagrange Multipliers
<hr>

Next step: locate possible optima where the partial derivatives of the Lagrangian are zero.

$$\begin{equation}\frac{\partial H(\cdot)}{\partial \cdot} = 0\end{equation}$$

--

Challenges are that Equation (1) is actually many equations, even though our original problem was low-dimensional, and so this can be slow.

But many advanced search methods are based on a variant of the Lagrange multiplier method.

---
class: left

# Linear Optimization Models
<hr>

Linear models are simpler!

Recall that a function $f(x_1, \ldots, x_n)$ is *linear* if

$$f(x_1, \ldots, x_n) = a_1x_1 + a_2x_2 + \ldots + a_nx_n.$$

--

The advantage of working with linear models is their geometry is simple, even if they're high-dimensional.

---
class: left

# Linear Programs
<hr>

A **linear program (LP)**  has the following characteristics:

--

- *Linearity*: The objective function and constraints are all linear.

--

- *Divisibility*: The decision variables are continuous (they can be fractional levels, not restricted to integers).

--

- *Certainty*: The problem is deterministic.

---
class: left

# Linear Programs
<hr>

Notice that our CRUD management example is not linear, as the objective (cost) function was quadratic, 

$$C(E_1, E_2) = 5000E_1^2 + 3000E_2^2.$$

.left-column[
We can approximate nonlinear functions by *linearizing* them.

This is called the **linear relaxation** of the original problem.]

.right-column[
```@eval
using Plots
using LaTeXStrings
using Measures

E = 0:0.1:1
plot(E, E.^2, legend=false, grid=false, xlabel="Efficiency", ylabel="Cost", color=:black, yticks=false, xlims=(0, 1), ylims=(0, 1), left_margin=8mm, linewidth=3)
xticks!([0.65, 0.95])
scatter!([0.65, 0.95], [0.65, 0.95].^2, markersize=10, color=:red)
plot!(E, 1.6 .* E  .- 0.6175, color=:blue, linestyle=:dash, linewidth=3)
plot!(E, 1.3 .* E  .- 0.31, color=:red, linestyle=:dot, linewidth=3)
plot!(size=(350, 350))

savefig("linear-relax.svg")
```

.center[![Linear Relaxation of Cost](figures/linear-relax.svg)]
]

---
class: left

# Why is Solving LPs Straightforward?
<hr>

```@eval
using Plots
using LaTeXStrings
using Measures

x = 2:0.1:11
f1(x) = 4.5 .* x
f2(x) = -x .+ 16
f3(x) = -1.5 .* x .+ 12
f4(x) = 0.5 .* x

plot(x, max.(f3(x), f4(x)), fillrange=min.(f1(x), f2(x)), color=:lightblue, grid=true, legend=false, xlabel=L"x", ylabel=L"y", xlims=(-2, 20), framestyle=:origin, ylims=(-2, 20), minorticks=5, aspect_ratio=1)
plot!(-2:0.1:20, f1.(-2:0.1:20), color=:green, linewidth=3)
plot!(-2:0.1:20, f2.(-2:0.1:20), color=:red, linewidth=3)
plot!(-2:0.1:20, f3.(-2:0.1:20), color=:brown, linewidth=3)
plot!(-2:0.1:20, f4.(-2:0.1:20), color=:purple, linewidth=3)
plot!(size=(800, 800))

savefig("lp-polytope.svg")
```

.left-column[All solutions must exist on the boundary of the feasible region (which must be a *polytope*).

More specifically, an optimum solution must occur at the intersection of constraints, so all you need to do is to find and analyze the corners. This is the basis of all *simplex* methods for solving LPs.]

.right-column[.center[![Linear Programming Feasible Polytope](figures/lp-polytope.svg)]]


---
class: left

# Example: Solving an LP
<hr>

.left-column[$$\begin{alignedat}{3}
& \max_{x_1, x_2} &  230x_1 + 120x_2 &  \\\\
& \text{subject to:} & &\\\\
& & 0.9x_1 + 0.5x_2 &\leq 600 \\\\
& & x_1 + x_2 &\leq 1000 \\\\
& & x_1, x_2 &\geq 0
\end{alignedat}$$]

```@eval
using Plots
using LaTeXStrings
using Measures

x1 = 0:1200
x2 = 0:1400
f1(x) = (600 .- 0.9 .* x) ./ 0.5
f2(x) = 1000 .- x

plot(0:667, min.(f1(0:667), f2(0:667)), fillrange=0, color=:lightblue, grid=true, label="Feasible Region", xlabel=L"x_1", ylabel=L"x_2", xlims=(-50, 1200), ylims=(-50, 1400), framestyle=:origin, minorticks=4, right_margin=4mm, left_margin=4mm, aspect_ratio=1)
plot!(0:667, f1.(0:667), color=:brown, linewidth=3, label=false)
plot!(0:1000, f2.(0:1000), color=:red, linewidth=3, label=false)
annotate!(275, 1200, text(L"0.9x_1 + 0.5x_2 = 600", color=:purple, pointsize=18))
annotate!(925, 300, text(L"x_1 + x_2 = 1000", color=:red, pointsize=18))
plot!(size=(800, 800))

savefig("lp-example-feasible.svg")
```

.right-column[.center[![Feasible Region for Example](figures/lp-example-feasible.svg)]] 

---
class: left

# Example: Solving an LP
<hr>

.left-column[$$\begin{alignedat}{3}
& \max_{x_1, x_2} &  230x_1 + 120x_2 &  \\\\
& \text{subject to:} & &\\\\
& & 0.9x_1 + 0.5x_2 &\leq 600 \\\\
& & x_1 + x_2 &\leq 1000 \\\\
& & x_1, x_2 &\geq 0
\end{alignedat}$$]

```@eval
using Plots
using LaTeXStrings
using Measures

x1 = 0:1200
x2 = 0:1400
f1(x) = (600 .- 0.9 .* x) ./ 0.5
f2(x) = 1000 .- x
Z(x1,x2) = 230 * x1 + 120 * x2

plot(0:667, min.(f1(0:667), f2(0:667)), fillrange=0, color=:lightblue, grid=true, label="Feasible Region", xlabel=L"x_1", ylabel=L"x_2", xlims=(-50, 1200), ylims=(-50, 1400), framestyle=:origin, minorticks=4, right_margin=4mm, left_margin=4mm, aspect_ratio=1)
plot!(0:667, f1.(0:667), color=:brown, linewidth=3, label=false)
plot!(0:1000, f2.(0:1000), color=:red, linewidth=3, label=false)
annotate!(275, 1200, text(L"0.9x_1 + 0.5x_2 = 600", color=:purple, pointsize=18))
annotate!(925, 300, text(L"x_1 + x_2 = 1000", color=:red, pointsize=18))
plot!(size=(800, 800))

contour!(0:660,0:1000,(x1,x2)->Z(x1,x2), nlevels=[50000, 100000, 150000], 
  c=:devon, linewidth=2, colorbar = false, 
  contour_labels = true) 

savefig("lp-example-contour.svg")
```

.right-column[![Feasible Region for Example](figures/lp-example-contour.svg)]

---
class: left

# Example: Solving an LP
<hr>


.left-column[Now we can explore the corner points to find which optimizes the objective.

Point ($(x_1, x_2)$) | Objective
:------------: | -------------:
$(0,0)$      | $0$
$(0, 1000)$ | $12000$
$(667, 0)$  | $153410$
$(250, 750)$ | $147500$
]

```@eval
using Plots
using LaTeXStrings
using Measures

x1 = 0:1200
x2 = 0:1400
f1(x) = (600 .- 0.9 .* x) ./ 0.5
f2(x) = 1000 .- x
Z(x1,x2) = 230 * x1 + 120 * x2

plot(0:667, min.(f1(0:667), f2(0:667)), fillrange=0, color=:lightblue, grid=true, label="Feasible Region", xlabel=L"x_1", ylabel=L"x_2", xlims=(-50, 1200), ylims=(-50, 1400), framestyle=:origin, minorticks=4, right_margin=4mm, left_margin=4mm, aspect_ratio=1)
plot!(0:667, f1.(0:667), color=:brown, linewidth=3, label=false)
plot!(0:1000, f2.(0:1000), color=:red, linewidth=3, label=false)
annotate!(275, 1200, text(L"0.9x_1 + 0.5x_2 = 600", color=:purple, pointsize=18))
annotate!(925, 300, text(L"x_1 + x_2 = 1000", color=:red, pointsize=18))
plot!(size=(800, 800))

scatter!([0, 0, 667, 250], [0, 1000, 0, 750], markersize=10, z=2, legend=false, markercolor=:orange)

savefig("lp-example-extrema.svg")
```


.right-column[![Feasible Region for Example](figures/lp-example-extrema.svg)]

---
class: left

# Recap
<hr>

- Trial and error: not a great approach!
- Search algorithms: better!
- Linear Programs: straightforward to solve!
- An optimum must occur at a corner of the feasible polytope.

---
class: center, middle

<hr>
# Next Class
<hr>

- Guest lecture by Mel Jensen, Cornell librarian
- Regulatory Review Project
- **After that**: How to use Julia to solve optimization problems.