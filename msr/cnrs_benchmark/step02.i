reactor_power = 1e9

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

[PowerDensity]
  power = ${reactor_power}
  power_density_variable = power
  power_scaling_postprocessor = Normalization
[]

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
  # Making a variable for the normalized power density
  #[normalized_power_density]
  #  family = MONOMIAL
  #  order = CONSTANT
  #[]
  # Making variables for the scaled neutron fluxes
  #[scaled_sflux_g0] # Scaled fast flux n/m^2/s
  #  family = L2_LAGRANGE
  #  order = FIRST
  #[]
  #[scaled_sflux_g1] # Scaled fast flux n/m^2/s
  #  family = L2_LAGRANGE
  #  order = FIRST
  #[]
  #[scaled_sflux_g2] # Scaled fast flux n/m^2/s
  #  family = L2_LAGRANGE
  #  order = FIRST
  #[]
  #[scaled_sflux_g3] # Scaled fast flux n/m^2/s
  #  family = L2_LAGRANGE
  #  order = FIRST
  #[]
  #[scaled_sflux_g4] # Scaled fast flux n/m^2/s
  #  family = L2_LAGRANGE
  #  order = FIRST
  #[]
  #[scaled_sflux_g5] # Scaled fast flux n/m^2/s
  #  family = L2_LAGRANGE
  #  order = FIRST
  #[]
  #[FissionRR] # Fission rate density fissions/m^3/s
  #  family = L2_LAGRANGE
  #  order = FIRST
  #  initial_condition = 0.0
  #[]
[]

#[AuxKernels]
#  [normalized_power_density]
#    type = ScaleAux
#    multiplier = ${fparse 1/reactor_power}
#    source_variable = pow_den
#    variable = normalized_power_density
#  []
#  # Scaling the neutron fluxes with the reactor power
#  [scaled_sflux_g0] #scaled flux unit is in n/m^2/s
#    type = ScaleAux
#    scale_factor = power_scaling
#    variable = scaled_sflux_g0
#    source_variable = sflux_g0
#  []
#  [scaled_sflux_g1] #scaled flux unit is in n/m^2/s
#    type = ScaleAux
#    scale_factor = power_scaling
#    variable = scaled_sflux_g1
#    source_variable = sflux_g1
#  []
#  [scaled_sflux_g2] #scaled flux unit is in n/m^2/s
#    type = ScaleAux
#    scale_factor = power_scaling
#    variable = scaled_sflux_g2
#    source_variable = sflux_g2
#  []
#  [scaled_sflux_g3] #scaled flux unit is in n/m^2/s
#    type = ScaleAux
#    scale_factor = power_scaling
#    variable = scaled_sflux_g3
#    source_variable = sflux_g3
#  []
#  [scaled_sflux_g4] #scaled flux unit is in n/m^2/s
#    type = ScaleAux
#    scale_factor = power_scaling
#    variable = scaled_sflux_g4
#    source_variable = sflux_g4
#  []
#  [scaled_sflux_g5] #scaled flux unit is in n/m^2/s
#    type = ScaleAux
#    scale_factor = power_scaling
#    variable = scaled_sflux_g5
#    source_variable = sflux_g5
#  []
#  # Sets the scaling and which fluxes get scaled
#  [FissionRR]
#    type = VectorReactionRate
#    variable = FissionRR
#    cross_section = sigma_fission
#    scale_factor = power_scaling
#    scalar_flux = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5'
#  []
#[]

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
  #[AA_line_values]
  # Temperature distribution along the x-midline
  #  type = LineValueSampler
   # start_point = '0 1 0'
   # end_point = '2 1 0'
   # variable = 'dnp'
   # num_points = 9
   # execute_on = 'TIMESTEP_END'
   # sort_by = x
  #[]
  #[BB_line_values]
  # Temperature distribution along the y-midline
  #  type = LineValueSampler
  #  start_point = '1 0 0'
  #  end_point = '1 2 0'
   # variable = 'dnp'
   # num_points = 9
    #execute_on = 'TIMESTEP_END'
    #sort_by = y
  #[]
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

[Outputs]
  exodus = true
  csv = true
[]
