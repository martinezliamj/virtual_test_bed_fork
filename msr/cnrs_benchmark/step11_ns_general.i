################################################################################
## Molten Salt Fast Reactor - CNRS Benchmark step 1.1                         ##
## Sub-application for Navier-Stokes                                          ##
## This runs an application using the Navier-Stokes action within MOOSE       ##
################################################################################

# Molecular thermophysical parameters
alpha = 0.0002 # Thermal expansion coefficient [1/K]
rho = 2000. # Density [kg/m^3]
cp = 3075 # Volumetric heat capacity [J/m^3 K]
k = 0.01 # Thermal conductivity [W/m K]
mu = 50. # Viscosity [Pa.s]

################################################################################
# OPTIONAL DEBUG BLOCK
################################################################################

[Debug]
  show_var_residual_norms = True
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
    nx = 50
    ny = 50
  []
[]

################################################################################
# MODULES
################################################################################

[Modules]
  [NavierStokesFV]
    compressibility = 'incompressible'
    add_energy_equation = true
    add_scalar_equation = false # Solving them with explicit kernels
    boussinesq_approximation = true

    density = ${rho}
    dynamic_viscosity = 'mu'
    thermal_conductivity = 'k'
    specific_heat = 'cp'
    thermal_expansion = ${alpha}

    # Boussinesq parameters
    gravity = '0 0 0'

    # Initial conditions
    initial_velocity = '0.5 1e-6 0'
    initial_temperature = 900
    initial_pressure = 0
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
    pinned_pressure_value = 0

    # Numerical Scheme
    energy_advection_interpolation = 'upwind'
    momentum_advection_interpolation = 'upwind'
    mass_advection_interpolation = 'upwind'
    energy_two_term_bc_expansion = true

    energy_scaling = 1e-7
    momentum_scaling = 0.1
  []
[]

################################################################################
# VARIABLES and AUXVARIABLES
################################################################################

[Variables]
  inactive = 'vel_x vel_y pressure T_fluid'
  [vel_x]
    type = 'INSFVVelocityVariable'
    initial_condition = 0.5
    block = 0
  []
  [vel_y]
    type = 'INSFVVelocityVariable'
    initial_condition = 1e-6
    block = 0
  []
  [pressure]
    type = 'INSFVPressureVariable'
    initial_condition = 1e5
    block = 0
  []
  [T_fluid]
    type = 'INSFVEnergyVariable'
    initial_condition = 900
  []
[]

[AuxVariables]
  [fission_source]
    type = MooseVariableFVReal
  []
  [c0]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [c1]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [c2]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [c3]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [c4]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [c5]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [c6]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [c7]
    type = MooseVariableFVReal
    initial_condition = 0.0
  []
  [a_u]
    type = MooseVariableFVReal
  []
  [a_v]
    type = MooseVariableFVReal
  []
[]

[AuxKernels]
  [ax_out]
    type = ADFunctorElementalAux
    functor = ax
    variable = a_u
    execute_on = timestep_end
  []
  [ay_out]
    type = ADFunctorElementalAux
    functor = ay
    variable = a_v
    execute_on = timestep_end
  []
[]

[ICs]
  [source_ic]
    type = FunctionIC
    variable = 'fission_source'
    function = source_function
  []
[]

[Functions]
  [source_function]
    type = ParsedFunction
    value = '1000000*sin(x*pi/2)*sin(y*pi/2)'
  []
[]

################################################################################
# MATERIALS AND USER OBJECTS
################################################################################

# Define thermophysical parameters for the action
[Materials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k rho mu'
    prop_values = '${cp} ${k} ${rho} ${mu}'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-10
[]

################################################################################
# MULTIAPPS and TRANSFERS for precursor transport
################################################################################

[MultiApps]
  [prec_transport]
    type = FullSolveMultiApp
    input_files = 'step11_prec_transport.i'
    execute_on = 'timestep_end'
    # no_backup_and_restore = true
  []
[]

[Transfers]
  [fission_source]
    type = MultiAppCopyTransfer
    to_multi_app = prec_transport
    source_variable = fission_source
    variable = fission_source
  []
  [u_x]
    type = MultiAppCopyTransfer
    to_multi_app = prec_transport
    source_variable = vel_x
    variable = vel_x
  []
  [u_y]
    type = MultiAppCopyTransfer
    to_multi_app = prec_transport
    source_variable = vel_y
    variable = vel_y
  []
  [a_x]
    type = MultiAppCopyTransfer
    to_multi_app = prec_transport
    source_variable = a_u
    variable = a_x
  []
  [a_y]
    type = MultiAppCopyTransfer
    to_multi_app = prec_transport
    source_variable = a_v
    variable = a_y
  []
  [pressure]
    type = MultiAppCopyTransfer
    to_multi_app = prec_transport
    source_variable = pressure
    variable = pressure
  []

  [c0]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c0'
    variable = 'c0'
  []
  [c1]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c6'
    variable = 'c6'
  []
  [c7]
    type = MultiAppCopyTransfer
    from_multi_app = prec_transport
    source_variable = 'c7'
    variable = 'c7'
  []
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
[]
