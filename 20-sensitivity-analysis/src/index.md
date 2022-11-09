class: center, middle

.title[Introduction to Sensitivity Analysis]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[November 9, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Project Due Dates
2. Questions?
3. Introduction to Sensitivity Analysis

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

- Robustness
- Satisfycing and Regret-Based Measures

---
class: left

# Prioritizing Factors of Interest
<hr>

Many parts of a systems-analysis workflow involve potentially large numbers of modeling assumptions, or *factors*:
- Monte Carlo simulation
- Simulation-Optimization
- Robustness of decisions

Every additional factor considered increases computational expense and analytic complexity.


---
class: split-40

# Prioritizing Factors of Interest
<hr>

.column[
Key question:

*How do we know which factors are most relevant to a particular analysis?*

or

*What modeling assumptions were most responsible for output uncertainty?*
]

.column[
.center[![Sensitivity Analysis Schematic](https://ars.els-cdn.com/content/image/1-s2.0-S1364815218302822-gr1_lrg.jpg)
.center[.cite[Source: [Saltelli et al (2019)](https://doi.org/10.1016/j.envsoft.2019.01.012)]]
]
]

---
# Sensitivity Analysis
<hr>

This question is commonly addressed using **sensitivity analyses**.

---
name: questions

template: poll-answer

***What do you think of when you hear "sensitivity analysis"?***

---
layout: false

# Sensitivity Analysis
<hr>

Sensitivity analysis is...

> the study of how uncertainty in the output of a model (numerical or otherwise) can be apportioned to different sources of uncertainty in the model input
>
> .footer[- Saltelli et al (2004), *Sensitivity Analysis in Practice*]

---
name: sa-why

layout: true

# Why Perform Sensitivity Analysis?
<hr>

.left-column[
    
{{content}}

]

.right-column[
.center[![Sensitivity analysis modes](https://uc-ebook.org/docs/html/_images/figure3_2_factor_mapping.png)]
.center[.cite[Source: [Reed et al (2002)](https://uc-ebook.org/)]]
]

---
template: sa-why

**Factor Prioritization**: 

Which factors have the greatest impact on output variability?

---
template: sa-why

**Factor Fixing**:

Which factors have negligible impact and can be fixed in subsequent analyses?

---
template: sa-why

**Factor Mapping**: 

Which values of factors lead to model outputs in a certain output range?

---
layout: false

# Shadow Prices Are Sensitivities
<hr>

We've seen one example of a quantified sensitivity before: **the shadow price of an LP constraint.**

The shadow price expresses the objective's sensitivity to a unit relaxation of the constraint.

--

**For example (HW3)**: how much money could be saved with a unit reduction of a CO<sub>2</sub> constraint.

---
# Types of Sensitivity Analysis
<hr>

- One-at-a-Time vs. All-At-A-Time Sampling
- Local vs. Global

---
# One-at-a-Time Sampling
<hr>

**Assumption**: Factors are linearly independent (no interactions).

**Benefits**: Easy to implement and interpret.

**Limits**: Ignores potential interactions.

---
# All-At-A-Time Sampling
<hr>

Number of different sampling strategies: full factorial, Latin hypercubes, more.

**Benefits**: Can capture interactions between factors.

**Challenges**: Can be computationally expensive, does not reveal where key sensitivities occur.

---
class: split-40

# Local vs. Global
<hr>

.column[

**Local** sensitivities: Pointwise perturbations from some baseline point.

Challenge: *Which point to use?*

]

.column[

.center[![Local vs. Global Sensitivity Analysis](figures/globallocalsa.png)]

]

---
class: split-40

# Local vs. Global
<hr>

.column[

**Global** sensitivities: Sample throughout the space.

Challenge: *How to measure global sensitivity to a particular output?*

Advantage: *Can estimate interactions between parameters*
]

.column[

.center[![Global Sensitivity Analysis](figures/globalsa.png)]

]

---
# How to Calculate Sensitivities?
<hr>

Number of approaches. Some examples:
- Derivative-based or Elementary Effect (*Method of Morris*)
- Regression 
- Variance Decomposition or ANOVA (*Sobol Method*)
- Density-based (*$\delta$ Moment-Independent Method*)

For our subsequent examples, we will look at *global* analyses with *variance decomposition* (Sobol method).

---

# Example: Lake Problem
<hr>

For a fixed release strategy, look at how different parameters influence reliability.

Take $a_t=0.03$, and look at the following parameters within ranges:

Parameter | Range 
:-----: | :-----:
$q$ | $(2, 3)$
$b$ | $(0.3, 0.5)$
$ymean$ | $(\log(0.01), \log)(0.07))$ 
$ystd$ | $(0.01, 0.25)$

---

# Method of Morris
<hr>

The Method of Morris is an *elementary effects* method.

This is a global, one-at-a-time method which averages effects of perturbations at different values $\bar{x}_i$:

$$S\_i = \frac{1}{r} \sum\_{j=1}^r \frac{f(\bar{x}^j\_1, \ldots, \bar{x}^j\_i + \Delta\_i, \bar{x}^j\_n) - f(\bar{x}^j\_1, \ldots, \bar{x}^j\_i, \ldots, \bar{x}^j\_n)}{\Delta\_i}$$

where $\Delta\_i$ is the step size.

---
class: split-50
# Method of Morris for the Lake Problem
<hr>

```@setup lakesa
using Distributions
using Random
using Roots

function lake(a, y, q, b, T)
    X = zeros(T+1, size(y, 2))
    # calculate states

    for t = 1:T
        X[t+1, :] = X[t, :] .+ a[t] .+ y[t, :] .+ (X[t, :].^q./(1 .+ X[t, :].^q)) .- b.*X[t, :]
    end
    return X
end

function lake_sens(params)
    Random.seed!(1)
    T = 100
    nsamp = 1000

    q = params[1]
    b = params[2]
    ymean = params[3]
    ystd = params[4]

    lnorm = LogNormal(ymean, ystd)
    y = rand(lnorm, (T, nsamp))
    crit(x) = (x^q/(1+x^q)) - b*x
    Xcrit = find_zero(crit, 0.5)

    X = lake(0.03ones(T), y, q, b, T)
    rel = sum(X[T+1, :] .<= Xcrit) / nsamp
    return rel
end
```

.left-column[

```@example lakesa
using GlobalSensitivity

Random.seed!(1) # hide
s = gsa(lake_sens, Morris(), 
    [(2, 3), (0.3, 0.5), (log(0.01), log(0.07)), 
    (0.01, 0.25)])
abs.(s.means)
```

```@example lakesa
s.variances
```

]

.right-column[

```@setup lakesa
using Plots
using LaTeXStrings

p1 = bar([L"$q$", L"$b$", "ymean", "ystd"], (abs.(s.means) .+ 0.01)', legend=false, title="Sensitivity Index Means", guidefontsize=14)
p2 = bar([L"$q$", L"$b$", "ymean", "ystd"], (s.variances .+ 0.01)', legend=false, yaxis=:log, title="Sensitivity Index Variances", guidefontsize=14)
plot(p1, p2, layout=(2,1))
savefig("morris-lake.svg")
```

.center[![Method of Morris Results](figures/morris-lake.svg)]

]

---
# Sobol Method
<hr>

The Sobol method is a variance decomposition method, which attributes the variance of the output into contributions from individual parameters or interactions between parameters.

$$S\_i^1 = \frac{Var\_{x\_i}\left[E\_{x\_{\sim i}}(x\_i)\right]}{Var(y)}$$

$$S\_{i,j}^2 = \frac{Var\_{x\_{i,j}}\left[E\_{x\_{\sim i,j}}(x\_i, x\_j)\right]}{Var(y)}$$

---
# Sobol for Lake Problem
<hr>

```@example lakesa
using GlobalSensitivity

s = gsa(lake_sens, Sobol(order=[0, 1, 2], nboot=10), 
    [(2, 3), (0.3, 0.5), (log(0.01), log(0.07)), (0.01, 0.25)];
    samples = 100)
s.ST'
```

```@example lakesa
s.ST_Conf_Int'
```


---
# Sobol for Lake Problem
<hr>

.left-column[

```@example lakesa
s.S1'
```

```@example lakesa
s.S1_Conf_Int'
```

]

.right-column[

```@example lakesa
s.S2
```

```@example lakesa
s.S2_Conf_Int
```
]

---
# Example: Cumulative CO<sub>2</sub> Emissions
<hr>

.center[![Model for CO2 Emissions](figures/co2-model.png)]

---
# Example: Cumulative CO<sub>2</sub> Emissions
<hr>

.center[![CO2 Emissions Sensitivities](https://media.springernature.com/full/springer-static/image/art%3A10.1007%2Fs10584-021-03279-7/MediaObjects/10584_2021_3279_Fig5_HTML.png)]
.center[.cite[Source: [Srikrishnan et al (2022)](https://doi.org/10.1007/s10584-021-03279-7)]]

---
# What Next?
<hr>

**Factor prioritization/fixing**: inform Monte Carlo or model simplification

**Factor mapping**: Scenario discovery, identify key parameters leading to outcomes of interest

---
# Key Takeaways
<hr>

- Sensitivity Analysis involves attributing variability in outputs to input factors.
- Factor prioritization, factor fixing, factor mapping are key modes.
- Different types of sensitivity analysis: choose carefully based on goals, computational expense, input-output assumptions.
- Many resources for more details.

---
class: middle

<hr>
# Next Class
<hr>

- Decision-Making Under Uncertainty: Decision Trees