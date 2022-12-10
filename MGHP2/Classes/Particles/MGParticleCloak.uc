class MGParticleCloak extends MGParticleFX;
 
defaultproperties
{
    ParticlesPerSec=(Base=1)
    SourceWidth=(Base=32)
    SourceHeight=(Base=80)
    SourceDepth=(Base=32)
    AngularSpreadWidth=(Base=0)
    AngularSpreadHeight=(Base=0)
    bSteadyState=True
    Speed=(Base=0)
    Lifetime=(Base=4,Rand=1)
    ColorStart=(Base=(R=45,G=166,B=255),Rand=(R=138,G=185,B=255))
    ColorEnd=(Base=(R=84,G=113,B=245),Rand=(R=176,G=208,B=255))
    AlphaStart=(Base=0.22)
    SizeEndScale=(Base=0)
    SpinRate=(Base=2,Rand=-4)
    bSystemRelative=True
    SizeDelay=3
    AlphaGrowPeriod=1
    Chaos=1
    Attraction=(X=5,Y=5)
	Elasticity=0.75
    Damping=16
    GravityModifier=0.01
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Les_Sparkle_04'
}

