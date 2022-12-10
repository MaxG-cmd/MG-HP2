class MGParticlePurpleEcto extends MGParticleFX;


defaultproperties
{
    ParticlesPerSec=(Base=120)
    SourceWidth=(Base=2)
    SourceHeight=(Base=2)
    SourceDepth=(Base=2)
    bSteadyState=True
	AngularSpreadWidth=(Base=0)
    AngularSpreadHeight=(Base=0)
    Speed=(Base=0)
    Lifetime=(Rand=-0.5)
    ColorStart=(Base=(R=164,G=75,B=243),Rand=(R=37,G=53,B=194))
    ColorEnd=(Base=(R=166,G=43,B=213),Rand=(R=1,G=100,B=248))
    SizeWidth=(Base=24)
    SizeLength=(Base=24)
    bVelocityRelative=True
    Chaos=16
    Attraction=(X=4,Y=4,Z=4)
    Damping=2
    GravityModifier=0.05
    Textures(0)=Texture'MGTech.SnowDot'
}