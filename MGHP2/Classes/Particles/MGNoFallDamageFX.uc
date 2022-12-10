class MGNoFallDamageFX extends MGParticleFX;

defaultproperties
{
	AlphaStart=(Base=0.1)
    ParticlesPerSec=(Base=60)
    SourceWidth=(Base=2)
    SourceHeight=(Base=2)
    SourceDepth=(Base=2)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=1)
    Lifetime=(Base=0.4)
    ColorStart=(Base=(G=255,B=255))
    ColorEnd=(Base=(G=255,B=255))
    SizeEndScale=(Base=2)
    SpinRate=(Base=4,Rand=-8)
    SizeGrowPeriod=0.1
    Attraction=(X=4,Y=4,Z=4)
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_1'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.Sparkle_4'
}