class: center, middle

.title[Robustness]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[November 7, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Project Due Dates
2. HW Plan
3. Questions?
4. Robustness

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

- Simulation-Optimization Exercise

---
class: left

# Conceptual Assumptions of Optimization
<hr>

Optimization problems implicitly assume perfect specification of:

- Model Structure
- Parameters
- Decision Alternatives/Specifications

--

*Even with Monte Carlo simulation, need to make assumptions about distributional forms and parameters.*

---
class: left

# What If These Are Wrong?
<hr>

Optimization problems implicitly assume perfect specification of:

- Model Structure
- Parameters
- Decision Alternatives/Specifications

*If these components are mis-specified, what are the implications?*

---
class: left

# Reminder: Bifurcations
<hr>

.left-column[**Bifurcations** occur at thresholds when the qualitative behavior of a system changes.

These thresholds are sometimes referred to as "tipping points" and are often associated with a *stable* state equilibrium transitioning to an *unstable* one.]

.right-column[.center[![Bifurcation Diagram](figures/bifurcation.png)]]

---
class: left

# Impact of Bifurcations On Misspecification
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
quiver!([0.4], [0.12], quiver=([-0.125], [-0.05]), color=:red, linewidth=2)
quiver!([2.5], [0.97], quiver=([-0.125], [-0.05]), color=:red, linewidth=2)
scatter!([(0.67, 0.4 * 0.67)], markershape=:star5, color=:gold, markersize=10, label=:false)
savefig("lake-1.svg")

p2 = plot(x, fin(x, 1), color=:black, linewidth=5,legend=:topleft, label=:false, ylabel="P Flux", xlabel=L"$X_t$", tickfontsize=12, guidefontsize=14, legendfontsize=12, palette=:tol_muted, framestyle=:origin, grid=:false)
plot!(x, fout(x, 0.6), linewidth=3, linestyle=:dash, label=L"$b=0.6$")
plot!(x, fout(x, 0.4), linewidth=3, linestyle=:dash, label=L"$b=0.4$")
plot!(x, fout(x, 0.2), linewidth=3, linestyle=:dash, label=L"$b=0.2$")
plot!(size=(400, 400), ylims=(0, 1))
quiver!([0.4], [0.1], quiver=([1], [0.4]), color=:red, linewidth=2)
quiver!([2.3], [0.87], quiver=([-0.5], [-0.2]), color=:red, linewidth=2)
scatter!([(0.67, 0.4 * 0.67)], markershape=:star5, color=:gold, markersize=10, label=:false)
savefig("lake-2.svg")

nothing # hide
```

.left-column[
$q=2.5$:

.center[![Impact On Flux](figures/lake-1.svg)]
.cite[Adapted from [Quinn et al (2017)](https://dx.doi.org/10.1016/j.envsoft.2017.02.017)]
]

.right-column[
$q=1$:

.center[![Impact On Flux](figures/lake-2.svg)]
]

---

# A Few Relevant Quotes!
<hr>

> Reports that say that something hasn't happened are always interesting to me, because as we know, there are **known knowns**; there are things **we know we know**. We also know there are **known unknowns**; that is to say **we know there are some things we do not know**. But there are also **unknown unknowns** — the ones **we don't know we don't know**. And if one looks throughout the history of our country and other free countries, **it is the latter category that tends to be the difficult ones**.
>
> .footer[-- Donald Rumsfeld, 2002 (emphasis mine)]

---

# A Few Relevant Quotes!
<hr>

> It ain’t what you don’t know that gets you into trouble. It’s what you know for sure that just ain’t so. 
>
> .footer[-- Often attributed to Mark Twain (apocryphal)]

---
template: poll-answer

***What can we do to reduce the risk of misspecification?***

---
# "Deep" Uncertainty
<hr>

This issue of mis-specification becomes particularly acute in the presence of *deep* uncertainties, which are uncertainties for which we cannot write down a consensus probability distribution.

---
template: poll-answer

***What are some examples of deep uncertainty?***


---
# "Deep" Uncertainty
<hr>

We won't talk much more about deep uncertainties, but they make this issue of misspecification more acute.

--

We might be able to discuss "expected" performance (more on this next week) in the presence of well-characterized uncertainties, but can you compute an expected value or quantile without a probability distribution?


---
layout: false

# Robustness
<hr>

What we'd like to have is a sense of how well a decision performs under *plausible* alternative specifications.

This is referred to as **robustness**.

---

template: poll-answer

***What do you think of when you hear the word "robustness"?***

---
layout: false

# Robustness
<hr>

**Note**: We are using "robustness" in a slightly different sense than some other related uses.

---
# Robustness
<hr>

The basic idea of robustness: summarizing how well a decision works across a range of different plausible futures.

---

# Lake Problem and Robustness
<hr>

.left-column[
Let's consider the lake problem. Suppose we estimate $q=2.5$, $b=0.4$, and runoffs $y_t\sim~LogNormal(\log(0.03), 0.1).$ 

After testing against 1000 runoff samples, we decide to try a release of $a_t = 0.04$ units each year.
]

```@setup lake
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
a = 0.04ones(T)

# get NPS inflows
lnorm = LogNormal(log(0.03), 0.1)
y = rand(lnorm, (T, nsamples))
phist = histogram(rand(lnorm, 10000), legend=:false, grid=:false, tickfontsize=12, guidefontsize=14)
# find critical value
crit(x) = (x^q/(1+x^q)) - b*x
Xcrit = find_zero(crit, (0.1, 1.5))

# define lake model
function lake(a, y, q, b, T)
    X = zeros(T+1, size(y, 2))
    # calculate states
    for t = 1:T
        X[t+1, :] = X[t, :] .+ a[t] .+ y[t, :] .+ (X[t, :].^q./(1 .+ X[t, :].^q)) .- b.*X[t, :]
    end
    return X
end

X = lake(a, y, q, b, T)
plot(X, alpha=0.1, 
    guidefontsize=10, tickfontsize=8, 
    legendfontsize=8, label=:false,
    legend=:topleft, dpi=300)
hline!([Xcrit], color=:red, linestyle=:dot, 
    label="Critical Value")
plot!(size=(275, 275))
savefig("lake-series.png")
```

--

.right-column[
.center[![Lake Problem Simulations](figures/lake-series.png)]
]

---
# But If We're Wrong...
<hr>

.left-column[
But now suppose that actually $q=2.4$!
]

```@setup lake
q = 2.4
b = 0.4
a = 0.04ones(T)

X = lake(a, y, q, b, T)
plot(X, alpha=0.1, 
    guidefontsize=10, tickfontsize=8, 
    legendfontsize=8, label=:false,
    legend=:topleft, dpi=300)
hline!([Xcrit], color=:red, linestyle=:dot, 
    label="Critical Value")
plot!(size=(275, 275))
savefig("lake-series-q.png")
```

.right-column[
.center[![Lake Problem Simulations](figures/lake-series-q.png)]
]

---
# But If We're Wrong...
<hr>

.left-column[
Or that $b=0.38$...
]

```@setup lake
q = 2.5
b = 0.38
a = 0.04ones(T)

X = lake(a, y, q, b, T)
plot(X, alpha=0.1, 
    guidefontsize=10, tickfontsize=8, 
    legendfontsize=8, label=:false,
    legend=:topleft, dpi=300)
hline!([Xcrit], color=:red, linestyle=:dot, 
    label="Critical Value")
plot!(size=(275, 275))
savefig("lake-series-b.png")
```

.right-column[
.center[![Lake Problem Simulations](figures/lake-series-b.png)]
]

---
# But If We're Wrong...
<hr>

```@setup lake
q = 2.5
b = 0.4
a = 0.04ones(T)

lnorm = LogNormal(log(0.033), 0.2)
y2 = rand(lnorm, (T, nsamples))
phist2 = histogram(rand(lnorm, 10000), legend=:false, grid=:false, tickfontsize=12, guidefontsize=14)
vline!([minimum(y)], color=:red, linestyle=:dot)
vline!([maximum(y)], color=:red, linestyle=:dot)
plot(phist, phist2, layout=(2, 1), link=:x)
savefig("lake-runoff-samples.svg")

X = lake(a, y2, q, b, T)
plot(X, alpha=0.1, 
    guidefontsize=10, tickfontsize=8, 
    legendfontsize=8, label=:false,
    legend=:topleft, dpi=300)
hline!([Xcrit], color=:red, linestyle=:dot, 
    label="Critical Value")
plot!(size=(275, 275))
savefig("lake-series-yvar.png")
```

.left-column[
Or 

$$y_t\sim LogNormal(\log(0.033), 0.2):$$

.center[![Lake Runoff Samples](figures/lake-runoff-samples.svg)]
]

.right-column[
.center[![Lake Problem Simulations](figures/lake-series-yvar.png)]
]

---
# Varying $q$ and $b$
<hr>

```@setup lake
using LaTeXStrings

q = 1:0.05:3
b = 0.1:0.05:0.8

out = [sum(lake(a, y, qq, bb, T)[101, :] .> Xcrit) for qq in q for bb in b]
scatter([(qq, bb) for qq in q for bb in b], marker_z=out .> (0.2 * T), seriescolor=cgrad(:RdBu_3, rev=true), legend=:false, ylabel=L"$b$", xlabel=L"$q$", tickfontsize=14, guidefontsize=16)
scatter!([(2.5, 0.4)], markershape=:star5, color=:blue, markersize=8)
savefig("lake-robust-grid.svg")
```

.left-column[
Let's explore whether this strategy meets our constraint over a variety of $q$ and $b$ values:
]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Robustness Measures
<hr>

.left-column[
Given an assessment of performance over a variety of specifications (or **states of the world**), there are a number of metrics that can be used to capture robustness, and the choice can matter quite a bit.

Two common ones are **satisfycing** and **regret**.
]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Satisfycing
<hr>

.left-column[**Satisfycing** metrics try to express the degree to which performance criteria are satisfied across the considered states of the world.
]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Satisfycing
<hr>

.left-column[A simple satisfycing metric: what is the fraction of states of the world (SOWs) in which the criterion is met, or

$$S=\frac{1}{N}\sum_{n=1}^N I_n,$$

where $I_n$ indicates if the performance criterion is met in SOW $n$.
]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Satisfycing
<hr>

.left-column[In this case, $S=0.58$.

Other satisfycing criteria might measure the "distance" from the baseline case before the system fails.
]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Regret
<hr>

.left-column[**Regret** metrics capture how much we "regret" (or lose in value) worse performances across SOWs.
]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Regret
<hr>

.left-column[A simple regret metric: what is the average worsening of performance across SOWs?

$$R = \frac{1}{N} \sum\_{n=1}^N \frac{\min(P\_n - P\_\text{crit}, 0)}{P\_\text{crit}},$$

where $P_\text{crit}$ is the performance criterion and $P_n$ is the performance in SOW $n$.
]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Regret
<hr>

.left-column[In this case, $R = 0.41$.

Note: Commonly we care about *maximum* regret over the considered SOWs. There are lots of possible metrics!
 ]

.right-column[
.center[![Evaluation of Lake Management Strategy](figures/lake-robust-grid.svg)]
]

---
# Robustness Metrics
<hr>

We could use these metrics during our optimization procedure by:
- minimizing regret or maximizing satisfycing as an objective;
- using either as a constraint.

A key point is that these different metrics, and even different metrics within the satisfying and regret categories, might rank decisions differently.

---
# Other Considerations
<hr>

Some other considerations when conducting robustness assessments:
- How are different SOWs generated?
- 

---
# Key Takeaways
<hr>

- Optimization methods make assumptions about model and parameter specification.
- This assumption can lead to very bad outcomes in the presence of nonlinear system dynamics such as bifurcations.
- Robustness is an approach to measuring how well a decision performs under mis-specification.
- Many different robustness metrics, make sure you choose one appropriate for the context.

---
class: middle

<hr>
# Next Class
<hr>

- Introduction to Sensitivity Analysis