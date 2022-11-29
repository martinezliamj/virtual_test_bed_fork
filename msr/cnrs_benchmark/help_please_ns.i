alpha = 0.0002
mu = 50.
rho = 2000.
cp = 3075
k = 0.01

[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2.
    ymin = 0
    ymax = 2.
    nx = 10
    ny = 10
  []
[]
[Modules]
  [NavierStokesFV]
    compressibility = 'incompressible'
    add_energy_equation = true
    boussinesq_approximation = true
    density = ${rho}
    dynamic_viscosity = 'mu'
    thermal_conductivity = 'k'
    specific_heat = 'cp'
    thermal_expansion = ${alpha}

    # Boussinesq parameters
    gravity = '0 -9.81 0'

    # Initial conditions
    initial_velocity = '0.5 1e-6 0'
    initial_temperature = 900.0 # Why does this only converge when set to < 0
    initial_pressure = 1e5
    ref_temperature = 900.0

    # Boundary conditions
    inlet_boundaries = 'top'
    momentum_inlet_types = 'fixed-velocity'
    momentum_inlet_function = '0.5 0'
    energy_inlet_types = 'fixed-temperature'
    energy_inlet_function = 900.0

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
    energy_scaling = 1e-10
    momentum_scaling = 1e-4
    mass_scaling = 1e1
  []
[]
[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    # Might be missing a scaling factor here
    initial_condition = 1.0
  []
  [fission_source]
    type = MooseVariableFVReal
    initial_condition = 1.0
  []
[]
[Variables]
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
[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-13
[]
[Outputs]
  exodus = true
[]
