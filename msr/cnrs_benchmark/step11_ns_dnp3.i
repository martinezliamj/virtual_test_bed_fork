alpha = 0.0002
rho=2000.
cp = 3075
k = 0.01
mu=50.

Sc_t = 2.0e8
lambda3 = -1.33042e-1
beta3   = 1.37726e-3

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
    passive_scalar_names = 'c3'
    passive_scalar_coupled_source = 'fission_source c3'
    passive_scalar_coupled_source_coeff = '${beta3} ${lambda3}'
    passive_scalar_schmidt_number = '${Sc_t}'
  []
[]

[Variables]
  [c3]
    type = MooseVariableFVReal
  []
[]

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
