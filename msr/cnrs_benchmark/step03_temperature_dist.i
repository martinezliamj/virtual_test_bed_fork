################################################################################
## Molten Salt Fast Reactor - CNRS Benchmark step 0.3                         ##
## Standalone application                                                     ##
## This calculates the temeprature field for the reactor                      ##
################################################################################

# Molecular thermophysical parameters
mu = 50.      # Viscosity [Pa.s]
rho = 2000.   # Density [kg/m^3]
k = 0.0000001 # Thermal conductivity [W/m K]
cp = 3075.    # Volumetric heat capacity [J/m^3 K]

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
  [file]
    type = FileMeshGenerator
    file = diff_out.e
    use_for_exodus_restart = true
  []
[]

################################################################################
# MATERIALS
################################################################################

[Materials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k'
    prop_values = '${cp} ${k}'
  []
  [ins_fv]
    type = INSFVEnthalpyMaterial
    temperature = 'temperature'
    rho = ${rho}
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
  [temperature]
    type = INSFVEnergyVariable
    initial_condition = 900.
    two_term_boundary_expansion = false
  []
  [lambda]
    family = SCALAR
    order = FIRST
  []
[]

[AuxVariables]
  [power]
    type = MooseVariableFVReal
  []
  [power_dummy]
    order = FIRST
    family = LAGRANGE
    # This power variable comes from 'step02.i'
    initial_from_file_var = power
  []
[]

################################################################################
# FVKERNELS AND AUXKERNELS
################################################################################

[AuxKernels]
  [fission_source]
    type = QuotientAux
    variable = power
    numerator = power_dummy
    denominator = 1
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


  [temp_conduction]
    type = FVDiffusion
    coeff = ${k}
    variable = temperature
  []
  [temp_advection]
    type = INSFVEnergyAdvection
    variable = temperature
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []

  [temp_sinksource]
    type = NSFVEnergyAmbientConvection
    variable = temperature
    T_ambient = 900.
    alpha = '1e6' # Convective heat transfer coefficient [W/m^3 K]
  []
  [temp_fissionpower]
    type = FVCoupledForce
    variable = temperature
    v = power
  []
[]

################################################################################
# BOUNDARY CONDITIONS
################################################################################

[FVBCs]
  [top_x]
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'top'
    function = 0.5
  []
  [no_slip_x]
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'left right bottom'
    function = 0
  []
  [no_slip_y]
    type = INSFVNoSlipWallBC
    variable = v
    boundary = 'left right top bottom'
    function = 0
  []
  # Adiabatic BC for the temperature
  [adiabatic]
    type = FVNeumannBC
    variable = temperature
    boundary = 'left right top bottom'
    value = 0.
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  #line_search = 'none'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-12
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
[]
