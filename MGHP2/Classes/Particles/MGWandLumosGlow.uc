class MGWandLumosGlow extends MGParticleFX;

defaultproperties
{
    bSystemRelative=True
    Chaos=6
    Damping=32
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=30)
    AngularSpreadHeight=(Base=30)
    bSteadyState=True
    ColorStart=(Base=(G=237,B=15))
    ColorEnd=(Base=(G=191,B=60))
    SizeWidth=(Base=4,Rand=4)
    SizeLength=(Base=4,Rand=4)
    SizeEndScale=(Base=0)
    Lifetime=(Base=1.5)
    SpinRate=(Base=8,Rand=-16)
    Speed=(Base=8)
    SizeDelay=0.1
    SizeGrowPeriod=0.12
    Attraction=(X=128,Y=128,Z=128)
    Textures(0)=Texture'HPParticle.hp_fx.Particles.flare4'
}