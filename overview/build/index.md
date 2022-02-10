
class: center, middle


.title[Introduction to Systems] <br> .subtitle[BEE 4750/5750] <br> .subtitle[Environmental Systems Analysis, Fall 2022] <hr> .author[Vivek Srikrishnan] <br> .date[August 27, 2022]


---


name: toc


class: left






# Outline


<hr>


1. Welcome!
2. Topics
3. Course Policies
4. Software Tools
5. Course Communication
6. Tips for Success


---


name: welcome


class: left






# Welcome to BEE 4750/5750!


<hr>


.left-column[Let's start with a quick poll!] .right-column[<img style="width: 100%;" src="assets/figures/mentimeterqrcode.png">]


---


name: poll results


class: left






# Poll results


<hr>


<div style='position: relative; padding-bottom: 56.25%; padding-top: 35px; height: 0; overflow: hidden;'><iframe sandbox='allow-scripts allow-same-origin allow-presentation' allowfullscreen='true' allowtransparency='true' frameborder='0' height='315' src='https://www.mentimeter.com/embed/6303ba2d8e533f56abac388386c31d71/d52e8876481e' style='position: absolute; top: 0; left: 0; width: 100%; height: 80%;' width='420'></iframe></div>


---


name: topics


class: left






# Topics


<hr>


In this course, we will learn how to:


  * Define systems and their boundaries
  * Simulate system dynamics using simulation models
  * Analyze and assess risk;
  * Formulate and solve linear and nonlinear optimization problems
  * Make decisions under uncertainty;
  * Explore trade-offs across competing objectives.


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


  * 50% homework assignments
  * 15% regulatory review project
  * 25% final project
  * 10% participation


---


name: assessments


template: policies






## Homework Assignments


  * Approximately 6 or 7 in total
  * Managed with Github Classroom (more on this shortly)
  * Submit on Gradescope by 11:59 PM on due date
  * Collaboration encouraged, but **everyone must submit their own original work unless otherwise specified**
  * **No late submissions accepted!**


---


name: reg-project


template: policies






## Regulatory Review Project


  * Requires researching a set of environmental regulation
  * Will receive guidance from a Cornell librarian
  * **We will discuss this in class before you start**


---


name: final-project


template: policies






## Final Project


  * Group project for 4750, individual for 5750
  * Work on applying and extending tools from this course to an analysis of a system of interest
  * Submit a poster and possibly a technical supplement
  * **We will discuss this in class before you start**


---


name: office-hours


template: policies






## Office Hours


  * Weekly office hours
  * Time TBD (watch for poll)
  * 1 by Zoom
  * 1 group/coding hour


---


name: website


template: policies






## Course Website


  * The website for this course is [https://viveks.me/environmental-systems-analysis](https://viveks.me/environmental-systems-analysis)
  * Includes course information, announcements, schedule, notes, demos, resources
  * **Make sure you check the site regularly!**


---


name: announcements


template: policies






## Announcements


  * Primarily through the course website and Slack
  * Really urgent announcements will also be made on Canvas for notifications


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


  * Julia is a modern, powerful, fast language
  * Demos and tips available on the website
  * Familiarize yourself with the documentation and searching for answers to questions!
  * We will discuss coding examples in class


---


name: weave


template: software






## Weave.jl


Homework assignments will be written and compiled using `Weave.jl`.


  * `Weave.jl` is a package for literate programming which allows integration of text (Markdown) and code (Julia) in a single document.
  * Result can be easily compiled to HTML or a PDF.
  * We have an example code and document available.


---


name: github


template: software






## Github Classroom


Access to assignments will be through Github Classroom.


  * You will be emailed a link to create a repository when an assignment is released.
  * PDFs of assignments will be auto-compiled when you `git push`.
  * Makes it easy to share code for feedback and debugging.
  * Let's look at a test repository!


---


name: communication


class: left


layout: false






# Course Communication


<hr>


  * Most communication will be done using Slack.
  * Please refrain from DMing me and the TA &mdash; unless private topic, **ask questions in the public channels so your classmates can help!**


---


name: tips


class: left






# Tips for Success


<hr>


  * Start assignments early!
  * Ask questions in class and on Slack and try to help your classmates
  * **Collaborate** &mdash; this is life as an engineer once you leave college!
  * But don't just copy, your work should reflect your own understanding.


---


name: goals


class: left






# Goals For This Course


<hr>


We want to build on your environmental engineering fundamentals with systems modeling and decision-making skills to:


  * Understand and identify modeling choices;
  * Use models to understand systems dynamics;
  * Use simulation and optimization to make management decisions;
  * Assess and analyze risk;
  * Make decisions in uncertain settings.


---


name: test-code


class: left






# Some Test Code


```julia
1+2
```

