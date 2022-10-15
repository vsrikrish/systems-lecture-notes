class: center, middle

.title[Economic Dispatch]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[October 12, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Homework 3 Released
2. Regulatory Project Proposal Due Thursday
3. Questions?
4. Single-Period Economic Dispatch
5. Multi-Period Economic Dispatch
6. "Duck Curve"

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

- Generating Capacity Expansion Example

---
class: left

# Power Systems Decision Problems
<hr>

.center[![Decision Problems for Power Systems](figures/elec-decision-problems.svg)]
.center[.cite[Adapted from Perez-Arriaga, Ignacio J., Hugh Rudnick, and Michel Rivier (2009).]]

---
class: left

# Economic Dispatch
<hr>

**Decision Problem**: Given a fleet of (online) generators, how do we meet demand at lowest cost?

--

**New Constraints**: Power plants are generally subject to engineering constraints that we had previously neglected, including:
- Ramping limits
- Minimum/Maximum power outputs
- May include network constraints (we will ignore here)

---
class: left

# Simple, Single-Period Economic Dispatch
<hr>

What does this look like for a single period?

Let:

Variable | Meaning | Units
:-----: | ------: | -----:
$d$ | demand | MW
$y_g$ | generation by generator $g$ | MW
$VarCost_g$ | variable generation cost for generator $g$ | \$/MW 
$P^{\text{min/max}}_g$ | generation limits for generator $g$ | MW

---
# Simple, Single-Period Economic Dispatch
<hr>

Then the economic dispatch problem becomes: 

$$\begin{alignedat}{3}
& \min\_{y_g} & \sum_g VarCost_g \times y_g \\\\
& \text{subject to:} & \\\\
& & \sum_g y_g = d \\\\
& & y_g \leq P^{\text{max}}_g \\\\
& & y_g \geq P^{\text{min}}_g
\end{alignedat}$$

---
class: left

# Simple, Single-Period Economic Dispatch
<hr>

Let's say we have an online fleet of the following generators:

Type | $P^{\text{min}}$ (MW) | $P^{\text{max}}$ (MW) | $VarCost$ (\$/MW) 
---:  |------: | ----: | ----: 
Hydro | 0 | 150 | 0
Wind | 0 | 200 | 0
Nuclear  | 200 | 1000 | 2
Coal  | 160 | 700 |   21.50
Natural Gas | 40 | 500 | 23

Also, demand in this hour is 2600 MW.

---
class: left

# Single-Period Dispatch: `JuMP` Implementation
<hr>

Let's load the generation data and demand:

```@example dispatch; continued = true
generators = ["hydro", "wind", "nuclear", "coal", "natgas"]
p_min = [0, 0, 200, 160, 40]
p_max = [150, 200, 1000, 700, 500]
varom = [0, 0, 2, 21.50, 23]
demand = 1800
```

---
class: left

# Single-Period Dispatch: `JuMP` Implementation
<hr>

Setting up the optimization problem:

```@example dispatch; continued = true
using JuMP
using HiGHS
using DataFrames
using Plots
gr()
using Measures
```

---
class: left

# Single-Period Dispatch: `JuMP` Implementation
<hr>

Setting up the optimization problem:

```@example dispatch; continued = true
G = 1:length(generators)
dispatch = Model(HiGHS.Optimizer)
@variable(dispatch, p_min[g] <= y[g in G] <= p_max[g])
@objective(dispatch, Min, sum(varom .* y))
@constraint(dispatch, load, sum(y) == demand)
```

---
class: left

# 
<hr>

```@example dispatch
print(dispatch)
```

---
class: left

# Single-Period Dispatch: Results
<hr>

.left-column[

```@example dispatch
set_silent(dispatch)
optimize!(dispatch)

gen = value.(y).data
results = DataFrame(
    "Name" => generators,
    "Dispatched Power (MW)" => gen
)
nothing #hide
```

]

.right-column[
```@example dispatch
results # hide
```
]

---
class: left

# Marginal Generators
<hr>

.left-column[
Once we hit the minimum for each generator, we then "fill up" capacity from lowest-cost generators first, then move on.

For this problem, the coal generator is the *marginal generator*: extra capacity is added from coal, and so this unit sets the price of electricity.
]

.right-column[
```@example dispatch
results # hide
```
]

---
class: left

# Merit Order and the Dispatch Stack
<hr>

This is the concept of *merit order*: plants are scheduled to supply additional electricity based (**mostly**) on their variable costs.

```@example dispatch
supply_curve = DataFrame( # hide
    name = generators, # hide
    pmin = p_min, # hide
    cap = p_max .- p_min, # hide
    varcost = varom # hide
) # hide

sort!(supply_curve, [:varcost, order(:cap, rev=true)]) #hide

using Measures #hide

function plot_supply_curve(supply_curve) # hide
    rectangle(w, h, x, y) = Shape(x .+ [0,w,w,0], y .+ [0,0,h,h]) # hide

    
    p = plot(grid=:false, color_palette=:tol_muted, legend=:left, size=(700, 400), left_margin=10mm, bottom_margin=10mm, legendfontsize=16, ticksize=13, guidefontsize=14) # hide
    marg_gen = 0 # hide
    marg_price = 0 # hide
    x = 0 # hide

    plot!(p, rectangle(sum(supply_curve.pmin), 0.5, x, 0), opacity=.5, label = "minimum", color="black") # hide
    x = x + sum(supply_curve.pmin) # hide
    for i in 1:nrow(supply_curve) # hide
        if supply_curve[i, :varcost] == 0 # hide
            plot!(p, rectangle(supply_curve[i, :cap], 0.5,x,0), opacity=.5, label = supply_curve[i, :name]) # hide
        else # hide
            plot!(p, rectangle(supply_curve[i, :cap], supply_curve[i, :varcost],x,0), opacity=.5, label = supply_curve[i, :name]) # hide
        end # hide
        if (x < demand) && (x + supply_curve[i,:cap] > demand) # hide
            marg_gen = i # hide
            marg_price = supply_curve[i,:varcost] # hide
        end # hide
        x = x + supply_curve[i,:cap] # hide
    end # hide
    vline!([demand],linecolor="black",linewidth=3, linestyle=:dash, label = "demand") # hide
    hline!([marg_price],linecolor="blue", linestyle=:dot, linewidth=3, label = "Electricity Price") # hide
    title!("Dispatch Stack Supply Curve") # hide
    xlabel!("Capacity (MW)") # hide
    ylabel!("Marginal Cost (\$\$/MW)") # hide

    return p # hide
end # hide

plot_supply_curve(supply_curve) # hide
savefig("simple-merit-order.svg") # hide
```

.center[![Example Merit Order](figures/simple-merit-order.svg)]

---
template: poll-answer

***What might complicate this simple merit ordering based on variable costs?***

---
class: left

# Multiple Time Period Example
<hr>

Now, let's consider multiple time periods. 

Not only do we need to meet demand at every time period, but we have additional **ramping** constraints: plants can only increase and decrease their output by so much from time to time, by $R_g$.

---
class: left

# Multiple Time Period Example
<hr>

$$\begin{alignedat}{3}
& \min\_{y\_{g,t}} & \sum\_g VarCost\_g \times \sum\_t y\_{g,t} \\\\
& \text{subject to:} & \\\\
& & \sum\_g y\_{g,t} = d\_t \\\\
& & y\_{g,t} \leq P^{\text{max}}\_g \\\\
& & y\_{g,t} \geq P^{\text{min}}\_g \\\\
& & \color{red}y\_{g,t+1} - y\_{g, t} \leq R\_g \\\\
& & \color{red}y\_{g,t} - y\_{g, t+1} \leq R\_g
\end{alignedat}$$

---
class: left

# Multiple Time Period Example
<hr>

Type | $P^{\text{min}}$ (MW) | $P^{\text{max}}$ (MW) | $VarCost$ (\$/MW) | $R$ (MW) 
---:  |------: | ----: | ----: | ----:
Hydro | 0 | 150 | 0 | 150
Wind | 0 | 200 | 0 | 200 
Nuclear  | 500 | 1000 | 2 | 100 
Coal  | 160 | 700 |   21.50 | 250
Natural Gas | 40 | 500 | 23 | 300

---
class: left

# Multiple Time Period Example: `JuMP` Implmenetation
<hr>

```@example dispatch
ramp = [150, 200, 100, 250, 300]
demand = [1725, 1596, 1476, 1408, 1530, 1714, 1820, 1973, 2081, 2202, 2105, 2065, 
    2045, 2195, 2309, 2390, 2486, 2515, 2075, 2006, 1956, 1902, 1865, 1820]
h = length(demand)
T = 1:h

dispatch2 = Model(HiGHS.Optimizer)
@variable(dispatch2, p_min[g] <= y[g in G, t in T] <= p_max[g])
@objective(dispatch2, Min, sum(varom .* sum([y[:, t] for t in T])))
@constraint(dispatch2, load[t in T], sum(y[:, t]) == demand[t])
@constraint(dispatch2, rampup[g in G, t in 1:h-1], y[g, t+1] - y[g, t] <= ramp[g])
@constraint(dispatch2, rampdown[g in G, t in 1:h-1], y[g, t] - y[g, t+1] <= ramp[g])
set_silent(dispatch2)
optimize!(dispatch2)
```

---
class: left

# Multiple Time Period Example: Visualization
<hr>

.left-column[
```@example dispatch
gen = value.(y).data
p = plot(gen', 
    label=permutedims(generators), 
    xlabel = "Hour", 
    ylabel ="Generated Electricity (MW)", 
    color_palette=:tol_muted, 
    thickness_scaling=1.45, linewidth=5,
    size=(700, 700), left_margin=5mm, 
    bottom_margin=5mm,
    legendfontsize=14, ticksize=13, 
    guidefontsize=14
)
savefig("multi-period-dispatch.svg") # hide
```

]

.right-column[
.center[![Multi-Period Dispatch Results](figures/multi-period-dispatch.svg)]
]

---
class: left

# Multiple Time Period Example: Visualization
<hr>

.left-column[
```@example dispatch
areaplot(gen', 
    label=permutedims(generators), 
    xlabel = "Hour", 
    ylabel ="Generated Electricity (MW)", 
    color_palette=:tol_muted, 
    size=(700, 700), 
    left_margin=5mm, 
    bottom_margin=5mm,
    thickness_scaling=1.45, grid=:false,
    legend = :topleft, ylim=(0, 2800),
    legendfontsize=14, ticksize=13, 
    guidefontsize=14
)
plot!(demand, color=:red, 
    label="demand", linestyle=:dash,
    linewidth=5)
savefig("multi-period-dispatch-stacked.svg") # hide
```

]

.right-column[

.center[![Multi-Period Dispatch Results](figures/multi-period-dispatch-stacked.svg)]
]

---
class: left

# Duck Curve
<hr>

.left-column[Ramping and minimum generation play a major role in systems with high levels of renewable penetration.

For example, a prominent feature of California's grid, which has a lot of solar generation, is the "duck curve" (right).]

.right-column[
![CAISO Duck Curve](figures/duck_curve.jpeg)
.center[.cite[Source: [Power Magazine](https://www.powermag.com/duck-hunting-california-independent-system-operator/)]]
]