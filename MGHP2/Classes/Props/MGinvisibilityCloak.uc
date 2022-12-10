class MGinvisibilityCloak extends MGPropActive;

var() Class<ParticleFX> CloakParticle;
var() Class<ParticleFX> OnTouchParticle;
var Rotator pRot;

var Vector vLoc;
var() float fBobAmount;
var() bool bBob;
var() Sound CloakPickupSound;
var() float CloakPickupSoundVolume;

var ParticleFX CloakPart;


event PreBeginPlay()
{
	Super.PreBeginPlay();

	if (CloakParticle != None)
	{
		CloakPart = Spawn(CloakParticle);
	}
}

event BeginPlay()
{
	pRot.pitch = 16384;
	vLoc = location;

	Super.BeginPlay();
}


event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	
	if (bBob)
	{
		SetLocation( vLoc + (vec( fBobAmount * 0.2 * Cos(Level.TimeSeconds), 0, fBobAmount * Sin(Level.TimeSeconds) ) >> Rotation) );
	}
	
	if (CloakPart != None)
	{
		CloakPart.SetLocation(Location);
	}
}


event Touch(Actor Other)
{
	if (Other == PlayerHarry)
	{
		Disable('Touch');

		MGHarry(PlayerHarry).bCloak = true;

		if (Event != 'None')
		{
			TriggerEvent(Event, Self, PlayerHarry);
		}

		KillCloak();
	}
}

function KillCloak()
{
	// MaxG: Play pickup sound in 2D.
	PlaySound(CloakPickupSound, SLOT_Misc, CloakPickupSoundVolume, , , , true);
	Spawn(OnTouchParticle, , , , pRot);
	if (CloakPart != None)
	{
		CloakPart.Destroy();
	}
	Destroy();
}

defaultproperties
{
	bBlockPlayers=False
	bBlockCamera=False
	bBlockActors=False
	Mesh=SkeletalMesh'MGModels.InvisibilityCloak'
	//DrawScale=48
	DrawScale=1
	CollideType=CT_Box
	CollisionHeight=22
	CollisionRadius=22
	CollisionWidth=6
	fBobAmount=3.0f
	CloakParticle=Class'MGhp2.MGParticleCloak'
	CloakPickupSound=Sound'MGSounds.Main.HAR_invisible'
	OnTouchParticle=Class'MGhp2.MGParticleCloakChange'
	CloakPickupSoundVolume=0.5
}