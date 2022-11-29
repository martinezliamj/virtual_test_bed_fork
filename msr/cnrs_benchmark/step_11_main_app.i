################################################################################
## Molten Salt Fast Reactor - CNRS Benchmark step 1.1                         ##
## Main application                                                           ##
## This runs an application for neutronics within Griffin                     ##
################################################################################

[PowerDensity]
  power = 1e9
  power_density_variable = power
  power_scaling_postprocessor = power_scaling
[]

################################################################################
# GEOMETRY
################################################################################

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
    #nx = 100
    #ny = 100
  []
[]

################################################################################
# TRANSPORT SYSTEMS
################################################################################

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

################################################################################
# AUXVARIABLES AND AUXKERNELS
################################################################################

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900 # in degree C
  []
  # Delayed neutron precursor groups
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

################################################################################
# MATERIALS
################################################################################

# Cross sections for the six neutron energy groups
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

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Eigenvalue
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -c_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  free_power_iterations = 2
  nl_abs_tol = 1e-6
  fixed_point_rel_tol = 1e-5
  fixed_point_min_its = 3
  fixed_point_max_its = 20
[]

################################################################################
# POSTPROCESORS
################################################################################

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
  [total_c0]
    type = ElementAverageValue
    variable = c0
  []
[]

################################################################################
# MULTIAPPS and TRANSFERS for Navier-Stokes
################################################################################

[MultiApps]
  [ns_dnp]
    type = FullSolveMultiApp
    input_files = 'step_11_ns_general.i'
    execute_on = 'timestep_end'
  []
[]

[Transfers]
  [fission_source0]
    type = MultiAppNearestNodeTransfer
    to_multi_app = ns_dnp
    source_variable = fission_source
    variable = fission_source
  []
  [c0]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
    source_variable = 'c0'
    variable = 'c0'
  []
  [c1]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
    source_variable = 'c6'
    variable = 'c6'
  []
  [c7]
    type =  MultiAppNearestNodeTransfer
    from_multi_app = ns_dnp
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
