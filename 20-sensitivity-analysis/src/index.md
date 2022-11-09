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

- One-at-a-Time vs. Joint Sampling
- Local vs. Global

---
# One-at-a-Time Sampling
<hr>

**Assumption**: Factors are linearly independent (no interactions).

**Benefits**: Easy to implement and interpret.

**Limits**: Ignores potential interactions.

---
# Joint Sampling
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
class: split-40

# Example: Lake Problem
<hr>

.column[

For a fixed release strategy, look at how different parameters influence reliability.

]

.column[

.center[![Lake Problem Sensitivity](figures/lake-sa.png)]

]

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