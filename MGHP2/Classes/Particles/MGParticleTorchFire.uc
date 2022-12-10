class MGParticleTorchFire extends MGParticleFX;


event PostBeginPlay()
{
	local Rotator Rot;
	
	// MaxG: Rotate vertically.
	Rot.Pitch = 16384;
	
	SetRotation(rot);
	
	Super.PostBeginPlay();	
}


defaultproperties
{
    // MaxG: I wanna be cheap.
	//AttachedParticleClasses(0)=class'MGhp2.MGParticleTorchFlare'
	ParticlesPerSec=(Base=10)
    SourceWidth=(Base=2)
    SourceHeight=(Base=2)
    SourceDepth=(Base=2)
    AngularSpreadWidth=(Base=4)
    AngularSpreadHeight=(Base=4)
    bSteadyState=True
    Speed=(Base=8,Rand=8)
    Lifetime=(Base=0.75,Rand=0.1)
    ColorStart=(Base=(G=231,B=230),Rand=(R=51,G=18,B=2))
    ColorEnd=(Base=(G=57),Rand=(R=71,G=48,B=3))
    AlphaEnd=(Base=0.7)
    SizeWidth=(Base=9)
    SizeLength=(Base=9)
    SizeEndScale=(Base=0)
    SpinRate=(Base=7,Rand=-14)
    SizeDelay=0.3
    Chaos=0.75
    Gravity=(Z=-2)
    Textures(0)=Texture'HPParticle.particle_fx.PotFire06'
    Rotation=(Pitch=16384)
}


