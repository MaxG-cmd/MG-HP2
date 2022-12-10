class MGExplosionDustRocks extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=256)
    SourceWidth=(Base=32)
    SourceHeight=(Base=8)
    SourceDepth=(Base=32)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=16,Rand=448)
    Lifetime=(Base=4)
    ColorStart=(Base=(R=148,G=148,B=148))
    ColorEnd=(Base=(R=143,G=143,B=143))
    SizeWidth=(Base=4,Rand=8)
    SizeLength=(Base=6,Rand=10)
    SizeEndScale=(Base=0)
    SpinRate=(Base=32,Rand=-64)
    AlphaDelay=3
    SizeDelay=1
    Elasticity=0.5
    GravityModifier=1
    ParticlesMax=16
    Textures(0)=Texture'HPParticle.hp_fx.Particles.SepiaFlamefx'
} 