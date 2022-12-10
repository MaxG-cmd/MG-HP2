class MGPig extends HChar;

#define RAND_SNORT_TIME RandRange(MinTimeBtwSnort, MaxTimeBtwSnort)

var(MGPigSounds) float SnortVolume;
var(MGPigSounds) float SquealVolume;
var(MGPigSounds) float MinSquealPitch;
var(MGPigSounds) float MaxSquealPitch;
var(MGPigSounds) Array<Sound> SnortSounds;
var(MGPigSounds) Array<Sound> SquealSounds;

var() bool bTraceGeometry;
var() float MaxTimeBtwSnort;
var() float MinTimeBtwSnort;
var() float PigCanSeeRadius;
var() float TimeStunned;


function PlaySnortSound()
{
	local int decision;
	decision = Rand(SnortSounds.Length);

	PlaySound(SnortSounds[decision], SLOT_Misc, SnortVolume, true, 4096.0, 1.0, false, false);
}

function PlaySquealSound()
{
	local int decision;
	decision = Rand(SquealSounds.Length);

	PlaySound(SquealSounds[decision], SLOT_Misc, SquealVolume, false, 4096.0, RandRange(MinSquealPitch, MaxSquealPitch), false, false);
}

function bool HandleSpellRictusempra(optional baseSpell Spell, optional Vector HitLocation)
{
	return True;
}

// MaxG: Can the player be seen?
function bool PigCanSee(Actor Seen)
{
	local Vector seen_midpoint;
	local Vector midpoint;

	seen_midpoint = Seen.Location;
	seen_midpoint.z += Seen.CollisionHeight * 0.5;

	midpoint = Location;
	midpoint.z += CollisionHeight * 0.5;

	if (VSize(Seen.Location - Location) > PigCanSeeRadius)
	{
		return false;
	}

	if (bTraceGeometry)
	{
		return FastTrace(seen_midpoint, midpoint);
	}

	return true;
}

// MaxG: Default state that automatically handles fidgeting.
auto state() stateIdle
{
	function bool HandleSpellRictusempra(optional baseSpell Spell, optional Vector HitLocation)
	{
		GotoState('Stunned');
		return True;
	}

	event Timer()
	{
		PlaySnortSound();
		SetTimer(RAND_SNORT_TIME, false);
	}

	event BeginState()
	{
		SetTimer(RAND_SNORT_TIME, false);
	}

	event Tick(float DeltaTime)
	{
		if ( PigCanSee(PlayerHarry) )
		{
			GoToState('Alerted');
		}
	}
}

state Stunned
{
	event EndState()
	{
		// MaxG: Stop turning.
		DestroyTurnToPermanentController();
	}

	begin:
		DoTurnTo(PlayerHarry, false, true, true);
		PlaySquealSound();
		PlayAnim('React', 1.3);
		FinishAnim();
		Sleep(TimeStunned);
		
		GoToState('stateIdle');
}

state Alerted
{
	function bool HandleSpellRictusempra(optional baseSpell Spell, optional Vector HitLocation)
	{
		GotoState('Stunned');
		return True;
	}

	event Tick(float DeltaTime)
	{
		if ( !PigCanSee(PlayerHarry) )
		{
			GoToState('stateIdle');
		}
	}

	event EndState()
	{
		DestroyTurnToPermanentController();
	}

	begin:
		DoTurnTo(PlayerHarry, false, true, true);
		PlaySquealSound();
		PlayAnim('Squeal', 0.7);
		FinishAnim();
		GoTo('begin');
}

defaultproperties
{
	AmbientGlow=16
	bTraceGeometry=False
	CollisionHeight=25
	CollisionRadius=40
	eVulnerableToSpell=SPELL_Rictusempra
	GroundSpeed=125.00
	MaxSquealPitch=1.12
	MaxTimeBtwSnort=12.0
	Mesh=SkeletalMesh'HPModels.skPigMesh'
	MinSquealPitch=0.82
	MinTimeBtwSnort=2.0
	PigCanSeeRadius=300
	RotationRate=(Pitch=0,Yaw=32000,Roll=0)
	SnortSounds(0)=Sound'Pig_snort01'
	SnortSounds(1)=Sound'Pig_snort02'
	SnortSounds(2)=Sound'Pig_snort03'
	SnortSounds(3)=Sound'Pig_snort04'
	SnortSounds(4)=Sound'Pig_snort05'
	SnortSounds(5)=Sound'Pig_snort06'
	SnortSounds(6)=Sound'Pig_snort07'
	SnortSounds(7)=Sound'Pig_snort08'
	SnortSounds(8)=Sound'Pig_snort09'
	SnortSounds(9)=Sound'Pig_snort10'
	SnortVolume=0.9
	SquealSounds(0)=Sound'pig_squeal1'
	SquealVolume=0.9
	TimeStunned=0.1
}
