class: center, middle

.title[Fate and Transport Modeling]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[September 14, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Questions?
2. Fate and Transport Modeling
3. Example: Dissolved Oxygen

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

- Monte Carlo Confidence Intervals
- Risk

---
class: left

# Fate and Transport Modeling
<hr>

- How do nutrients and other quantities move through environmental mediums?

- The mass balances can be the result of more complex processes, not just decay/dissipation, requiring simulation one "chunk" of the domain at a time.

---
class: left

# Example: Dissolved Oxygen
<hr>

.left-column[Dissolved oxygen (DO) is the free, non-compound oxygen present in water or other liquids.

Freshwater can only hold small amounts, and thie capacity is regulated by temperature.]

.right-column[.center[![Dissolved Oxygen by temperature](https://www.fondriest.com/environmental-measurements/wp-content/uploads/2013/11/dissolvedoxygen_river-levels.jpg)

.cite[Source: [fondriest.com](https://www.fondriest.com/environmental-measurements/parameters/water-quality/dissolved-oxygen/)]]]

---
class: left

# Dissolved Oxygen
<hr>

.center[![Dissolved Oxygen and Temperature Plot](https://d9-wret.s3.us-west-2.amazonaws.com/assets/palladium/production/s3fs-public/thumbnails/image/do_temp_0.png)
.cite[Source: [usgs.gov](https://www.usgs.gov/special-topics/water-science-school/science/dissolved-oxygen-and-water)]]

---
class: left

# Dissolved Oxygen and Life
<hr>

.left-column[Dissolved oxygen is an important nutrient for aquatic life. 

**Hypoxia** occurs when DO levels are $< 2$ mg/L.
]

.right-column[.center[![Minimum DO requirements for freshwater fish](https://www.fondriest.com/environmental-measurements/wp-content/uploads/2013/11/dissolvedoxygen_levels-fresh.jpg)]
.center[.cite[Source: [fondriest.com](https://www.fondriest.com/environmental-measurements/parameters/water-quality/dissolved-oxygen/)]]
]

---
class: left

# Factors Influencing DO
<hr>

- Temperature, Pressure, Depth
- Salinity
- Mixing
- Plant and Microbial Life
- Organic Matter

---
class: left

# Impact of Paris On DO In The Seine, 1874
<hr>

.center[![Dissolved Oxygen Downstream of Paris, 1874](https://www.researchgate.net/publication/325721176/figure/fig10/AS:962439298445322@1606474818380/Longitudinal-profiles-x-axis-in-km-downstream-of-Paris-center-of-dissolved-oxygen_W640.jpg)

.cite[Source: Dmitrieva, T., et al. (2018). <https://doi.org/10.1007/s12685-018-0216-7>]]

---
class: left

# DO Regulatory Standards
<hr>

**Objective**: Keep DO *above* the regulatory standard.

In NY: 
- DO levels may not fall below 3 mg/L
- DO may not be below 4.8 mg/L for an extended period

.cite[Source: [Westlaw](https://govt.westlaw.com/nycrr/Document/I4ed90412cd1711dda432a117e6e0f345?viewType=FullText&originationContext=documenttoc&transitionType=CategoryPageItem&contextData=(sc.Default)&bhcp=1)]

---
class: left

# Oxygen Balance in Rivers and Streams
<hr>

.center[![Processes influencing oxygen balance in moving freshwater](figures/do-processes.svg)]

---
class: left

# Selecting a Metric for DO Fluxes
<hr>

Typically use *oxygen demand* (OD): 
- measure of the concentration of oxidizable materials in a water sample
- metric for organic waste contamination
- reflects how oxygen will be depleted in a given segment

But there are several different processes affecting total OD!

---
class: left

layout: true

# Types of Oxygen Demand
<hr>

{{content}}

---

- **Biochemical Oxygen Demand (BOD)**: Oxygen used by microbes during aerobic decomposition of organic materials:
$$\text{Organic Matter} + \text{O}_2 \rightarrow \text{CO}_2 +  \text{H}_2\text{O} + \text{NO}_3 + \text{SO}_2 + \text{Residuals}$$

---

- **Carbonaceous BOD (CBOD)**: Oxygen consumed during microbial decomposition of carbon compounds, *e.g.*:
$$\text{C}_a\text{H}_b\text{O}_c + d\text{O}_2 \rightarrow e\text{H}_2\text{O} + f\text{CO}_2$$

---

- **Nitrogenous BOD (NBOD)**: Oxygen consumed during microbial decomposition of nitrogen compounds:
$$2\text{NH}_2^+ + 4\text{O}_2 \rightarrow 2\text{H}_2\text{O} + 4\text{H}^+ + 2\text{NO}_3^-$$

---

Moreover, BOD is differentiated based on time frame, *e.g.*:

- BOD<sub>5</sub>: oxygen demand over 5 days
- BOD<sub>20</sub>: oxygen demand over 20 days

---
class: left

layout: false

# Modeling DO
<hr>

- Need a model that will predict DO as a function of CBOD, NBOD
- But now, use a *fate and transport* modeling approach.
- Can't assume homogeneous processes.

---
class: left

layout: false

# Modeling DO
<hr>

.left-column[So what do we do?

Start by assuming *steady-state* waste in each section.]

.right-column[.center[![Processes influencing oxygen balance in moving freshwater](figures/do-processes.svg)]]

---
class: left

layout: false

# Steady-State Waste, DO Mass Balance
<hr>

$$\text{Flow in} - \text{Flow out} = U \frac{dC}{dx},$$

where $C(x)$ is DO (mg/l) $x$ km downstream, $U$ (km/d) is the water velocity.

-- 

Additional notation:

- CBOD (mg/l): $B(x)$
- NBOD (mg/l): $N(x)$

---
class: left

# Steady-State Waste, DO Mass Balance
<hr>

Assume decomposition of wastes is first-order:

$$\begin{aligned}
\frac{dM}{dt} &= -kM \\\\
\Rightarrow M &= M_0 \exp(-kt)
\end{aligned}$$

where $M$ is the mass (kg) of waste, $M_0$ is the mass at $t=0, x=0$.

--

Since $U$ is the velocity:

$$M = M_0 \exp(-kx/U)$$

---
class: left

# Steady-State Waste, DO Mass Balance
<hr>

This means:

- For biochemical organics,

$$B(x) = B_0 \exp(-k_c x / U);$$

- For nitrification,

$$N(x) = N_0 \exp(-k_n x / U).$$

---
class: left

# Steady-State Waste, DO Mass Balance
<hr>

Other processes:
- Reaeration, assume a simple linear model: $k_a (C_s - C)$

- Assume measured, constant values for photosynthesis ($P_s$), respiration ($R$), benthal uptake ($S_B$)

--

DO uptake from waste decomposition:

- CBOD: $k_cB = k_cB_0 \exp(-k_cx/U)$
- NBOD: $k_nN = k_nN_0 \exp(-k_nx/U)$

---
class: left

# Steady-State Waste, DO Mass Balance
<hr>

Putting it all together:

$$\begin{aligned}
U \frac{dC}{dx} &= k_a (C_s - C) + P - R - S_B \\\\
&\quad - k_cB_0\exp\left(\frac{-k_cx}{U}\right) - k_n N_0\exp\left(\frac{-k_nx}{U}\right)
\end{aligned}$$

---
class: left

# Steady-State Mass Balance Solution
<hr>

$$\begin{aligned}
C(x) &= C_s(1 - \alpha_1) + C_0 \alpha_1 - B_0 \alpha_2 - N_0 \alpha_3 \\\\
&\quad + \left(\frac{P-R-S_B}{k_a}\right) (1-\alpha_1),
\end{aligned}$$

--

$$\begin{aligned}
\alpha_1 &= \exp\left(-\frac{k_a x}{U}\right)\\\\
\alpha_2 &= \left(\frac{k_c}{k_a-k_c}\right)\left[\exp\left(\frac{-k_c x}{U}\right) - \exp\left(\frac{-k_ax}{U}\right)\right]\\\\
\alpha_3 &= \left(\frac{k_n}{k_a-k_n}\right)\left[\exp\left(\frac{-k_n x}{U}\right) - \exp\left(\frac{-k_ax}{U}\right)\right]
\end{aligned}$$

---
class: left

# Steady-State Mass Balance Solution
<hr>

$$\begin{aligned}
C(x) &= C_s(1 - \alpha_1) + C_0 \alpha_1 - B_0 \alpha_2 - N_0 \alpha_3 \\\\
&\quad + \left(\frac{P-R-S_B}{k_a}\right) (1-\alpha_1),
\end{aligned}$$

**Note**: Usually, these models ignore $P$, $R$, and $S_B$.

Why do you think that might be?

---
class: left

# Steady-State Mass Balance Solution
<hr>

$$C(x) = C_s(1 - \alpha_1) + C_0 \alpha_1 - B_0 \alpha_2 - N_0 \alpha_3$$


```@eval
using Plots
using Measures
Plots.scalefontsizes(1.25)

function do_simulate(x, C0, B0, N0, ka, kn, kc, Cs, U)
    B = B0 .* exp.(-kc .* x ./ U)
    N = N0 .* exp.(-kn .* x ./ U)
    alpha1 = exp.(-ka .* x ./ U)
    alpha2 = (kc/(ka-kc)) .* (exp.(-kc .* x / U) - exp.(-ka .* x / U))
    alpha3 = (kn/(ka-kn)) .* (exp.(-kn .* x / U) - exp.(-ka .* x / U))
    C = Cs .* (1 .- alpha1) + (C0 .* alpha1) - (B0 .* alpha2) - (N0 .* alpha3)
    return (C, B, N)
end #hide 

ka = 0.5
kc = 0.4
kn = 0.25

x = 0:20

C, B, N = do_simulate(x, 12, 10, 6, ka, kc, kn, 10, 6)

plot(x, C, grid=false, color=:black, ylabel="DO/OD (mg/l)", xlabel="Distance (km)", label="DO", xticks=:false, yticks=:false, linewidth=3, left_margin=12mm, top_margin=10mm)
plot!(x, B, color=:green, label="CBOD", linestyle=:dashdotdot, linewidth=3)
plot!(x, N, color=:blue, label="NBOD", linestyle=:dash, linewidth=3)

annotate!(0.75, 13, text("Waste Discharge", pointsize=16, color=:red))
vline!([0], color=:red, linewidth=2, label=:false)
savefig("do-decay.svg") # hide

Q1 = 100000
Q2 = 20000
Q3 = 25000

x0 = 0
x1 = 18
x2 = 30
x3 = 45

C01 = 8
B01 = 5
N01 = 4.5

C1, B1, N1 = do_simulate(x0:x1, C01, B01, N01, ka, kc, kn, 10, 6)

C02 = (C1[length(C1)] * Q1 + 4 * Q2) / (Q1 + Q2)
B02 = (B1[length(B1)] * Q1 + 60 * Q2) / (Q1 + Q2)
N02 = (N1[length(N1)] * Q1 + 50 * Q2) / (Q1 + Q2)

C2, B2, N2 = do_simulate(x0:(x2-x1), C02, B02, N02, ka, kc, kn, 10, 6)

C03 = (C2[length(C2)] * (Q1 + Q2) + 2 * Q3) / (Q1 + Q2 + Q3)
B03 = (B2[length(B2)] * (Q1 + Q2) + 20 * Q3) / (Q1 + Q2 + Q3)
N03 = (N2[length(N2)] * (Q1 + Q2) + 15 * Q3) / (Q1 + Q2 + Q3)

C3, B3, N3 = do_simulate(x0:(x3-x2), C03, B03, N03, ka, kc, kn, 10, 6)

plot(x0:x1, C1, grid=false, color=:black, ylabel="DO (mg/l)", xlabel="Distance (km)", label="DO", xticks=:false, yticks=:false, linewidth=3, left_margin=12mm, top_margin=10mm)
plot!(x1:x2, C2, color=:black, label=false, linewidth=3)
plot!(x2:x3, C3, color=:black, label=false, linewidth=3)

vline!([x0, x1, x2], color=:red, linewidth=2, label="Discharge")
hline!([3], color=:green, linewidth=2, label="Regulation", linestyle=:dot)
savefig("do-multi.svg") # hide
nothing # hide
```

.center[![Waste Decay](figures/do-decay.svg)]

---
class: left

# Multiple Discharges
<hr>

.center[![Waste Decay with Multiple Discharges](figures/do-multi.svg)]

--

**Note**: Need to calculate new concentrations at each discharge due to volume changes!

---
class: left

# Multiple Discharges
<hr>

.center[![Waste Decay with Multiple Discharges](figures/do-multi.svg)]

**Question**: Is it fair to ask every discharge to comply with the regulation? Why or why not?

---
class: left

# Example DO Questions:

- What treatment % (CBOD/NBOD reduction) is needed to meet standard?
- What is the probability of noncompliance?

---
class: left

# Simulation Modeling Framework
<hr>

.center[![Simulation Workflow Diagram](figures/simulation-workflow.svg)]

---
class: middle, center

<hr>
# Next Class
<hr>

- Prescriptive Modeling
- Introduction to Optimization