alpha = 0.0002
#mu = 1
#rho = 1
#k = .01
#cp = 1
mu=50.
rho=2000.
cp = 3075
k = 0.01
#Pr_t = 3.075e5
#Sc_t = 2.0e8

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
    #nx = 10
    #ny = 10
  []
  # [sidesets]
  #   # Sets boundary names for the BCs block
  #   type = RenameBoundaryGenerator
  #   input = gen
  #   old_boundary = '0 1 2 3'
  #   new_boundary = 'bottom right top left'
  # []
[]

[Modules]
  [NavierStokesFV]
    compressibility = 'incompressible'
    add_energy_equation = true
    add_scalar_equation = false
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
    initial_temperature = 900 # Why does this only converge when set to < 0
    initial_pressure = 1e5
    ref_temperature = 900

    # Precursor equations, difusion, and source terms
    #passive_scalar_names = 'c0 c1 c2 c3 c4 c5 c6 c7'
    #passive_scalar_schmidt_number = '${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t}'
    #passive_scalar_coupled_source = 'fission_source c0; fission_source c1; fission_source c2; fission_source c3;
    #                                 fission_source c4; fission_source c5; fission_source c6; fission_source c7'
    #passive_scalar_coupled_source_coeff = '${beta0} ${lambda0}; ${beta1} ${lambda1}; ${beta2} ${lambda2};
    #                                       ${beta3} ${lambda3}; ${beta4} ${lambda4};
    #                                       ${beta5} ${lambda5}; ${beta6} ${lambda6}; ${beta7} ${lambda7}'

    # Boundary conditions
    inlet_boundaries = 'top'
    momentum_inlet_types = 'fixed-velocity'
    momentum_inlet_function = '0.5 0'
    energy_inlet_types = 'fixed-temperature'
    energy_inlet_function = 900
    #passive_scalar_inlet_types = 'fixed-value'
    #passive_scalar_inlet_function = '1' # Placeholder

    wall_boundaries = 'left right bottom'
    momentum_wall_types = 'noslip noslip noslip'
    energy_wall_types = 'heatflux heatflux heatflux'
    energy_wall_function = '0 0 0'

    pin_pressure = true
    pinned_pressure_type = average
    pinned_pressure_value = 1e5

    # Heat source
    # external_heat_source = power_density

    # Numerical Scheme
    energy_advection_interpolation = 'upwind'
    momentum_advection_interpolation = 'upwind'
    mass_advection_interpolation = 'upwind'
    #passive_scalar_advection_interpolation = 'average'
    energy_two_term_bc_expansion = false

    energy_scaling = 0.000001
    momentum_scaling = 0.1

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
  nl_rel_tol = 1e-8
[]

[Outputs]
  exodus = true
[]