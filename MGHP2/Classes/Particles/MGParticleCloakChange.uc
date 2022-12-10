class MGParticleCloakChange extends GhostTrail;
 
defaultproperties
{
    ParticlesPerSec=(Base=270)
    SourceWidth=(Base=24,Rand=0)
    SourceHeight=(Base=24,Rand=0)
    SourceDepth=(Rand=0)
	Attraction=(X=0.5,Y=0.5)
    AngularSpreadWidth=(Base=12,Rand=0)
    AngularSpreadHeight=(Base=12,Rand=0)
    bSteadyState=True
    Speed=(Base=140,Rand=0)
    Lifetime=(Base=1.0,Rand=-0.5)
    AlphaStart=(Base=0.1)
    AlphaDelay=0.5
    SizeGrowPeriod=0.15
    ParticlesMax=50
	bSystemRelative=True
} 
