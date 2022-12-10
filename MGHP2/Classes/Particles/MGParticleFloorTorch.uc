class MGParticleFloorTorch extends MGParticleTorchFire;

defaultproperties
{
    ParticlesPerSec=(Base=14)
    SourceWidth=(Base=8)
    SourceHeight=(Base=8)
    Speed=(Base=18,Rand=0)
    Lifetime=(Base=1,Rand=0.5)
    SizeWidth=(Base=16,Rand=6)
    SizeLength=(Base=16,Rand=6)
    SpinRate=(Base=8,Rand=-16)
    Attraction=(X=1,Y=1)
    Gravity=(Z=-6)
}