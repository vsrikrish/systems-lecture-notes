class: center, middle

.title[Introduction to Systems]
<br>
.subtitle[BEE 4750/5750]
<br>
.subtitle[Environmental Systems Analysis, Fall 2022]
<hr>
.author[Vivek Srikrishnan]
<br>
.date[August 27, 2022]

---
name: toc

class: left

# Outline
<hr>

1. Welcome!
2. Topics
3. Course Policies
4. Computational Tools
5. Course Communication
6. Tips for Success
7. *Intro to Systems*

---
name: welcome

class: left

# Welcome to BEE 4750/5750!
<hr>


In this course, we will learn (using examples from environmental systems) how to:

* Define systems and their boundaries
* Simulate system dynamics using simulation models
* Analyze and assess risk
* Formulate and solve linear and nonlinear optimization problems
* Explore trade-offs across competing objectives

---
name: poll-answer

layout: true

class: left

# Poll
<hr>

.left-column[{{content}}

URL: <https://pollev.com/vsrikrish>

Text: **VSRIKRISH** to 22333, then message]

.right-column[.centered[![Poll Everywhere QR Code](../figures/vsrikrish-polleverywhere.png)]]

---
name: welcome-poll

template: poll-answer

***What are you hoping to get out of this class?***

---
name: topics

layout: false

class: left

# Course Organization
<hr>

1. Introduction to Systems Analysis
2. Simulating Systems and Risk
3. Systems Management and Optimization
4. Analyzing Assumptions
5. *Decision-Making Under Uncertainty*

---
name: policies

class: left

layout: true

# Course Policies
<hr>

---
name: grades

template: policies

## Grades

- 35% homework assignments
- 25% regulatory review project
- 30% final project
- 10% participation

---
name: assessments

template: policies

## Homework Assignments

- Approximately 6 in total
- Managed with GitHub Classroom (more on this shortly)
- Submit on Gradescope by 9:00 PM on due date
- Collaboration encouraged, but **everyone must submit their own original work unless otherwise specified**
- Late submissions penalized by 10% per day

---
name: reg-project

template: policies

## Regulatory Review Project

- Requires researching an environmental regulation and modeling a relevant system
- Will receive guidance from a Cornell librarian
- **We will discuss this in class before you start**

---
name: final-project

template: policies

## Final Project

- Group project for 4750, individual for 5750
- Work on applying and extending tools from this course to an analysis of a system of interest
- Submit a poster and possibly a technical supplement
- **We will discuss this in class before you start**

---
name: office-hours

template: policies

## Office Hours

- Time TBD (watch for poll)
- 1x/week by Zoom (maybe?)

---
name: website

template: policies

## Course Website

- The website for this course is <https://viveks.me/environmental-systems-analysis>
- Includes course information, announcements, schedule, notes, demos, resources
- **Make sure you check the site regularly!**
 
---
name: communications

template: policies

## Communications

- Use [Ed Discussion](https://us.edstem.org) for discussions about class, homework assignments, readings, etc.
- Try to use public Ed posts instead of email and private posts so others can benefit from questions.
- But when privacy or urgency is essential, use whatever channel is appropriate.
- *Announcements primarily through the course website and Ed Discussion*

---
name: software

class: left

layout: true

# Software Tools
<hr>

---
name: julia

template: software

## Julia

This course will use the [Julia programming language](https://julialang.org/).

- Julia is a modern, powerful, fast language
- Demos and tips available on the website
- Familiarize yourself with the documentation and searching for answers to questions!
- We will discuss and work on coding examples in class

---
name: julia-poll

template: poll-answer

***Programming language familiarity***


---
name: weave

template: software

## Weave.jl

Homework assignments will be written and compiled using `Weave.jl`.

- `Weave.jl` is a package for literate programming which allows integration of text (Markdown) and code (Julia) in a single document.
- Result can be easily compiled to HTML or a PDF.
- We have an example code and document available.

---
name: github

template: software

## Github Classroom

Access to assignments will be through Github Classroom.

- You will be given a link to create a repository when an assignment is released.
- PDFs of assignments will be auto-compiled when you `git push`.
- Makes it easy to share code for feedback and debugging.
- Let's look at [an example repository](https://github.com/BEE4750/hw0)!

---
name: tips

layout: false

class: left

# Tips for Success
<hr>

- Start assignments early!
- Ask questions in class and on Ed and try to help your classmates
- **Collaborate** &mdash; this is life as an engineer once you leave college!
- But don't just copy, your work should reflect your own understanding.

---
name: intro-systems-title

class: center, middle

<hr>
# Introduction to Systems Analysis
<hr>

---
name: system-intro  

layout: true

class: left

# What Is A System?
<hr>

{{content}}

---

> A system is "an interconnected set of elements that is coherently organized in a way that achieves something...A system must consist of three kinds of things: *elements*, *interconnections* and *a function or purpose*."
>
>> -- Donella Meadows, *Thinking in Systems: A Primer*, 2008

---

class: left

In other words, **a system involves an interconnected set of components**, and analyzing a system involves **understanding the dynamics caused by those interconnections**.

For examples, systems might have:
* amplifying or dampening feedbacks;
* thresholds and bifurcations;
* emergent dynamics.

---
name: systems-analysis

layout: false

class: left

# Systems Analysis
<hr>

.left-column[## What We Study

- System dynamics;
- Response to inputs;
- Alternatives for management or design.
]

--

.right-column[## Needs

{{content}}
]

--

- Definition of the system
- Systems model


---
name: systems-def

class: left

# What Do We Need to Define a System?
<hr>

- *Components*: relevant processes, agents, etc
--
- *Interconnections*: relationships between system components
--
- *Control volume*: internal vs. external components
--
- *Inputs*: control policies and/or external forcings
--
- *Outputs*: measured quantities of interest

---
name: systems-fig

layout: true

class: left

# Example Systems Diagram: Lake Eutrophication
<hr>

---

.left-column[## Components

Relevant "pieces" for the system
]

--

.right-column[![Lake Eutrophication System Components](../figures/eutrophication-system-comps-01.png)]

---

.left-column[## Interconnections

Relationships between components
]

--

.right-column[![Lake Eutrophication System Interconnections](../figures/eutrophication-system-arrows-01.png)]

---

.left-column[## Control Volume

"Boundary" between internal and external components and processes
]

--

.right-column[![Lake Eutrophication Control Volume](../figures/eutrophication-system-cv-01.png)]

---

.left-column[## Inputs

Additional external inputs: these may be control policies or forcings
]

--

.right-column[![Lake Eutrophication System Control Volume](../figures/eutrophication-system-cv-01.png)]

---

.left-column[## Outputs

System outputs for monitoring or inputs into other systems
]

--

.right-column[![Lake Eutrophication System Outputs](../figures/eutrophication-system-all-01.png)]

---
layout: false

class: left

# Stocks and Flows
<hr>

Two important concepts in systems analysis are **stocks** and **flows**.

* A **stock** is the amount of a system property: concentrations of a pollutant, numbers of currency units, etc.
* A **flow** is the way in which a stock changes: decay, diffusion, production, consumption, etc.

Most systems analysis amounts to analyzing how flows across system interconnections impact stocks.

---
class: left

# Modeling System Flows
<hr>

For example:
* Mass balance equations let us track changes in stocks at particular points;
* Equilibrium conditions are requirements that there is no net flow, and thus that stocks are preserved;
* Fate and transport modeling involves quantifying how stocks change as they move through the system.

---
class: middle, center

# Next Time
<hr>

We will discuss mathematical models of systems, and work through an example.