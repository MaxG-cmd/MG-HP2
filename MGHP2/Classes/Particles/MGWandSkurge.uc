class MGWandSkurge extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=45)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    bSteadyState=True
    Speed=(Base=0)
    ColorStart=(Base=(R=34,G=67,B=255))
    ColorEnd=(Base=(R=75,G=6,B=184))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=12)
    SizeLength=(Base=12)
    SizeEndScale=(Base=0)
    SpinRate=(Base=5,Rand=5)
    SizeGrowPeriod=0.1
    Chaos=2
    Attraction=(X=16,Y=16,Z=16)
    Damping=1
    Textures(0)=Texture'HPParticle.hp_fx.Particles.flare4'
}