class MGExplosionDust extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=1024)
    SourceWidth=(Base=16)
    SourceHeight=(Base=16)
    SourceDepth=(Base=16)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=60)
    bSteadyState=True
    Speed=(Base=48,Rand=128)
    Lifetime=(Base=4)
    ColorStart=(Base=(G=255,B=255))
    ColorEnd=(Base=(G=255,B=255))
    AlphaStart=(Base=0.25)
    SizeWidth=(Base=24,Rand=16)
    SizeLength=(Base=24,Rand=16)
    SizeEndScale=(Base=3)
    SpinRate=(Base=2,Rand=-4)
    SizeGrowPeriod=0.05
    Chaos=2
    Damping=3
    GravityModifier=0.15
    ParticlesMax=32
    Textures(0)=Texture'HPParticle.hp_fx.Particles.FF_SmallPuff'
} 