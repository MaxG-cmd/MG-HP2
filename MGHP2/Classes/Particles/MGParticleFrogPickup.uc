class MGParticleFrogPickup extends MGParticleFX;


defaultproperties
{
    ParticlesPerSec=(Base=120)
    SourceWidth=(Base=8)
    SourceHeight=(Base=16)
    SourceDepth=(Base=8)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=90)
    Speed=(Base=64,Rand=80)
    Lifetime=(Base=4)
    ColorStart=(Base=(R=240,G=142,B=77))
    ColorEnd=(Base=(R=136,G=57))
    SizeWidth=(Rand=8)
    SizeLength=(Rand=8)
    SizeEndScale=(Base=0)
    SpinRate=(Base=4,Rand=-8)
    Elasticity=0.8
    Attraction=(X=4,Y=4)
    Damping=4
    GravityModifier=0.2
    ParticlesMax=20
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_BW'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.Les_Sparkle_04'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
}