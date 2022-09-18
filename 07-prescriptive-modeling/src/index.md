class: center, middle

.title[Prescriptive Modeling and Waste Load Allocation]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[September 19, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Questions?
2. Prescriptive Modeling
3. Waste Load Allocation Problems

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

- Fate and Transport Modeling
- Dissolved Oxygen
- Simulation Workflow

---
class: left

# CRUD, Revisited
<hr>

.center[![CRUD Wastewater System](figures/river_diagram.png)]

Recall the CRUD wastewater model from [Lecture 2](https://viveks.me/environmental-systems-analysis/assets/lecture-notes/02-intro-modeling/index.html#13).

---
class: left

# CRUD, Revisited
<hr>

.center[![CRUD Wastewater System](figures/river_diagram.png)]

Environmental authorities have sampled water from the river and determined that concentrations exceed the legal standard (1 mg/L).

---
class: left

# CRUD, Revisited
<hr>

.center[![CRUD Wastewater System](figures/river_diagram.png)]

We want to design a CRUD removal plan to get back in compliance.

---
class: left

# Prescriptive Modeling
<hr>

If we want to design a treatment strategy, we are now in the world of *prescriptive modeling*.

**Recall**: Precriptive modeling is intended to specify an action, policy, or decision.

--

- Descriptive modeling question: "What happens if I do something?"

- Prescriptive modeling question: "What should I do?"

---
class: left

# Decision Model Components
<hr>

This means that we need a *decision model*.

What information do we need to specify a decision?

---
class: left

# Components of a Decision Model
<hr>

**Objective**: What are we trying to *do*?
- *e.g* minimizing cost or impact

**Constraints**: What limits do we have to observe?
- *e.g.* budgetary or regulatory constraints

---
class: left

# Decision Model for CRUD Treatment
<hr>

Let's apply this framework to the CRUD release problem.

- What might our objective be?
- What constraints do we have?

---
class: left

# Formulating An Objective
<hr>

.center[![CRUD Wastewater System](figures/river_diagram.png)]

Let's say that our objective is to minimize costs, and relevant constraints include the regulatory standard.

---
class: left

# Formulating An Objective
<hr>

.center[![CRUD Wastewater System](figures/river_diagram.png)]

Treating CRUD costs $ \\$50 E^2 \text{ per } 1000 \  m^3,$ where $E$ is the treatment efficiency.

---
class: left

# Formulating An Objective
<hr>

.center[![CRUD Wastewater System](figures/river_diagram.png)]

This makes the treatment cost

$$C(E_1, E_2) = 50(100)E_1^2 + 50(60)E_2^2 = 5000E_1^2 + 3000E_2^2.$$

---
class: left

# Formulating An Objective
<hr>

Treatment Cost: 

$$$C(E_1, E_2) = 50(100)E_1^2 + 50(60)E_2^2 = 5000E_1^2 + 3000E_2^2.$$

Then the objective is to minimize the cost, or

$$\min_{E_1, E_2} 5000E_1^2 + 3000E_2^2.$$

---
class: left

# Developing Constraints
<hr>

But we can't choose just any $E_1$ and $E_2$ to minimize the cost, or we would just choose $E_1=E_2=0$.

--

For example, we need to comply with the regulatory standard: 

CRUD concentration $< 1$ mg/l.

---
class: left

# Developing Constraints
<hr>

**What information can we bring to bear?**

--

Since we know that the concentrations are highest at the points of discharge, we can check whether each of those points is in compliance with the standard.

---
class: left

# Mass Balance at Point 1
<hr>

.center[![](figures/crud-release-1-treated.svg)]

Total CRUD after factory 1 release: $\color{blue}\text{100} + \color{red} 1000(1-E_1) \color{black} \ \text{kg/d}$


---
class: left

# Mass Balance at Point 1
<hr>

.center[![](figures/crud-release-1-treated.svg)]

Our standard is $1 \ \text{mg/L} = 10^{-3} \ \text{kg/m}^3$, and the volume of the inflow is $\color{blue}500,000 + \color{red}100,000 \color{black}= 600,000 \ \text{m}^3\text{/d}$.

---
class: left

# Constraint at Point 1
<hr>

So:

$$\begin{aligned}
100 + 1000(1-E_1) &\leq 600 \\\\
\color{blue}1000E_1 &\color{blue}\geq 500
\end{aligned}$$

---
class: left

# Mass Balance at Release 2
<hr>

.center[![](figures/crud-release-2-treated.svg)]

We [had derived](https://viveks.me/environmental-systems-analysis/assets/lecture-notes/02-intro-modeling/index.html#31) that the CRUD concentration at release 2 is:

$$(1100 - 1000E_1) \exp(-0.18) + 1200(1 - E_2) \ \text{kg/d}.$$

---
class: left

# Mass Balance At Release 2
<hr>

.center[![](figures/crud-release-2-treated.svg)]

The volume at release 2 is $660,000 \ \text{m}^3\text{/d}$, so the constraint is:

$$(1100 - 1000E_1) \exp(-0.18) + 1200(1 - E_2) \leq 660.$$

---
class: left

# Constraint At Release 2
<hr>

Simplifying:

$$\begin{aligned}
(1100 - 1000E_1) \exp(-0.18) + 1200(1 - E_2) &\leq 660  \\\\
(1100 - 1000E_1) 0.835 + 1200(1 - E_2) &\leq 660  \\\\
2119 - 835E_1 - 1200E_2 &\leq 660\\\\
\color{blue} 835E_1 + 1200E_2 &\color{blue}\geq 1459
\end{aligned}$$

---
class: left

# Model Formulation
<hr>

Combining our objective and our regulatory constraints:

$$\begin{alignat}{3}
& \min_{E_1, E_2} &\color{green}\quad  5000E_1^2 + 3000E_2^2 & \notag \\\\
& \text{subject to:} & \color{blue}1000 E_1 &\color{blue}\geq 500 \notag \\\\
& & \color{blue}835E_1 + 1200E_2 &\color{blue}\geq 1459 \notag \\\\
\end{alignat}$$

--

**Is this complete?**

---
class: left

# Model Formulation
<hr>

$$\begin{alignat}{3}
& \min_{E_1, E_2} &\color{green}\quad  5000E_1^2 + 3000E_2^2 &  \\\\
& \text{subject to:} & \color{blue}1000 E_1 &\color{blue}\geq 500 \\\\
& & \color{blue}835E_1 + 1200E_2 &\color{blue}\geq 1459 \\\\
& & \color{purple}E_1, E_2 &\color{purple}\geq 0 \\\\
& & \color{purple}E_1, E_2 &\color{purple}\leq 1
\end{alignat}$$

---
class: left

# Ok...so how do we solve this?
<hr>

More general discussion next time, but this example is relatively straightforward to solve graphically.

---
class: left

# Plot the Decision Space
<hr>

.left-column[
```@example crud-plot
using Plots
using LaTeXStrings
using Measures

# define objective function
a = range(0, 1, step=0.05)
b = range(0, 1, step=0.05)
f(a, b) = 5000 * a.^2 + 3000 * b.^2
# plotting contours
contour(a,b,(a,b)->f(a,b), nlevels=15, 
  c=:heat, linewidth=5, colorbar = false, 
  contour_labels = true, grid = false, 
  right_margin=8mm) 
xaxis!(L"E_1", ticks=0:0.1:1, 
  limits=(0, 1))
yaxis!(L"E_2", ticks=0:0.1:1, 
  limits=(0, 1))
plot!(size=(600, 600)) # hide
savefig("crud-base-plot.svg") # hide
```
]

.right-column[![CRUD Problem Decision Space](figures/crud-base-plot.svg)]

---
class: left

# Plot the Feasible Region
<hr>

.left-column[
```@example crud-plot
# plot constraints
vline!([0.5], color=:green, linewidth=3,
  label=false) # Equation 2
plot!(a, (1459 .- 835 .* a) ./ 1200, 
  color=:green, linewidth=3,
  label=false) # Equation 3
# plot feasible region
fa = a[a .>= 0.5]
fb = (1459 .- 835 .* a[a .>= 0.5])./1200
plot!(fa, fb, fillrange=1, 
  label="Feasible Region", opacity=0.4, 
  color=:green, legend=:bottomleft)
scatter!([0.5], [(1459 - 835 * 0.5) / 1200],
  markershape=:star, color=:yellow, 
  markersize=20, label="Optimum")
plot!(right_margin=8mm) #hide
plot!(size=(600, 600)) # hide
savefig("crud-feasible-plot.svg") # hide
```
]

.right-column[![CRUD Problem Feasible Region](figures/crud-feasible-plot.svg)
]

---
class: left

# The Solution!
<hr>

.left-column[So the solution occurs at the intersection of the two constraints, where:

$$E_1 = 0.5, E_2 = 0.85$$

and the cost of this treatment plan is 

$$C(0.5, 0.85) = \$ 3417.$$

**Does this solution make sense**?

]
.right-column[![CRUD Problem Feasible Region](figures/crud-feasible-plot.svg)
]


---
class: left

# Waste Load Allocation Problems
<hr>

.center[![Environmental Systems Model Schematic](figures/system-environmental.svg)]

This is an example of a *waste load allocation* problem.

---
class: left

# Waste Load Allocation Problems
<hr>

.center[![Environmental Systems Model Schematic](figures/system-environmental.svg)]


**Key question**: How do we restrict waste discharges to control or limit environmental impact?

---
center: left

# Waste Load Allocation Problems
<hr>

.center[![Environmental Systems Model Schematic](figures/system-environmental.svg)]

Each source is allocated a "load" they can discharge based on waste fate and transport.

---
class: left

# Waste Load Allocation Problem
<hr>

Waste loads affect quality $Q$ based on F&T model: 

$$Q=f(W_1, W_2, \ldots, W_n)$$

--

So the general form for a prescriptive waste load allocation model:

$$\begin{aligned}
\text{determine} & \quad  W_1, W_2, \ldots, W_n \notag \\\\
\text{subject to:} & \quad f(W_1, W_2, \ldots, W_n) \geq Q^* \notag
\end{aligned}$$

--

How do we choose certain variables to **optimize** a target outcome, possibly subject to some constraints.

---
class: middle, center

<hr>
# Next Class
<hr>

- Optimization Models
- Solution Methods
- Solving the CRUD Example