class MGLightRockExplode extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=3600)
    AngularSpreadWidth=(Base=30)
    AngularSpreadHeight=(Base=60)
    bSteadyState=True
    Speed=(Base=0,Rand=600)
    Lifetime=(Base=5)
    ColorStart=(Base=(G=159))
    ColorEnd=(Base=(G=159,B=64))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=4,Rand=24)
    SizeLength=(Base=4,Rand=24)
    SizeEndScale=(Base=0)
    SpinRate=(Base=8,Rand=-16)
    SizeDelay=1
    Chaos=1
    Elasticity=0.5
    GravityModifier=1
    ParticlesMax=30
    Textures(0)=Texture'HPParticle.hp_fx.Particles.rockpiece'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.rockpiece'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.rockpiece'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.rockpiece'
    Textures(4)=Texture'HPParticle.hp_fx.Particles.SepiaFlamefx'
    Style=STY_Masked
}