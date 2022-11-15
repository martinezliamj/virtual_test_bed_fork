mu = 50.
rho = 2000.
k = 0.0000001
cp = 3075.
# Remove the comments, and also maybe the commented blocks - have to ask Ramiro about that
advected_interp_method = 'average'
velocity_interp_method = 'rc'

[GlobalParams]
  rhie_chow_user_object = 'rc'
[]

[Mesh]
  [file]
    type = FileMeshGenerator
    file = diff_out.e
    use_for_exodus_restart = true
  []
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = u
    v = v
    pressure = pressure
  []
[]

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
    # This power variable comes from a file from step 0.2
    initial_from_file_var = power
  []
[]

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

  # All the blocks up to here are for the mass conservation equation in step 0.1
  # All the blocks below are for temperature step 0.3

  [temp_conduction]
  # Difusion term for the temperature
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
  # Term for temperature loss to elsewhere
    type = NSFVEnergyAmbientConvection
    variable = temperature
    T_ambient = 900.
    alpha = '1e6'
  []
  [temp_fissionpower]
  # Source term for the temperature
    type = FVCoupledForce
    variable = temperature
    v = power
  []
[]

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
  # Above blocks are the same BCs as in step 0.1
  # Below block is a new BC for the temperature, defining the walls to be adiabatic - no heat transfer into/out of the box
  [adiabatic]
    type = FVNeumannBC
    variable = temperature
    boundary = 'left right top bottom'
    value = 0.
  []
[]

[Materials]
  #[const]
  # Defines k and cp as material properties
  #  type = ADGenericConstantMaterial
  #  prop_names = 'k cp'
  #  prop_values = '${k} ${cp}'
  #[]
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

[Executioner]
# Solving the steady-state versions of these equations
  type = Steady
  solve_type = 'NEWTON'
  #line_search = 'none'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-12
[]

[Outputs]
  exodus = true
  csv = true
[]
