class: center, middle

.title[Simulation-Optimization and the Shallow Lake Problem]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[October 31, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Project Due Dates
2. HW 4 Due Thursday
3. Questions?
4. Challenges to Mathematical Programming
5. Shallow Lake Model
6. Simulation-Optimization

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

- Multiple Point Sources/Receptors
- Box Modeling for Airsheds

---
class: left

# Mathematical Programming
<hr>

**Previous weeks**: "Mathematical Programming" with formal decision models: objectives and constraints as functions (linear or otherwise) of decision variables.

Mathematically programming is nice when possible because you can guarantee that you can find optima for certain classes of problems.

---
class: left

# What If We Can't Write Down a Mathematical Program?
<hr>

But what if our constraints and objectives cannot be written down as a mathematical program?

This often occurs with systems models, due to complex, nonlinear dynamics. 

---
class: left

# Systems Dynamics: Feedback Loops
<hr>

.left-column[**Feedback loops** can be *reinforcing* or *dampening*.

Dampening feedback loops are associated with *stable* equilibria, while reinforcing feedback loops are associated with *instability*.]

.right-column[
.center[![Reinforcing Feedback Example](figures/reinforcing-feedback.png)]
]

---
class: left

# Systems Dynamics: Bifurcations
<hr>

.left-column[**Bifurcations** occur at thresholds when the qualitative behavior of a system changes.

These thresholds are sometimes referred to as "tipping points" and are often associated with a *stable* state equilibrium transitioning to an *unstable* one.]

.right-column[.center[![Bifurcation Diagram](figures/bifurcation.png)]]

---
class: left

# Systems Dynamics: Emergence
<hr>

**Emergence** refers to when simple rules governing interactions result in macro-scale "ordered" patterns and possibly unexpected behaviors.

.left-column[
*Examples*:
- Schelling segregation model (left)
- Macroeconomic systems
- Snowflake formation
]

.right-column[
.center[![Schelling Model Animation](https://upload.wikimedia.org/wikipedia/commons/e/e8/Schellings.gif)]
.cite[Source: Blaqdolphin - Own work, CC BY-SA 4.0, https://commons.wikimedia.org/w/index.php?curid=91228415]
]

---
# Example: Shallow Lake Problem
<hr>

.left-column[
Suppose we have a town which emits phosphorous into a lake as a by-product of economic activity. 

The lake also receives phosphorous from non-point source runoff. There is some nutrient cycling in the lake which naturally reduces phosphorous concentrations.
]

.right-column[
.center[![Shallow Lake Problem Diagram](figures/eutrophication-system-all.png)]
]

---
# Shallow Lake Model
<hr>

Suppose the lake dynamics are given by:

$$X_{t+1} = X_t + a_t + y_t + \frac{X_t^q}{1 + X_t^q} - bX_t, \quad y_t \sim LogNormal(\mu, \sigma^2)$$

| Parameter | Definition | Units |
|:---------:|:------|:-----|
| $X_t$ | P concentration in lake | dimensionless |
| $a_t$ | point source P input | dimensionless |
| $y_t$ | non-point source P input | dimensionless |
| $q$ | P recycling rate | dimensionless |
| $b$ | rate at which P is lost | dimensionless |

---
# Impacts of Parameters on Equilibria
<hr>

```@eval
using Plots
using LaTeXStrings
x = 0:0.05:2.5
fin(x, q) = x.^q ./ (1 .+ x.^q)
fout(x, b) = b .* x

p1 = plot(x, fin(x, 2.5), color=:black, linewidth=5,legend=:topleft, label=:false, ylabel="P Flux", xlabel=L"$X_t$", tickfontsize=12, guidefontsize=14, legendfontsize=12, palette=:tol_muted, framestyle=:origin, grid=:false)
plot!(x, fout(x, 0.6), linewidth=3, linestyle=:dash, label=L"$b=0.6$")
plot!(x, fout(x, 0.4), linewidth=3, linestyle=:dash, label=L"$b=0.4$")
plot!(x, fout(x, 0.2), linewidth=3, linestyle=:dash, label=L"$b=0.2$")
plot!(size=(400, 400), ylims=(0, 1))
quiver!([1], [0.35], quiver=([1], [0.4]), color=:red, linewidth=2)
quiver!([0.4], [0.19], quiver=([-0.125], [-0.05]), color=:red, linewidth=2)
quiver!([2.5], [0.97], quiver=([-0.125], [-0.05]), color=:red, linewidth=2)
savefig("lake-nox.svg")

p2 = plot(x, 0.05 .+ fin(x, 2.5), color=:black, linewidth=5,legend=:topleft, label=:false, ylabel="P Flux", xlabel=L"$X_t$", tickfontsize=12, guidefontsize=14, legendfontsize=12, palette=:tol_muted, framestyle=:origin, grid=:false)
plot!(x, fout(x, 0.6), linewidth=3, linestyle=:dash, label=L"$b=0.6$")
plot!(x, fout(x, 0.4), linewidth=3, linestyle=:dash, label=L"$b=0.4$")
plot!(x, fout(x, 0.2), linewidth=3, linestyle=:dash, label=L"$b=0.2$")
plot!(size=(400, 400), ylims=(0, 1))
savefig("lake-x.svg")

nothing # hide
```

.left-column[
$a + y = 0, q=2.5$:

.center[![Impact On Flux](figures/lake-nox.svg)]
.cite[Adapted from [Quinn et al (2017)](https://dx.doi.org/10.1016/j.envsoft.2017.02.017)]
]

.right-column[
$a + y = 0.05, q=2.5$:

.center[![Impact On Flux](figures/lake-x.svg)]
]

---
# Can We Write Down a Mathematical Program For This Problem?
<hr>

Our objective might be to maximize $\sum_{t=1}^T a_t$ (as a proxy for economic activity), while keeping a low probability of eutrophication. 

--

Straightforward to compute probability of eutrophication for a given input sequence $a_t$ using Monte Carlo simulation for $y_t$, but highly nontrivial to write this out in analytic form.

Even if we did, it'd be *very* nonlinear and definitely nonconvex, which rules out most forms of mathematical programming.

---
# Simulation-Optimization
<hr>

*So how do we make decisions?*

--

Recall our previous comment about Monte Carlo!

We can use a search algorithm to explore the exceedance probabilities using our simulation model, and find the "optimum" sequence of releases that keeps the probability of eutrophification at some specified level.

---
# Why "Optimum" in Quotes?
<hr>

Unlike mathematical programming, **there is usually no guarantee that a solution found this way is truly optimal**.

Simulation-optimization methods typically rely on *heuristics* to decide that a solution is good enough. These can include
- number of evaluations/iterations; or
- lack of improvement of solution.

---
# Challenges to Simulation-Optimization In General
<hr>

- **Monte Carlo Error**: If constraints or objective is probabilistic, how many Monte Carlo runs are needed to ensure difference in function values is "real" and not stochastic noise.
- **Computational**: Can be expensive depending on the simulation model.
- **Local vs. Global Optima**: Depending on type of search algorithm, may not be able to guarantee more than a local optimum.

But, like Monte Carlo, often other methods are impossible or worse.

---
# Gradient Estimation
<hr>

.left-column[Find estimate of gradient near current point and step in positive/negative direction (depending on max/min).

$$x_{n+1} = x_n \pm \alpha_n \nabla f(x_n)$$

But: may not find global optimum; stepsize plays a big role in convergence.
]


```@eval
using Plots
using Measures
using LaTeXStrings

f(x) = 4 .* x.^4 - 10 .* (x.+2).^3 - 6 .* (x.-15).^2 + 2 .* (x.+4).^2
x = -4:0.01:5
plot(x, f(x), grid=false, linewidth=3, label=false, yticks=false, xticks=false, ylabel="Objective", xlabel="Decision Variable", left_margin=8mm, legendfontsize=12, guidefontsize=14)
scatter!([-2.36 3.69], f.([-2.36 3.69]), color=[:blue :red], markersize=[8 12], label=["Local Optimum" "Global Optimum"])
ylims!((-1800, -1100))
xlims!((-4, 5))
scatter!([0], [f(0)], color=:black, label="Start Point", markersize=6)
plot!([0, 0], [-1800, f(0)], color=:gray, linestyle=:dot, label=:false)
plot!([-1, -1], [-1800, f(-1)], color=:gray, linestyle=:dot, label=:false)
plot!([-1.75, -1.75], [-1800, f(-1.75)], color=:gray, linestyle=:dot, label=:false)
quiver!([0], [-1775], quiver=([-1], [0]), color=:red)
quiver!([-1], [-1775], quiver=([-0.75], [0]), color=:red)
annotate!([0.25], [-1750], text(L"x_1", :red, 14))
annotate!([-0.75], [-1750], text(L"x_2", :red, 14))
annotate!([-1.5], [-1750], text(L"x_3", :red, 14))

savefig("gradient-algorithm.svg")
nothing # hide
```

.right-column[.center![Gradient Search Algorithm](figures/gradient-algorithm.svg)]

---
# Random Search
<hr>

.left-column[Use a sampling strategy to find a new proposal, then evaluate, keep if improvement.

- Evolutionary Algorithms fall into this category.
- No guarantees! Need to evaluate lots and convince yourself you've done enough.]

```@eval
using Plots
using Measures
using LaTeXStrings
using Distributions
using Random

f(x) = 4 .* x.^4 - 10 .* (x.+2).^3 - 6 .* (x.-15).^2 + 2 .* (x.+4).^2
x = -4:0.01:5
plot(x, f(x), grid=false, linewidth=3, label=false, yticks=false, xticks=false, ylabel="Objective", xlabel="Decision Variable", left_margin=8mm, legendfontsize=12, guidefontsize=14)
scatter!([-2.36 3.69], f.([-2.36 3.69]), color=[:blue :red], markersize=[8 12], label=["Local Optimum" "Global Optimum"])
ylims!((-1800, -1100))
xlims!((-4, 5))
Random.seed!(1)
y = -4 .+ 9 .* rand(5)
scatter!([y], [f.(y)], color=:black, label=:false, markersize=6)
annotate!([y[1] + 0.5], [f.(y[1])], text(L"x_1", :black, 14))
annotate!([y[2] + 0.5], [f.(y[2])], text(L"x_2", :black, 14))
annotate!([y[3] + 0.5], [f.(y[3])], text(L"x_3", :black, 14))
annotate!([y[4] + 0.5], [f.(y[4])], text(L"x_4", :black, 14))
annotate!([y[5] + 0.5], [f.(y[5])], text(L"x_5", :black, 14))

savefig("random-algorithm.svg")
nothing # hide
```

.right-column[.center[![Random Search Algorithm](figures/random-algorithm.svg)]]

---
# Random Search with Constraints
<hr>

.left-column[With constraints, need a way to mark samples as infeasible.]

```@eval
using Plots
using Measures
using LaTeXStrings
using Distributions
using Random

f(x) = 4 .* x.^4 - 10 .* (x.+2).^3 - 6 .* (x.-15).^2 + 2 .* (x.+4).^2
x1 = -4:0.01:3.1
x2 = 3.1:0.01:5
plot(x1, f(x1), grid=false, linewidth=3, label=false, yticks=false, xticks=false, ylabel="Objective", xlabel="Decision Variable", left_margin=8mm, legendfontsize=12, guidefontsize=14)
plot!(x2, f(x2), linestyle=:dash, color=:purple, linewidth=3, label=false)
vline!([3.1], color=:orange, linewidth=5, label=false)
scatter!([-2.36 3.1], f.([-2.36 3.1]), color=[:blue :red], markersize=[8 12], label=["Local Optimum" "Constrained Optimum"])
ylims!((-1800, -1100))
xlims!((-4, 5))
Random.seed!(1)
y = -4 .+ 9 .* rand(5)
scatter!([y[1:4]], [f.(y[1:4])], color=:black, label=:false, markersize=6)
scatter!([(y[5], f(y[5]))], color=:orange, label=:false, markersize=6)
annotate!([y[1] + 0.5], [f.(y[1])], text(L"x_1", :black, 14))
annotate!([y[2] + 0.5], [f.(y[2])], text(L"x_2", :black, 14))
annotate!([y[3] + 0.5], [f.(y[3])], text(L"x_3", :black, 14))
annotate!([y[4] + 0.5], [f.(y[4])], text(L"x_4", :black, 14))
annotate!([y[5] + 0.5], [f.(y[5])], text(L"x_5", :orange, 14))

savefig("random-algorithm-const.svg")
nothing # hide
```

.right-column[.center[![Random Search Algorithm](figures/random-algorithm-const.svg)]]

---
# Random Search In Julia
<hr>

Two main packages:

- [`Metaheuristics.jl`](https://docs.juliahub.com/Metaheuristics/aJ70z/3.2.12/)
- [`BlackBoxOptim.jl`](https://github.com/robertfeldt/BlackBoxOptim.jl)

---
# Quick Example (Adapted From `Metaheuristics.jl` Tutorial)
<hr>

```@example optim; continued=true
using Metaheuristics
using Distributions
using Random
Random.seed!(1)
# define function to optimize
function f(x)
    lnorm = LogNormal(0.25, 1) 
    y = rand(lnorm)
    return sum(x .- y)^2
end
fobj(x) = mean([f(x) for i in 1:1000])
```

---
# Quick Example (Adapted From `Metaheuristics.jl` Tutorial)
<hr>

```@example optim
# set bounds
bounds = [0.0 1000.0]'
# optimize
results = optimize(fobj, bounds, DE())
results.best_sol
```

---
# `Metaheuristics.jl` Algorithms
<hr>

`Metaheuristics.jl` contains [a number of algorithms](https://docs.juliahub.com/Metaheuristics/aJ70z/3.2.12/algorithms/), covering a number of single-objective and multi-objective algorithms.

We won't go into details here, and will just stick with `DE()` (differential evolution) in our examples.

---
# Lake Example (Including Constraints)
<hr>

Lake Problem: Let's try to keep the probability of exceeding the critical value (leading to eutrophication) less than 80%.

```@example lake
using Metaheuristics
using Distributions
using Plots
using Random
using Roots
Random.seed!(1)

# set parameters
q = 2.5
b = 0.4
T = 100
nsamples = 1000
```

---
# Lake Example (Including Constraints)
<hr>

.left-column[
```@example lake
# get NPS inflows
lnorm = LogNormal(log(0.03), 0.1)
y = rand(lnorm, (T, nsamples))
phist = histogram(rand(lnorm, 10000), legend=:false, grid=:false) # hide
savefig("nps-inflow-samps.svg") # hide
# find critical value
crit(x) = (x^q/(1+x^q)) - b*x
Xcrit = find_zero(crit, (0.1, 1.5))
```
]

.right-column[
.center[![NPS Inflow Distribution](figures/nps-inflow-samps.svg)]
]

---
# Lake Example (Including Constraints)
<hr>

```@example lake; continued=true
# define lake model
function lake(a, y, q, b, T)
    X = zeros(T+1, size(y, 2))
    # calculate states
    for t = 1:T
        X[t+1, :] = X[t, :] .+ a[t] .+ y[t, :] .+ (X[t, :].^q./(1 .+ X[t, :].^q)) .- b.*X[t, :]
    end
    return X
end
function lake_opt(a, y, q, b, T, Xcrit)
    X = lake(a, y, q, b, T)
    # calculate exceedance of critical value
    Pexceed = sum(X[101, :] .> Xcrit) / size(X, 2)
    failconst = [Pexceed - 0.2]
    return mean(a), failconst, [0.0]
end
```

---
# Lake Example (Including Constraints)
<hr>

```@example lake
# set bounds
bounds = [0.0ones(T) 0.1ones(T)]'
# optimize
obj(a) = lake_opt(a, y, q, b, T, Xcrit)
options = Options(f_calls_limit=1000)
results = optimize(obj, bounds, DE(options=options))
```

---
# Lake Example (Including Constraints)
<hr>

.left-column[
```@example lake
using Plots

a = results.best_sol.x
X = lake(a, y, q, b, T)
plot(X, alpha=0.1, 
    guidefontsize=14, tickfontsize=12, 
    legendfontsize=12, label=:false,
    legend=:topleft)
hline!([Xcrit], color=:red, linestyle=:dot, 
    label="Critical Value")
plot!(size=(400, 400))
savefig("lake-series.svg") # hide
nothing # hide
```
]

.right-column[
.center[![Lake Model Time Series](figures/lake-series.svg)]
]

---
# Lake Example (Including Constraints)
<hr>

.left-column[
```@example lake
histogram(X[101, :], xlabel="End P Concentration", ylabel="Count",
    guidefontsize=14, tickfontsize=12, 
    legendfontsize=12, label=:false)
vline!([Xcrit], color=:red, linestyle=:dot, 
    label="Critical Value")
plot!(size=(400, 400))
savefig("lake-dist.svg") # hide
nothing # hide
```
]

.right-column[
.center[![Lake Model Time Series](figures/lake-dist.svg)]
]

---
# Key Takeaways
<hr>

- Many challenges to using mathematical programming for general systems analysis.
- Can use simulation-optimization approaches.
- But be careful of computational expense and convergence!

---
class: middle

<hr>
# Next Class
<hr>
- In-Class Coding Exercise with the Lake Problem