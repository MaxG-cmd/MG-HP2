class MGParticleDoorDust extends DustCloud01_tiny;

defaultproperties
{
    ParticlesPerSec=(Base=2048)
    SourceWidth=(Base=4)
    SourceHeight=(Base=200)
    SourceDepth=(Base=32)
    Speed=(Base=0)
    Lifetime=(Base=4)
    ColorStart=(Base=(R=122,G=114,B=107),Rand=(R=131,G=131,B=131))
    ColorEnd=(Base=(R=127,G=127,B=127),Rand=(R=124,G=124,B=124))
    AlphaStart=(Base=0.07)
    SizeWidth=(Base=14,Rand=12)
    SizeLength=(Base=14,Rand=12)
    AlphaDelay=0.25
    AlphaGrowPeriod=0.25
    Chaos=2
    Elasticity=0.1
    Damping=3
    GravityModifier=0.15
    ParticlesMax=32
	bSteadyState=true
}


    
