# Step 1.1 Inputs

*Contact: Ramiro Freile at ramiro.freile.at.inl.gov, Mustafa Jaradat at mustafa.jaradat.at.inl.gov, or Liam Martinez at liam.martinez.at.inl.gov*

## Overview

In this step, we made use of the MultiApp system in MOOSE.
Each of the three input files used in this step will be presented in sequence.

## Main Input File

Presented below is the first input file is the main application, which solves the neutronics eigenvalue problem.
In the next sections, the important blocks of the file are presented and discussed.

!listing msr/cnrs_benchmark/step11_main_app.i

### Power Density

!listing msr/cnrs_benchmark/step11_main_app.i block=PowerDensity

This block defines the power density variable and sets it to a constant value of 1 GW.

### Geometry

!listing msr/cnrs_benchmark/step11_main_app.i block=Mesh

This block defines the reactor geometry as a simple, two-dimensional square.

### Transport Systems

!listing msr/cnrs_benchmark/step11_main_app.i block=TransportSystems

This block defines the Transportsystems module, a Griffin module that solves the neutronics eigenvalue problem.

### AuxVariables and AuxKernels

!listing msr/cnrs_benchmark/step11_main_app.i block=AuxVariables

This block defines the fuel temperature variable, each of the eight delayed neutron precursor groups, and a vector that collects the DNP groups.

!listing msr/cnrs_benchmark/step11_main_app.i block=AuxKernels

This block builds the DNP vector initialized earlier as one of the auxiliary variables.

### Materials

!listing msr/cnrs_benchmark/step11_main_app.i block=Materials

This block provides the cross sections used in the TransportSystems module.

### Executioner and Outputs

!listing msr/cnrs_benchmark/step11_main_app.i block=Executioner

This block uses the PJFNK solver to solve the eigenvalue criticality problem.

!listing msr/cnrs_benchmark/step11_main_app.i block=Outputs

This file prints out an Exodus file contianing the data from all three apps.

### MultiApps and Transfers

!listing msr/cnrs_benchmark/step11_main_app.i block=MultiApps

This block defines `step11_main_app.i` to be the main application, and `step11_ns_general.i` to be a sub-application.

!listing msr/cnrs_benchmark/step11_main_app.i block=Transfers

This block defines transfers of data to and from `step11_main_app.i` and `step11_ns_general.i`.
The fission source variable is sent to the sub-app, and the DNP groups are received from the sub-app.

## Navier-Stokes Input File

Presented below is the first sub-app, one that solves the fluid transport problem.
In the next sections, the important parts of the input file are presented and discussed.

!listing msr/cnrs_benchmark/step11_ns_general.i

### Mesh

!listing msr/cnrs_benchmark/step11_ns_general.i block=Mesh

This block defines the reactor geometry to be a simple, two-dimensional square reactor.

### Navier-Stokes Module

!listing msr/cnrs_benchmark/step11_ns_general.i block=Modules

This block defines the incompressable finite volume Navier-Stokes action, which solves fluid transport all at once without the need for defining external kernels.
Boundary and initial conditions can be specified inside the action, and the action makes use of thermophysical properies defined at the top of the input file.

### Variables, AuxVariables, and Initial Conditions

!listing msr/cnrs_benchmark/step11_ns_general.i block=Variables

This block defines variables for the velocity components, pressure, and the fluid temperature.
The variables are inactive so that the file will output these variables in the Exodus file without having to specify postprocessors for each variable.

!listing msr/cnrs_benchmark/step11_ns_general.i block=AuxVariables

This block defines auxiliary variables to receive the corresponding auxiliary variables transferred from the main application.
It also defines the Rhie-Chow coefficients that are used inside the action, to ensure that the fluid is incompressible.

!listing msr/cnrs_benchmark/step11_ns_general.i block=ICs

!listing msr/cnrs_benchmark/step11_ns_general.i block=Functions

The Functions block defines a sinusoidal profile for the fission source variable.
The ICs block uses this profile to initialize the fission source variable.

### Materials

!listing msr/cnrs_benchmark/step11_ns_general.i block=Materials

This block defines the thermophysical parameters used by the Navier-Stokes action.

### MultiApps and Transfers

!listing msr/cnrs_benchmark/step11_ns_general.i block=MultiApps

This block defines a second multiapp relationship nested within the previously defined multiapp.
In this nested multiapp, `step11_ns_general.i` is the main application and `step11_prec_transport` is the sub-application.
In this case, the sub-application solves the precursor transport separately, which is then transferred back to `step11_main_app.i`.

!listing msr/cnrs_benchmark/step11_ns_general.i block=Transfers

This block defines the transfers between this input file and `step11_prec_transport.i`.
The velocity components, Rhie-Chow coefficients, pressure, and DNP variables are all transferred to the subapp for use in solving the precursor transport.

### Executioner and Outputs

!listing msr/cnrs_benchmark/step11_ns_general.i block=Executioner

This block uses the Newton solver to solve the steady-state fluid transport problem.

!listing msr/cnrs_benchmark/step11_ns_general.i block=Outputs

This file outputs an Exodus file with the results of the fluid transport solve.

## Precursor Transport Input File

Presented below is the second sub-app, one that solves the DNP transport problem.
In the next sections, the important parts of the input file are presented and discussed.

!listing msr/cnrs_benchmark/step11_prec_transport.i

### Global Parameters and User Objects

!listing msr/cnrs_benchmark/step11_prec_transport.i block=GlobalParams

!listing msr/cnrs_benchmark/step11_prec_transport.i block=UserObjects

These blocks define the Rhie-Chow interpolation method which is used throughout the entire input file.
In addition, the thermophysical parameters and the DNP parameters are defined above this block, for use throughout this input file.

### Geometry

!listing msr/cnrs_benchmark/step11_prec_transport.i block=Mesh

This block defines the reactor geometry to be a simple, two-dimensional square.

### Variables and AuxVariables

!listing msr/cnrs_benchmark/step11_prec_transport.i block=Variables

This block defines the DNP variables for all eight groups.
These variables will be sued in calculations throughout this input file.

!listing msr/cnrs_benchmark/step11_prec_transport.i block=AuxVariables

This block defines the power density, velocity components, Rhie-Chow coefficients, and pressure variables that are transferred from the other multiapps.

### Kernels and Boundary Conditions

!listing msr/cnrs_benchmark/step11_prec_transport.i block=FVKernels

This block defines the advection, diffusion, source, and decay terms of the DNP transport problem.

!listing msr/cnrs_benchmark/step11_prec_transport.i block=FVBCs

This block defines the fluid boundary conditions for the transport problem.

### Executioner and Outputs

!listing msr/cnrs_benchmark/step11_prec_transport.i block=Executioner

This file uses the Newton solver to solve the steady-state DNP transport problem.

!listing msr/cnrs_benchmark/step11_prec_transport.i block=Outputs

This file outputs an Exodus file with the results of the DNP transport solve.

## Run Command

Use this command to run the main input file.

```
mpirun -n 10 /path/to/blue_crab-opt -i step11_main_app.i
```