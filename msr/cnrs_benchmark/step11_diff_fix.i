[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2
    ymin = 0
    ymax = 2
    nx = 50
    ny = 50
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
  []
[]

[PowerDensity]
  power = 1e9
  power_density_variable = power
  power_scaling_postprocessor = power_scaling
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
    #block = '0'
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
  #[power_density]
  #  # Might get angry that power or reactor_power is not initialized as an AuxVariable
  #  power = ${reactor_power}
  #  power_density_variable = power
  #  power_scaling_postprocessor = Normalization
  #[]
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
  free_power_iterations = 2
  nl_abs_tol = 1e-6
  # picard_max_its = 100
  fixed_point_min_its = 3
  fixed_point_max_its = 10
[]

#[VectorPostprocessors]
#  [eigenvalues]
#    type = Eigenvalues
#    inverse_eigenvalue = true
#  []
#  [AA_line_values]
#    type = LineValueSampler
#    start_point = '0 1 0'
#    end_point = '2 1 0'
#    variable = 'c0 c1 c2 c3 c4 c5 c6 c7'
#    num_points = 100
#    execute_on = 'TIMESTEP_END'
#    sort_by = x
#  []
#  [BB_line_values]
#    type = LineValueSampler
#    start_point = '1 0 0'
#    end_point = '1 2 0'
#    variable = 'c0 c1 c2 c3 c4 c5 c6 c7'
#	  num_points = 100
#    execute_on = 'TIMESTEP_END'
#    sort_by = y
#  []
#[]

#[Postprocessors]
#  [eigenvalue_out]
#    type = VectorPostprocessorComponent
#    vectorpostprocessor = eigenvalues
#    vector_name = eigen_values_real
#    index = 0
#  []
#[]

[MultiApps]
  [ns_dnp0]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp0.i
    execute_on = 'timestep_end'
  []
  [ns_dnp1]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp1.i
    execute_on = 'timestep_end'
  []
  [ns_dnp2]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp2.i
    execute_on = 'timestep_end'
  []
  [ns_dnp3]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp3.i
    execute_on = 'timestep_end'
  []
  [ns_dnp4]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp4.i
    execute_on = 'timestep_end'
  []
  [ns_dnp5]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp5.i
    execute_on = 'timestep_end'
  []
  [ns_dnp6]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp6.i
    execute_on = 'timestep_end'
  []
  [ns_dnp7]
    type = FullSolveMultiApp
    input_files = step11_ns_dnp7.i
    execute_on = 'timestep_end'
  []
[]

[Transfers]
  [fission_source0]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp0
    source_variable = fission_source
    variable = fission_source
  []
  [c0]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp0
    source_variable = 'c0'
    variable = 'c0'
  []
  
  [fission_source1]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp1
    source_variable = fission_source
    variable = fission_source
  []
  [c1]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp1
    source_variable = 'c1'
    variable = 'c1'
  []
  
  [fission_source2]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp2
    source_variable = fission_source
    variable = fission_source
  []
  [c2]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp2
    source_variable = 'c2'
    variable = 'c2'
  []
  
  [fission_source3]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp3
    source_variable = fission_source
    variable = fission_source
  []
  [c3]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp3
    source_variable = 'c3'
    variable = 'c3'
  []


  [fission_source4]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp4
    source_variable = fission_source
    variable = fission_source
  []
  [c4]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp4
    source_variable = 'c4'
    variable = 'c4'
  []
  
  [fission_source5]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp5
    source_variable = fission_source
    variable = fission_source
  []
  [c5]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp5
    source_variable = 'c5'
    variable = 'c5'
  []
  
  [fission_source6]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp6
    source_variable = fission_source
    variable = fission_source
  []
  [c6]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp6
    source_variable = 'c6'
    variable = 'c6'
  []
  
  [fission_source7]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp7
    source_variable = fission_source
    variable = fission_source
  []
  [c7]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp7
    source_variable = 'c7'
    variable = 'c7'
  []
[]

[Outputs]
  csv = true
[]
