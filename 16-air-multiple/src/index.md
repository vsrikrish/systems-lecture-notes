class: center, middle

.title[Emissions: Multiple Point Sources and Box Models]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[October 26, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Questions?
2. Gaussian Plume Model Recap
3. Multiple Point Sources/Receptors Example
4. Box Models for Airsheds

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

- Gaussian Plume Model

---
class: left

# Gaussian Plume Model Recap
<hr>

.center[![Plume Model Schematic](figures/air-pollution-plume-dist.png)]

---
class: left

# Gaussian Plume Model Recap
<hr>

$$\begin{aligned}
C(x,y,z) = &\frac{Q}{2\pi u \sigma\_y \sigma\_z} \exp\left(\frac{-y^2}{2\sigma\_y^2} \right) \times \\\\
& \quad \left[\exp\left(\frac{-(z-H)^2}{2\sigma\_z^2}\right) + \exp\left(\frac{-(z+H)^2}{2\sigma\_z^2}\right) \right]
\end{aligned}$$

Assumptions:
1. Steady-State, no reactions
2. Constant wind vector, wind >> dispersion in $x$-direction
3. Smooth ground (avoids turbulent eddies and other reflections)

---
class: left

# Gaussian Plume Model Recap
<hr>

Dispersion factors $\sigma_y$ and $\sigma_z$ determined by atmospheric stability class:

Class | Stability | Description
:----:|:----------|:-----------
A | Extremely unstable | Sunny summer day 
B | Moderately unstable | Sunny & warm |
C | Slightly unstable | Partly cloudy day 
D | Neutral | Cloudy day or night |
E | Slightly stable | Partly cloudy night 
F | Moderately unstable | Clear night 

.center[.cite[Source: https://courses.ecampus.oregonstate.edu/ne581/eleven/]]

---
# Multiple Point Sources
<hr>

```@eval
using Plots
using LaTeXStrings
gr()

sources = [(0, 7), (2, 5), (3, 5)]
receptors = [(1, 1.5), (3, 7), (5, 3), (7.5, 6), (10, 5)]

p = scatter(sources, label="Source", markersize=6, color=:red, xlabel=L"$x$ (km)", ylabel=L"$y$ (km)", guidefontsize=14, legendfontsize=12, tickfontsize=12, legend=:bottomright, ylims=(0, 8), xlims=(-0.5, 10.5))
scatter!(receptors, label="Receptor", markersize=6, color=:black)
for i in 1:length(sources)
    annotate!(sources[i][1], sources[i][2] + 0.3, text(string(i), :red, 10, :center))
    annotate!(sources[i][1], sources[i][2] - 0.3, text(string(sources[i]), :red, 10, :center))    
end
for i in 1:length(receptors)
    annotate!(receptors[i][1], receptors[i][2] + 0.3, text(string(i), :black, 10, :center))
    annotate!(receptors[i][1], receptors[i][2] - 0.3, text(string(receptors[i]), :black, 10, :center))    
end
plot!(size=(500, 400))
plot!([(0, 7.75), (10, 7.75)], arrow=true, color=:blue, linewidth=2, label="")
annotate!(5, 8, text("Wind", :left, 12, :blue))

savefig("multiple-sources.svg")
nothing #hide
```

.left-column[
Suppose we have three sources of SO$_2$:

| Source | Emissions (kg/day) | Effective Height (m) | Removal Cost (\$/kg)
| :----: | ----: | -----: | -----:
| 1 | 34,560 | 50 | 0.20
| 2 | 172,800 | 200 | 0.45
| 3 | 103,680 | 30 | 0.60

and five receptors at ground level with $u = 1.5$ m/s, air quality standard 150 $\mu\text{g/m}^3$.
]

.right-column[.center[![Schematic for Multiple Sources](figures/multiple-sources.svg)]]


---
# Modeling Considerations
<hr>

.left-column[    
Would like to know relationship between source emissions ($Q_i$ and receptor exposure)

Receptors are only affected by upwind sources.
]

.right-column[.center[![Schematic for Multiple Sources](figures/multiple-sources.svg)]]

---

# How to Combine Concentrations From Multiple Sources?
<hr>

--

Additive:

$$\begin{aligned}
\text{Concentration} &= \frac{M_1 + M_2 + M_3}{V} \\\\
&= \frac{M_1}{V} + \frac{M_2}{V} + \frac{M_3}{V} \\\\
&= C_1 + C_2 + C_3
\end{aligned}$$

---

# Developing Constraints
<hr>

Want to model exposure as a function of the emissions $Q_i$. How?

--

Write $C_i(x,y) = Q_it_i(x,y)$, where the $t_i$ is the transmission factor

$$t_i(x,y) = \frac{1}{2\pi u \sigma\_y \sigma\_z} \exp\left(\frac{-y^2}{2\sigma\_y^2} + \frac{H^2}{\sigma\_z^2}\right)$$

--

This turns exposure constraints linear as a function of $Q_i$: for a receptor $j$ (with fixed location $(x_j, y_j)$),

$$\text{Exp}\_j = \sum\_i Q\_i t\_i(x\_j, y\_j) \leq 150\ \mu\text{g/m}^3$$

---

# Dispersion Spread
<hr>

**Last class**: Tables for $\sigma_y$ and $\sigma_z$ fits based on atmospheric stability class.

$$\begin{aligned}
\sigma_y &= ax^{0.894} \\\\
\sigma_z &= cx^d + f
\end{aligned}$$

.center[![Dispersion Coefficients](figures/plume-dispersion.png)
.cite[Source: <https://courses.washington.edu/cee490/DISPCOEF4WP.htm>]
]

---
# Calculating Transmission Factors
<hr>

Let's assume we're in stability class C. Then we have $\sigma_y = 104x^{0.894}$ and
$\sigma_z = 61x^{0.911}$ (regardless of distance).

.center[![Dispersion Coefficients](figures/plume-dispersion.png)
.cite[Source: <https://courses.washington.edu/cee490/DISPCOEF4WP.htm>]
]

---
# Calculating Transmission Factors
<hr>

Now we can write a function:

```@example air
# delta_x, delta_y should be in m
# should subtract receptor from source for upwind check
function transmission_factor(delta_x, delta_y, u, H)
    if delta_x <= 0
        tf = 0.
    else
        sigma_y = 104 * (delta_x / 1000)^0.894
        sigma_z = 61 * (delta_x / 1000)^0.911
        tf_coef = 1/(2 * pi * u * sigma_y * sigma_z)
        tf = tf_coef * 
            exp((-0.5 * (delta_y / sigma_y)^2) + (H / sigma_z)^2)
    end
    return tf
end
nothing # hide
```

---
# Calculating Transmission Factors
<hr>

.left-column[
For example, from Source 1 to Receptor 1:
```@example air
transmission_factor(1000, 5500, 1.5, 50)
```

Source 1 to Receptor 2:
```@example air
transmission_factor(3000, 0, 1.5, 50)
```
]

.right-column[.center[![Schematic for Multiple Sources](figures/multiple-sources.svg)]]

---

# Calculating Transmission Factors
<hr>

```@example air
sources = [(0, 7), (2, 5), (3, 5)]
receptors = [(1, 1.5), (3, 7), (5, 3), (7.5, 6), (10, 5)]
H = [50, 200, 30]

calctf(i, j) = transmission_factor(
                1000 * (receptors[j][1] - sources[i][1]),
                1000 * (receptors[j][2] - sources[i][2]), 
                1.5, H[i])
tf = [calctf(i, j) for i in 1:length(sources), j in 1:length(receptors)]
nothing # hide
```

---
# Calculating Transmission Factors
<hr>

```@example air
using DataFrames

DataFrame(tf, string.(collect(1:length(receptors))))
```

---
# Optimization Formulation: Decision Variables
<hr>

What are our decision variables?

--

Let's use: $R_i$, fraction of emissions reduced at source $i$. 

Then $Q_i = (1-R_i)E_i$, where $E_i$ is the emissions corrected to the appropriate units).

```@example air; continued=true
using JuMP
using HiGHS

air_model = Model(HiGHS.Optimizer)
@variable(air_model, 0 <= R[1:3] <= 1)
```

---
# Optimization Objective
<hr>

| Source | Emissions (kg/day) | Emissions (g/s) | Effective Height (m) | Removal Cost (\$/kg)
| :----: | ----: | ----: | -----: | -----:
| 1 | 34,560 | 400  | 50 | 0.20
| 2 | 172,800 | 2000 | 200 | 0.45
| 3 | 103,680 | 1200  | 30 | 0.60

--

$$\begin{aligned}
\min\_{R\_i} Z &= \sum_i RemCost_i \times DayEmis_i \times R_i \\\\
&= (0.20) (34560) R_1 + (0.45)(172800) R_2 + (0.60)(103680) R_3 \\\\
&= 6912R_1 + 77760R_2 + 62208R_3
\end{aligned}$$

```@example air; continued=true
@objective(air_model, Min, 6912*R[1] + 77760*R[2] + 62208*R[3])
```

---
# Optimization Constraints
<hr>

- Exposure Constraints:

$$\begin{aligned}
\text{Exp}\_j = \sum\_i Q\_i t\_i(x\_j, y\_j) &\leq 150\ \mu\text{g/m}^3 \\\\
\Rightarrow \sum\_i E\_it\_{ij}(1-R\_i) &\leq 150 \times 10^{-6}
\end{aligned}$$

```@example air; continued=true
E = [400, 2000, 1200]
@constraint(air_model, exposure[j in 1:5], 
    sum([E[i] * tf[i, j] * (1-R[i]) for i in 1:3]) <= .00015)
```

---
# Optimization Constraints
<hr>

- Bounds:

$$\begin{aligned}
R_i &\leq 1 \\\\
R_i &\geq 0
\end{aligned}$$

---

# Let's Optimize!
<hr>

```@example air
set_silent(air_model)
optimize!(air_model)
objective_value(air_model)
```

```@example air
value.(R)
```

--

**Does this make sense?**

---
# Untreated Exposure
<hr>

```@example air
(E .* tf) .* 1e6 # in micrograms/m^3
```

---
# Reduced Exposure
<hr>

```@example air
(E .* (1 .- value.(R)) .* tf) .* 1e6
```

---
# Why This Plan Makes Sense
<hr>

Basically (ignoring source 1, which is constrained by receptor 2):

We *could* reduce emissions from source 2 by ~85% to comply at receptor 5, but then would also need to reduce source 3's emissions by 100%, at a cost of **~$128,304**.

This plan involves eliminating all of source 2's emissions, but only 75% of source 3's, at a cost of **$124,416**.

---
# What If Removal Isn't 100% Effective?
<hr>

```@example air
set_upper_bound.(R, [0.95, 0.95, 0.95])
optimize!(air_model)
objective_value(air_model)
```

```@example air
value.(R)
```



---
# Gaussian Plume Upshot
<hr>

.left-column[
Remember the key assumptions:

- Steady-state, no reactions
- Constant wind
- Wind >> dispersion in $x$-direction
- Smooth ground
]

.right-column[![Schematic for Multiple Sources](figures/multiple-sources.svg)]

---
# Airsheds and Box Models
<hr>

.left-column[
**Box models** are all about mass-balance. Denote by $C$ (g/m$^3$) the concentration in box, $E$ (g/s) the emissions rate within the box;, $u$ (m/s) the wind speed, and by $L, W, H$ the box dimensions (m)
]

.right-column[![Steady-State Box Model](figures/steady-box.png)]


---
# Steady-State Box Model
<hr>

.left-column[
First, consider a steady-state box, $\Delta m = 0$.

$$\begin{aligned}
0 &= \dot{m}\_{in} - \dot{m}\_{out} + E \\\\
&= u WH C\_{in} - u WH C + E \\\\
C &= C\_{in} + \frac{E}{uWH}
\end{aligned}$$
]

.right-column[![Steady-State Box Model](figures/steady-box.png)]

---
# Quick Example
<hr>

A box surrounding a city has dimensions $W = 4km$, $L = 8km$, $H=1km$. The upwind concentration of $CO$ is 5 $\mu\text{g/m}^3$ and the wind is moving at 2 m/s. The emission rate of $CO$ within the city is $3 \mu\text{g/(s} \cdot \text{m}^2)$. What is the concentration of $CO$ over the city?

--

$$E = (3 \mu\text{g/(s} \cdot \text{m}^2))(8000 \text{m})(4000 \text{m}) = 9.6 \text{g/s}$$

--

$$C = (5 \mu\text{g/s}) + \frac{9.6 \text{g/s}}{(2 \text{m/s})(4000 \text{m})(1000 \text{m})} = 6.2 \mu\text{g/s}$$

---
# Emissions Credits and Trading
<hr>

When using a "box" representation, all that matters is the total emissions not exceeding a certain level within the box.

Opens the door for emissions credits/trading as a market-based mechanism vs. a pure regulation.

--

**What are some pros and cons of these approaches?**

---
# Sources and Sinks
<hr>

Of course, we could also have sinks (including reactions) which absorb or consume some of the contaminant.

How would this change our simple box model?

--

Modify $E$ as net emissions, sources - sinks (might have to model these processes more explicitly, which adds complexity).


---
# Multi-Box Models
<hr>

Box models get more interesting when multiple boxes are combined (think your dissolved oxygen example from the simulation unit).

This allows for 2d or 3d fate & transport modeling with potentially heterogeneous advection, mixing, and source/sink rates.

But can be computationally expensive over large regions: need to loop and evaluate over many boxes.

---
# Key Takeaways
<hr>

- Gaussian Plume: all upwind sources can affect downwind receptors.
- Assumptions may not generally hold --- how much does this matter?
- Box models allow for more flexibility when more detailed mass-balance is required, but are computationally more expensive to combine over large domains.

---
class: middle, center

<hr>
# Next Class
<hr>

- Dissolved Oxygen revisited
- Simulation-Optimization methods