class: center, middle

.title[Simulating Systems]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[August 29, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Questions?
2. Simulating Systems
3. Uncertainty and Probability

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
name: reasons

class: left

layout: false

# Some Reasons To Simulate With Models
<hr>

* System involves complex, nonlinear dynamics that may not be analytically tractable.
* Setting up and running a real-world experiment is not possible
* Need to understand range of system performance across rarely-seen conditions.   

---
class: left

# Simulating Dice Rolls
<hr>

A model doesn't have to be particularly "complex" for it to be worth simulating: sometimes there are just a lot of combinations, and it would be tedious to solve the problem analytically.

Let's look at a classic (if cliched) example: **what is the probability of rolling two dice and getting a count of 7?**

---
# Simulating Dice Rolls
<hr>

**What is the probability of rolling two dice and getting a count of 7?**

.left-column[![Combinations of two dice](figures/dice-count.png)
.cite[Modified from [West Yorkshire Backgammon](http://westyorkshirebackgammon.co.uk/How%20to%20part%203.html)]
]

--

.right-column[Sample Space (total number of combinations): 36, each with probability 1/36

Events summing to 7: 6

**So the probability is 6/36=1/6.**]

---
class: left

# A More Involved Dice Example
<hr>

Now: **what is the probability of rolling 4 dice for a total of 19?**

--

We could solve this analytically as well, but it's tedious. Instead, let's solve this computationally.

---
class: left

# A More Involved Dice Example
<hr>

**What is the probability of rolling 4 dice for a total of 19?**

To answer this question, we have two options:

--

1. We could enumerate all possibilities of combinations of 4 dice (*~1300*), like before, but use a computer to do it more quickly.

--

2. We can simulate lots of individual rolls of 4 dice and keep a running tally of the frequency of 19s.

---
class: left

# A More Involved Dice Example
<hr>

**What is the probability of rolling 4 dice for a total of 19?**

```@example dice
using Random, Distributions

Random.seed!(1) # set seed
# this function rolls several dice repeatedly and returns the sums of each trial
function dice_roll_repeated(n_trials, n_dice)
    dice_dist = DiscreteUniform(1, 6) 
	roll_results = zeros(n_trials)
	for i=1:n_trials
		roll_results[i] = sum(rand(dice_dist, n_dice))
	end
	return roll_results
end
nothing # hide
```

---
class: left

# A More Involved Dice Example
<hr>

**What is the probability of rolling 4 dice for a total of 19?**

```@example dice
# roll four dice 10000 times
rolls = dice_roll_repeated(10000, 4) 

# calculate probability of 19
sum(rolls .== 19) / length(rolls) 
```

--

By comparison, the true value is 0.0432.

Is that difference meaningful?

---
class: left

# A More Involved Dice Example
<hr>

**How does this estimate vary as we add more simulated rolls?**

```@example dice
# initialize storage for frequencies by sample length
avg_freq = zeros(length(rolls)) 
# compute average frequencies of 19
avg_freq[1] = (rolls[1] == 19)
count = 1
for i=2:length(rolls)
    avg_freq[i] = (avg_freq[i-1] * (i-1) + (rolls[i] == 19)) / i
end
nothing # hide
```

---
class: left

# A More Involved Dice Example
<hr>

**How does this estimate vary as we add more simulated rolls?**

.left-column[
```@example dice
using Plots
Plots.scalefontsizes(1.75) #hide

# plot running average frequencies 
scatter(avg_freq, markershape=:xcross,
    markersize=1, grid=:false,
    label="frequency of 19s", 
    legend=:bottom)
# plot the true value for comparison
hline!([0.0432], color="red", 
    label="true value") 
savefig("dice-freq.svg") #hide
nothing #hide
```
]

.right-column[.center[![Plot of Dice Frequencies](figures/dice-freq.svg)]]

---
class: left

# A More Involved Dice Example
<hr>

This use of stochastic simulation to solve a deterministic problem is an example of *Monte Carlo estimation*. We'll return to this later.

--

**Note**: For this problem, Monte Carlo simulation actually took more runs to get a "reliable" estimate. But it may scale better as the number of uncertainties increases (6 dice: *~46,000 combinations*).

---
template: reasons

layout: false

---
class: left

layout: true

# Multiple Objectives and Tradeoffs
<hr>

Simulation also facilitates *exploratory* analyses of multiple outcomes of interest.

For example: 

{{content}}

---

**Reservoir management** involves tradeoffs between water supply, hydropower potential, flood risk, and streamflow.

---

**Electric power systems** can involve tradeoffs between reliability, emissions, and other materials flow (for batteries)

---

**Climate risk management** involves...lots of tradeoffs! Mitigation costs, warming risk, and more specific cross-sectoral tradeoffs depending on the mitigation pathway.

---
class: left

layout: false

# Reminder: "All Models Are Wrong, But Some Are Useful"
<hr>

.center[![XKCD Comic 2355](https://imgs.xkcd.com/comics/university_covid_model_2x.png)]

.cite[Source: <https://xkcd.com/2355>]

---
class: left

# Reminder: "All Models Are Wrong, But Some Are Useful"
<hr>

.left-column[*Every* systems model simplifies or neglects certain aspects of the system!

It's essential to use domain knowledge to understand when these simplifications are appropriate and what the implications might be.]

.right-column[![Conceptual Schematic of a Systems Model](figures/system-conceptual.svg)]

---
class: left

# Uncertainty and Systems Modeling
<hr>

.left-column[Deterministic systems models can be subject to uncertainties due to the separation between the "internals" of the system and the "external" environment.]

.right-column[![Conceptual Schematic of a Systems Model](figures/system-conceptual.svg)]

---
class: left

layout: true

# What Is Uncertainty?
<hr>

{{content}}

---

**Glib Answer**: *A lack of certainty!*

--

**More Seriously**: Uncertainty refers to an inability to exactly describe current or future values or states.

---

Two (broad) types of uncertainties:
* *Aleatory* uncertainty, or uncertainties resulting from randomness;
* *Epistemic* uncertainty, or uncertainties resulting from lack of knowledge. 

---
class: left

layout: false

# On Epistemic Uncertainty
<hr>

.center[
![XKCD cartoon 2440: Epistemic Uncertainty](https://imgs.xkcd.com/comics/epistemic_uncertainty.png)
<br>
.cite[Source: <https://xkcd.com/2440>]
]

---
name: probability-def

class: left

layout: false

# Uncertainty and Probability
<hr>

We often represent uncertainty using *probabilities*.

What is probability?

---
template: poll-answer

***What is probability?***

---
template: probability-def

--
* Long-run frequency of an event (**frequentist**)
--
* Degree of belief that a proposition is true (**Bayesian**)
--

The frequentist definition concerns what would happen with a large enough number of repeated trials. The Bayesian definition concerns the odds that you should bet on an outcome. 

---
class: left

name: distributions

# Probability Distributions
# <hr>

.left-column[The likelihood of possible values of an unknown quantity are often represented as a probability distribution.

One key feature for systems analysis: **tails**! These can represent low-probability but high-impact outcomes (more on this later...)]

```@eval
using Distributions, Plots, StatsPlots

x = range(-5, 10; length = 100)
plot(x, pdf.(Cauchy(), x), linecolor = :red, linestyle = :dash, yaxis = false, yticks = false, grid = false, label = "Cauchy Distribution", size=(500, 400))
plot!(x, pdf.(Normal(), x), linecolor = :blue, label = "Normal Distribution")
plot!(x[x .> 1.75], pdf.(Cauchy(), x[x .> 1.75]), fillrange = pdf.(Normal(), x[x .> 1.75]), fillcolor = :red, fillalpha = 0.2, label = false, linecolor= false)
xlabel!("Value")
savefig("dist-tails.svg") #hide
nothing #hide
```

.right-column[.center[![Comparison of Cauchy and Normal distributions. Notice the difference in tail area.](figures/dist-tails.svg)]]

---
class: left 

name: distributions-julia

# Working with Distributions in Julia
<hr>

In Julia, we use [`Distributions.jl`](https://juliastats.org/Distributions.jl/stable/) to work with probability distributions.

.left-column[
```@example
using Random, Distributions, Plots

Random.seed!(1) # set seed
# define a distribution
normal_dist = Normal(0, 1) 
# draw samples
normal_samp = rand(normal_dist, 1000)
# plot histogram
histogram(normal_samp, grid=false, 
    legend=false, ylabel="Count",
    xlabel="Value", size=(500, 400))
savefig("normal_hist.svg") #hide
nothing #hide
```
]

.right-column[.center[![Histogram of Normal Samples](figures/normal_hist.svg)]]

---
name: distributions-julia-2

class: left

# Working with Distributions in Julia
<hr>

We can also plot probability distribution functions (pdfs).

.left-column[
```@example
using Distributions, Plots

# set grid of x values to evaluate
x = range(-10, 10; length = 100)
# evaluate pdf over x
norm_pdf = pdf.(Normal(0, 2), x)
# make plot
plot(x, norm_pdf, linecolor=:blue, 
    legend=false, grid=false, 
    xlabel="Value", yticks=false, 
    yaxis=false, size=(500, 400))
savefig("dist-norm.svg") #hide
nothing # hide
```
]

.right-column[.center[![Plot of Normal PDF](figures/dist-norm.svg)]]


---
class: middle, left

<hr>
# Next Class
<hr>

- Coding example of systems simulation (**bring laptop to class if possible!**)
- How does Monte Carlo work?
