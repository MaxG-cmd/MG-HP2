class MGParticleCrackerFly extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=30)
    SourceWidth=(Base=20)
    SourceHeight=(Base=8)
    SourceDepth=(Base=8)
    bSteadyState=True
    Speed=(Base=0,Rand=8)
    Lifetime=(Base=0.7)
    ColorStart=(Base=(R=4,G=36,B=255),Rand=(R=255,G=28,B=28))
    ColorEnd=(Base=(R=83,G=87,B=255),Rand=(R=90,G=234,B=21))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=2,Rand=4)
    SizeLength=(Base=2,Rand=4)
    SizeEndScale=(Base=0)
    SpinRate=(Base=4,Rand=-8)
    Chaos=1
    Elasticity=0
    GravityModifier=0.02
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Les_Sparkle_04'
}