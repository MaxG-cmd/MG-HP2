class MGParticlePurpleEctoEXPLODE extends MGParticleFX;


defaultproperties
{
    ParticlesPerSec=(Base=5000)
    SourceWidth=(Base=2)
    SourceHeight=(Base=2)
    SourceDepth=(Base=2)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=200,Rand=-400)
    Lifetime=(Base=0.75,Rand=-0.5)
    ColorStart=(Base=(R=164,G=75,B=243),Rand=(R=37,G=53,B=194))
    ColorEnd=(Base=(R=166,G=43,B=213),Rand=(R=1,G=100,B=248))
    SizeWidth=(Base=16)
    SizeLength=(Base=16)
    bVelocityRelative=True
    Chaos=64
    Attraction=(X=4,Y=4,Z=4)
    Damping=2
    GravityModifier=0.05
    ParticlesMax=50
    Textures(0)=Texture'MGTech.SnowDot'
}