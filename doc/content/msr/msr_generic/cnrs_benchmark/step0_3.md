# Step 0.3 Input

*Contact: Ramiro Freile at ramiro.freile.at.inl.gov, Mustafa Jaradat at mustafa.jaradat.at.inl.gov, or Liam Martinez at liam.martinez.at.inl.gov*

## Input file

The full input file for the third step of the CNRS benchmark is given below.
In the next sections, each block of the file is presented and discussed.

!listing msr/cnrs_benchmark/step03_temperature_dist.i

## Global Parameters and User Objects

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=GlobalParams

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=UserObjects

These blocks define the Rhie-Chow interpolation method, which is used throughout the entire input file.

## Geometry

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=Mesh

This block defines the reactor geometry as a simple two-dimensional square.

## Materials

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=Materials

This block defines certain thermophysical proeprties as material properties to be used in the input file.

## Variables and AuxVariables

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=Variables

This block defines the velocity components, pressure, and the temperature, all of which are calculated in this file.

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=AuxVariables

This block defines the reactor power.

## AuxKernels and FVKernels

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=AuxKernels

This block calculates the fission source, using the auxiliary variables power and power_dummy.

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=FVKernels

This block solves the finite volume advection, viscosity, and pressure terms for both velocity components, as well as the advection, conduction, heatsink, and fission heat source terms for the temperature field.

## Boundary Conditions

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=FVBCs

This block defines the temperature and fluid boundary conditions for this problem.

## Executioner and Outputs

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=Executioner

This block uses the PJFNK solver to solve the steady-state temperature problem.

!listing msr/cnrs_benchmark/step03_temperature_dist.i block=Outputs

This fie prints out both an Exodus file and a CSV file with the temperature and velocity fields solved in this step.