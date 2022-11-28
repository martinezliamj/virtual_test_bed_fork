alpha = 0.0002
rho=2000.
cp = 3075
k = 0.01
mu=50.

Sc_t = 2.0e8
lambda1 = -2.82917e-2
beta1   = 1.03262e-3

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2.
    ymin = 0
    ymax = 2.
    nx = 50
    ny = 50
  []
  [sidesets]
    # Sets boundary names for the BCs block
    type = RenameBoundaryGenerator
    input = gen
    old_boundary = '0 1 2 3'
    new_boundary = 'bottom right top left'
  []
[]

[Modules]
  [NavierStokesFV]
    compressibility = 'incompressible'
    add_energy_equation = true
    add_scalar_equation = true
    boussinesq_approximation = true

    density = ${rho}
    dynamic_viscosity = 'mu'
    thermal_conductivity = 'k'
    specific_heat = 'cp'
    thermal_expansion = ${alpha}

    # External variables
    #velocity_variable = 'u1 v1'
    #pressure_variable = 'p1'

    # Boussinesq parameters
    gravity = '0 -9.81 0'

    # Initial conditions
    initial_velocity = '0.5 1e-6 0'
    initial_temperature = 900
    initial_pressure = 1e5
    ref_temperature = 900

    # Boundary conditions
    inlet_boundaries = 'top'
    momentum_inlet_types = 'fixed-velocity'
    momentum_inlet_function = '0.5 0'
    energy_inlet_types = 'fixed-temperature'
    energy_inlet_function = 900

    wall_boundaries = 'left right bottom'
    momentum_wall_types = 'noslip noslip noslip'
    energy_wall_types = 'heatflux heatflux heatflux'
    energy_wall_function = '0 0 0'

    pin_pressure = true
    pinned_pressure_type = average
    pinned_pressure_value = 1e5

    # Numerical Scheme
    energy_advection_interpolation = 'upwind'
    momentum_advection_interpolation = 'upwind'
    mass_advection_interpolation = 'upwind'
    energy_two_term_bc_expansion = false

    # energy_scaling = 0.001
    energy_scaling = 1e-7
    momentum_scaling = 0.1

    passive_scalar_inlet_types = 'fixed-value'
    passive_scalar_inlet_function = '1' # Placeholder
    # Precursor advection, diffusion and source term
    passive_scalar_names = 'c1'
    passive_scalar_coupled_source = 'fission_source c1'
    passive_scalar_coupled_source_coeff = '${beta1} ${lambda1}'
    passive_scalar_schmidt_number = '${Sc_t}'
  []
[]

#[GlobalParams]
#  rhie_chow_user_object = 'ins_rhie_chow_interpolator' #'rc'
#[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    pressure = pressure
    block = '0'
  []
[]

[Variables]
  inactive = 'vel_x vel_y pressure T_fluid scalar'
  [vel_x]
    type = 'INSFVVelocityVariable'
    initial_condition = 0.5
    block=0
  []
  [vel_y]
    type = 'INSFVVelocityVariable'
    initial_condition = 1e-6
    block=0
  []
  [pressure]
    type = 'INSFVPressureVariable'
    initial_condition = 1e5
    block=0
  []
  [T_fluid]
    type = 'INSFVEnergyVariable'
    initial_condition = 900
    block=0
  []
  [scalar]
    type = MooseVariableFVReal
  []
  [c1]
    type = MooseVariableFVReal
  []
  # [u1]
  #   type = INSFVVelocityVariable
  #   block = '0'
  # []
  # [v1]
  #   type = INSFVVelocityVariable
  #   block = '0'
  # []
  # [p1]
  #   type = INSFVPressureVariable
  #   block = '0'
  #   initial_condition = 1e5
  # []
[]

# [FVBCs]
#   # x-direction BCs
#   [bottom_u]
#     type = FVDirichletBC
#     variable = u1
#     boundary = 'bottom'
#     value = 0.0
#   []
#   [right_u]
#     type = FVDirichletBC
#     variable = u1
#     boundary = 'right'
#     value = 0.0
#   []
#   [left_u]
#     type = FVDirichletBC
#     variable = u1
#     boundary = 'left'
#     value = 0.0
#   []
#   [top_u]
#     type = FVDirichletBC
#     variable = u1
#     boundary = 'top'
#     value = 0.5
#   []
#   # y-direction BCs
#   [bottom_v]
#     type = FVDirichletBC
#     variable = v1
#     boundary = 'bottom'
#     value = 0.0
#   []
#   [right_v]
#     type = FVDirichletBC
#     variable = v1
#     boundary = 'right'
#     value = 0.0
#   []
#   [left_v]
#     type = FVDirichletBC
#     variable = v1
#     boundary = 'left'
#     value = 0.0
#   []
#   [top_v]
#     type = FVDirichletBC
#     variable = v1
#     boundary = 'top'
#     value = 0.0
#   []
# []

[AuxVariables]
  [fission_source]
    type = MooseVariableFVReal
  []
[]

[Materials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k rho mu'
    prop_values = '${cp} ${k} ${rho} ${mu}'
  []
[]

[Debug]
  show_var_residual_norms = True
[]

# [Postprocessors]
#   [u1]
#     type = ScalarVariable
#     variable = u1
#     execute_on = 'TIMESTEP_END'
#   []
#   [v1]
#     type = ScalarVariable
#     variable = v1
#     execute_on = 'TIMESTEP_END'
#   []
#   [p1]
#     type = ScalarVariable
#     variable = p1
#     execute_on = 'TIMESTEP_END'
#   []
# []

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-5
[]

[Outputs]
  exodus = true
[]
