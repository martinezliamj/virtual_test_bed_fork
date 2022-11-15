# This is the original input file, with only the syntax updated

mu=50.
rho=2000.

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

advected_interp_method = 'average'
velocity_interp_method = 'rc'

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = u
    v = v
    pressure = pressure
  []
[]

[GlobalParams]
  vel = 'velocity'
  velocity_interp_method = 'rc'
  advected_interp_method = 'average'
  rhie_chow_user_object = 'rc'
  two_term_boundary_expansion = true
[]

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

[Variables]
  [u]
    type = INSFVVelocityVariable
  []
  [v]
    type = INSFVVelocityVariable
  []
  [pressure]
    type = INSFVPressureVariable
  []
  [lambda]
    family = SCALAR
    order = FIRST
  []
  [c0]                                #SCALING?
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [c7]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
[]

[AuxVariables]
  [fission_source]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
[]

[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
  []
  [mean_zero_pressure]
    type = FVIntegralValueConstraint
    variable = pressure
    lambda = lambda
  []

  [u_advection]
    type = INSFVMomentumAdvection
    variable = u
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_viscosity]
    type = INSFVMomentumDiffusion
    variable = u
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    mu = ${mu}
    momentum_component = 'x'
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = u
    momentum_component = 'x'
    pressure = pressure
  []

  [v_advection]
    type = INSFVMomentumAdvection
    variable = v
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_viscosity]
    type = INSFVMomentumDiffusion
    variable = v
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    mu = ${mu}
    momentum_component = 'y'
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v
    momentum_component = 'y'
    pressure = pressure
  []

  [c0_advection]
    type = INSFVScalarFieldAdvection
    variable = c0
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  [c1_advection]
    type = INSFVScalarFieldAdvection
    variable = c1
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  [c2_advection]
    type = INSFVScalarFieldAdvection
    variable = c2
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  [c3_advection]
    type = INSFVScalarFieldAdvection
    variable = c3
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  [c4_advection]
    type = INSFVScalarFieldAdvection
    variable = c4
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  [c5_advection]
    type = INSFVScalarFieldAdvection
    variable = c5
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  [c6_advection]
    type = INSFVScalarFieldAdvection
    variable = c6
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  [c7_advection]
    type = INSFVScalarFieldAdvection
    variable = c7
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = u
    v = v
    mu = 'mu'
    rho = ${rho}
  []
  #[c1_turb_diffusion]
  #  type = FVDiffusion
  #  coeff = ${epsilon_c}
  #  variable = c1
  #  block = 'fuel pump hx'
  #[]
  #[c2_turb_diffusion]
  #  type = FVDiffusion
  #  coeff = ${epsilon_c}
  #  variable = c2
  #  block = 'fuel pump hx'
  #[]
  #[c3_turb_diffusion]
  #  type = FVDiffusion
  #  coeff = ${epsilon_c}
  #  variable = c3
  #  block = 'fuel pump hx'
  #[]
  #[c4_turb_diffusion]
  #  type = FVDiffusion
  #  coeff = ${epsilon_c}
  #  variable = c4
  #  block = 'fuel pump hx'
  #[]
  #[c5_turb_diffusion]
  #  type = FVDiffusion
  #  coeff = ${epsilon_c}
  #  variable = c5
  #[]
  #[c6_turb_diffusion]
  #  type = FVDiffusion
  #  coeff = ${epsilon_c}
  #  variable = c6
  #[]
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

[FVBCs]
  [top_x]
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'top'
    function = 0.5
  []
  [no_slip_x]
    type = INSFVNoSlipWallBC
    variable = u
    boundary = 'left right bottom'
    function = 0
  []
  [no_slip_y]
    type = INSFVNoSlipWallBC
    variable = v
    boundary = 'left right top bottom'
    function = 0
  []
[]

# [Materials]
#   [ins_fv]
#     type = INSFVMaterial
#     u = 'u'
#     v = 'v'
#     pressure = 'pressure'
#     rho = ${rho}
#   []
# []

[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -ksp_gmres_restart -sub_pc_type -sub_pc_factor_shift_type'
  petsc_options_value = 'asm      100                lu           NONZERO'
  line_search = 'none'
[]

[Outputs]
  exodus = true
  csv = true
[]
