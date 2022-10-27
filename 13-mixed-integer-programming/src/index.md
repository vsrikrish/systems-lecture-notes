class: center, middle

.title[Mixed Integer Programming and Waste Management]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[October 17, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Mixed Integer Programming for Operational Decisions
2. Waste Management: Netowrk \& Transport Modeling
3. Solving our Waste Management Example

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

- Economic Dispatch Examples

---
class: left

# Decision-Making About Operational Status
<hr>

Last class, we discussed economic dispatch, which assumed we had already decided which generating plants are online.

But what if we need to make that decision? Or what if we have a fleet of treatment facilities, some of which might be operated at a given time?

---
class: left

# Decision-Making About Operational Status
<hr>

Last class, we discussed economic dispatch, which assumed we had already decided which generating plants are online.

But what if we need to make that decision? Or what if we have a fleet of treatment facilities, some of which might be operated at a given time?

---
class: left

# Fixed Costs
<hr>

A key consideration when deciding whether to operate *something* is fixed costs.

Costs can be (roughly) broken down into two categories:

- **Fixed costs**: Labor, etc, required to operate or produce regardless of quantity.
- **Variable costs**: Costs of inputs (energy, additional labor, materials) required to operate or produce per unit of time/quantity.

---
class: left

# Fixed Costs
<hr>

The existence of fixed costs creates a discontinuous cost function.

```@eval
using Plots
gr()
using Measures

x = 1:1:10
C(x) = 3 .+ 2 .* x

plot(x, C(x), grid=:false, ylabel="Costs", xlabel="Units of Operation",
label="Cost (\$\$)", thickness_scaling=1.25, color=:black, legend=:bottomright, xticks=0:1:10, linewidth=3, xtickfontsize=12, ytickfontsize=12, xguidefontsize=15, yguidefontsize=15, legendfontsize=12, xlims=(-0.5, 10), ylims=(-0.5, 24), framestyle=:origin)
plot!(x[x .> 0.], cumsum(C(x[x .> 0.])) ./ x[x .> 0.], color=:red, linestyle=:dot, label="Average Cost (\$\$/Unit)", linewidth=2)
scatter!([(0, 0), (1, 5)], color=:black, markersize=3, label=:false)
plot!(0:0.1:1, 3 .+ 2 .* (0:0.1:1), color=:black, linestyle=:dash, label=:false)
plot!(size=(500, 450))

savefig("cost-cartoon.svg")
nothing # hide
```

.center[![Illustrating Fixed and Average Costs](figures/cost-cartoon.svg)]

---
class: left

# Discontinuous Objectives: No More LP
<hr>

A discontinuous cost function is one way to violate the principles of linear programming!

This might mean a discontinuous objective, *particularly* if higher average costs mean that it is less cost-effective to operate minimally than to not operate and find another option.

---
class: left

# Indicator Variables and Constraints
<hr>

The potential decision to not operate means that we need to introduce new *indicator* variables, which flag on/off status.

These variables are binary, and hence not continuous!

For an example, let's consider **waste allocation** problems.

---
class: left

# Waste Load Allocation
<hr>

.left-column[
Many options exist for waste management, of varying levels of desirability.

Some relevant questions:
- Where do we send waste?
- What types of facilities do we build/operate?
]
.right-column[.center[
![Waste Management Hierarchy](https://www.epa.gov/sites/default/files/styles/medium/public/2015-08/hierarchy_hierarchy_and_options_pages.png)

.cite[Source: [EPA](https://www.epa.gov/homeland-security-waste/waste-management-options-homeland-security-incidents)]
]]

---
class: left

# Waste Load Allocation
<hr>

Notice that this type of allocation problem is not specific to garbage: those key questions are applicable to all supply chain problems.

---
class: left

# Waste Load Allocation as a Network Problem
<hr>

Think in terms of flows between sources and sinks!

.center[![Example Network](figures/waste-network-blank.svg)]

---
class: left

# Parameterizing the Network Representation
<hr>

.left-column[
![Example Network](figures/waste-network-params.svg)
]
.right-column[

| Variable | Definition |
| :------: | :------- |
| $\color{purple}S_i$ | Waste produced at source $i$ (Mg/day) |
| $\color{red}K_j$ | Capacity of disposal $j$ (Mg/day) |
| $\color{blue}W_{ij}$ | Waste transported from source $i$ to disposal $j$ (Mg/day) |

]

---
class: left

# Further System-Specific Information Needs
<hr>

This network representation takes into account the graph structure of the system, but nothing else.

To complete a model, need:
- System dynamics (fate, transport)
- Objectives
- Costs
- Management goals and/or regulatory constraints

---
class: left

# Waste Management Information
<hr>

Mass-Balance constraints:

- Need to dispose of all waste from each source $i$:

$$\sum\_{j \in J} W\_{ij} = S_i$$

- Capacity limit at each disposal site $j$:

$$\sum\_{i \in I} W\_{ij} \leq K_j$$

---
class: left

# Objective: Minimize Total Costs
<hr>

What are the components of the total system cost?

---
template: poll-answer

***What are the components of total waste management system cost?***

---
class: left

# Objective: Minimize Total Costs
<hr>

- **Transportation** of waste between sources and disposals
- **Disposal**: fixed costs (labor, maintanance energy), variable costs (fuel, etc)

---
class: left

# Objective: Transportation Costs
<hr>

Variable | Definition
:------: | :-------
$a_{ij}$ | Cost of transporting waste from source $i$ to disposal $j$ (\$/Mg-km)
$l_{ij}$ | Distance between source $i$ and disposal $j$ (km)

--


$$\text{Transportation Costs} = \sum\_{i \in I, j \in J} a\_{ij}l\_{ij}W\_{ij}$$

---
class: left

# Objective: Disposal Costs
<hr>

Variable | Definition
:------: | :-------
$c_j$ | Fixed costs of operating disposal $j$ (\$/day)
$b_{j}$ | Variable cost of disposing waste at disposal $j$ (\$/Mg)

--

$$\text{Disposal Costs} = \sum\_{j \in J} \left[c\_j + b\_j \sum\_{i \in I} W\_{ij}\right]$$

--

Is that expression for disposal costs right? What is the underlying assumption?

---
class: left

# Objective: Disposal Costs
<hr>

The equation from the previous slide is only right if all disposal facilities are operating.

But the fixed costs of a disposal may make it not cost-effective to operate within the system constraints.

---
class: left

# Objective: Disposal Costs
<hr>

The option to not operate a disposal facility $j$ means that we need to introduce a new set of variables:

$$Y\_j = \begin{cases}0 & \text{if } \sum\_{i \in I} W\_{ij} = 0 \\\\ 1 & \text{if } \sum\_{i \in I} W\_{ij} > 0 \end{cases}$$

--

Since $Y_j$ is not a continuous variable, our decision problem is no longer a linear program.

Instead, the inclusion of some integer-constrained variables (which includes binary variables) makes this a ***mixed integer* linear program**.

---
class: left


# Waste Management Problem Formulation
<hr>

$$\begin{alignat}{2}
& \min\_{W\_{i,j}, {Y\_j}} && \sum\_i \sum\_j a\_{ij}l\_{ij}W\_{ij} + \sum\_j \left[c\_jY\_j + \sum\_i b\_jW\_{ij}\right] \notag \\\\
& \text{subject to:} \qquad && Y\_j = \begin{cases}0 & \text{if } \sum\_{i \in I} W\_{ij} = 0 \\\\ 1 & \text{if } \sum\_{i \in I} W\_{ij} > 0 \end{cases} \tag{commitment} \\\\
& && \sum\_i W\_{ij} \leq K\_j \tag{capacity limit} \\\\
& && \sum\_j W\_{ij} = S\_i \tag{mass balance} \\\\
& &&  W_{ij} \geq 0 \tag{nonnegativity}\\\\
\end{alignat}$$

---
class: left

# How Do We Solve a Mixed-Integer Program?
<hr>

What are the implications of the integer-constrained variable $Y_j$ for the solution?

---
class: left

# Recall: Linear Programming
<hr>

.left-column[
Since objective function and constraints are all linear and variables are continuous, we know optimal solutions occur at corners of the feasible polytope.
]

```@eval
using Plots
using LaTeXStrings
using Measures

x = 2:0.1:10.75
f1(x) = 4.5 .* x
f2(x) = -x .+ 16
f3(x) = -1.5 .* x .+ 12
f4(x) = 0.5 .* x

p = plot(x, max.(f3(x), f4(x)), fillrange=min.(f1(x), f2(x)), color=:lightblue, grid=true, legend=false, xlabel=L"x", ylabel=L"y", xlims=(0, 12), framestyle=:origin, ylims=(0, 15), minorticks=2, aspect_ratio=1,
thickness_scaling=1, left_margin=-60mm, right_margin=-60mm, bottom_margin=-12mm)
plot!(-2:0.1:20, f1.(-2:0.1:20), color=:green, linewidth=3)
plot!(-2:0.1:20, f2.(-2:0.1:20), color=:red, linewidth=3)
plot!(-2:0.1:20, f3.(-2:0.1:20), color=:brown, linewidth=3)
plot!(-2:0.1:20, f4.(-2:0.1:20), color=:purple, linewidth=3)
plot!(size=(800, 800))
plot!(gridlinewidth=1, gridalpha=0.75)
plot!(xticks=round(Int,xlims(p)[1]):round(Int,xlims(p)[2]), yticks=round(Int,ylims(p)[1]):round(Int,ylims(p)[2]))

savefig("lp-polytope.svg")
nothing # hide
```

.right-column[.center[![Feasible Region for Example](figures/lp-polytope.svg)]]

---
class: left

# Now: Mixed-Integer Linear Program
<hr>

.left-column[
But corners may not exist at integer-valued points!
]

```@eval
using Plots
using LaTeXStrings
using Measures

x = 2:0.1:10.75
f1(x) = 4.5 .* x
f2(x) = -x .+ 16
f3(x) = -1.5 .* x .+ 12
f4(x) = 0.5 .* x

p = plot(x, max.(f3(x), f4(x)), fillrange=min.(f1(x), f2(x)), color=:lightblue, grid=true, legend=false, xlabel=L"x", ylabel=L"y", xlims=(0, 12), framestyle=:origin, ylims=(0, 15), minorticks=2, aspect_ratio=1,
thickness_scaling=1, left_margin=-60mm, right_margin=-60mm, bottom_margin=-12mm)
plot!(-2:0.1:20, f1.(-2:0.1:20), color=:green, linewidth=3)
plot!(-2:0.1:20, f2.(-2:0.1:20), color=:red, linewidth=3)
plot!(-2:0.1:20, f3.(-2:0.1:20), color=:brown, linewidth=3)
plot!(-2:0.1:20, f4.(-2:0.1:20), color=:purple, linewidth=3)
plot!(size=(800, 800))
plot!(gridlinewidth=1, gridalpha=0.75)
plot!(xticks=round(Int,xlims(p)[1]):round(Int,xlims(p)[2]), yticks=round(Int,ylims(p)[1]):round(Int,ylims(p)[2]))

scatter!(collect(Iterators.product(2:10, 3:13))[:], color=:black, markersize=3)

savefig("milp-polytope.svg")
nothing # hide
```

.right-column[.center[![Feasible Region for Example](figures/milp-polytope.svg)]]

---
class: left

# A Simple Mixed-Integer Problem
<hr>

.left-column[
$$\begin{alignedat}{2}
& \max && 3x_1 + 4x_2 \\\\
& \text{subject to:} && \\\\
& && 2x_1 + 6x_2 \leq 27 \\\\
& && x_2 \geq 2 \\\\
& && 3x_1 + x_2 \leq 19 \\\\
& && x_1, x_2 \geq 0 \\\
& && x_1, x_2 \quad \text{integers}
\end{alignedat}$$
]

```@eval
using Plots
using LaTeXStrings
using Measures

x = 0:0.1:5.7
f1(x) = (27 .- 2 .* x) ./ 6.    
f2(x) = 19 .- 3 .* x

p = plot(x, 2 .+ zeros(length(x)), fillrange=min.(f1(x), f2(x)), color=:lightblue, grid=true, legend=false, xlabel=L"x_1", ylabel=L"x_2", xlims=(0, 6), framestyle=:origin, ylims=(0, 5), minorticks=2, aspect_ratio=1,
thickness_scaling=1.25, left_margin=-60mm, right_margin=-60mm, bottom_margin=-5mm)
hline!([2], color=:red, linewidth=3)
plot!(-2:0.1:6, f1.(-2:0.1:6), color=:purple, linewidth=3)
vline!([0], color=:black, linewidth=3)
plot!(-2:0.1:6, f2.(-2:0.1:6), color=:blue, linewidth=3)
plot!(gridlinewidth=0.75, gridalpha=0.3)
plot!(xticks=round(Int,xlims(p)[1]):round(Int,xlims(p)[2]), yticks=round(Int,ylims(p)[1]):round(Int,ylims(p)[2]))
annotate!(3.2, 4.5, text("LP Solution", :black, :center, 14))
quiver!([4], [4.25], quiver=([1.3], [-1.4]), color=:black, linewidth=2)

scatter!([(5.44, 2.69)], markersize=6, markerstrokeecolor=:black, markercolor=:yellow)

grid_pts = [(5, 2), (4, 2), (4, 3), (3, 2), (3, 3), (2, 2), (2, 3), (1, 2), (1, 3), (1,4), (0, 2), (0, 3), (0, 4)]
scatter!(grid_pts, color=:brown, markersize=5)
plot!(size=(600, 450))

savefig("milp-solution.svg")
nothing # hide
```

.right-column[
.center[![Mixed Integer Example Solution](figures/milp-solution.svg)]
]

---
class: left

# A Simple Mixed-Integer Problem
<hr>

.left-column[
$$\begin{alignedat}{2}
& \max && 3x_1 + 4x_2 \\\\
& \text{subject to:} && \\\\
& && 2x_1 + 6x_2 \leq 27 \\\\
& && x_2 \geq 2 \\\\
& && 3x_1 + x_2 \leq 19 \\\\
& && x_1, x_2 \geq 0 \\\
& && x_1, x_2 \quad \text{integers}
\end{alignedat}$$

Integer solution: $f(4, 3) = 24$
]

```@eval
using Plots
using LaTeXStrings
using Measures

x = 0:0.1:5.7
f1(x) = (27 .- 2 .* x) ./ 6.    
f2(x) = 19 .- 3 .* x

p = plot(x, 2 .+ zeros(length(x)), fillrange=min.(f1(x), f2(x)), color=:lightblue, grid=true, legend=false, xlabel=L"x_1", ylabel=L"x_2", xlims=(0, 6), framestyle=:origin, ylims=(0, 5), minorticks=2, aspect_ratio=1,
thickness_scaling=1.25, left_margin=-60mm, right_margin=-60mm, bottom_margin=-5mm)
hline!([2], color=:red, linewidth=3)
plot!(-2:0.1:6, f1.(-2:0.1:6), color=:purple, linewidth=3)
vline!([0], color=:black, linewidth=3)
plot!(-2:0.1:6, f2.(-2:0.1:6), color=:blue, linewidth=3)
plot!(gridlinewidth=0.75, gridalpha=0.3)
plot!(xticks=round(Int,xlims(p)[1]):round(Int,xlims(p)[2]), yticks=round(Int,ylims(p)[1]):round(Int,ylims(p)[2]))
plot!(size=(600, 450))
annotate!(3.2, 4.5, text("LP Solution", :black, :center, 14))
quiver!([4], [4.25], quiver=([1.3], [-1.4]), color=:black, linewidth=2)

scatter!([(5.44, 2.69)], markersize=6, markerstrokeecolor=:black, markercolor=:yellow)

grid_pts = [(5, 2), (4, 2), (4, 3), (3, 2), (3, 3), (2, 2), (2, 3), (1, 2), (1, 3), (1,4), (0, 2), (0, 3), (0, 4)]
scatter!(grid_pts, color=:brown, markersize=5)
scatter!([(4, 3)], color=:red, markersize=5)

savefig("milp-solution-2.svg")
nothing # hide
```

.right-column[
.center[![Mixed Integer Example Solution](figures/milp-solution-2.svg)]
]

---
class: left

# Idea of Mixed-Integer Solution Method
<hr>

.left-column[
Solution to linear relaxation (relax integer constraint) is an *upper bound* on the mixed-integer solution (why?).

Starting from this, test new problems "bounding" LP solution with integer constraints.

Continue until integer solution found.
]

```@eval
using Plots
using LaTeXStrings
using Measures

x = 0:0.1:4.5
f1(x) = (27 .- 2 .* x) ./ 6.    
f2(x) = 19 .- 3 .* x

p = plot(x, 3 .+ zeros(length(x)), fillrange=min.(f1(x), f2(x)), color=:lightblue, grid=true, legend=false, xlabel=L"x_1", ylabel=L"x_2", xlims=(0, 6), framestyle=:origin, ylims=(0, 5), minorticks=2, aspect_ratio=1,
thickness_scaling=1.25, left_margin=-60mm, right_margin=-60mm, bottom_margin=-5mm)
hline!([2], color=:red, linewidth=3)
plot!(-2:0.1:6, f1.(-2:0.1:6), color=:purple, linewidth=3)
vline!([0], color=:black, linewidth=3)
plot!(-2:0.1:6, f2.(-2:0.1:6), color=:blue, linewidth=3)
plot!(gridlinewidth=0.75, gridalpha=0.3)
vline!([5], linestyle=:dash, color=:orange, linewidth=2)
hline!([2, 3], linestyle=:dash, color=:orange, linewidth=2)
plot!(xticks=round(Int,xlims(p)[1]):round(Int,xlims(p)[2]), yticks=round(Int,ylims(p)[1]):round(Int,ylims(p)[2]))
plot!(size=(600, 450))
annotate!(2.75, 4.75, text("Relaxed Solution", :black, :center, 14))
quiver!([3.75], [4.5], quiver=([0.25], [-1.4]), color=:black, linewidth=2)


scatter!([(4.5, 3)], markersize=6, markerstrokeecolor=:black, markercolor=:yellow)

grid_pts = [(5, 2), (4, 2), (4, 3), (3, 2), (3, 3), (2, 2), (2, 3), (1, 2), (1, 3), (1,4), (0, 2), (0, 3), (0, 4)]
scatter!(grid_pts, color=:brown, markersize=5)
scatter!([(4, 3)], color=:red, markersize=5)

savefig("milp-solution-3.svg")
nothing # hide
```

.right-column[
.center[![Mixed Integer Example Solution](figures/milp-solution-3.svg)]
]

---
class: left

# Idea of Mixed-Integer Solution Method
<hr>

.left-column[
Solution to linear relaxation (relax integer constraint) is an *upper bound* on the mixed-integer solution (why?).

Starting from this, test new problems "bounding" LP solution with integer constraints.

Continue until integer solution found.
]

```@eval
using Plots
using LaTeXStrings
using Measures

x = 0:0.1:1.5
f1(x) = (27 .- 2 .* x) ./ 6.    
f2(x) = 19 .- 3 .* x

p = plot(x, 4 .+ zeros(length(x)), fillrange=min.(f1(x), f2(x)), color=:lightblue, grid=true, legend=false, xlabel=L"x_1", ylabel=L"x_2", xlims=(0, 6), framestyle=:origin, ylims=(0, 5), minorticks=2, aspect_ratio=1,
thickness_scaling=1.25, left_margin=-60mm, right_margin=-60mm, bottom_margin=-5mm)
hline!([2], color=:red, linewidth=3)
plot!(-2:0.1:6, f1.(-2:0.1:6), color=:purple, linewidth=3)
vline!([0], color=:black, linewidth=3)
plot!(-2:0.1:6, f2.(-2:0.1:6), color=:blue, linewidth=3)
plot!(gridlinewidth=0.75, gridalpha=0.3)
vline!([4], linestyle=:dash, color=:orange, linewidth=2)
hline!([3, 4], linestyle=:dash, color=:orange, linewidth=2)
plot!(xticks=round(Int,xlims(p)[1]):round(Int,xlims(p)[2]), yticks=round(Int,ylims(p)[1]):round(Int,ylims(p)[2]))
plot!(size=(600, 450))
annotate!(2.75, 4.75, text("Relaxed Solution", :black, :center, 14))
quiver!([3.75], [4.5], quiver=([0.25], [-1.4]), color=:black, linewidth=2)

grid_pts = [(4, 3), (3, 3), (2, 3), (1, 3), (1,4), (0, 3), (0, 4)]
scatter!(grid_pts, color=:brown, markersize=5)
scatter!([(4, 3)], color=:red, markersize=6)

savefig("milp-solution-4.svg")
nothing # hide
```

.right-column[
.center[![Mixed Integer Example Solution](figures/milp-solution-4.svg)]
]

---
class: left

# Back to Waste Management
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]]

.right-column[
Three disposal options:
- Waste-to-Energy (WTE) combusts waste, resulting in residual ash.
- Materials Recovery Facility (MRF) recycles waste.
- Landfill (LF) can store all waste types.
]

---
class: left

# Back to Waste Management

```@example waste; continued=true
using JuMP
using Cbc

waste = Model(Cbc.Optimizer)
I = 1:2 # number of cities
J = 1:3 # number of disposal sites
```

---
class: left

# Waste Management Example: Decision Variables
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]]

.right-column[

Variable | Definition
:-----: | :-----
$W\_{ij}$ | Waste transported from city $i$ to disposal $j$ (Mg/day)
$R\_{kj}$ | Residual waste transported from disposal $k$ to disposal $j$ (Mg/day)
$Y\_j$ | Operational status (on/off) of disposal $j$ (binary)


```@example waste; continued=true
@variable(waste, W[i in I, j in J] >= 0)
@variable(waste, R[k in J, j in J] >= 0)
@variable(waste, Y[j in J], Bin)
```
]

---
class: left

# Waste Management Example: WTE Costs
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]

Transportation: \$1.50/Mg-km

Recycling Rate: 40%]

.right-column[
Facility Costs:

Facility | Fixed Cost (\$/yr) | Tipping Cost (\$/Mg) | Recycling Cost (\$/Mg recycled) 
:----: | -----: | -----: | ----: 
WTE | 900,000 | 60 | --
MRF | 400,000 | 5 | 35 
LF | 700,000 | 40 | --
]

**WTE Costs**: 
$$2466 Y\_1 + 60(W\_{11} + W\_{21} + R\_{21})$$

---
class: left


# Waste Management Example: MRF Costs
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]

Transportation: \$1.50/Mg-km

Recycling Rate: 40%]

.right-column[
Facility Costs:

Facility | Fixed Cost (\$/yr) | Tipping Cost (\$/Mg) | Recycling Cost (\$/Mg recycled) 
:----: | -----: | -----: | ----: 
WTE | 900,000 | 60 | --
MRF | 400,000 | 5 | 35 
LF | 700,000 | 40 | --


**MRF Costs**: 
$$1096 Y\_2 + 5(W\_{12} + W\_{22} + 0.4(35)(W\_{12} + W\_{22})$$
]

---
class: left


# Waste Management Example: LF Costs
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]

Transportation: \$1.50/Mg-km

Recycling Rate: 40%]

.right-column[
Facility Costs:

Facility | Fixed Cost (\$/yr) | Tipping Cost (\$/Mg) | Recycling Cost (\$/Mg recycled) 
:----: | -----: | -----: | ----: 
WTE | 900,000 | 60 | --
MRF | 400,000 | 5 | 35 
LF | 700,000 | 40 | --


**LF Costs**: 
$$1918 Y\_2 + 40(W\_{13} + W\_{23} + R\_{13} + R\_{23})$$
]

---
class: left

# Waste Management Example: Transportation Costs
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]

Transportation: \$1.50/Mg-km

Recycling Rate: 40%]

.right-column[
**Transportation Costs**:
$$\begin{aligned} 
&1.5[15W\_{11} + 5W\_{12} + 30W\_{13} \\\\
& \quad 10W\_{21} + 15W\_{22} + 25W\_{23} \\\\
& \quad 18R\_{13} + 15R\_{21} + 32R\_{23}]
\end{aligned}$$
]

---
class: left

# Waste Management Example: Objective
<hr>

$$\begin{aligned}
\min\_{W, R, Y} \qquad & 82.5 W\_{11} + 26.5W\_{12} + 85W\_{13} + 75W\_{21} + \\\\
& \quad 41.5W\_{22} + 77.5W\_{23} + 67R\{13} + 82.5R\_{21} + \\\\
& \quad 88R\_{23} + 2466Y\_1 + 1096Y\_2 + 1918Y\_3
\end{aligned}$$

```@example waste; continued=true
@objective(waste, Min, sum([82.5 26.5 85; 75 41.5 77.5] .* W) +
    sum([0 0 67; 82.5 0 88; 0 0 0] .* R) + sum([2466; 1096; 1916] .* Y))
```

---
class: left

# Waste Management Example: Mass-Balance
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]]

.right-column[
City 1: $W\_{11} + W\_{12} + W\_{13} = 100$

City 2: $W\_{21} + W\_{22} + W\_{23} = 170$

]

---
class: left

# Waste Management Example: Mass-Balance
<hr>
.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]]

.right-column[
WTE: $W\_{11} + W\_{21} + R\_{21} \leq 150$

MRF: $W\_{12} + W\_{22} \leq 130$

LF: $W\_{13} + W\_{23} + R\_{23} + R\_{13} \leq 200$
]


---
class: left

# Waste Management Example: Mass-Balance
<hr>

.left-column[.center[![Waste Management Example Network](figures/waste-example-network.svg)]]

.right-column[
Recycling Rate: 40%

WTE Residual Ash: 20%

$R\_{13} = 0.2(W\_{11} + W\_{21} + R\_{21})$

$R\_{21} + R\_{23} = 0.6(W\_{12} + W\_{22})$
]

---
class: left

# Waste Management Example: Commitment and Non-Negativity
<hr>

$$\begin{aligned}
Y\_1 &= \begin{cases}0 &\quad \text{if } W\_{11} + W\_{21} + R\_{21} = 0 \\\\ 1 & \quad \text{else} \end{cases} \\\\
Y\_2 &= \begin{cases}0 &\quad \text{if } W\_{21} + W\_{22} = 0 \\\\ 1 & \quad \text{else} \end{cases} \\\\
Y\_3 &= 1 \\\\
W\_{ij}, R\_{ij} &\geq 0
\end{aligned}$$ 


---
class: left

# Waste Management Example: All Constraints
<hr>

```@example waste; continued=true
city_out = [100; 170]
# mass-balance
@constraint(waste, city[i in I], sum(W[i,:]) == city_out[i])
@constraint(waste, wte, W[1,1] + W[2,1] + R[2,1] <= 150)
@constraint(waste, mrf, W[1,2] + W[2,2]  <= 130)
@constraint(waste, lf, W[1,3] + W[2,3] + R[2,3] + R[1,3] <= 200)
# residuals
@constraint(waste, resid1, R[1,3] == 0.2 .* (W[1,1] + W[2,1] + R[2,1]))
@constraint(waste, resid2, R[2,1] + R[2,3] == 0.6 .* (W[1,2] + W[2,2]))
@constraint(waste, resid3, sum(R[3,:]) == 0)
@constraint(waste, noresiddiag, sum(R[i, i] for i in I) == 0)
@constraint(waste, noresid, R[1,2] == 0)
```

---
class: left

# Waste Management Example: All Constraints
<hr>

```@example waste; continued=true
# commitment
@constraint(waste, commit1, !Y[1] => {W[1,1] + W[2,1] + R[2,1] == 0})
@constraint(waste, commit2, !Y[2] => {W[1,2] + W[2,2] == 0})
@constraint(waste, commit3, Y[3] == 1)
```

---
class: left

# Waste Management Example: Optimize
<hr>

```@example waste
optimize!(waste)
```

---
class: left

# Waste Management Example: Solution
<hr>

```@example waste
objective_value(waste)
```

---
class: left

# Waste Management Example: Solution
<hr>

```@example waste
value.(Y)
```

---
class: left

# Waste Management Example: Solution
<hr>

```@example waste
value.(W)
```

---
class: left

# Waste Management Example: Solution
<hr>

```@example waste
value.(R)
```

---
class: left

# Waste Management Example: Solution
<hr>

.center[![Waste Example Solution](figures/waste-example-solution.svg)]

---
class: left

# Key Takeaways
<hr>

- Fixed Costs cause discontinuities in the cost function; average cost usually declines with operation.
- Decisions about operational status of facilities requires *binary* variables; no longer an LP.
- Waste disposal as an example of a network problem.
- Fate \& transport dynamics can result in residuals and extra flows which need to be accounted for.

---
class: left

# Next Class
<hr>

- Term Project Release
- Unit Commitment as a mixed-integer example
