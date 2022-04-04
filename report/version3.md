---
title: "Reaction-diffusion spatial modeling of COVID-19 in Chicago"
author:
	- Trent Gerew, Illinois Institute of Technology^[[Contact the author](mailto:tgerew@hawk.iit.edu).]
output:
	pdf_document:
		toc: true
		toc_depth: 1
		fig_width: 2
		fig_caption: true
	urlcolor: cyan
	linkcolor: cyan
	bibliography: version3.bib
---

# Abstract
We investigate whether a reaction-diffusion model considering only meanly daily movement is sufficient to describe the spread of the COVID-19 virus in Chicago.
The model is calibrated using publicly available health data published by the city.
We first study the system of partial differential equations, then derive the basic reproduction number $\Ro$.
Then we consider the numerical simulations conducted from March 18 to June 24, 2020.
These simulations show that this model may not be sufficient to describe COVID-19 in Chicago.
Finally, we discuss shortcomings of the model, and offer some potential solutions.

# Introduction
Emerging from Wuhan, China in late 2019, the COVID-19 virus rapidly
spread throughout the globe [@covid-name]. Since the outbreak,
governments have been trying to contain the pandemic. Now, with safe and
effective vaccines being distributed, it is hoped the pandemic can be
overcome [@vaccine]. Before the introduction of the vaccines, so-called
"non-therapeutic" interventions [@interventions1] were frequently
deployed. Prominent among these are social distancing, self
quarantining, lockdowns, gathering limitations, and the use of personal
protective equipment. Now with the Omicron variant on the rise
[@omicron], these interventions are once again becoming prominent with
some European countries reintroducing lockdowns and travel restrictions
[@lockdowns].

Many mathematical models have been proposed to study the spread of the
virus. Most are compartment models, where a population is divided into
groups according to the state of individuals. These are generally known
as SIR (susceptible-infected-removed) type models. The majority of such
models ignore any spatial components. [@s+t+spain] employs a SAIR
(asymptomatic) model and includes mobility terms based on the position
of cell phones to model the propagation of the disease through Spain.
Similarly, [@Danon2020.02.12.20022566] incorporates daily movements into
an SEIR (exposed) model. In a different approach,
[@giuliani2020modelling] considers a statistical model to handle
diffusion of COVID-19 in Italy.

The goal of our model is to strike a reasonable balance between
representation of the pandemic and the populations involved, and
feasibility of data collection and computation.

To do this, we follow [@Kevrekidis-2021] and [@Mammeri+2020+102+113] in
building a virus model where the spatial propagation is modeled by a
diffusion and the reactions are derived from an SAIR model.
Specifically, we examine the spread of COVID-19 in the city of Chicago.
Does a reaction-diffusion model, which considers only the average daily
movements of the population, correctly describe the spread of the virus
in Chicago? If it does, we can use the model to assess possible
vaccination strategies or reopening scenarios.

A successful model can also be used to examine how social and economic
disparities play a role in the transmission of COVID-19. One can merge
race, income, or health-care accessibility data from the Chicago area
with the results from the model to ask and hopefully answer questions
like the following: Does community structure play a role? How effective
are vaccines? (Or what is thwarting them?) Are care facilities properly
allocated?

The paper is organized as follows. Section 2 outlines the methodology,
including data collection, modeling assumptions, and parameter
estimates. Section 3 contains a brief analysis of the model and the
results. In Section 4, we offer a discussion of the shortcomings of the
model, and how they can be improved.

# Materials and methods

## Confirmed and death data
In this study, we used the publicly available data sets of COVID-19
metrics provided by the City of Chicago Data Portal. [@Chicago-cases]
includes daily counts of city-wide confirmed infected cases,
hospitalizations, and deaths. Weekly cases, tests and deaths by ZIP code
are logged in [@Chicago-zips].

## Mathematical model
We focus our study on four components of the epidemic flow (Figure
[\[fig:model\]](#fig:model){reference-type="ref"
reference="fig:model"}). That is, the populations of Susceptible
individuals ($S$), Asymptomatic infected individuals ($A$), symptomatic
Infected individuals ($I$), and Removed individuals ($R$).

Our model is known as the SAIR model [@s+t+spain], which substitutes the
$E$ compartment of the SEIR model by the $A$ compartment. This model is
relevant when there are many undetected asymptomatic infectious
individuals, which is known to be the case for COVID-19.

A few notes motivating this very simple model are necessary.

*   We do not consider the "exposed" $E$ group in this work. Because the
    members of $A$ have separate infection and recovery rates, and
    because there is a possibility they are detected and move to $I$, we
    consider $E$ to be merged with $A$.

*   We do not distinguish between quarantined, incarcerated,
    hospitalized, or nursing home populations. Nursing homes are now
    known to be epicenters of the virus, however the true case rates are
    notoriously difficult to track [@nursing-homes]. Additionally, these
    four population groups can be assumed to be stationary in nature,
    and in the case of quarantined and hospitalized, isolated. Therefore
    we ignore their individual contributions.

*   In general, the way in which data has been collected and is provided
    by authorities has varied over time, making its usage rather
    difficult[^2] [@messy-data1], [@messy-data2], [@challenges]. There
    is also the question of case counts being influenced by access to
    testing, especially early in the pandemic. Including additional
    compartments would over-parameterize the model making it more
    difficult to verify, and would not provide useful information.

*   Lastly, adding additional compartments and parameters reduces the
    computational feasibility of the optimization problem.

To build the mathematical model, we followed the standard strategy
developed in the literature concerning SIR models [@bio-models]. We
assume that individuals in $S$ can be infected by both members of $A$
and $I$. We suppose that the individuals in the $A$ and $I$ compartments
may have different contact rates $\beta_A$ and $\beta_I$, and different
recovery rates $\gamma_A$ and $\gamma_I$. Furthermore, we consider a
rate $\delta$ at which individuals in $A$ may develop symptoms or are
otherwise detected and so will move to the $I$ compartment. Lastly, we
assume that only members of $S$ and $A$ are mobile.

The average number of contacts $\omega$ is described in Equation
[\[eq:contacts\]](#eq:contacts){reference-type="ref"
reference="eq:contacts"}. The diffusion coefficient $D$ is assumed to be
the same for both $A$ and $I$, and is defined by Equation
[\[eq:diffusion\]](#eq:diffusion){reference-type="ref"
reference="eq:diffusion"}.

The dynamics is governed by a system of two partial differential
equations (PDE) and two ordinary differential equations (ODE) as
follows, for
$\mathbf{x} = (x,y) \in \Omega \subset \mathbf{R}^2, t > 0$,
$$\label{eq:model}
            \begin{aligned}
                S_t - D(t) \Delta S &= - \omega(t) \left( \beta_A A + \beta_I I \right) S, \\
                A_t - D(t) \Delta A &= \omega(t) \left( \beta_A A + \beta_I I \right) S - (\gamma_A - \delta) A, \\
                I_t &= - \gamma_I I + \delta A, \\
                R_t &= \gamma_A A + \gamma_I.
            \end{aligned}$$ Since travel into the city of Chicago was
heavily restricted for the early stages of the pandemic, the homogeneous
Neumann boundary condition is imposed [@Mammeri+2020+102+113]. The
population compartments are considered fractions, such that
$S + A + I + R = 1$.

## Parameter estimation
To account for the lockdown, the average number of of contacts is
updated as in [@Kevrekidis-2021] $$\label{eq:contacts}
            \omega (t) = \omega_0 \left[ \eta + (1 - \eta) \frac{1 - \tanh \left[2 (t - t_q) \right]}{2} \right].$$
Here, $t_q = (t_{\mathrm{eol}} + t_{\mathrm{bol}}) / 5$, where
$\mathrm{bol}$ denotes the beginning of the lockdown and $\mathrm{eol}$
denotes the end of the lockdown. The parameter $0 \leq \eta \leq 1$ is a
varying coefficient translating respect for social distancing and other
preventative measures. Note that $\omega_0$ is the average number of
contacts before any intervention, and is a constant.

The parameters $\omega_0$, $\beta_A$, and $\beta_I$ are not
independently identifiable, so the optimization problem reduces to five
parameters
$\mathbf{\theta} = (\omega_0 \beta_A, \omega_0 \beta_I, \delta, \gamma_A, \gamma_I)$.
Given the observations $I_\mathrm{obs} (t_i)$ over $n$ days, we have the
minimization problem $$\label{eq:obj}
            \begin{aligned}
                \min_\theta \quad & \sum_{i=1}^n \left[ I_\mathrm{obs} (t_i) - I (t_i) \right]^2 \\
                \textrm{s.t.} \quad & \mathbf{0} \leq \theta \leq \mathbf{1}
            \end{aligned}$$ $I (t_i)$ denotes the output of the
mathematical model at time $t_i$ computed with parameters
$\mathbf{\theta}$.

The optimization problem is solved using the MATLAB nonlinear
optimization function `fmincon`. The initial parameter guesses to seed
`fmincon` were randomly sampled from a uniform distribution over 1000
iterations. The median of each resulting parameter was selected. Figure
[1](#fig:params){reference-type="ref" reference="fig:params"} shows the
estimated parameters.

The diffusion coefficient is also assumed to be altered by the lockdown,
and is updated as a simple step function $$\label{eq:diffusion}
                D(t) = D_0 \left[ 1 - (1 - \eta) H (t - t_\mathrm{bol}) \right]$$
where $H(t)$ is the Heaviside step function. The average one-way commute
in Chicago is about 5 miles [@travel]. Thus we set the diffusion
coefficient $D_0$ to the fixed value of $5 / 0.72$ to convert to the
spacing used for the discretization.

## Numerical discretization
From the map of the city, the computational domain $\Omega$ is defined
as the minimum square enclosing the city. The city is contained by
$\Omega' = \left\{ (X,Y) \mid X \in [-87.9397, -87.5245], \ Y \in [41.6447, 42.023] \right\}$
where $X$ represents degrees latitude and $Y$ represents degrees
longitude. Note that degrees latitude and longitude are not equal when
converted to miles. Therefore, we define the computational domain such
that the grid spacing is approximately 0.72 miles in both axes. This
gives the domain $$\label{eq:domain}
            \Omega = \left\{ \mathbf{x} \in \mathbf{R}^2 \mid x \in [0, 40], \ y \in [0, 29] \right\}.$$

The initial spatial distribution of the infected population is
determined by sampling the ZIP code data of confirmed cases
[@Chicago-zips] at the grid points, as shown in Figure
[\[fig:seeding\]](#fig:seeding){reference-type="ref"
reference="fig:seeding"}.

The model is solved via finite differences, using the `scikit-fdiff`
Python module [@nicolas_cellier_2019_3236970]. It is important to note
that due to the limitations of the solver, the simulation had to be
broken into time blocks where the values of $\omega (t) \beta_A$,
$\omega (t) \beta_I$, and $D(t)$ are evaluated for the initial time in
each block and held constant.

![ZIP data.](t0-cases){width="\\textwidth"}

![Seeded model.](infected_0){width="\\textwidth"}

# Results

## Existence of solutions and basic reproduction numbers
We show that we are justified in searching for suitable parameters to
solve the model. Let $\mathbf{x} = (S, A, I, R)^\intercal$ and
$\mathbf{x}_0 = (S_0, A_0, I_0, R_0)^\intercal$. First we show that the
solution of the initial value problem
([\[eq:model\]](#eq:model){reference-type="ref" reference="eq:model"})
exists for the case with no diffusion.

Let $\mathbf{0} \leq \mathbf{x}_0 \leq \mathbf{1}$ be the initial datum.
Then there exists a unique in time solution $\mathbf{x}$ of the initial
value problem ([\[eq:model\]](#eq:model){reference-type="ref"
reference="eq:model"}) without diffusion over
$C \subset U \subset \mathbf{R}^4 \times \mathbf{R}^1$ where $C$ is a
compact set that contains $(\mathbf{x}_0, t_0)$. Moreover, the solution
is $\mathbf{C}^1$.

Since $\mathbf{x}_t = f(\mathbf{x},t)$ is $\mathbf{C}^1$ on the open set
$U \subset \mathbf{R}^4 \times \mathbf{R}^1$, it follows that there
exists a solution of ([\[eq:model\]](#eq:model){reference-type="ref"
reference="eq:model"}) without diffusion through the point
$\mathbf{x}_0$ at $t = t_0$ for $|t - t_0|$ sufficiently small.
Moreover, $\mathbf{x} (t, t_0,\mathbf{x_0})$ is a $\mathbf{C}^1$
function [@dynamics]. Since $C$ is a compact set containing
$(\mathbf{x}_0, t_0)$, then the solution
$\mathbf{x} (t, t_0, \mathbf{x}_0)$ can be uniquely extended backward
and forward in $t$ up to the boundary of $C$ [@dynamics].

We do not provide a proof for the existence of solutions to the initial
boundary value problem ([\[eq:model\]](#eq:model){reference-type="ref"
reference="eq:model"}) with diffusion terms, but we assume it exists.

Let $\mathbf{0} \leq \mathbf{x}_0 \leq \mathbf{1}$ the initial datum.
Then there exists a unique global in time solution $\mathbf{x}$ of the
initial boundary value problem
([\[eq:model\]](#eq:model){reference-type="ref" reference="eq:model"}).

A proof for this conjecture will be similar to the one given in
[@Mammeri+2020+102+113].

An important parameter in understanding the initial growth of the virus
is the basic reproduction number.

The basic reproduction number $\mathcal{R}_0$ can be computed using the
next generation of the model without diffusion. Since the infected
individuals are in $A$ and $I$, new infections ($\mathcal{F}$) and
transitions between compartments ($\mathcal{V}$) can be rewritten as
$$\begin{aligned}
                \mathcal{F} &= \begin{pmatrix} \omega (\beta_A A + \beta_I I) S \\ 0 \end{pmatrix}, &
                \mathcal{V} &= \begin{pmatrix} (\gamma_A + \delta) A \\ \gamma_I - \delta A \end{pmatrix}.
            \end{aligned}$$ Then $\mathsf{F}$ and $\mathsf{V}$ are the
Jacobians of $\mathcal{F}$ and $\mathcal{V}$ respectively evaluated at
the disease free equilibrium. Thus,
$\mathcal{R}_0= \rho (\mathsf{F} \mathsf{V}^{-1})$ of the next
generation matrix $$\mathsf{F} \mathsf{V}^{-1} = \begin{pmatrix} 
                \frac{S_0 \omega_0 \beta_A}{\gamma_A + \delta} + \frac{S_0 \omega_0 \beta_I \delta}{\gamma_I (\gamma_A + \delta)} & 
                \frac{S_0 \omega_0 \beta_I}{\gamma_I} \\ 
                0 & 0 \end{pmatrix}.$$ So, $$\label{eq:ro}
                \mathcal{R}_0=  \frac{S_0 \omega_0}{\gamma_A + \delta}  \left( \beta_A + \beta_I \frac{\delta}{\gamma_I} \right).$$

This number is dimensionless and has an epidemiological meaning. The
first term represents the transmission rate by asymptomatic individuals,
and the second term represents the transmission rate by symptomatic
individuals.

## Model resolution
Calibration of the model is done from March 18, 2020 to June 24, 2020.
This range corresponds approximately to the first "wave" of cases seen
in Chicago. The lockdown time points match exactly to the imposed
lockdown of the city. That is, $t_\mathrm{bol} =$ March 21, 2020 and
$t_\mathrm{eol} =$ May 29, 2020. In Figure
[1](#fig:params){reference-type="ref" reference="fig:params"}, the table
shows the estimated parameters. Figure
[2](#fig:fit){reference-type="ref" reference="fig:fit"} compares the
data and the fitted symptomatic infected populations.

  -------------------- ------------------------------ -------- ----------
   $\omega_0 \beta_A$   transmission rate due to $A$   0.1969   days^-1^
   $\omega_0 \beta_I$   transmission rate due to $I$   0.3061   days^-1^
         $\eta$            lockdown scale factor       0.5514      1
       $\gamma_A$           removal rate of $A$        0.3632   days^-1^
       $\gamma_I$           removal rate of $I$        0.1385   days^-1^
        $\delta$             symptom onset rate        0.0939   days^-1^
  -------------------- ------------------------------ -------- ----------

![Parameters calibrated according to data from the Chicago Data Portal.
On the right is a boxplot of the parameter distribution from 1000
optimization iterations.](box-plot.pdf){#fig:params width="\\textwidth"}

![Fitting symptomatic infected by the median value. Note the logarithmic
scale on the y-axis.](cases.pdf){#fig:fit width="50%"}

## Spatial spread of COVID-19 {#sec:spread}
Simulations are performed from March 18, 2020 to June 24, 2020. The time
step is $\Delta t = 0.2$ \[days\], chosen to satisfy the convergence
condition [@pde].

Figure
[\[fig:spatial-results\]](#fig:spatial-results){reference-type="ref"
reference="fig:spatial-results"} presents three of the days from the
simulation time: the effective lockdown $t_q$ day, the last day of
simulation, and arbitrary day from the period in between. The observed
data is shown on the left, while the model results are on the right.
Comparing the model results to the data, we see that the model's
diffusion mostly misses the diseases west-ward movement between days 15
and 35. Additionally, the model shows significantly fewer cases than are
seen in the data (note the difference in the scale of the colorbars).

In short, this model does not produce a reasonable reproduction of the
spatial spread of COVID-19.

![Observed Day 15 ($t_q$): April 2, 2020](tq-cases){width="\\textwidth"}

![Model Day 15 ($t_q$): April 2, 2020](infected_15){width="\\textwidth"}

![Observed Day 35: April 22, 2020](tmid-cases){width="\\textwidth"}

![Model Day 35: April 22, 2020](infected_35){width="\\textwidth"}

![Observed Day 99: June 24, 2020](tfin-cases){width="\\textwidth"}

![Model Day 99: June 24, 2020](infected_99){width="\\textwidth"}

# Discussion
As mentioned in Section [3.3](#sec:spread){reference-type="ref"
reference="sec:spread"}, the proposed model does not reproduce the
spatial propagation of the virus. In this section, we address possible
causes of these inaccuracies and discuss proposals for improving the
results.

The selected model populations may not, contrary to the assumption, be
sufficient to describe the virus dynamics. Figure
[2](#fig:fit){reference-type="ref" reference="fig:fit"} suggests this
conclusion, since the growth of the model population only roughly
describes the observed data. Note that after Day 20, the model and data
begin to diverge substantially. This seems to correspond to the
discrepancy in the number of cases seen in the spatial results in Figure
[\[fig:spatial-results\]](#fig:spatial-results){reference-type="ref"
reference="fig:spatial-results"}. Likely, the Exposed compartment
describing the latent period is necessary, as in
[@Mammeri+2020+102+113]. It is possible that the assumption that
Deceased and Recovered populations can be modeled by the same population
compartment is errant. On the other hand, in either case these
populations have no effect on the act of transmission, so the model
dynamics would likely be similar for both cases. A Deceased population
may be useful for other reasons, as discussed below.

The boundaries imposed on the computational domain (Equation
[\[eq:domain\]](#eq:domain){reference-type="ref" reference="eq:domain"})
are likely not sufficient to force the diffusion process to replicate
the true virus propagation. Figure
[\[fig:app-pops\]](#fig:app-pops){reference-type="ref"
reference="fig:app-pops"} shows the $S$ and $A$ populations at the same
time points. There is a notable amount of diffusion of the $S$
population out of the boundaries of the city, including into Lake
Michigan. Since the $S$ population diffuses into areas not reachable by
the $I$ population, the reaction rates as described in Equation
[\[eq:model\]](#eq:model){reference-type="ref" reference="eq:model"} are
small. This may also explain the differences in case numbers seen in
Figure
[\[fig:spatial-results\]](#fig:spatial-results){reference-type="ref"
reference="fig:spatial-results"}. It seems a tightening of the bounds of
the computational domain is in order. Ideally, we would define the
computational domain to be exactly the boundaries of the city. In
practice, however, this is infeasible due to the irregularities of the
shape. A better alternative is to define a polygon that approximates the
shape of the city to be the computational domain. In any case, a new
solver will be needed as the `scikit-fdiff` module only allows
rectangular domains.

The optimization method can be improved in two ways. First, by adding a
Deceased population we can modify the objective function (Equation
[\[eq:obj\]](#eq:obj){reference-type="ref" reference="eq:obj"}) to
compare both cases and deaths, as in [@Kevrekidis-2021]. COVID-19 death
data is readily available, though requires caution to work with due to
reporting inconsistencies. Second, we can perform the optimization
directly on the spatial model, as in [@Mammeri+2020+102+113], rather
than relying on parameters from a temporal-only model.


# Appendix {#appendix .unnumbered}

## Nomenclature (Units are indicated in brackets.) {#nomenclature-units-are-indicated-in-brackets. .unnumbered}

  ------------------- --------------------------------------------------------------------- --------------
   **Latin symbols**                                                                        
          $A$         Asymptomatic infected individuals                                     \[1\]
          $D$         Diffusivity                                                           
     $\mathcal{F}$    Rate of appearance of new infections                                  \[days^-1^\]
     $\mathsf{F}$     Jacobian of $\mathcal{F}$ evaluated at the disease-free equilibrium   N/A
          $I$         Symptomatic infected individuals                                      \[1\]
          $R$         Removed individuals                                                   \[1\]
    $\mathcal{R}_0$   Basic reproduction number                                             \[1\]
          $S$         Susceptible individuals                                               \[1\]
     $\mathcal{V}$    Rate of transfer of individuals                                       \[days^-1^\]
     $\mathsf{V}$     Jacobian of $\mathcal{V}$ evaluated at the disease-free equilibrium   N/A
   **Greek symbols**                                                                        
       $\beta_j$      Contact rate of compartment $j$                                       \[days^-1^\]
      $\gamma_j$      Recovery rate of compartment $j$                                      \[days^-1^\]
       $\Delta$       Laplacian operator                                                    N/A
       $\delta$       Rate of asymptomatic individuals that may develop symptoms            \[days^-1^\]
        $\eta$        Lockdown scale factor                                                 \[1\]
       $\theta$       Parameter vector                                                      N/A
        $\rho$        Spectral radius                                                       N/A
       $\Omega$       Computational domain                                                  N/A
       $\omega$       Contacts                                                              \[1\]
  ------------------- --------------------------------------------------------------------- --------------

## Model Populations {#model-populations .unnumbered}

![Susceptible Day 15 ($t_q$): April 2,
2020](susceptible_15){width="\\textwidth"}

![Asymptomatic Day 15 ($t_q$): April 2,
2020](asymptomatic_15){width="\\textwidth"}

![Susceptible Day 35: April 22,
2020](susceptible_35){width="\\textwidth"}

![Asymptomatic Day 35: April 22,
2020](asymptomatic_35){width="\\textwidth"}

![Susceptible Day 99: June 24,
2020](susceptible_99){width="\\textwidth"}

![Asymptomatic Day 99: June 24,
2020](asymptomatic_99){width="\\textwidth"}

[^2]: For an in-depth analysis of the data collection problem, see
    [@sara-soremo].
