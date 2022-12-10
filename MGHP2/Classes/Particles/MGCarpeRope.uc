class MGCarpeRope extends MGParticleFX;

var MGCarpeStatue CTarget;

event Tick(float DeltaTime)
{
	local Vector BallLoc;

	BallLoc = CTarget.BallParticle.Location;
	
	SetLocation( BaseWand(Harry(Owner).Weapon).GetWandEndpoint() );
	
	SetRotation( Rotator(BallLoc - Location) );

	Lifetime.Base = (1 * DeltaTime);

	ParticlesPerSec.Base = ParticlesAlive / DeltaTime;

	Speed.Base = VSize(Location - BallLoc) / (2 * DeltaTime);

	Speed.Rand = Speed.Base;

	Gravity = BallLoc - Location;

	Super.Tick(DeltaTime);
}

defaultproperties
{
	AngularSpreadWidth=(Base=3)
	AngularSpreadHeight=(Base=3)
    ParticlesPerSec=(Base=60)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    bSteadyState=True
    Speed=(Base=0)
    Lifetime=(Base=0.25)
    ColorStart=(Base=(R=182,G=76,B=249))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=4,Rand=4)
    SizeLength=(Base=4,Rand=4)
    SpinRate=(Base=8,Rand=-16)
    ParticlesAlive=120
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
}