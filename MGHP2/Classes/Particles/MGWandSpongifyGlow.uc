class MGWandSpongifyGlow extends MGParticleFX;

defaultproperties
{
    bSystemRelative=True
    ParticlesPerSec=(Base=30)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=8)
    Lifetime=(Base=0.75)
    ColorStart=(Base=(R=143,G=63,B=192))
    ColorEnd=(Base=(R=143,G=63,B=192))
    SpinRate=(Base=16,Rand=-32)
    AlphaDelay=0.25
    SizeGrowPeriod=0.1
    SizeWidth=(Base=2,Rand=2)
    SizeLength=(Base=2,Rand=2)
    Chaos=3
    Attraction=(X=64,Y=64,Z=64)
    Damping=12
    Textures(0)=Texture'HPParticle.hp_fx.Particles.flare4'
}