class MGreparo_fly extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=60)
    SourceWidth=(Base=1)
    SourceHeight=(Base=1)
    SourceDepth=(Base=1)
    AngularSpreadWidth=(Base=0,Rand=8)
    AngularSpreadHeight=(Base=0,Rand=8)
    bSteadyState=True
    Speed=(Base=0)
    Lifetime=(Base=2)
    ColorStart=(Base=(G=121))
    ColorEnd=(Base=(R=235,G=128,B=20))
    SpinRate=(Base=4,Rand=-8)
    Chaos=1
    GravityModifier=0.03
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_1'
}