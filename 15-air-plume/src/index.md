class: center, middle

.title[Emissions and Plume Models]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[October 24, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Homework 4 Release
2. Questions?
3. Emissions of Pollutants
4. Gaussian Plume Models of Point Source/Receptors

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

- Unit Commitment
- Increased Complexity Switching from LP to MIP

---
class: left

# Air Pollution
<hr>

.center[![Clean Air Act Air Pollutants](https://deq.utah.gov/wp-content/uploads/AQversion2.jpg)
.cite[Source: [Utah Department of Environmental Quality](https://deq.utah.gov/communication/news/ask-an-environmental-scientist-what-air-pollutants-does-deq-test-for)]]

---
class: left

# Greenhouse Gases
<hr>

.center[![Human-Emitted Greenhouse Gases](https://assets.nrdc.org/sites/default/files/styles/full_content--retina/public/media-uploads/greenhouseeffect_graphic2_2400x1800_0.png?itok=1SUXMPEl)
.cite[Source: [NRDC](https://www.nrdc.org/stories/greenhouse-effect-101)]]

---
class: left

# Clean Air Act Impacts
<hr>

.center[![Clean Air Act Changes in GDP and Criteria Pollutants](https://media.rff.org/images/clean_air_PR.width-1480.png)
.cite[Source: [Resources for the Future](https://www.rff.org/news/press-releases/clean-air-act-successes-and-challenges-1970/)]]

---
class: left

# Modeling Air Pollution
<hr>

There are many approaches to modeling concentrations of pollutants/chemicals, including:

1. Point sources/receptors (plume/puff models)
2. Analyzing an "airshed" (box models)

---
class: left

# Point Sources/Receptors
<hr>

In this case, we're concerned about the dispersal from a point source:
.center[![Source-Receptor Geometry](figures/air-pollution.png)]

---
# Point Sources/Receptors
<hr>

At a given instant, the flow from source to receptor follows some path:
.center[![Source-Receptor Geometry](figures/air-pollution-instant.png)]

---
# Point Sources/Receptors
<hr>

Averaging over time gives us a "plume":
.center[![Source-Receptor Geometry](figures/air-pollution-plume-timeavg.png)]

---
# Point Source/Receptors
<hr>

What is the distribution of pollutant above the receptor?
.center[![Source-Receptor Geometry](figures/air-pollution-plume-timeavg.png)]

---
# "Gaussian Plume"
<hr>

We can reason that the concentration follows a "bell curve":
.center[![Source-Receptor Geometry](figures/air-pollution-plume-shape.png)]

---
# "Gaussian Plume"
<hr>

We can reason that the concentration follows a "bell curve":
.center[![Source-Receptor Geometry](figures/air-pollution-plume-dist.png)]

---
# "Gaussian Plume"
<hr>

Not illustrated here, but this same reasoning applies cross-wind.
.center[![Source-Receptor Geometry](figures/air-pollution-plume-dist.png)]

---
# Gaussian Plume Model
<hr>

For an elevated source **without reflection**:

$$C(x,y,z) = \frac{Q}{2\pi u\sigma_y \sigma_z} \exp\left[-\frac{1}{2}\left(\frac{y^2}{\sigma_y^2} + \frac{(z - H)^2}{\sigma_z^2}\right)\right].$$

Variable | Meaning 
:----: | :------
$C$ | Concentration (g/m$^3$)
$Q$ | Emissions rate (g/s)
$u$ | Wind speed (m/s)
$H$ | Height of source (m)
$x, y, z$ | Downwind, crosswind, vertical distances (m)

---
# Gaussian Plume Model Derivation
<hr>

We use the **advective-diffusion equation** to describe the mass-balance:

$$\frac{\partial C}{\partial t} = [D + K] \nabla^2 C - \vec{u} \cdot \vec{\nabla} C $$

where $D$ is the diffusion coefficient, $K$ is the dispersion coefficient due to turbulent mixing.

---
# Diffusive Flux
<hr>

.left-column[.center[![Flux from Diffusion](figures/diffusion-flux.png)]]

.right-column[.middle[
Fick's law: mass transfer by diffusion

$$F_x = D\frac{dC}{dx}

Concentration gradient + diffusion $\Rightarrow$ Flux]]

---
# Turbulent Flux
<hr>

.left-column[.center[![Flux from Turbulence](figures/turbulent-flux.png)]]

.right-column[.middle[

$$F\_x = K\_{xx} \frac{dC}{dx}$$

The dispersion coefficient $K_{xx}$ depends on flow/eddy characteristics.

Concentration gradient + turbulent mixing $\Rightarrow$ Flux]]

---
# Gaussian Plume Model Derivation
<hr>

$$\frac{\partial C}{\partial t} + \vec{u} \cdot \vec{\nabla} C  - [D + K] \nabla^2 C  = 0$$

Assumptions:

--

- Steady-state, e.g. $\frac{\partial C}{\partial t} = 0$

---

# Gaussian Plume Model Derivation
<hr>

$$\frac{\partial C}{\partial t} + \vec{u} \cdot \vec{\nabla} C  - [D + K] \nabla^2 C  = 0$$

Assumptions:

- Wind only in the $x$-direction:

$$\vec{u} \cdot \vec{\nabla} C = u_x \frac{\partial C}{\partial x} + \cancel{u_y \frac{\partial C}{\partial y}} + \cancel{u_z \frac{\partial C}{\partial z}}$$

---
# Gaussian Plume Model Derivation
<hr>

$$\frac{\partial C}{\partial t} + \vec{u} \cdot \vec{\nabla} C  - [D + K] \nabla^2 C  = 0$$

Assumptions:

- Turbulence $>>$ diffusion, e.g. $K >> D$, and $K$ is unimportant along $x$-direction:

$$-[\cancel{D} + K] \nabla^2 C = \cancel{K\_{xx}} \frac{\partial^2 C}{\partial x^2} + K\_{yy} \frac{\partial^2 C}{\partial y^2} + K\_{zz} \frac{\partial^2 C}{\partial z^2}$$

---
# Gaussian Plume Model Derivation
<hr>

With these assumptions, the equation simplifies to:

$$u \frac{\partial C}{\partial x} = K\_{yy} \frac{\partial^2 C}{\partial y^2} + K\_{zz}\frac{\partial^2 C}{\partial z^2}$$

--

.left-column[
Assume mass flow through vertical plane downwind must equal emissions rate $Q$:

$$Q = \iint u C dy dz$$ 
]

.right-column[
.center[![Boundary Condition for A-D Equation](figures/boundary-mass.png)]
]

---
# Gaussian Plume Model Derivation
<hr>

Solving this PDE:

$$C(x,y,z) = \frac{Q}{4\pi x \sqrt{K\_{yy} + K\_{zz}}} \exp\left[-\frac{u}{4x}\left(\frac{y^2}{K\_{yy}} + \frac{(z-H)^2}{K\_{zz}}\right)\right]$$

--

To deal with $K$, substitute:

$$\begin{aligned}
\sigma\_y^2 &= 2 K\_{yy} t = 2 K\_{yy} \frac{x}{u} \\\\
\sigma\_z^2 &= 2 K\_{zz} \frac{x}{u}
\end{aligned}$$

---
# Gaussian Plume Model Derivation
<hr>

Solving this PDE:

$$\begin{aligned}
C(x,y,z) &= \frac{Q}{4\pi x \sqrt{K\_{yy} + K\_{zz}}} \exp\left[-\frac{u}{4x}\left(\frac{y^2}{K\_{yy}} + \frac{(z-H)^2}{K\_{zz}}\right)\right] \\\\
\Rightarrow C(x,y,z) &= \frac{Q}{2\pi u \sigma\_y \sigma\_z} \exp\left[-\frac{1}{2}\left(\frac{y^2}{\sigma\_y^2} + \frac{(z-H)^2}{\sigma\_z^2}\right) \right],
\end{aligned}$$

which looks like a Gaussian distribution probability distribution if we restrict to $y$ or $z$.

---
# Gaussian Plume Model with Reflection
<hr>

Last piece: the ground dampens vertical dispersion.

.left-column[.center[![Reflected Mass Off Ground](figures/reflection.png)]]

.right-column[The mass that would be dispersed below the ground is reflected back, increasing the concentration.]

---
# Gaussian Plume Model with Reflection
<hr>

.left-column[We can account for this extra term using a flipped "image" of the source.]

.right-column[.center[![Reflected Mass Off Ground](figures/reflection-image.png)]]

---
# Final Model: Elevated Source with Reflection
<hr>

$$\begin{aligned}
C(x,y,z) = &\frac{Q}{2\pi u \sigma\_y \sigma\_z} \exp\left(\frac{-y^2}{2\sigma\_y^2} \right) \times \\\\
& \quad \left[\exp\left(\frac{-(z-H)^2}{2\sigma\_z^2}\right) + \exp\left(\frac{-(z+H)^2}{2\sigma\_z^2}\right) \right]
\end{aligned}$$

---
# Final Model: Elevated Source with Reflection
<hr>

Assumptions:

1. Steady-State
2. Constant wind velocity and direction
3. Wind >> dispersion in $x$-direction
4. No reactions
5. Smooth ground (avoids turbulent eddies and other reflections)

---
# Gaussian Plume Example
<hr>

SO$_2$ is emitted at a rate of $100 \text{g/s}$ from the top of a $100 \text{m}$-high chimney. The plume initially rises $10 \text{m}$ before being convected horizontally by a wind speed of $15 \text{m/s}$. What is the centerline ground-level concentration $3 \text{km}$ downwind if at this distance $\sigma_y = 80 \text{m}$ and $\sigma_z=30 \text{m}$ under current meteorological conditions?

$$\begin{aligned}
C(x,y,z) = &\frac{Q}{2\pi u \sigma\_y \sigma\_z} \exp\left(\frac{-y^2}{2\sigma\_y^2} \right) \times \\\\
& \quad \left[\exp\left(\frac{-(z-H)^2}{2\sigma\_z^2}\right) + \exp\left(\frac{-(z+H)^2}{2\sigma\_z^2}\right) \right]
\end{aligned}$$

---
# Gaussian Plume Example
<hr>

SO$_2$ is emitted at a rate of $100 \text{g/s}$ from the top of a $100 \text{m}$-high chimney. The plume initially rises $10 \text{m}$ before being convected horizontally by a wind speed of $15 \text{m/s}$. What is the centerline ground-level concentration $3 \text{km}$ downwind if at this distance $\sigma_y = 80 \text{m}$ and $\sigma_z=30 \text{m}$ under current meteorological conditions?

Variable | Value
:----: | :------
$Q$ | ?
$u$ | ?
$H$ | ?
$x, y, z$ | ?


---
# Gaussian Plume Example
<hr>

SO$_2$ is emitted at a rate of $100 \text{g/s}$ from the top of a $100 \text{m}$-high chimney. The plume initially rises $10 \text{m}$ before being convected horizontally by a wind speed of $15 \text{m/s}$. What is the centerline ground-level concentration $3 \text{km}$ downwind if at this distance $\sigma_y = 80 \text{m}$ and $\sigma_z=30 \text{m}$ under current meteorological conditions?

Variable | Value
:----: | :------
$Q$ | 40 (g/s)
$u$ | 2 (m/s)
$H$ | 110 (m)
$x, y, z$ | 3000, 0, 0 (m)

---
# Gaussian Plume Example
<hr>

SO$_2$ is emitted at a rate of $100 \text{g/s}$ from the top of a $100 \text{m}$-high chimney. The plume initially rises $10 \text{m}$ before being convected horizontally by a wind speed of $15 \text{m/s}$. What is the centerline ground-level concentration $3 \text{km}$ downwind if at this distance $\sigma_y = 80 \text{m}$ and $\sigma_z=30 \text{m}$ under current meteorological conditions?

$$\begin{aligned}
C(3000,0,0) = &\frac{100 \text{g/s}}{2\pi (15 \text{m/s})(80 \text{m})(30 \text{m})} \exp(0) \times  \\\\
& \quad \left[\exp\left(\frac{-(-110 \text{m})^2}{2(30 \text{m})^2}\right) + \exp\left(\frac{-(110 \text{m})^2}{2(30 \text{m})^2}\right) \right]
\end{aligned}$$

---
# Gaussian Plume Example
<hr>

SO$_2$ is emitted at a rate of $100 \text{g/s}$ from the top of a $100 \text{m}$-high chimney. The plume initially rises $10 \text{m}$ before being convected horizontally by a wind speed of $15 \text{m/s}$. What is the centerline ground-level concentration $3 \text{km}$ downwind if at this distance $\sigma_y = 80 \text{m}$ and $\sigma_z=30 \text{m}$ under current meteorological conditions?


$$C(x,y,z) = .27 \text{mg/m}^3,$$

which is around 2% of the [NIOSH short-term exposure standard for SO$_2$](https://www.cdc.gov/niosh/npg/npgd0575.html).

---
# Estimating Dispersion "Spread"
<hr>

Values of $\sigma_y$ and $\sigma_z$ matter substantially for modeling plume spread downwind. What influences them?

---
# Estimating Dispersion "Spread"
<hr>

**Main contribution**: atmospheric stability

Pasquill (1961): Six stability classes, A -> F.

---
# Estimating Dispersion "Spread"
<hr>

Contributors to atmospheric stability:
- Temperature gradient
- Wind speed
- Solar radiation
- Cloud cover
- Richardson number (buoyancy / flow shear)

---
# Estimating Dispersion "Spread"
<hr>

Can estimate deviations based on stability class,

$$\begin{aligned}
\sigma_y &= ax^b \\\\
\sigma_z &= cx^d + f
\end{aligned}$$

where the coefficients are linked to the stability class.

---
# Multiple Point Sources
<hr>

.left-column[
Suppose we have three sources of SO$_2$:

| Source | Emissions (kg/day) | Effective Height (m) | Removal Cost (\$/kg)
| :----: | ----: | -----: | -----:
| 1 | 34,560 | 50 | 0.20
| 2 | 172,800 | 200 | 0.45
| 3 | 103,680 | 30 | 0.60

and five receptors with $u = 1.5$ m/s and air quality standard 150 $
\mu$g/m$^3$.
]

```@eval
using Plots
using LaTeXStrings
gr()

scatter([(0, 7), (2, 5), (3, 5)], label="Source", markersize=6, color=:red, xlabel=L"$x$ (km)", ylabel=L"$y$ (km)", guidefontsize=14, legendfontsize=12, tickfontsize=12, legend=:bottomright)
scatter!([(1, 1.5), (3, 7), (5, 3), (7.5, 6), (10, 5)], label="Receptor", markersize=6, color=:black)
plot!(size=(400, 450))

savefig("multiple-sources.svg")
```

.right-column[.center[![Schematic for Multiple Sources](figures/multiple-sources.svg)]]


---

# Key Takeaways
<hr>

- Regulatory controls (or lack thereof) on air pollutants (Clean Air Act, etc) and greenhouse gas emissions (patchwork)
- Concentrations of contaminants can be modeled in several ways, depending on the goal and assumptions.
- Point source/receptor: Gaussian plume is common approach.

--- 
class: center, middle

<hr>
# Next Class
<hr>

- Multiple source example
- Box models of airsheds
