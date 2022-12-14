class MGParticleBeanPickup extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=120)
    SourceWidth=(Base=8)
    SourceHeight=(Base=16)
    SourceDepth=(Base=8)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=45)
    bSteadyState=True
    Speed=(Base=0,Rand=128)
    Lifetime=(Base=2)
    ColorStart=(Base=(R=201,G=81,B=253))
    ColorEnd=(Base=(R=128,B=230))
    SizeWidth=(Base=4,Rand=8)
    SizeLength=(Base=4,Rand=8)
    SizeEndScale=(Base=0)
    SpinRate=(Base=4,Rand=-8)
    Chaos=0.1
    Elasticity=0.5
    Damping=10
    GravityModifier=-0.5
    ParticlesMax=10
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_BW'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.Sparkle_4'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.Dot_1'
}