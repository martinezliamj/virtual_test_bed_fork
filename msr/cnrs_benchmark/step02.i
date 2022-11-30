################################################################################
## Molten Salt Fast Reactor - CNRS Benchmark step 0.2                         ##
## Standalone application                                                     ##
## This calculates neutronics for the reactor, ignoring fluid motion          ##
################################################################################

# Reactor power is held constant at 1 GW for this step
reactor_power = 1e9

[PowerDensity]
  power = ${reactor_power}
  power_density_variable = power
  power_scaling_postprocessor = Normalization
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
    nx = 100
    ny = 100
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
    # external_dnp_variable = 'dnp'
    family = LAGRANGE
    order = FIRST
  []
[]

################################################################################
# AUXVARIABLES AND AUXKERNELS
################################################################################

[AuxVariables]
# Fuel temperature - held constant for this step
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900 # in degree C
  []
  [FRD]
    order = FIRST
    family = L2_LAGRANGE
  []
[]

[AuxKernels]
  [fission_rate_density]
    type = VectorReactionRate
    scalar_flux = 'sflux_g0 sflux_g1 sflux_g2
                   sflux_g3 sflux_g4 sflux_g5'
    cross_section = sigma_fission
    variable = FRD
    scale_factor = Normalization
    block = '0'
  []
[]

################################################################################
# MATERIALS
################################################################################

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
# POSTPROCESSORS
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
    variable = 'FRD sflux_g0 sflux_g1 sflux_g2
                    sflux_g3 sflux_g4 sflux_g5'
    num_points = 100
    execute_on = 'TIMESTEP_END'
    sort_by = x
  []
  [BB_line_values]
    type = LineValueSampler
    start_point = '1 0 0'
    end_point = '1 2 0'
    variable = 'FRD sflux_g0 sflux_g1 sflux_g2
                    sflux_g3 sflux_g4 sflux_g5'
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

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Eigenvalue
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -c_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'
  free_power_iterations = 4
  nl_abs_tol = 1e-9
  picard_max_its = 100
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
[]
