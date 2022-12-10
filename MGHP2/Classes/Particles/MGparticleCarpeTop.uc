class MGparticleCarpeTop extends MGParticleFX;


defaultproperties
{
    ParticlesPerSec=(Base=18)
    SourceWidth=(Base=20)
    SourceHeight=(Base=4)
    SourceDepth=(Base=12)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=4)
    bSteadyState=True
    Speed=(Base=48,Rand=12)
    Lifetime=(Base=3)
    ColorStart=(Base=(R=68,G=40,B=227))
    ColorEnd=(Base=(R=217))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=4,Rand=6)
    SizeLength=(Base=4,Rand=6)
    SizeEndScale=(Base=0)
    SpinRate=(Base=2,Rand=-4)
    ColorDelay=1
    SizeDelay=1
    Chaos=2
    Attraction=(X=3,Y=3)
    Damping=1
    GravityModifier=-0.04
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_BW'
}