#(broken) step11_diff.i - converges but does not transfer

# reactor_power = 1e9

# Remove the comments before doing anything official
[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2
    ymin = 0
    ymax = 2
    nx = 100
    ny = 100
    # nx = 10
    # ny = 10
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 6
  VacuumBoundary = 'left bottom right top'
  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 8
    external_dnp_variable = 'dnp'
    family = LAGRANGE
    order = FIRST
    fission_source_aux = true

    # For PJFNKMO
    # assemble_scattering_jacobian = true
    # assemble_fission_jacobian = true
  []
[]

[PowerDensity]
  # power = ${reactor_power}
  # power_density_variable = power
  # power_scaling_postprocessor = Normalization

  # Edits to reflect run_neutronics.i
  power = 1e9
  power_density_variable = power
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[AuxVariables]
# Fuel temperature - still a constant for step 1.1
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900 # in degree C
  []
  # Delayed neutron precursor groups
  [c0]
    order = CONSTANT
    family = MONOMIAL
    block = '0'
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
  []
  [c7]
    order = CONSTANT
    family = MONOMIAL
  []
  # Delayed neutron precursors
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 8
  []
  # [FRD]
  #   order = CONSTANT
  #   family = MONOMIAL
  # []
[]

[AuxKernels]
# Makes an array called dnp that collects the 8 delayed neutron precursor groups
  [dnp_vector]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c0 c1 c2 c3 c4 c5 c6 c7'
    execute_on = 'timestep_begin'
  []
  # [fission_rate_density]
  #   type = VectorReactionRate
  #   scalar_flux = 'sflux_g0 sflux_g1 sflux_g2
  #                  sflux_g3 sflux_g4 sflux_g5'
  #   cross_section = sigma_fission
  #   variable = FRD
  #   scale_factor = Normalization
  # []
  #  [power_density]
  #    # Might get angry that power or reactor_power is not initialized as an AuxVariable
  #    power = ${reactor_power}
  #    power_density_variable = power
  #    power_scaling_postprocessor = Normalization
  #  []
[]

[Materials]
  [nm]
    type = ConstantNeutronicsMaterial
    block = '0'
    fromFile = true
    library_file = msr_cavity_xslib.xml
    material_id = '0'
    is_meter = true
    plus = true
  []
[]


[Executioner]
  type = Eigenvalue
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -c_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  free_power_iterations = 4
  nl_abs_tol = 1e-9
  # picard_max_its = 100
  fixed_point_max_its = 10

  # type = Eigenvalue
  # solve_type = PJFNKMO

  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  # petsc_options_value = 'hypre boomeramg 50'
  # l_max_its = 50

  # free_power_iterations = 4  # important to obtain fundamental mode eigenvalue

  # nl_abs_tol = 1e-9
  # fixed_point_abs_tol = 1e-9
  # fixed_point_max_its = 20
[]

[VectorPostprocessors]
  [eigenvalues]
    type = Eigenvalues
    inverse_eigenvalue = true
  []
  [AA_line_values]
    type = LineValueSampler
    start_point = '0 1 0'
    end_point = '2 1 0'
    variable = 'c0 c1 c2 c3 c4 c5 c6 c7'
    num_points = 100
    execute_on = 'TIMESTEP_END'
    sort_by = x
  []
  [BB_line_values]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    variable = 'c0 c1 c2 c3 c4 c5 c6 c7'
	num_points = 100
    execute_on = 'TIMESTEP_END'
    sort_by = y
  []
[]

[Postprocessors]
  [eigenvalue_out]
    type = VectorPostprocessorComponent
    vectorpostprocessor = eigenvalues
    vector_name = eigen_values_real
    index = 0
  []
[]

# [MultiApps]
# # This input ile is the master app, and step11_ns.i s the subapp that solves Navier-Stokes
#   [ns]
#     type = FullSolveMultiApp
#     input_files = broken_step11_ns.i
#     execute_on = 'NONLINEAR'
#   []
# []

# [Transfers]
# #fission_source and power_density have to be removed because the subapp does not have these
#   # [fission_source]
#   # # The master app gives the subapp the fission source to calculate NS
#   #   type = MultiAppNearestNodeTransfer
#   #   #multi_app = ns
#   #   #direction = to_multiapp
#   #   to_multi_app = ns
#   #   source_variable = FRD
#   #   variable = FRD
#   # []
#   [fission_source]
#     type = MultiAppCopyTransfer
#     to_multi_app = ns
#     source_variable = fission_source
#     variable = fission_source
#   []
#   [power_density]
#     type = MultiAppCopyTransfer
#     to_multi_app = ns
#     source_variable = power
#     variable = power_density
#   []
#   # All these transfers are the subapp solving for these dnp groups to give those values back
#   # to the master app
#   [c0]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c0'
#     variable = 'c0'
#   []
#   [c1]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c1'
#     variable = 'c1'
#   []
#   [c2]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c2'
#     variable = 'c2'
#   []
#   [c3]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c3'
#     variable = 'c3'
#   []
#   [c4]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c4'
#     variable = 'c4'
#   []
#   [c5]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c5'
#     variable = 'c5'
#   []
#   [c6]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c6'
#     variable = 'c6'
#   []
#   [c7]
#     type =  MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = 'c7'
#     variable = 'c7'
#   []
#   [u]
#     type = MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = vel_x
#     variable = u
#   []
#   [v]
#     type = MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = vel_y
#     variable = v
#   []
#   [pressure]
#     type = MultiAppCopyTransfer
#     from_multi_app = ns
#     source_variable = pressure
#     variable = pressure
#   []
# []

[Outputs]
  exodus = true
  csv = true
[]