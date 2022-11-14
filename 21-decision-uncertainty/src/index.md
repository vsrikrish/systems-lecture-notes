class: center, middle

.title[Decision-Making Under Uncertainty]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[November 14, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Project Schedule
2. Questions?
3. Approaches to Decision-Making Under Uncertainty
4. Scenario Trees
5. Including Scenarios Into Optimization

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

- Overview of Sensitivity Analysis
- Application of Morris and Sobol Methods

---
class: left

# Decision-Making Under Uncertainty
<hr>

Many optimization frameworks (LP, etc) assume deterministic problem formulations.

But most systems problems aren't *actually* deterministic.


---
class: split-50

# Approaches to Decision-Making Under Uncertainty
<hr>

.left-column[
**A Common Approach**:
 1. Solve deterministic problem using best estimates and/or expected values.
 2. Stress-test with Monte Carlo (robustness, etc) or include safety margins.
]

--

.right-column[
**Alternative**:
 1. Solve stochastic problem for best expected performance (or similar summary statistic).
]

---
# Representing Uncertainty in Decision Problems
<hr>

*Previously with the Lake Problem*: Uncertainty in non-point source inflows represented through a distribution.

In this case, we can do Monte Carlo analysis to estimate some summary statistic:
- Expected performance
- Reliability of strategy

---
# Representing Uncertainty in Decision Problems
<hr>

But we can also represent uncertainty through scenarios and sequential events, which sometimes lets us rewrite decision problems to directly incorporate different outcomes.

---
# Revisiting the Farmer Problem
<hr>

A farmer can grow wheat, corn, and sugar beets on 500 ha of land. How much land should they allocate to each crop?

---
# Revisiting the Farmer Problem
<hr>

Key information:
- Planting costs are $\$150$, $\$230$, and $\$260$ per acre for wheat, corn, and sugar beets, respectively.
- The farmer requires $200$T of wheat and $240$T kg of corn for feed, and excess can be sold for $\$170$ and $\$150$ per T, respectively.
- Purchasing crops costs $40\%$ more than the selling prices.
- Sugar beets are sold at $\$36$/T up to $6000$T, at which point the price drops to $\$10$ per T.

---
# Farm Yields
<hr>

From prior experience, the farmer knows that in an average year, yields are:
- 2.5 T/acre for wheat;
- 3 T/acre per corn;  
- 20T/acre for beets.

---
# Problem Formulation
<hr>

Decision variables:

--

Variable | Definition
:----: | :-----
$x_i$ | acres of crop $i$ planted
$y_i$ | T of crop $i$ purchased
$z_i$ | T of crop $i$ sold

---
# Deterministic Problem Formulation
<hr>

$$\begin{alignedat}{3}
&\min\_{x, y, z} & & 150x\_1 + 230x\_2 + 260x\_3 +  238y\_1 + 210y\_2 - 170 z\_1 \\\\[0.5ex]
& &&\qquad -150z\_2 - 36z\_3 - 10z\_4 \\\\
& \text{subject to:} & & \qquad\\\\
& && x\_1 + x\_2 + x\_3 \leq 500 \\\\
& && 2.5 x\_1 + y\_1 - z\_1 \geq 200 \\\\
& && 3 x\_2 + y\_2 - z\_2 \geq 240 \\\\
& && z\_3 + z\_4 \leq 20 x\_3 \\\\
& && z\_3 \leq 6000 \\\\
& && x\_i, y\_i, z\_i \geq 0
\end{alignedat}$$

---
# Deterministic Solution
<hr>

Variable | Wheat | Corn | Beets
:----- | :-----: | :----: | :-----:
Area (acres) | 120 | 80 | 300
Yield (T) | 300 | 288 | 6000 
Sales (T) | 100 | -- | 6000 
Purchased (T) | -- | -- | --

<br>
This solution yields a profit of $\$118,600$.

--

What is this solution doing? Does it make sense?

---
# Now Let's Add Uncertainty
<hr>

But yields tend to vary from year to year. From prior experience, the historical variability is:
- in a good year, yields can be 20% above average;
- in a bad year, yields can be 20% below average.

--

To simplify things, let's assume these yields vary consistently across crops and that each scenario (average, good, bad) has an equal probability of occurrence.

---
# Stochastic Formulation
<hr>

What should our decision variables be?

.left-column[
**Deterministic**:

Variable | Definition
:----: | :-----
$x_i$ | acres of crop $i$ planted
$y_i$ | T of crop $i$ purchased
$z_i$ | T of crop $i$ sold

]

--

.right-column[
**Stochastic**:

Variable | Definition
:----: | :-----
$x_i$ | acres of crop $i$ planted
$y_{ij}$ | T of crop $i$ purchased in scenario $j$
$z_{ij}$ | T of crop $i$ sold in scenario $j$

]

---
# Stochastic Objective
<hr>

How can we formulate an objective?

--

**First choice: what statistic are we trying to optimize?**

--

Let's choose the expected value $\mathbb{E}\left[\text{Profit}\right]$.

Other possible choices: quantiles (*robust optimization*) to hedge against worst-case outcomes, variance (to minimize year-on-year fluctuations).

---
class: split-40

# Scenario Tree for Objective
<hr>

.column[

Since we have a discrete (and small) set of outcomes, we can use a **scenario tree** to write out the different outcomes.

This is overkill for this problem, but can be useful when there are nested or sequential outcomes (we'll see examples later).
]

.column[

.center[![Scenario Tree for Farmer Problem](figures/farm-scen-tree.svg)]

]

---
# Stochastic Objective
<hr>

Our new objective becomes:

$$\begin{alignedat}{2}
&\min\_{x, y, z} & & \quad 150x\_1 + 230x\_2 + 260x\_3 \\\\[0.5ex]
& &&\qquad -\frac{1}{3} \left(170z\_{11} + 150z\_{21} + 36z\_{31} + 10z\_{41} - 238y\_{11} - 210 y\_{21}\right) \\\\[0.5ex]
& &&\qquad -\frac{1}{3} \left(170z\_{12} + 150z\_{22} + 36z\_{32} + 10z\_{42} - 238y\_{12} - 210 y\_{22}\right) \\\\[0.5ex]
& &&\qquad -\frac{1}{3} \left(170z\_{13} + 150z\_{23} + 36z\_{33} + 10z\_{43} - 238y\_{13} - 210 y\_{23}\right)
\end{alignedat}$$

---
# Stochastic Constraints
<hr>

$$\begin{alignedat}{2}
&x\_1 + x\_2 + x\_3 \leq 500 \\\\
&\color{blue}3x\_1 + y\_{11} - z\_{11} \geq 200, && \qquad  \color{blue}3.6x\_2 + y\_{21} - z\_{21} \geq 240 \\\\
&\color{blue}z\_{31} + z\_{41} \leq 24x\_3, && \qquad \color{blue}z\_{31} \leq 6000 \\\\
&\color{purple}2.5x\_1 + y\_{12} - z\_{12} \geq 200, && \qquad \color{purple}3x\_2 + y\_{22} - z\_{22} \geq 240 \\\\
&\color{purple}z\_{32} + z\_{42} \leq 20x\_3, && \qquad \color{purple}z\_{32} \leq 6000 \\\\
&\color{red}2x\_1 + y\_{13} - z\_{13} \geq 200, && \qquad \color{red}2.4x\_2 + y\_{23} - z\_{23} \geq 240 \\\\
&\color{red}z\_{33} + z\_{43} \leq 16x\_3, && \qquad \color{red}z\_{33} \leq 6000 \\\\
&x\_i, y\_i, z\_i \geq 0
\end{alignedat}$$

---
# Stochastic Solution
<hr>

Variable | Wheat | Corn | Beets
:----- | :-----: | :----: | :-----:
Deterministic Area (acres) | 120 | 80 | 300
Stochastic Area (acres) | 170 | 80 | 250 

<br>
Deterministic Solution: $\text{``Expected'' Profit (no uncertainty)} = \$118,600$.<br>
Stochastic Solution: $\mathbb{E}[\text{Profit}] = \$108,390$.

**What should we do?**

---
# Expected Performance of Deterministic Solution
<hr>

Note that the deterministic solution only gives us the expected payoff in the average year: we'd get more or less yield in other years, which would affect profits.

Year | Deterministic Profit | Stochastic Profit
:--- | :----: | :----:
Good | \$148,000 | \$167,000
Average | \$118,600 | \$109,350
Bad | \$55,120 | \$48,820

<br>

**Expected Profit from Deterministic *under uncertainty***: \$107,240

---
# Value of the Stochastic Solution
<hr>

We can now compare the difference in expected profits *under uncertainty*, which is the fair comparison. This is called the **value of the stochastic solution (VSS)**, or sometimes the **expected value of including uncertainty (EVIU)**.

$$\begin{aligned}
VSS &= \mathbb{E}[\text{Stochastic Profit}] - \mathbb{E}[\text{Deterministic Profit}] \\\\
&= \$108,390 - \$107,240 \\\\
&= \$1,150.
\end{aligned}$$

---
# Value of the Stochastic Solution
<hr>

**To summarize**:

- A solution obtained assuming deterministic outcomes might "on paper" yield better anticipated outcomes.
- But for many problems, downside outcomes can carry a higher penalty than the upside reward.
- Solutions to stochastic problems can produce a better expected outcome than the deterministic solution, but will perform better/worse in any given scenario.

---
# Expected Value of Perfect Information
<hr>

Another relevant quantity, the **expected value of perfect information (EVPI)**, concerns the value associated with better forecasts.

If the farmer had perfect foresight and could allocate acreage $x$ accordingly and sell/purchase $z$ and $y$ optimally,

$$\mathbb{E}[\text{Profits} | \text{perfect information}] = \sum_j p_j \times \text{Profits}_j = \$115,405.$$

--

$$\text{EVPI} = \$115,405 - \$108,390 = \$7,015$$

---
# Other Approaches to Incorporating Uncertainty
<hr>

- Chance-Constrained Optimization
- Robust Optimization
- Stochastic Dynamic Programming
- Simulation-Optimization with Monte Carlo estimates of objective

**Note**: All of these can get very computationally expensive *very* quickly.

---
# Simplified Reservoir Operations Example
<hr>

Consider two conflicting objectives when managing a reservoir:
- Want to avoid floods
- Want to maintain appropriate water supply.

--

With a high water level, water demand is likely to be met, but highly damaging flooding is more probable.

With a low water level, flooding is less likely, but also less likely to meet demand.

--

**To Be Continued!**

---
# Key Takeaways
<hr>

- Ignoring uncertainty may *accidentally* lead to better solutions, but we would like to incorporate uncertainty into decision-making when possible.
- Value of the stochastic solution quantifies expected improvement in performance.
- Need to balance computational expense with representation of uncertainty.

---
class: middle

<hr>
# Next Class
<hr>
- More examples of decision-making under uncertainty