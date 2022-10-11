class: center, middle

.title[LP Examples: Generating Capacity Expansion]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[October 5, 2022]

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

- Coding Exercise with JuMP

---
class: left

# Overview of Electric Power Systems
<hr>

.center[![Structure of the Electric Power System](https://upload.wikimedia.org/wikipedia/commons/4/41/Electricity_grid_simple-_North_America.svg)]

.center[.cite[Source: [Wikipedia](https://en.wikipedia.org/wiki/Electric_power_transmission)]]

---
class: left

# Power Systems Decision Problems
<hr>

.center[![Decision Problems for Power Systems](figures/elec-decision-problems.svg)]
.center[.cite[Adapted from Perez-Arriaga, Ignacio J., Hugh Rudnick, and Michel Rivier (2009).]]

---
class: left

# Electricity Generation by Source
<hr>

.center[![U.S. Electricity Generation by Source, 2021](https://www.eia.gov/energyexplained/electricity/images/outlet-graph-large.jpg)]

---
class: left

# Capacity Expansion
<hr>

*Capacity expansion* involves adding resources to generate or transmit electricity to meet anticipated demand (load) in the future.

Typical objective is to minimize cost, but other constraints (such as reducing CO$_2$ emissions or increasing fuel diversity) may apply.

---
class: left

# Simple Capacity Expansion Example
<hr>

Let's look at a *very* simplified example first.

---
# Simple Capacity Expansion Example
<hr>

In general, we have many possible fuel options:
- Gas (combined cycle or simple cycle)
- Coal
- Nuclear
- Renewables (wind, solar, hydro)

Each of these different types of plants has a different *capacity factor*, which reflects how much of the installed capacity can be relied upon at various times.


---
class: left

# Simple Capacity Expansion Example
<hr>

Assume we can simplify demand to two scenarios:
- On-peak: 3,760 hours with 3,000 MW of demand
- Off-peak: 5,000 hours with 2,000 MW of demand

Generator types (only three):

Tech | Peak CF | Off-Peak CF | Investment Cost $(\\$\text{/MW-yr})$ | Operating Cost $(\\$\text{/MWh})$ |
:--------: | ---------:| -------------: | ------------: | ----------: | 
Gas | 0.9 | 0.9 | 100,000 | 50 |
Wind | 0.2 | 0.5 | 150,000 | 0 |
Solar | 0.7 | 0 | 150,000 | 0 |

---
class: left

# Simple Capacity Expansion Example
<hr>

**Goal**: Find an installed capacity of each technology that meets demand at all periods at minimal *total cost*.

What are our variables?

--

| Variable | Meaning |
| :---------:|:--------|
| $x_g$ | installed capacity (MW) of generator type $g$ |
| $y_{g,t}$ | production (MW) from generator type $g$ in period $t$ |

---
class: left

# Simple Capacity Expansion Example
<hr>

The objective function (to minimize cost):

$$\begin{aligned}
\min\_{x\_g, y\_{g,t}} Z &= \color{red}\text{investment cost} + \color{blue}\text{operating cost} \\\\
&= \color{red}100000 x\_\text{gas} + 150000 x\_\text{wind} + 150000 x\_\text{solar} \\\\
& \color{blue}\quad + (3760 \times 50) y\_\text{gas,peak} + (5000 \times 50) y\_\text{gas,off}
\end{aligned}$$

---
class: left

# Simple Capacity Expansion Example
<hr>

More generally (as the problem size gets larger), we want to write this more compactly.

If $C^{INV}_g$ is the investment cost for generator $g$, $C^{OP}_g$ is the operating cost for generator $g$, and $L_t$ is the length of time period $t$:

$$\min Z = \sum\_g C^\text{INV}\_g x\_g + \sum\_g \sum\_t L\_t C^\text{OP}\_g y\_{g,t}$$ 

---
# Simple Capacity Expansion Example
<hr>

What are the constraints?

--

- Generators cannot produce more than their installed capacity and availability, *e.g.*

$$y\_\text{wind, peak} \leq 0.2 x\_\text{wind}$$

- Need to serve load in both peak and off-peak hours:

$$\begin{aligned}
y\_\text{gas, peak} + y\_\text{wind, peak} + y\_\text{solar, peak} &= 3000 \\\\
y\_\text{gas, off} + y\_\text{wind, off} + y\_\text{solar, off} &= 2000
\end{aligned}$$

---

# Simple Capacity Expansion Example
<hr>

And don't forget non-negativity!

$$\begin{aligned}
x\_g &\geq 0 \\\\
y\_{g,t} &\geq 0
\end{aligned}$$

---

# Simple Capacity Expansion Example
<hr>

Notice that this is an LP!

- Linear (costs scale linearly);
- Divisible (since we're modeling installed capacity, not number of individual units);
- Certainty (no uncertainty about renewables)

Things can get more complex for real decisions, particularly with renewables...

---

# Simple Capacity Expansion Example
<hr>

```@example gencap
using JuMP
using HiGHS

gencap = Model(HiGHS.Optimizer)
generators = ["gas", "wind", "solar"]
periods = ["peak", "off"]
G = 1:length(generators) 
T = 1:length(periods)
@variable(gencap, x[G] >= 0)
@variable(gencap, y[G, T] >= 0)
@objective(gencap, Min, [100000; 150000; 150000]' * x 
    + sum([188000 0 0; 250000 0 0]' .* y))
```

---

# Simple Capacity Expansion Example
<hr>

```@example gencap
avail = [0.9 0.2 0.5; 0.9 0.5 0]' # availability factors
@constraint(gencap,
    availability[g in G, t in T], y[g, t] <= avail[g, t] * x[g]
)
```

---

# Simple Capacity Expansion Example
<hr>

```@example gencap
demand = [3000; 2000] # load
@constraint(gencap,
    load[t in T], sum(y[:, t]) == demand[t])
```

---

# Simple Capacity Expansion Example
<hr>

```@example gencap
print(gencap)
```

---

# Simple Capacity Expansion Example
<hr>

```@example gencap
optimize!(gencap)
objective_value(gencap)
```

---
# Simple Capacity Expansion Example
<hr>

```@example gencap
value.(x)
```

---
# Simple Capacity Expansion Example
<hr>

```@example gencap
value.(y)
```

---
# Simple Capacity Expansion Example
<hr>

In summary:

- We want to install 2444.4 MW of gas, 4000 MW of wind, and no solar.
- During peak hours, we rely on all of the gas and wind we can.
- Off-peak, we rely on only wind.

**Does this solution make sense**?

---
# Simple Capacity Expansion Example
<hr>

How can we display these results more easily? Use `DataFrames.jl`:

```@example gencap
using DataFrames

# compute total generation by generation resource
period_hours = [3760; 5000]
generation = [sum(value.(y).data[g, :] .* period_hours) for g in G]

results = DataFrame(
    "Resource" => generators,
    "Installed (MW)" => value.(x).data,
    "Generated (GWh)" => generation/1000
)
nothing # hide
```

---
# Simple Capacity Expansion Example
<hr>

```@example gencap
results # hide
```

---
# Simple Capacity Expansion Example
<hr>

```@example gencap
shadow_price.(load)
```

---
# Simple Capacity Expansion Example
<hr>

```@example gencap
shadow_price.(availability)
```

---
# Capacity Expansion
<hr>

**What modifications can we make to this setup?**

---
template: poll-answer

**What modifications can we make to our basic generation capacity example?**

---
# Capacity Expansion
<hr>

**What modifications can we make to this setup?**

- More hours (not just peak/off-peak)
- More generator types
- Add in non-served demand (usually penalized by a cost in the objective)
- Emissions (CO$_2$ or air pollutant)
- Plant retirements (if we have existing plants)
- Dynamic fuel prices

---

# Emissions
<hr>

We could add in emissions as a constraint or try to minimize emissions (instead of cost).

**How would we do this?**

--

- Would need information on emissions per generated Wh.

---

# Non-Served Energy
<hr>

It could be that it's cheaper to not serve energy during some periods than to build additional capacity.

**How would we implement this?**

--

- Add non-served energy penalty ($NSECost \times NSE_t$) to objective;
- Generated electricity plus non-served energy equal demand.

---
# Non-Served Energy
<hr>

New objective:

$$\begin{aligned}
\min\_{x\_g, y\_{g,t}, nse\_t} Z &= \text{investment cost} + \text{operating cost} + \text{NSE cost}\\\\
&= 100000 x\_\text{gas} + 150000 x\_\text{wind} + 150000 x\_\text{solar} \\\\
& \quad + (3760 \times 50) y\_\text{gas,peak} + (5000 \times 50) y\_\text{gas,off} \\\\
& \quad + NSECost \times nse\_t
\end{aligned}$$

---
# Non-Served Energy
<hr>

New load constraints:

$$\begin{aligned}
y\_\text{gas, peak} + y\_\text{wind, peak} + y\_\text{solar, peak} + nse\_\text{peak}&= 3000 \\\\
y\_\text{gas, off} + y\_\text{wind, off} + y\_\text{solar, off} + nse\_\text{off} &= 2000
\end{aligned}$$

---
class: middle

# Next Class
<hr>
- Air Pollution Modeling Example or Economic Dispatch
<hr>