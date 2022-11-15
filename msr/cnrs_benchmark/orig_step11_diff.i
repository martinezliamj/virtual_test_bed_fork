# This is the original input file, with only the syntax updated

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
    # external_dnp_variable = 'dnp'
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
[]

[AuxKernels]
  [dnp_vector]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c0 c1 c2 c3 c4 c5 c6 c7'
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
  fixed_point_max_its = 100
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
    variable = 'dnp'
    num_points = 9
    execute_on = 'TIMESTEP_END'
    sort_by = x
  []
  [BB_line_values]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    variable = 'dnp'
    num_points = 9
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
  [ns]
    type = FullSolveMultiApp
    input_files = 'orig_step11_ns.i'
    execute_on = 'timestep_end'
  []
[]

[Transfers]
  [fission_source]
    type = MultiAppProjectionTransfer
    to_multiapp = ns
    source_variable = fission_source
    variable = fission_source
  []
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
    mfrom_multiapp = ns
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
