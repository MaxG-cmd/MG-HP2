class MGparticleCrabs extends Fireworks2;

defaultproperties
{
    ParticlesPerSec=(Base=90000)
    SourceWidth=(Base=4)
    SourceHeight=(Base=4)
    SourceDepth=(Base=4)
    bSteadyState=True
    Speed=(Base=800,Rand=175)
    Lifetime=(Rand=2)
    ColorStart=(Base=(R=217,G=9,B=9),Rand=(R=235,G=121,B=18))
    ColorEnd=(Base=(R=49,G=255,B=80),Rand=(R=34,G=255,B=205))
    SizeWidth=(Rand=8)
    SizeLength=(Rand=8)
    AlphaDelay=0.3
    ColorDelay=0.2
    Elasticity=2
    Damping=7
    ParticlesMax=3000
}
