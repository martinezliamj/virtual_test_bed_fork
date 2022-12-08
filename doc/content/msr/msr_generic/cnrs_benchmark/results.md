# Results

*Contact: Ramiro Freile at ramiro.freile.at.inl.gov, Mustafa Jaradat at mustafa.jaradat.at.inl.gov, or Liam Martinez at liam.martinez.at.inl.gov*

## Overview

Here, selected results for each of the steps of the CNRS benchmark are reported [!citep](cnrs_inl).
The selected results are those prescbribed in [!citep](TIBERGA2020107428).

## Step 0.1 Results

For step 0.1, the velocity components along the reactor's horizontal and vertical centerlines are presented.

Along the AA' centerline, the x-component of velocity is shown in [vxh] and the y-component of velocity is shown in [vyh].

!media /msr/cnrs_benchmark/01_x_vel_along_aa.png
       style=width:60%
       id=vxh
       caption=x - velocity along the reactor's horizontal centerline.

!media /msr/cnrs_benchmark/01_y_vel_along_aa.png
       style=width:60%
       id=vyh
       caption=y - velocity along the reactor's horizontal centerline.

Along the BB' centerline, the x-component of velocity is shown in [vxv] and the y-component of velocity is shown in [vyv] .

!media /msr/cnrs_benchmark/01_x_vel_along_bb.png
       style=width:60%
       id=vxv
       caption=x - velocity along the reactor's vertical centerline.

!media /msr/cnrs_benchmark/01_y_vel_along_bb.png
       style=width:60%
       id=vyv
       caption=y - velocity along the reactor's vertical centerline.

The pressure field is shown in [01pressure] for physical context.

!media /msr/cnrs_benchmark/01_pressure.png
       style=width:60%
       id=01pressure
       caption=Pressure field for step 0.1.

Considering the pressure field in [01pressure], the data for the velocity components makes physical sense.
In [vxh], v$_x$ along AA’ is negative over almost the whole domain, indicating that the fluid tended to travel left.
The component v$_x$ peaks near the vertical walls, where the pressure is at its two extremes.
Along BB’ in [vxv], v$_x$ is highest near the top of the reactor, closest to the pressure gradient, and lowest at the middle where it is farther from the horizontal walls and the pressure gradient.
The v$_y$ component along AA’ in [vyh] is positive near the top left corner where the lower pressure is, indicating the flow of fluid towards lower pressure, and is negative near the top right corner where the higher pressure is, indicating the flow of fluid away from higher pressure.
This is exactly what we would expect.
The component v$_y$ along BB’ in [vyv] maximizes near the top of the reactor.

## Step 0.2 Results

For step 0.2, the fission rate density along the horizontal centerline and the reactivity $\rho$ are presented.

The fission rate density is shown in [frd].

!media /msr/cnrs_benchmark/02_frd_along_aa.png
       style=width:60%
       id=frd
       caption=Fission rate density along the reactor's horizontal centerline.

The power is radially symmetric and is centered at the center of the reactor, which makes sense because in this step we do not consider fluid flow and there is nothing to force the neutrons around the reactor.

The reactivity for this step was calculated to be $\rho_{0.2} = 4.65126 \times 10^{-3}$.

## Step 0.3 Results

For step 0.3, the temperature distributions along the horizontal and vertical centerlines are presented.

The temperature along AA' is shown in [tempa], and the temperature along BB' is shown in [tempb].

!media /msr/cnrs_benchmark/03_temp_along_aa.png
       style=width:60%
       id=tempa
       caption=Temperature along the reactor's horizontal centerline.

!media /msr/cnrs_benchmark/03_temp_along_bb.png
       style=width:60%
       id=tempb
       caption=Temperature along the reactor's vertical centerline.

The temperature distribution in the entire reactor is shown in [temp] for context.

!media /msr/cnrs_benchmark/03_temp_dist.png
       style=width:60%
       id=temp
       caption=Temperature distribution throughout the reactor.

The shape of the temperature distribution in [temp] looks as though it is being pushed left, since the right edge is concave and the left edge is convex.
This makes sense because the velocity field would be moving heat towards the left side of the reactor.
The temperatures along the AA’ and BB’ lines also reflect this behavior, with the temperature along AA’ peaking towards the left side of the reactor and the temperature along BB’ peaking towards the middle.

## Step 1.1 Results

For step 1.1, the DNP distributions along both centerlines and the reactivity change $\Delta \rho$ are presented.

The DNP distribution along AA' is shown in [dnpa], and the DNP distribution along BB' is shown in [dnpb].

!media /msr/cnrs_benchmark/11_dnp_along_aa.png
       style=width:60%
       id=dnpa
       caption=DNP distribution along the reactor's horizontal centerline.

!media /msr/cnrs_benchmark/11_dnp_along_bb.png
       style=width:60%
       id=dnpb
       caption=DNP distribution along the reactor's vertical centerline.

The distributions of DNP groups 0, 4, and 7 throughout the whole reactor are shown in [dnp0], [dnp4], and [dnp7], respectively.

!media /msr/cnrs_benchmark/11_dnp0.png
       style=width:60%
       id=dnp0
       caption=DNP group 0 distribution throughout the reactor.

!media /msr/cnrs_benchmark/11_dnp4.png
       style=width:60%
       id=dnp4
       caption=DNP group 4 distribution throughout the reactor.

!media /msr/cnrs_benchmark/11_dnp7.png
       style=width:60%
       id=dnp7
       caption=DNP group 7 distribution throughout the reactor.

The DNP distributions show that, for the lower-integer energy groups (dnp_0, dnp_1, etc.), the precursors are being pushed to the left side of the reactor, much like the shape of the temperature distribution from [temp].
The higher-integer energy groups are much more symmetric and are located closer to the center of the reactor.
These trends are reflected by the centerline data from [dnpa] and [dnpb].
In [dnpa], the lower-integer DNP group distributions peak towards the left side of the reactor and decrease going right, and the higher-integer DNP groups tend to peak towards the center and are generally symmetric around the center.
In [dnpb] the lower-integer DNP group distributions tend to peak towards the top of the reactor, while the higher-integer DNP groups tend to be symmetric around the center of the reactor where they peak, similar to the behavior of these groups in [dnpa].

The reactivity calculated for this step was $\rho_{1.1} = 4.05251 \times 10^{-3}$.
The change in reactivity $\Delta \rho = \rho_{1.1} - \rho_{0.2}$ was calculated to be $-5.9875 \times 10^{-4}$, representing a decrease in reactivity when including fuel flow in the calculation.