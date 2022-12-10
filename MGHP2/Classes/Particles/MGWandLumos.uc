class MGWandLumos extends MGParticleFX;

defaultproperties
{
    AttachedParticleClasses(0)=Class'MGWandLumosGlow'
    bSystemRelative=False
    Chaos=3
    Damping=4
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    ParticlesPerSec=(Base=10)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    ColorStart=(Base=(G=237,B=15))
    ColorEnd=(Base=(G=191,B=60))
    SizeWidth=(Base=1,Rand=2)
    SizeLength=(Base=1,Rand=2)
    SizeEndScale=(Base=0)
    Lifetime=(Base=1.5)
    SpinRate=(Base=8,Rand=-16)
    Speed=(Base=0,Rand=32)
    SizeDelay=0.1
    SizeGrowPeriod=0.12
    Attraction=(X=1,Y=1,Z=1)
    Textures(0)=Texture'HPParticle.hp_fx.Particles.flare4'
}