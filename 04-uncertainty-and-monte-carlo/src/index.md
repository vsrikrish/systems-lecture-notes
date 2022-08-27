class: center, middle

.title[Uncertainty and Monte Carlo Simulation]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[August 31, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Questions?
2. Probability Distributions in Julia
3. Coding Example
4. Introduction to Monte Carlo

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
class: left

# Coding Example: CRUD Simulation
<hr>

Now, let's do some simulations with the CRUD example.

Go to <https://github.com/BEE4750-FA22/class-examples/simulation/> and clone (you may have already done this).

---
class: left

# Monte Carlo Methods
<hr>

Last class, we used *Monte Carlo estimation* for frequencies of sums of multiple dice.

---
class: left

# Monte Carlo Methods
<hr>

.left-column[
Monte Carlo estimation involves:
1. Sampling input(s) from probability distribution(s);
2. Simulating the quantity of interest;
3. Aggregating the results.
]

.right-column[
    ![James Bond in Casino Royale](https://i0.wp.com/www.solzyatthemovies.com/wp-content/uploads/2021/09/CASINO_ROYALE_CR_13874_rgb-scaled.jpg)
]

---
class: left

# Monte Carlo Methods
<hr>

In this case, we used Monte Carlo to estimate a very simple quantity (which we didn't need it for), but it's a very powerful category of methods.

Monte Carlo estimation is a very useful method for calculating complex and high-dimensional integrals, since an integral is an $n$-dimensional area:
1. Sample uniformly from the domain;
2. Compute how many samples are in the area of interest.

---
class: left

# Monte Carlo (Formally)
<hr>

We can formalize this common use of Monte Carlo estimation as the computation of the expected value of a random quantity $Y$: 

$$\mu = \mathbb{E}[Y]$$

To do this, generate $n$ independent and identically distributed values $Y_1, \ldots, Y_n$.  Then the sample estimate is

$$\tilde{\mu} = \frac{1}{n}\sum_{i=1}^n Y_i$$

---
class: left

# Monte Carlo (Formally)
<hr>

More generally, we want to compute some quantity $Y=f(X)$, where $X$ is distributed according to some probability distribution $p(x)$ and $f(x)$ is a real-valued function over a domain $D$.

Then
$$\mu = \mathbb{E}(Y) = \int_D f(x)p(x)dx.$$

But the method is more general even than that: $X$ need not be continuous (like rolling dice).

And this isn't limited to scalars: so long as $f(x)$ is sufficiently well-behaved, the **law of large numbers** ensures that Monte Carlo estimation will work.

---
class: left

# The Large of Law Numbers
<hr>

If 

(1) $Y$ is a random variable and its expectation exists and 

(2) $Y_1, \ldots, Y_n$ are independently and identically distributed

Then by the **weak law of large numbers**:

$$\lim_{n \to \infty} \mathbb{P}\left(\left|\tilde{\mu}_n - \mu\right| \leq \varepsilon \right) = 1$$

--

In other words, *eventually* we will get within an arbitrary error of the true expectation. But how large is large enough?

---
class: left

# Monte Carlo Sample Mean
<hr>

Notice that the sample mean $\tilde{\mu}_n$ is itself a random variable.

With some assumptions (the mean of $Y$ exists and $Y$ has finite variance), the Monte Carlo sample mean $\mathbb{E}[\tilde{\mu}_n]$ is

$$\frac{1}{n}\sum_{i=1}^n \mathbb{E}[Y_i] = \frac{1}{n} n \mu = \mu$$


This means that the Monte Carlo estimate is an *unbiased* estimate of the mean.

---
class: left

# Monte Carlo Sample Error
<hr>

Next, we'd like to know more about the error of this estimate for a given sample size.

The variance of this estimator is

$$\tilde{\sigma}_n^2 = \text{Var}\left(\tilde{\mu}_n\right) = \mathbb{E}\left((\tilde{\mu}_n - \mu)^2\right) = \frac{\sigma_Y^2}{n}$$

So as $n$ increases, the *standard error* decreases:

$$\tilde{\sigma}_n = \frac{\sigma_Y}{\sqrt{n}}$$

---
class: left

# Monte Carlo Sample Error
<hr>

In other words, if we want to decrease the Monte Carlo error by 10x, we need 100x additional samples. **This is not an ideal method for high levels of accuracy.** The mathematician Alan Sokal once said

> Monte Carlo is an extremely bad method. It should only be used when all alternative methods are worse.
>
> .footer[-- Sokal, *Monte Carlo Methods in Statistical Mechanics*, 1996]

--

The thing is, though --- for a lot of problems, all alternative methods *are* worse!

---
class: left

# When To Use Monte Carlo?
<hr>

Converging at a rate of $1/\sqrt{n}$ is not great. But:

--

* All models are wrong, and so there always exists some irreducible model error. Can we reduce the Monte Carlo error enough so it's less than the model error and other uncertainties?

--

* We often need a lot of simulations. Do we have enough computational power?

---
class: left

# When To Use Monte Carlo?
<hr>

If you can compute your answers analytically, you probably should. **But for real problems, we often can't**, and problems that are analytically tractable are often so stylized that we want to test them across a variety of uncertainties to make sure we didn't over-simplify.

---
class: middle, center

<hr>
# Next Class
<hr>

- Monte Carlo confidence intervals
- Correlated uncertainties
- Intro to risk
