class MGParticleWebFall extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=3600)
    SourceWidth=(Base=64)
    SourceHeight=(Base=64)
    AngularSpreadWidth=(Base=15,Rand=30)
    AngularSpreadHeight=(Base=15,Rand=30)
    bSteadyState=True
    Speed=(Base=428)
    Lifetime=(Base=2)
    ColorStart=(Base=(G=255,B=255))
    ColorEnd=(Base=(G=255,B=255))
    AlphaStart=(Base=0.35)
    AlphaEnd=(Base=0.25)
    SizeWidth=(Base=4,Rand=4)
    SizeLength=(Base=1,Rand=1)
    SizeEndScale=(Base=0)
    SpinRate=(Base=8,Rand=-16)
    AlphaGrowPeriod=0.1
    Chaos=1
    Elasticity=0.1
    Attraction=(X=0.7,Y=0.7)
    Damping=1.5
    GravityModifier=0.01
    ParticlesMax=240
    Textures(0)=Texture'HPParticle.hp_fx.Particles.webticle'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.webticle'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.webticle'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.FF_Wind'
    Textures(4)=Texture'HPParticle.hp_fx.Particles.FF_Wind'
}