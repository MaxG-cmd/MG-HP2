class MGparticleCarpeSpiral extends MGParticleFX;


defaultproperties
{
	AngularSpreadHeight=(Base=180,Rand=0)
	AngularSpreadWidth=(Base=180,Rand=0)
    ParticlesPerSec=(Base=200,Rand=0)
    SourceWidth=(Base=32)
    SourceHeight=(Base=32)
    SourceDepth=(Base=32)
    bSteadyState=True
    Speed=(Base=90)
    Lifetime=(Base=1)
    ColorStart=(Base=(R=218,G=218,B=218),Rand=(R=28,G=33,B=255))
    ColorEnd=(Base=(R=181,G=181,B=181),Rand=(R=17,B=225))
    SizeWidth=(Base=16)
    SizeLength=(Base=16)
    SizeEndScale=(Base=0.5)
    AlphaDelay=0.25
    SizeDelay=0.2
    SizeGrowPeriod=0.1
    Chaos=0
    Attraction=(X=32,Y=32,Z=32)
    Damping=0
    GravityModifier=0
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_1'
}