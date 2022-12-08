# Step 0.1 Input

*Contact: Ramiro Freile at ramiro.freile.at.inl.gov, Mustafa Jaradat at mustafa.jaradat.at.inl.gov, or Liam Martinez at liam.martinez.at.inl.gov*

## Input file

The full input file for the first step of the CNRS benchmark is given below.
In the next sections, each block of the file is presented and discussed.

!listing msr/cnrs_benchmark/step01_velocity_field.i

## Global Parameters and UserObjects

!listing msr/cnrs_benchmark/step01_velocity_field.i block=GlobalParams

!listing msr/cnrs_benchmark/step01_velocity_field.i block=UserObjects

In these blocks, we define the Rhie-Chow interpolation method which is used throughout the entire input file.

## Mesh

!listing msr/cnrs_benchmark/step01_velocity_field.i block=Mesh

Here we define the reactor geometry as a two-dimensional square.

## Variables and AuxVariables

!listing msr/cnrs_benchmark/step01_velocity_field.i block=Variables

!listing msr/cnrs_benchmark/step01_velocity_field.i block=AuxVariables

Here we define the velocity and pressure variables that will be solved for, as well as the velocity vector as an AuxVariable.

## AuxKernels and FVKernels

!listing msr/cnrs_benchmark/step01_velocity_field.i block=AuxKernels

!listing msr/cnrs_benchmark/step01_velocity_field.i block=FVKernels

Here we define the calculation of the velocity vector as an AuxKernel.
We use finite volume for this benchmark, so we make use of the FVKernels to solve the advection, viscosity, and pressure terms for both of the velocity components u and v.

## Boundary Conditions

!listing msr/cnrs_benchmark/step01_velocity_field.i block=FVBCs

Here we define the boundary conditions for the problem.

## Executioner and Outputs

!listing msr/cnrs_benchmark/step01_velocity_field.i block=Executioner

!listing msr/cnrs_benchmark/step01_velocity_field.i block=Outputs

Here we define the Executioner block, which uses the PJFNK solver, and the Outputs block, which creates an Exodus file to visualize simulation data.
We use a steady solve here, because for this step we do not introduce time dependence.