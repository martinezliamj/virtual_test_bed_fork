################################################################################
## Molten Salt Fast Reactor - CNRS Benchmark step 1.1                         ##
## Sub-application for precursor transport                                    ##
## This runs an application for precursor transport within Pronghorn          ##
################################################################################

# Molecular thermophysical parameters
mu = 50.0 # Viscosity: [Pa.s]
rho = 2000. # Density: [kg/m^3]

# Turbulent Schmidt Number
Sc_t = 2.0e8 # Schmidt number: [-]

# Delayed neutron precursor parameters. Lambda values are decay constants in
# [1/s]. Beta values are production fractions.
# Using eight delayed neutron precursor families
lambda0 = 1.24667e-2
beta0   = 2.33102e-4
lambda1 = 2.82917e-2
beta1   = 1.03262e-3
lambda2 = 4.25244e-2
beta2   = 6.81878e-4
lambda3 = 1.33042e-1
beta3   = 1.37726e-3
lambda4 = 2.92467e-1
beta4   = 2.14493e-3
lambda5 = 6.66488e-1
beta5   = 6.40917e-4
lambda6 = 1.63478
beta6   = 6.05805e-4
lambda7 = 3.55460
beta7   = 1.66016e-4


# Defining global interpolation schemes and rc user object to advoid
# putting them in every kernel
[GlobalParams]
  rhie_chow_user_object = 'ins_rhie_chow_interpolator'
  two_term_boundary_expansion = false
  advected_interp_method = 'upwind'
  velocity_interp_method = 'average'
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

#[Problem]
#  kernel_coverage_check = false
#[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS & BCS
################################################################################

[UserObjects]
  [ins_rhie_chow_interpolator]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    pressure = pressure
  []
[]

[Variables]
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
[]

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
  []
  [fission_source]
    type = MooseVariableFVReal
    initial_condition = 1.0
  []
  [vel_x]
    type = 'INSFVVelocityVariable'
    initial_condition = 1.0
  []
  [vel_y]
    type = 'INSFVVelocityVariable'
    initial_condition = 1.0
  []
  [pressure]
    type = 'INSFVPressureVariable'
    initial_condition = 1.0
  []
[]

[FVKernels]
  [c0_advection]
    type = INSFVScalarFieldAdvection
    variable = c0
  []
  [c1_advection]
    type = INSFVScalarFieldAdvection
    variable = c1
  []
  [c2_advection]
    type = INSFVScalarFieldAdvection
    variable = c2
  []
  [c3_advection]
    type = INSFVScalarFieldAdvection
    variable = c3
  []
  [c4_advection]
    type = INSFVScalarFieldAdvection
    variable = c4
  []
  [c5_advection]
    type = INSFVScalarFieldAdvection
    variable = c5
  []
  [c6_advection]
    type = INSFVScalarFieldAdvection
    variable = c6
  []
  [c7_advection]
    type = INSFVScalarFieldAdvection
    variable = c7
  []

  [c0_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c0
  []
  [c1_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c1
  []
  [c2_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c2
  []
  [c3_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c3
  []
  [c4_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c4
  []
  [c5_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c5
  []
  [c6_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c6
  []
  [c7_diffusion]
    type = FVDiffusion
    coeff = ${fparse mu/Sc_t/rho}
    variable = c7
  []

  [c0_src]
    type = FVCoupledForce
    variable = c0
    v = fission_source
    coef = ${beta0}
  []
  [c1_src]
    type = FVCoupledForce
    variable = c1
    v = fission_source
    coef = ${beta1}
  []
  [c2_src]
    type = FVCoupledForce
    variable = c2
    v = fission_source
    coef = ${beta2}
  []
  [c3_src]
    type = FVCoupledForce
    variable = c3
    v = fission_source
    coef = ${beta3}
  []
  [c4_src]
    type = FVCoupledForce
    variable = c4
    v = fission_source
    coef = ${beta4}
  []
  [c5_src]
    type = FVCoupledForce
    variable = c5
    v = fission_source
    coef = ${beta5}
  []
  [c6_src]
    type = FVCoupledForce
    variable = c6
    v = fission_source
    coef = ${beta6}
  []
  [c7_src]
    type = FVCoupledForce
    variable = c7
    v = fission_source
    coef = ${beta7}
  []

  [c0_decay]
    type = FVReaction
    variable = c0
    rate = ${lambda0}
  []
  [c1_decay]
    type = FVReaction
    variable = c1
    rate = ${lambda1}
  []
  [c2_decay]
    type = FVReaction
    variable = c2
    rate = ${lambda2}
  []
  [c3_decay]
    type = FVReaction
    variable = c3
    rate = ${lambda3}
  []
  [c4_decay]
    type = FVReaction
    variable = c4
    rate = ${lambda4}
  []
  [c5_decay]
    type = FVReaction
    variable = c5
    rate = ${lambda5}
  []
  [c6_decay]
    type = FVReaction
    variable = c6
    rate = ${lambda6}
  []
  [c7_decay]
    type = FVReaction
    variable = c7
    rate = ${lambda7}
  []
[]

#[FVBCs]
#[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'hypre NONZERO'
  nl_rel_tol = 1e-8
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
[]