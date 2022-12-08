# CNRS Benchmark

*Contact: Ramiro Freile at ramiro.freile.at.inl.gov, Mustafa Jaradat at mustafa.jaradat.at.inl.gov, or Liam Martinez at liam.martinez.at.inl.gov*

The CNRS benchmark was developed as an exercise to develop and compare MSR simulation codes [!citep](TIBERGA2020107428).
It is organized into several steps, each of which focuses on a particular task for a nuclear reactor physics code to simulate.
The purpose of specifying steps for the benchmark is so that the complex behavior of a full MSR can be approached in a slow and more controlled manner, by breaking the simulation into three smaller and simpler phases[!citep](cnrs_inl).

## Reactor Assumptions and Geometry

The MSR geometry being considered in the benchmark is very simple, consisting of a two-dimensional 2 m by 2 m square reactor.
The geometry is shown in [geometry].
This reactor is filled with fluid representing the fuel and coolant mix, and starts at a temperature of 900 K.

!media /msr/cnrs_benchmark/benchmark_geometry.jpg
       style=width:40%
       id=geometry
       caption=CNRS model reactor

The Boussinesq approximation is used for the fluid flow calculations in this model of the reactor.
The fluid salt fuel-coolant mix is also assumed to be incompressible and fluid flow is assumed to be laminar.
Finally, the fluid flow calculations ignore turbulence to further simplify the simulation of the important processes in the reactor.
The simplified reactor makes use of vacuum boundaries for neutron flux and Neumann boundary conditions at the walls, to ensure that neutrons are going through the walls to exit the reactor.
This is done to prevent neutrons from reflecting off the boundary and increasing k$_{eff}$.
It also uses a no-slip condition for the fluid at the top, bottom, and sides of the reactor, so that a boundary layer is formed.
Finally, the walls are assumed to have adiabatic boundaries so that no heat is transferred outside of the reactor [!citep](TIBERGA2020107428) [!citep](cnrs_inl).

## Reactor Inputs

The fuel salt used in the benchmark is LiF-BeF$_2$-UF$_4$, with the proportions given in [salt].
The salt is present in molten form inside the reactor, and is used as both nuclear fuel and coolant for the reactor.
The thermophysical parameters for the fuel salt mix are given in [prop].
The nuclear cross sections were calculated using the Serpent code.
The model makes use of six energy groups, which are given in [group] [!citep](TIBERGA2020107428).

!table id=salt caption= Fuel Salt Composition.
|  Isotope | $^6$Li | $^7$Li | $^9$Be | $^{19}$F | $^{235}$U |
| :- | :- | :- | :- | :- | :- |
| Percent Atomic Fraction | $2.11488$ | $26.0836$ | $14.0992$ | $56.3969$ | $1.30545$ |

!table id=prop caption= Thermophysical properties.
|  Property | Value (units) |
| :- | :- |
| Density | $2.0 \times 10^{3}$ (kg/m$^3$) |
| Kinematic viscosity | $2.5 \times 10^{-2}$ (m$^2$/s) |
| Volumetric heat capacity | $6.15 \times 10^{6}$ (J/m$^3$ K) |
| Thermal expansion coeficient | $2.0 \times 10^{-4}$ ($1$/K) |
| Schmidt number | $2.0 \times 10^{8}$ (-) |
| Thermal conductivity | $1.0 \times 10^{-2}$ (W/m K) |

!table id=group caption= Energy Group Ranges.
|  Group, g | Upper Energy Bound (MeV) |
| :- | :- |
| 1 | $2.000 \times 10^{1}$ |
| 2 | $2.231 \times 10^{0}$ |
| 3 | $4.979 \times 10^{-1}$ |
| 4 | $2.479 \times 10^{-2}$ |
| 5 | $5.531 \times 10^{-3}$ |
| 6 | $7.485 \times 10^{-4}$ |

## Benchmark Structure

The benchmark problem is divided into three phases.
Phase 0 deals with individual physics verification, phase 1 deals with steady-state coupling of the single physics problems in phase 0, and phase 2 adds time-dependence to the simulation.
The phases are subdivided into different numbers of steps, each of which is a particular task that the simulation needs to complete to move onto the next task.

Step 0.1 concerns the velocity field and fluid flow inside the reactor, assuming a constant temperature and ignoring any effects of nuclear fission.
In this step, the fluid starts at rest everywhere in the reactor except along the top surface.
Along that surface, the velocity is 0.5 m/s parallel to the surface in the x-direction.

Step 0.2 concerns the calculation of the criticality eigenvalue problem, assuming a constant temperature and ignoring the fuel flow.
The criticality eigenvalue problem determines what kinds of reactions the neutrons in the reactor are participating in, whether they are taking part in nuclear fission or are interacting in other ways.

Step 0.3 concerns the passive transport of heat throughout the reactor and determines the temperature at every point in the reactor.
This step ignores the neutron interactions present in step 0.2 but does include the fluid flow from step 0.1.

Step 1.1 concerns the combination of all steps of phase 0; that is, steps 0.1 through 0.3.
The criticality eigenvalue problem is now solved while the fuel is circulating around the reactor.
The delayed neutron precursors (DNP) are added in at this step, and step 1.1 determines the distribution of these precursors inside the reactor.

Step 1.2 concerns the addition of the temperature distribution simulated in step 0.3 to the circulating fuel where neutrons are undergoing various interactions simulated in step 1.1.
Here, another source of heat from the neutron interactions will change the temperature distribution, which will also change the temperature field in the reactor.

Step 1.3

Step 1.4

Step 2.1