# Step 0.2 Input

*Contact: Ramiro Freile at ramiro.freile.at.inl.gov, Mustafa Jaradat at mustafa.jaradat.at.inl.gov, or Liam Martinez at liam.martinez.at.inl.gov*

## Input File

The full input file for the second step of the CNRS benchmark is given below.
In the next sections, each block of the file is presented and discussed.

!listing msr/cnrs_benchmark/step02.i

## Geometry

!listing msr/cnrs_benchmark/step02.i block=Mesh

Here we define the geometry of the reactor as a simple two-dimensional square.

## TransportSystems

!listing msr/cnrs_benchmark/step02.i block=TransportSystems

Here we define the Transportsystems module, a Griffin module that solves the neutronics eigenvalue problem.

## AuxVariables and AuxKernels

!listing msr/cnrs_benchmark/step02.i block=AuxVariables

Here we define the auxiliary variables temeprature, which is held constant, and fission rate density.

!listing msr/cnrs_benchmark/step02.i block=AuxKernels

Here we define the auxiliary kernel that calculates the fission rate density for each energy group.

## Materials

!listing msr/cnrs_benchmark/step02.i block=Materials

This block provides the cross sections used in the TransportSystems module.

## Executioner and Outputs

!listing msr/cnrs_benchmark/step02.i block=Executioner

This block uses the PJFNK solver to solve the eigenvalue criticality problem.

!listing msr/cnrs_benchmark/step02.i block=Outputs

This file prints out an Exodus file and a CSV file with the fisison rate density and neutron fluxes calculated in this step.