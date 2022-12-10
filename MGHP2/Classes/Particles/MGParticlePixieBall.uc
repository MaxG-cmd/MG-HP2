class MGParticlePixieBall extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=30,Rand=30)
    SourceWidth=(Base=1)
    SourceHeight=(Base=1)
    SourceDepth=(Base=1)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=0,Rand=8)
    Lifetime=(Base=0.25,Rand=0.25)
    ColorStart=(Base=(R=43,G=90,B=255),Rand=(R=1,G=1,B=2))
    ColorEnd=(Base=(R=128,G=214,B=255))
    AlphaEnd=(Base=1,Rand=-0.25)
    SizeWidth=(Base=16,Rand=16)
    SizeLength=(Base=16,Rand=16)
    SizeEndScale=(Base=0)
    SpinRate=(Base=16,Rand=-32)
    Attraction=(X=0.2,Y=0.2,Z=0.2)
    GravityModifier=0.01
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.FF_SmallPuff'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.Sparkle_BW'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
    Textures(4)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
}