class: center, middle

.title[Examples of Decision-Making Under Uncertainty]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[November 16, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Project Schedule
2. Questions?
3. Reservoir Management Example
4. Recap and Synthesis of Class Topics

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

- Introduction to Decision-Making Under Future Uncertainty
- Value of the Stochastic Solution
- Expected Value of Perfect Information
- Mention of Some Alternative Frameworks

---
class: left

# Decision-Making Under Uncertainty
<hr>

**Last class**: Simple two-stage land allocation problem.

**Today**: Simple two-stage reservoir management problem (still very stylized!)

---

# Reservoir Management
<hr>

Two common objectives with reservoir management:
1. Meet water demands (*e.g.* recreation, agriculture, hydropower, environmental)
2. Avoid flooding

---
class: split-40

# Reservoir Management
<hr>

.left-column[

Reservoir has a maximum storage level $S_\text{max}$ TAF.

Mass-Balance: 

$$S_{t+1} = S_t + I_t - E_t - R_t$$

Here we'll assume evaporation $E$ is negligible.

]

.right-column[

.center[![Reservoir Mass Balance Diagram](figures/reservoir-mass-balance.png)]

]

---
class: split-40

# Reservoir Management
<hr>

.left-column[

Higher storage levels increase the probability of larger discharges, which could result in flooding.

Lower storage levels might not leave enough water to discharge to meet demand.

]

.right-column[

.center[![Reservoir Mass Balance Diagram](figures/reservoir-mass-balance.png)]

]

---

# Reservoir Management Decision Problem
<hr>

We'll formulate a *very* simple two-stage problem.

**First stage**: What storage level $S$ should we aim for at the end of period one given uncertain inflows $I$ and demand $D$?

**Second stage**: After inflows and demand are realized, we can discharge $R$.

---

# Reservoir Management Decision Problem
<hr>

**But**:
- There is a maximum safe discharge $R\_{safe}$, and exceeding this causes a flood.
- If $S$ is too close to $S_\text{max}$, we have to discharge enough to keep the storage below max.
- If $S$ is too low, may not be able to discharge enough to meet demand.

---
# Reseroir Management: Scenario Tree
<hr>

.center[![Reservoir Scenario Tree](figures/reservoir-scen-tree.png)]

---
# Reservoir Management: Decision Variables
<hr>

Variable | Definition
:-----: | :-----
$S$ | Initial reservoir storage (TAF)
$R_{j}$ | Release in scenario $j$ (TAF)
$N_{j}$ | Unserved demand in scenario $j$ (TAF)
$F_{j}$ | Flood volume in scenario $j$ (TAF)

---

# Reservoir Management: Objective
<hr>

How can we formulate an objective for this problem?

--

$$\min_{S,R,N} \mathbb{E}\left[c_N N_j + c_F F_j\right],$$

where $c_N$ is the cost of unmet demand and $c_F$ is the cost of flooding.

---

# Reservoir Management: Problem Formulation
<hr>

$$\begin{alignat}{2}
& \min\_{S,R,N} \quad \frac{1}{J} \sum\_j^J \rho\_j \left(c\_N N\_j + c\_F F\_j\right) && \\\\
& S + I\_j - R\_j \leq S\_\text{max} && \qquad \forall j \\\\
& R\_j + N\_j \geq D\_j && \qquad \forall j \\\\
& R\_j \leq R\_\text{safe} + F\_j && \qquad \forall j\\\\
& S, R\_j, N\_j, F\_j \geq 0 && \qquad \forall j
\end{alignat}$$

---

# Reservoir Management: Parameters
<hr>

Parameter | Units | Value | 
:------: | :-----: | :----: 
$S_\text{max}$ | TAF | 100  
$R_\text{safe}$ | TAF | 40
$D_\text{low}$ | TAF | 10 
$D_\text{high}$ | TAF | 35 
$I_\text{low}$ | TAF | 5 
$I_\text{med}$ | TAF | 60
$I_\text{high}$ | TAF | 150

---
# Reservoir Management Results
<hr>

.left-column[

Scenario/Variable | Probability/Value 
:------: | :-----: |  
$D_\text{low}$ |  2/3
$D_\text{high}$ | 1/3
$I_\text{low}$ |  1/4
$I_\text{med}$ | 5/8
$I_\text{high}$ | 1/8
$c_N$ | \$500/TAF  
$c_F$ | \$1000/TAF 

]

.right-column[

The optimal initial volume is $S = 5 \text{ TAF}$. 

This results in:
* flooding of 15 TAF when inflows are high;
* 25 TAF of unmet demand when inflows are low and demand is high.


]

---
# Reservoir Management Results
<hr>

.left-column[

Scenario/Variable | Probability/Value 
:------: | :-----: |  
$D_\text{low}$ |  2/3
$D_\text{high}$ | 1/3
$I_\text{low}$ |  1/4
$I_\text{med}$ | 5/8
$I_\text{high}$ | 1/8
**$c_N$** | **\$100/TAF**  
$c_F$ | \$1000/TAF 

]

.right-column[

Reducing $c_N$ gives an optimal initial volume of $S = 0 \text{ TAF}$.  This results in:
* flooding of 10 TAF when inflows are high;
* Unmet demand with low inflows: 5 TAF when demand is low and 30 TAF when high.

]

---
# Reservoir Management Results
<hr>

.left-column[

Scenario/Variable | Probability/Value 
:------: | :-----: |  
$D_\text{low}$ |  2/3
$D_\text{high}$ | 1/3
**$I_\text{low}$** |  **29/100**
**$I_\text{med}$** | **7/10**
**$I_\text{high}$** | **1/100**
$c_N$ | \$500/TAF  
$c_F$ | \$1000/TAF 

]

.right-column[

If the high inflows are more rare, we're more likely to risk flooding. The optimal storage is now 30 TAF.

This results in no unmet demand, but flooding of 40 TAF when inflows are high.

]

---
# How Could We Make This More Realistic?
<hr>

--

- Sequential decision-making
- Continuous/more realistic inflow distributions
- Nonlinear objective (for example: quadratic penalties)
- More realistic demand
- Hydropower releases
- Minimum reservoir volume target (for example: recreation)

**Many of these require large-scale computation and/or simulation!**

---
# Reservoir Management Example Takeaways
<hr>

- Number of scenarios can increase exponentially.
- Decisions are typically sensitive to scenario probabilities (which we saw last time as well).
- Assigning relative cost/weights for different objectives can change the decision as well -- be careful!

---
class: center, middle

.title[Class Review]

---
class: left

# Concepts Covered
<hr>

1. Components of Systems
2. Uncertainty and Risk
3. Simulation/Descriptive Modeling
4. Prescriptive Modeling/Decision-Making
5. Checking Assumptions
6. Decision-Making Under Uncertainty

---
class: left

# System Components
<hr>

- Stocks/Flows
- Endogenous vs. Exogenous Components, Control Volumes
- Constraints or Performance Standards often imposed by regulations and stakeholder priorities.

---
# Uncertainty and Risk
<hr>

- Risk is the product of Hazard, Exposure, Vulnerability.
- Represent uncertainties through probability distributions.
- Monte Carlo to evaluate how uncertainties propagate through system.

---
# Simulation Modeling
<hr>

- Used to understand/describe system dynamics.
- Fate & transport modeling to evaluate mass-balances over spatial/temporal subdomains.
- Often used for Monte Carlo.
- Saw waste load allocation problems in wastewater and air quality.

---
# Prescriptive Modeling
<hr>

- Used for decision-making
- Saw deterministic linear and mixed-integer linear mathematical programs.
- Examples include resource allocation problems, network problems, power systems applications, air quality 
- Simulation-Optimization when mathematical programming is not possible or is intractable.

---
# Checking Assumptions
<hr>

- Often have to use best estimates or guesses for parameter values or input distributions.
- Robustness and sensitivity analysis offer approaches to checking impact of those assumptions.
- Careful to use appropriate methods and metrics!
- Just scratched the surface --- lots more to explore.

---
# Decision-Making Under Uncertainty
<hr>

- When possible, can obtain different solutions by formulating a problem stochastically.
- Often requires a tradeoff with model fidelity and/or uncertainty representation.
- Once again, just scratched the surface!

---
# Overarching Themes
<hr>

- Neglecting systems dynamics and interactions can be tempting, but is fraught
- These nonlinearities and feedbacks make stress-testing analyses under varying assumptions essential.
- But there do exist a variety of mathematical and computational frameworks and approaches which let us build on engineering fundamentals to analyze systems.
- Always try to choose the right tool for the job, and be aware of what limitations accompany models, methods, and assumptions.

---
name: questions

template: poll-answer

***Any remaining questions?***


---
class: center, middle

<hr>
# Next Class
<hr>
- Term Project Meetings
