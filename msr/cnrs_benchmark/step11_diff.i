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
  []
[]

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900 # in degree C
  []
  # Delayed neutron precursor (DNP) groups
  [c0]
    order = CONSTANT
    family = MONOMIAL
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
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 8
  []
  [FRD]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[AuxKernels]
  [dnp_vector]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c0 c1 c2 c3 c4 c5 c6 c7'
    execute_on = 'timestep_begin'
  []
  [fission_rate_density]
    type = VectorReactionRate
    scalar_flux = 'sflux_g0 sflux_g1 sflux_g2
                   sflux_g3 sflux_g4 sflux_g5'
    cross_section = sigma_fission
    variable = FRD
    scale_factor = Normalization
    execute_on = 'timestep_begin'
  []
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
  picard_max_its = 100
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
    # variable = 'dnp'
    # num_points = 9
    variable = 'c0 c1 c2 c3 c4 c5 c6 c7'
    num_points = 100
    execute_on = 'TIMESTEP_END'
    sort_by = x
  []
  [BB_line_values]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    # variable = 'dnp'
    # num_points = 9
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

[MultiApps]
# This input file is the master app, and step11_ns.i s the subapp that solves Navier-Stokes
  [ns]
    type = FullSolveMultiApp
    input_files = 'step11_ns.i'
    execute_on = 'timestep_end'
    # execute_on = 'timestep_begin'
  []
[]

[Transfers]
  [fission_source]
  # The master app gives the subapp the fission source to calculate NS
    # type = MultiAppProjectionTransfer
    type = MultiAppNearestNodeTransfer
    to_multiapp = ns
    source_variable = FRD
    variable = FRD
  []
  # All these transfers are the subapp solving for these c_s and giving those values back
  # to the master app
  [c0]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c0'
    variable = 'c0'
  []
  [c1]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c6'
    variable = 'c6'
  []
  [c7]
    type = MultiAppProjectionTransfer
    from_multiapp = ns
    source_variable = 'c7'
    variable = 'c7'
  []
[]
