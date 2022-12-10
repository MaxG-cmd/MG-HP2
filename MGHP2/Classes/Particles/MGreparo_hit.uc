class MGreparo_hit extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=10000)
    SourceWidth=(Base=1)
    SourceHeight=(Base=1)
    SourceDepth=(Base=1)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=32,Rand=-64)
    Lifetime=(Base=2)
    ColorStart=(Base=(G=121))
    ColorEnd=(Base=(R=235,G=128,B=20))
    SpinRate=(Base=4,Rand=-8)
    SizeGrowPeriod=0.1
    Chaos=14
    Damping=2
    GravityModifier=0.03
    ParticlesMax=36
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_1'
}