class MGParticleCarpeMain extends MGParticleFX;
 
defaultproperties
{
	SizeWidth=(Base=10)
    SizeLength=(Base=10)
	AlphaDelay=1
    ParticlesPerSec=(Base=32)
    SourceWidth=(Base=0)
    SourceHeight=(Base=24,Rand=6)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=30)
    bSteadyState=True
    Speed=(Base=16,Rand=16)
    Lifetime=(Base=4)
    ColorStart=(Base=(R=132,G=66,B=253))
    ColorEnd=(Base=(R=0,G=45,B=255))
    SizeEndScale=(Base=1.5,Rand=-3)
    SpinRate=(Base=2,Rand=-4)
    bSystemRelative=True
    Elasticity=0.1
    Attraction=(X=4,Y=4,Z=4)
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Smoke3'
	AmbientSound=None
	SoundVolume=0
} 
