mu=50.
rho=2000.
k=0.4187
cp=2575.
advected_interp_method='average'
velocity_interp_method='rc'
velocity='velocity'
# Remove the comments, and also maybe the commented blocks - have to ask Ramiro about that
# Not sure at all what this input file is doing - there appear to be some solution checking
# of variables calculated in step03.i, but there are also some new things in this file
[Mesh]
  [gen]
    type = GeneratedMeshGenerator
    dim = 2
    xmin = 0
    xmax = 2.
    ymin = 0
    ymax = 2.
    nx = 200
    ny = 200
  []
[]

[Variables]
  [temperature]
    type = INSFVEnergyVariable
    two_term_boundary_expansion = false
  []
[]

[AuxVariables]
  [vel_x]
    type = INSFVVelocityVariable
  []
  [vel_y]
    type = INSFVVelocityVariable
  []
  [pressure]
    type = INSFVPressureVariable
  []
[]

[AuxKernels]
  [vx]
  # This type does not seem to exist anymore - might be deprecated
    type = SolutionAux
    solution = vel_x_solution
    execute_on = initial
    variable = vel_x
  []
  [vy]
  # This type does not seem to exist anymore - might be deprecated
    type = SolutionAux
    solution = vel_y_solution
    execute_on = initial
    variable = vel_y
  []
  [p]
  # This type does not seem to exist anymore - might be deprecated
    type = SolutionAux
    solution = pressure_solution
    execute_on = initial
    variable = pressure
  []
[]

[UserObjects]
  [vel_x_solution]
  # This type does not seem to exist anymore - might be deprecated
    type = SolutionUserObject
    mesh = cnrs01_200x200.e
    system_variables = 'u'
    timestep = LATEST
  []
  [vel_y_solution]
  # This type does not seem to exist anymore - might be deprecated
    type = SolutionUserObject
    mesh = cnrs01_200x200.e
    system_variables = 'v'
    timestep = LATEST
  []
  [pressure_solution]
  # This type does not seem to exist anymore - might be deprecated
    type = SolutionUserObject
    mesh = cnrs01_200x200.e
    system_variables = 'pressure'
    timestep = LATEST
  []
[]

[FVKernels]
  [temp_conduction]
  # This type does not seem to exist anymore - might be INSFMomentumDiffusion
    type = FVDiffusion
    coeff = 'k'
    variable = temperature
  []
  [temp_advection]
    type = INSFVEnergyAdvection
    vel = ${velocity}
    variable = temperature
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    pressure = pressure
    u = vel_x
    v = vel_y
    mu = ${mu}
    rho = ${rho}
  []
  [temp_sinksource]
    type = NSFVEnergyAmbientConvection
    variable = temperature
    T_ambient = 900.
    alpha = '1e6'
  []
[]

[FVBCs]
  [adiabatic]
    type = FVNeumannBC
    variable = temperature
    boundary = 'left right top bottom'
    value = 0.
  []
[]

[Materials]
  [const]
  # Defines k and cp as material properties
    type = ADGenericConstantMaterial
    prop_names = 'k cp'
    prop_values = '${k} ${cp}'
  []
  [ins_fv]
  # Not sure what exactly this is defining
  # This material type does not seem to exist - might have to find/use something else
    type = INSFVMaterial
    u = 'vel_x'
    v = 'vel_y'
    pressure = 'pressure'
    temperature = 'temperature'
    rho = ${rho}
  []
[]

[Executioner]
# Solving the steady-state versions of these equations
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
