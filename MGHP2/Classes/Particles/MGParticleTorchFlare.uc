class MGParticleTorchFlare extends TorchFire01;

defaultproperties
{
    ParticlesPerSec=(Base=1)
    SourceWidth=(Base=8)
    SourceHeight=(Base=8)
    SourceDepth=(Base=8)
    bSteadyState=True
    Speed=(Base=5,Rand=-10)
    Lifetime=(Base=1.5)
    ColorStart=(Base=(R=196,G=217,B=255),Rand=(R=64,G=75,B=215))
    ColorEnd=(Base=(R=97,G=81,B=238),Rand=(R=71,G=48,B=3))
    AlphaStart=(Base=0.1)
    SizeWidth=(Base=48,Rand=32)
    SizeLength=(Base=48,Rand=32)
    SizeEndScale=(Base=2,Rand=0)
    SpinRate=(Base=1,Rand=-2)
    AlphaDelay=1.0
    AlphaGrowPeriod=0.5
    Chaos=2
    Damping=8
    Gravity=(Z=4)
    Textures(0)=Texture'MGhp2.EFlareOY'
    Rotation=(Pitch=0)
	AmbientSound=None
}