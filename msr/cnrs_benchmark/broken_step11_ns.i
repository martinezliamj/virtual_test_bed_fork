# # (broken) step11_ns.i - refuses to converge

mu=50.
rho=2000.
alpha = 2.e-4
cp = 3075 #6.15e6
k = 0.0000001 #missing the thermal conductivity
Pr_t = 3.075e5
Sc_t = 2.0e8

lambda0 = 1.24667e-2
lambda1 = 2.82917e-2
lambda2 = 4.25244e-2
lambda3 = 1.33042e-1
lambda4 = 2.92467e-1
lambda5 = 6.66488e-1
lambda6 = 1.63478
lambda7 = 3.55460
beta0 = 2.33102e-4
beta1 = 1.03262e-3
beta2 = 6.81878e-4
beta3 = 1.37726e-3
beta4 = 2.14493e-3
beta5 = 6.40917e-4
beta6 = 6.05805e-4
beta7 = 1.66016e-4

# ============================================================================================
# ============================================================================================
# ============================================================================================
# Copy of all the stuff from 0.1, just to see what part of the main app is screwed

# This input file is a test case where we try to slowly add the NS stuff in step 1.1, to fix
# the convergence problem we are having

# advected_interp_method = 'average'
# velocity_interp_method = 'rc'

# [GlobalParams]
#   rhie_chow_user_object = 'ins_rhie_chow_interpolator' #'rc'
# []

# [UserObjects]
#   [rc]
#     type = INSFVRhieChowInterpolator
#     u = u
#     v = v
#     pressure = pressure
#   []
# []

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
  # [sidesets]
  #   # Sets boundary names for the BCs block
  #   type = RenameBoundaryGenerator
  #   input = gen
  #   old_boundary = '0 1 2 3'
  #   new_boundary = 'bottom right top left'
  # []
[]

[Modules]
# Action that Guillaume spoke of
  [NavierStokesFV]
    compressibility = 'incompressible'
    add_energy_equation = true
    add_scalar_equation = true
    boussinesq_approximation = true

    # Variables, defined below for the Exodus restart
    # velocity_variable = 'u v'
    # pressure_variable = 'pressure'
    # fluid_temperature_variable = 'tfuel'

    # Material properties
    density = ${rho}
    dynamic_viscosity = ${mu}

    # These material properties we do not have
    thermal_conductivity = ${k}
    specific_heat = 'cp'
    thermal_expansion = ${alpha}

    # Boussinesq parameters
    gravity = '0 -9.81 0'

    # Initial conditions
    initial_velocity = '0.5 0 0'
    initial_temperature = '900'

    # Boundary conditions
    wall_boundaries = 'bottom right top left'
    momentum_wall_types = 'noslip noslip wallfunction noslip'
    energy_wall_types = 'heatflux heatflux heatflux heatflux'
    energy_wall_function = '0 0 0 0'
    momentum_wall_function = '0 0 0.5 0'

    # Pressure pin for incompressible flow
    pin_pressure = true
    pinned_pressure_type = average
    pinned_pressure_value = 1e5

    # Fairly certain we do not need these - this case ignores turbulence
    # # Turbulence parameters
    # turbulence_handling = 'mixing-length'
    # turbulent_prandtl = ${Pr_t}
    # von_karman_const = ${von_karman_const}
    # mixing_length_delta = 0.1
    # mixing_length_walls = 'shield_wall reflector_wall'
    # mixing_length_aux_execute_on = 'initial'

    # Numerical scheme
    momentum_advection_interpolation = 'upwind'
    mass_advection_interpolation = 'upwind'
    energy_advection_interpolation = 'upwind'
    passive_scalar_advection_interpolation = 'upwind'

    # Heat source
    external_heat_source = power_density

    # Precursor advection, diffusion and source term
    passive_scalar_names = 'c0 c1 c2 c3 c4 c5 c6 c7'
    passive_scalar_schmidt_number = '${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t}'
    passive_scalar_coupled_source = 'fission_source c0; fission_source c1; fission_source c2; fission_source c3;
                                     fission_source c4; fission_source c5; fission_source c6; fission_source c7'
    passive_scalar_coupled_source_coeff = '${beta0} ${lambda0}; ${beta1} ${lambda1}; ${beta2} ${lambda2};
                                           ${beta3} ${lambda3}; ${beta4} ${lambda4};
                                           ${beta5} ${lambda5}; ${beta6} ${lambda6}; ${beta7} ${lambda7}'
  []
[]

# [BCs]
#   # x-direction BCs
#   [bottom_u]
#     type = DirichletBC
#     variable = u
#     boundary = 'bottom'
#     value = 0.0
#   []
#   [right_u]
#     type = DirichletBC
#     variable = u
#     boundary = 'right'
#     value = 0.0
#   []
#   [left_u]
#     type = DirichletBC
#     variable = u
#     boundary = 'left'
#     value = 0.0
#   []
#   [top_u]
#     type = DirichletBC
#     variable = u
#     boundary = 'top'
#     value = 0.5
#   []
#   # y-direction BCs
#   [bottom_v]
#     type = DirichletBC
#     variable = v
#     boundary = 'bottom'
#     value = 0.0
#   []
#   [right_v]
#     type = DirichletBC
#     variable = v
#     boundary = 'right'
#     value = 0.0
#   []
#   [left_v]
#     type = DirichletBC
#     variable = v
#     boundary = 'left'
#     value = 0.0
#   []
#   [top_v]
#     type = DirichletBC
#     variable = v
#     boundary = 'top'
#     value = 0.0
#   []
# []

[Variables]
  # [u]
  #   type = INSFVVelocityVariable
  #   block = '0'
  #   fv = false
  # []
  # [v]
  #   type = INSFVVelocityVariable
  #   block = '0'
  #   # initial_condition = 0.0
  #   fv = false
  # []
  # [pressure]
  #   type = INSFVPressureVariable
  #   block = '0'
  # []
  [lambda]
    family = SCALAR
    order = FIRST
  []
  # [tfuel]
  #   type = INSFVEnergyVariable
  #   initial_condition = 900
  # []
  [c0]
    type = MooseVariableFVReal
  []
  [c1]
    type = MooseVariableFVReal
  []
  [c2]
    type = MooseVariableFVReal
  []
  [c3]
    type = MooseVariableFVReal
  []
  [c4]
    type = MooseVariableFVReal
  []
  [c5]
    type = MooseVariableFVReal
  []
  [c6]
    type = MooseVariableFVReal
  []
  [c7]
    type = MooseVariableFVReal
  []
[]

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    # Might be missing a scaling factor here
  []
  [fission_source]
    type = MooseVariableFVReal
  []
[]

# This is not present in the corresponding broken_ file
# I will leave this here; maybe it will help out or maybe it will do nothing
[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
# Solving the steady-state versions of these equations
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_pc_type -sub_pc_factor_shift_type'
  petsc_options_value = 'asm      100                lu           NONZERO'
  nl_rel_tol = 1e-12
[]

[Outputs]
  exodus = true
[]
