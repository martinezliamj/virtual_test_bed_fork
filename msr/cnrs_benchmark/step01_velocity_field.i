################################################################################
## Molten Salt Fast Reactor - CNRS Benchmark step 0.1                         ##
## Standalone application                                                     ##
## This calculates the velocity field for the reactor                         ##
################################################################################

# Molecular thermophysical parameters
mu=50.    # Viscosity [Pa.s]
rho=2000. # Density [kg/m^3]

################################################################################
# GLOBAL PARAMETERS AND USER OBJECTS
################################################################################

# Defining global interpolation schemes and rc user object to advoid
# putting them in every kernel
advected_interp_method = 'average'
velocity_interp_method = 'rc'

[GlobalParams]
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = u
    v = v
    pressure = pressure
  []
[]

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2.
    ymin = 0
    ymax = 2.
    nx = 100
    ny = 100
  []
[]

################################################################################
# VARIABLES AND AUXVARIABLES
################################################################################

[Variables]
  [u]
    type = INSFVVelocityVariable
  []
  [v]
    type = INSFVVelocityVariable
  []
  [pressure]
    type = INSFVPressureVariable
  []
  [lambda]
    family = SCALAR
    order = FIRST
  []
[]

[AuxVariables]
# 2D velocity vector
  [U]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
[]

################################################################################
# FVKERNELS, AUXKERNELS, AND BCS
################################################################################

[AuxKernels]
# Calculates magnitude of the velocity vector U
  [mag]
    type = VectorMagnitudeAux
    variable = U
    x = u
    y = v
  []
[]

[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
  []
  [mean_zero_pressure]
    type = FVIntegralValueConstraint
    variable = pressure
    lambda = lambda
  []

  [u_advection]
    type = INSFVMomentumAdvection
    variable = u
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_viscosity]
    type = INSFVMomentumDiffusion
    variable = u
    mu = ${mu}
    momentum_component = 'x'
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = u
    momentum_component = 'x'
    pressure = pressure
  []

  [v_advection]
    type = INSFVMomentumAdvection
    variable = v
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_viscosity]
    type = INSFVMomentumDiffusion
    variable = v
    mu = ${mu}
    momentum_component = 'y'
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v
    momentum_component = 'y'
   pressure = pressure
  []
[]

[FVBCs]
  [top_x]
  # Defines the 'lid' at the top of the simulation where fluid is moving
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'top'
    function = 0.5
  []
  [no_slip_x]
  # Defines the walls where fluid is not moving in the x-direction
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'left right bottom'
    function = 0
  []
  [no_slip_y]
  # Defines the walls where fluid is not moving in the y-direction
    type = INSFVNoSlipWallBC
    variable = v
    boundary = 'left right top bottom'
    function = 0
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_pc_type -sub_pc_factor_shift_type'
  petsc_options_value = 'asm      100                lu           NONZERO'
  nl_rel_tol = 1e-12
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
[]
