class MGParticleExpelShield extends MGParticleFX;


defaultproperties
{
	bSystemRelative=True
    ParticlesPerSec=(Base=2048)
    SourceWidth=(Base=64)
    SourceHeight=(Base=64)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=0,Rand=32)
    ColorStart=(Base=(R=254,G=162,B=37))
    ColorEnd=(Base=(R=247,G=164,B=9))
    AlphaStart=(Base=0.8)
    AlphaEnd=(Base=0.6)
    SizeEndScale=(Base=0)
    SpinRate=(Base=8,Rand=-16)
    SizeDelay=0.5
    SizeGrowPeriod=0.125
    Chaos=1
    Attraction=(X=4,Y=4,Z=4)
    Damping=1
    ParticlesMax=64
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Sparkle_BW'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.swirl001'
}