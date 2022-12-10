class MGPigGoyle extends MGPig;

var() bool bInitiallyActive;
var() PatrolPoint FirstFeedWalkPoint;

var bool bActive;
var PatrolPoint CurrentPatrolTarget;
var PatrolPoint PrevPatrolTarget;
var SleepingGoyle Goyle;

event PreBeginPlay()
{
	Super.PreBeginPlay();

	bActive = bInitiallyActive;
}

// MaxG: Find sleeping Goyle.
event PostBeginPlay()
{
	Super.PostBeginPlay();

	forEach AllActors(Class'SleepingGoyle', Goyle)
	{
		break;
	}
}

function PatrolPoint FindNextPatrolPoint(PatrolPoint CurPoint)
{
	local PatrolPoint P;

	forEach AllActors(Class'PatrolPoint', P)
	{
		if (P.Name == CurPoint.NextPatrol_ObjectName)
		{
			return P;
		}
	}

	return None;
}

// MaxG: Default state that automatically handles fidgeting.
auto state() stateIdle
{
	event Trigger(Actor Other, Pawn EventInstigator)
	{
		bActive = !bActive;
	}

	event Tick(float DeltaTime)
	{
		if (PigCanSee(PlayerHarry) && bActive)
		{
			GoToState('Alerted');
		}
	}
}

state Stunned
{
	begin:
		DoTurnTo(PlayerHarry, false, true, true);
		PlaySnortSound();
		PlayAnim('React', 1.3);
		FinishAnim();
		Sleep(TimeStunned);

		GoToState('GoingToFeed');
}

state GoingToFeed
{
	event BeginState()
	{
		eVulnerableToSpell = SPELL_None;
	}

	begin:
		LoopAnim('Walk');
		CurrentPatrolTarget = FirstFeedWalkPoint;
		GoTo('find');

	find:
		if (CurrentPatrolTarget == None)
		{
			Velocity = Vec(0, 0, 0);
			Acceleration = Vec(0, 0, 0);
			
			// MaxG: Match the rotation of the node.
			TurnTo( Location +  ( 128 * Vector(PrevPatrolTarget.Rotation) ) );
			GoToState('Feeding');
		}

		MoveTo(CurrentPatrolTarget.Location);
		PrevPatrolTarget = CurrentPatrolTarget;
		CurrentPatrolTarget = FindNextPatrolPoint(CurrentPatrolTarget);

		GoTo('find');
}

state Feeding
{
	event BeginState()
	{
		LoopAnim('Eating');
		SetTimer(RAND_SNORT_TIME, false);
	}

	event Timer()
	{
		PlaySnortSound();
		SetTimer(RAND_SNORT_TIME, false);
	}
}

state Alerted
{
	// MaxG: Let them always be loud.
	event Tick(float DeltaTime)
	{

	}

	begin:
		DoTurnTo(PlayerHarry, false, true, true);
		PlaySquealSound();
		// MaxG: Wake up Goyle, we've been alerted.
		Goyle.PigWakeGoyle();
		PlayAnim('Squeal', 0.7);
		FinishAnim();
		GoTo('begin');
}

defaultproperties
{
	bInitiallyActive=True
}
