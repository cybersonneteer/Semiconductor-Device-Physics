File{
   Grid      = "nmos1_msh.tdr"
   *--Parameter = "@parameter@"
   Plot      = "IdVgs"
   Current   = "IdVgs"
   Output    = "IdVgs"
}

Electrode{
   { Name="source"    Voltage=0.0 }
   { Name="drain"     Voltage=0.0 }
   { Name="gate"      Voltage=0.0 }
}

Physics
{	
	 Fermi
	 Mobility( PhuMob Enormal ThinLayer (lombardi) hHighFieldSat(GradQuasiFermi) eHighFieldSat(GradQuasiFermi))
	 EffectiveIntrinsicDensity (BandGapNarrowing (OldSlotboom))
	 Recombination (SRH(DopingDep) Auger Band2Band ( Model = Hurkx ))
	*- eQuantumPotential hQuantumPotential


}

Plot{
*--Density and Currents, etc
   eDensity hDensity
   TotalCurrent/Vector eCurrent/Vector hCurrent/Vector
   eMobility hMobility
   eVelocity hVelocity
   eQuasiFermi hQuasiFermi

*--Temperature 
   eTemperature Temperature  hTemperature

*--Heat Quantities
   TotalHeat eJouleHeat hJouleHeat

*--Fields and charges
   ElectricField/Vector Potential SpaceCharge

*--Doping Profiles
   Doping DonorConcentration AcceptorConcentration

*--Generation/Recombination
   SRH Band2Band  Auger
   AvalancheGeneration eAvalancheGeneration hAvalancheGeneration

*--Driving forces
   eGradQuasiFermi/Vector hGradQuasiFermi/Vector
   eEparallel hEparallel eENormal hENormal

*--Band structure/Composition
   BandGap 
   BandGapNarrowing
   Affinity
   ConductionBand ValenceBand
   
}

Math { 
	Digits=6
	StressLimit=6e9
	Iterations=30
	Extrapolate
	Derivatives
	CNormPrint
	NotDamped=200
	Wallclock
	Method=Blocked SubMethod=ParDiso
	NoSRHperPotential
*--Digits(NonLocal)=3
*--EnergyResolution(NonLocal)=0.001
	Number_Of_Threads=8
}

Solve {
   *- Build-up of initial solution:
*-   NewCurrentPrefix="init_"
   Poisson
   Coupled(Iterations=100){ Poisson Electron Hole eQuantumPotential hQuantumPotential }
   
   *- Bias drain to target bias
  Quasistationary(
    InitialStep=0.01 MinStep=1e-5 MaxStep=1e-1
      Goal{ Name="drain" Voltage= 0.7  }
  ) { Coupled { Poisson Electron Hole eQuantumPotential hQuantumPotential} }

     *- Bias gate to target bias
     	Quasistationary (InitialStep=0.01 Minstep=1e-5 MaxStep=1e-2 Increment=100 
      Goal{ Name="gate" Voltage= -0.1  }
   ){ Coupled{ Poisson Electron Hole eQuantumPotential}}

   *-  gate voltage sweep
   NewCurrentPrefix="IdVgs(NSHE)_"
   Quasistationary( InitialStep=0.01 MinStep=1e-5 MaxStep=1e-2
      Goal{ Name="gate" Voltage= 1.0 }
   ) {
       Coupled { Poisson Electron Hole eQuantumPotential hQuantumPotential }
       CurrentPlot(Time=(Range=(0 1) Intervals=20))
     }

}

