class MGCarpeStatue extends MGPropActive;

// ------------------------------------------------------------------------------
// --- Variables ----------------------------------------------------------------

// MaxG: Offset where the player gets pulled to.
var() Vector PullOffset;

var() float ReEnableTime;

// MaxG: Where the simulation ends.
var() float PullDeadzone;

var() bool bSpawnFloatingParticle;

var MGHarry Harry;

var MGPeevesShield CarpeBall;
var MGParticleCarpeBall BallParticle;
var MGParticleCarpeActive ActiveParticle;
var MGParticleCarpeTop TopParticle;
var MGCarpeRope CarpeRope;

var(CarpeSounds) Sound RopeDissolveSound;


// --- End Variables ------------------------------------------------------------
// ------------------------------------------------------------------------------

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// +++ Macros +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// MaxG: Get the distance and account for the offset.
#define DIST(Other) ((Location + PullOffset) - Other.Location)


// +++ End Macros +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

// ==============================================================================
// === Functions ================================================================

function Vector VecClamp(Vector VecToClamp, float Magnitude)
{
    local Vector result;
    
    result = Normal(VecToClamp);
    
    result *= Magnitude;
    
    return result;
}


event PostBeginPlay()
{
	Harry = MGHarry(Level.PlayerHarryActor);

	CarpeBall = Spawn(Class'MGPeevesShield');

	CarpeBall.DrawScale = 0.085 * DrawScale;

	AttachToBone(CarpeBall, 'Attach');

	BallParticle = Spawn(Class'MGParticleCarpeBall', CarpeBall);
	AttachToBone(BallParticle, 'Attach');
	BallParticle.SetOwner(CarpeBall);

	ActiveParticle = Spawn(Class'MGParticleCarpeActive', CarpeBall);
	AttachToBone(ActiveParticle, 'Attach');
	ActiveParticle.SetOwner(CarpeBall);
	ActiveParticle.SetEmission(false);

	// MaxG: Spawn particle only if not on floor.
	if (bSpawnFloatingParticle)
	{
		TopParticle = Spawn(Class'MGParticleCarpeTop');
		AttachToBone(TopParticle, 'Attach');
		TopParticle.RelativeLocation.Z = 88;
		//Log("[" $ Name $ "]::PostBeginPlay ==> Spawning Top Particle");
	}

	Super.PostBeginPlay();
}


event Trigger(Actor Other, Pawn EventInstigator)
{
	// MaxG: Toggle usability.
	if (IsInState('Disabled'))
	{
		GoToState('Enabled');
	}
	else
	{
		if (IsInState('Pulling'))
		{
			Harry.Drop();
		}

		GoToState('Disabled');
	}
}

function DropHarry()
{
}

// === End Functions ============================================================
// ==============================================================================


// ******************************************************************************
// *** States *******************************************************************

state Enabled
{
	event BeginState()
	{
		SetCollision(true, false, false);
		eVulnerableToSpell = SPELL_LocomotorWibbly;
		BallParticle.SetEmission(true);
	}

	function bool HandleSpellSpongify(Optional BaseSpell Spell, Optional Vector HitLocation)
	{
		GotoState('Pulling');
		return True;
    }
}

state Disabled
{
	event BeginState()
	{
		SetCollision(false, false, false);
		eVulnerableToSpell = SPELL_None;
		BallParticle.SetEmission(false);
	}
}

state Pulling
{
	function DropHarry()
	{
		local Vector temp_velocity;

		temp_velocity = Harry.Velocity;

		Harry.GoToState('PlayerWalking');

		// MaxG: Restore velocity.
		Harry.Velocity = temp_velocity;

		//CM("[" $ Name $ "]::DropHarry ==> Sent Harry to PlayerWalking");

		if (CarpeRope != None)
		{
			CarpeRope.ShutDown();
		}

		// MaxG: Explosion effect on the statue.
		Spawn(Class'MGHP2.MGParticleCarpeExp', Self, , BonePos('Attach'));
		
		PlaySound(RopeDissolveSound, SLOT_None, [Volume]0.30, [bNoOverride], [Radius], [Pitch]0.85);

		GoToState('GoingToEnabled');
	}

	event BeginState()
	{
		BallParticle.SetEmission(false);
		ActiveParticle.SetEmission(true);
	}

	event EndState()
	{
		BallParticle.SetEmission(true);
		ActiveParticle.SetEmission(false);
	}
}

state GoingToEnabled
{
	event BeginState()
	{
		SetCollision(false, false, false);
	}

	Begin:
		Sleep(ReEnableTime);
		GoToState('Enabled');
}

// *** End States ***************************************************************
// ******************************************************************************

defaultproperties
{
	ReEnableTime=0.35
	AmbientGlow=32
	bBlockActors=False
	bBlockCamera=False
	bBlockPlayers=False
	bCollideWorld=False
	bEdShouldSnap=False
	bStatic=False
	bMovable=True
	bCanTeleport=True
	CollideType=CT_OrientedCylinder
	CollisionHeight=48.0
	CollisionRadius=48.0
	eVulnerableToSpell=SPELL_LocomotorWibbly
	LODBias=8
	ScaleGlow=1.5
	SpecularGlow=0
    bProjTarget=True
    Drawscale=1.0
    Mesh=SkeletalMesh'MGModels.CarpeStatue'
	bSpawnFloatingParticle=False
	RopeDissolveSound=Sound'MGSounds.Main.spell_carpe_cast_alt'
    PullDeadzone=0
}