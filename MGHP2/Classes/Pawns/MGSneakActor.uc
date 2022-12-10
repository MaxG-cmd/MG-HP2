class MGSneakActor extends HChar;

#exec OBJ LOAD FILE="..\Animations\MGModels.ukx"
#exec OBJ LOAD FILE="..\Sounds\AllDialog.uax" 

/************************************************
Class: MGSneakActor

Function:	This actor is supposed to patrol around
            areas and catch sneaky students who are
            in restricted places.
************************************************/


// Variables ------------------------------------

// MaxG: Used for CalculatePercievedLoudness()
// MaxG: 1/4pi
const SOUND_INTENSITY_COEFFICIENT = 0.07957747154594766788444188168626; 
const METERS_PER_UNIT = 0.01905;
const INVERSE_HEARING_THRESHOLD = 1000000000000;
const RADIANS_PER_DEGREE = 0.017453292519943295769236907684886127134428718885417254560971;
// --- Names ---------------------------------
var() Name BasePathTag;
// --- End Names------------------------------

// --- Floats --------------------------------

// MaxG: The minimum distance this actor can catch HRY from.
//			 If HRY is within this range, he will automatically get caught.
var() float AutoCatchDist;

// MaxG: Vertical field of view for this actor in degrees units.
var() float FOVVertical;

// MaxG: Horizontal field of view for this actor in degrees units.
var() float FOVHorizontal;

var() float SneakSeeingRadius;

// MaxG: This value represents how many units vertically this actor
//			 can hear.
var() float VerticalHearingRange;

// MaxG: This is used to prevent hearing at extreme ranges. This happens sometimes when the game lags.
var() float HearingRange;

// MaxG: About in decibels. The quietest sound that alerts.
var() float MinHearingAlertThreshold;


// MaxG: If HRY is this close to MGSneakActor and is actively being heard,
//			 he will be chased with presicion. 
var() float ChasingDist;

// MaxG: If player is above or at this opacity, he can be seen.
var() float OpacityThreshold;


// MaxG: How long the actor should look around for.
var() float LookAroundTime;


// MaxG: The maximum velocity to be considered stuck.
//		 If the actor is under this velocity while chasing, it will be considered stuck. 
var() float MaxStuckVelocity;

// MaxG: Amount of time that needs to pass for it to be considered stuck.
var() float MaxStuckTime;


var() float SeeingCatchTime;

// MaxG: The seeingAlertness is decremented by DeltaTime * seeingAlertnessDecayFactor when HRY is not seen.
//		 Essentially, over time the Actor loses alertness.
var() float SeeingAlertnessDecayFactor;


var() float SleepTimeBeforeCaughtDialog;

// MaxG: Sleep time after dialogue from getting caught but before reloading.
var() float SleepTimeBeforeDeath;

var() float RandomStopChance;
var() float RandomStopRadius;


// MaxG: The player must be this many units above the actor before jumping.
var() float MinElevationBeforeJumpingAtPlayer;

var() float MinJumpHeight;
var() float MaxJumpHeight;
var() float JumpCooldown;
var() float MaxJumpStuckVelocity;

var float NextJumpTime;


// MaxG: The length of time the entire catching sequence takes.
//			 This is derived from the length of the dialog.
var float CatchSequenceDuration;

var float TanSquared;

// MaxG: This goes up by 1 for every second that HRY is seen.
var float SeeingAlertness;
var float HalfCos;

var float SneakSeeingRadiusSQ;
var float ChasingDistSQ;
var float HearingRangeSQ;
// --- End Floats ----------------------------

// --- Booleans ------------------------------

var() bool bDebugPathing;

var bool bDoRandomStop;

// --- End Booleans --------------------------

// --- Categories ----------------------------

// ------ Sounds -----------------------------
var(SneakSounds) Sound CloakRevealSound;
var(SneakSounds) float CloakRevealSoundVolume;


var(SneakSounds) float FootStepVolume;

// MaxG: The various grumblings after failing a chase.
var(SneakSounds) Array<Sound> AlarmedDialog;

// MaxG: The stern scoldings after a successful catch.
var(SneakSounds) Array<Sound> CaughtDialog;

// MaxG: The various cackles and laughs for the sneak actor to make upon RunToStation events.
var(SneakSounds) Array<Sound> AlarmedGrumblings;

var(SneakSounds) String CaughtDialogINT;

var(FootstepSounds) Array<MultiSound> FootstepSounds;
// ------ End Sounds -------------------------

// ------ Animations -------------------------
var(SneakAnims) name CaughtAnim;
var(SneakAnims) name IdleAnim;
var(SneakAnims) name LookAnim;
var(SneakAnims) name RunAnim;
var(SneakAnims) name WalkAnim;
var(SneakAnims) name JumpAnim;
// ------ End Animations ---------------------
// --- End Categories ------------------------
// --- Actors -----------------------------
var MGTimer HitWallTimer;

// MaxG: For custom patrolling.
var MGSneakNode CurrentPatrolTarget;
var MGSneakNode PreviousPatrolTarget;

var PathNode CurrentNodeDest;
var Actor CurrentMoveTarget;
// --- End Actors -------------------------

// --- Enums ------------------------------
// MaxG: This is used for clarity in the getRandDialog() function.
enum dialogType
{
	DT_Caught,
	DT_Alarmed,
	DT_Grumble
};
// --- End Enums --------------------------

// MaxG: who's idea was it to write all these stupid comments?

var int itr_pause;

var Actor CurrentNoiseMaker;

var MGSneakController Controller;
var() Class<MGSneakController> ControllerClass;
// End Variables --------------------------------

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// +++ Macros +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#define DISTANCE(Other) (Location - Other.Location)

#define VSIZESQ(Vecta) ((Vecta.x ** 2) + (Vecta.y ** 2) + (Vecta.z ** 2))

#define HRY MGHarry(Level.PlayerHarryActor)

//;

// +++ End Macros +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


// ==============================================================================
// === Functions ================================================================

// MaxG: ???
//       Override this!
function PreSetMovement()
{
    return;
}

event PreBeginPlay()
{
	Super.PreBeginPlay();

	// MaxG: I precalculate some squares here to avoid doing square root operations
	//			 using VSize() later.

	tanSquared = tan(fovVertical * RADIANS_PER_DEGREE) ** 2;
	halfCos = Cos(fovHorizontal * RADIANS_PER_DEGREE) * 0.5;
	sneakSeeingRadiusSQ = sneakSeeingRadius ** 2;
	chasingDistSQ = chasingDist ** 2;
	hearingRangeSQ = hearingRange ** 2;
}

// MaxG: Get a reference to MGHarry;
event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	HitWallTimer = Spawn(class'MGTimer');

    Controller = Spawn(ControllerClass);

    Controller.SetSneakActor(Self);
}

function int GetTextureSound()
{
	local Texture HitTexture;
	local int Flags;
	
	HitTexture = TraceTexture(Location + (vect(0,0,-128)), Location, Flags);
	
	if (HitTexture != None)
	{
		return HitTexture.FootstepSound;
	}
	else
	{
		return 0;
	}
}

function PlayFootStep()
{
	local sound step;

	local int FootstepSound;
	
	FootstepSound = GetTextureSound();
	
	switch (FootstepSound)
    {
        case 1:
            step = FootstepSounds[0];				
            break;

        case 2:
            step = FootstepSounds[1];
            break;

        case 0:
            step = FootstepSounds[2];
            break;

        case 3:
            step = FootstepSounds[3];
            break;

        case 4:
            step = FootstepSounds[4];
            break;

        case 5:
            step = FootstepSounds[5];
            break;

        case 6:
            step = FootstepSounds[6];
            break;

        case 7:
            step = FootstepSounds[7];
            break;
    }
		

	PlaySound(step, SLOT_None, FootStepVolume, false, 1000.0, 0.9);
}

// MaxG: Toggle activity on trigger. Do NOT use this in CutScenes. He may freeze.
event Trigger(Actor Other, Pawn EventInstigator)
{
	if (isInState('Idle'))
	{
		//CM("[" $ Name $ "]::Trigger ==> In Idle, going to Patrol.");
        HRY.ConsoleCommand("KillAll Actor");	
	}
	else
	{
		//CM("[" $ Name $ "]::Trigger ==> In " $ GetStateName() $ ", going to Idle.");

		GoToState('Idle');
	}
}

// MaxG: If damage is taken, reset.
event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, name DamageType)
{
	GoToState('DamageEnd');
}

// MaxG: Retrieve a random piece of dialog to play.
//			Call this after looking around, or after catching HRY.
function Sound getRandDialog(dialogType dialogType)
{
	switch(dialogType)
	{
	case DT_Grumble:
		return alarmedGrumblings[rand(alarmedGrumblings.length)];
		break;

	// MaxG: Dialog to play after being alerted.
	case DT_Alarmed:
		// MaxG: Start with the alarmedDialog dynamic array.
		//			 Then find an index from range 0-length. Rand() is exclusive, so no need to do length - 1.
		return alarmedDialog[rand(alarmedDialog.length)];
		break;
			
	// MaxG: Dialog to play after catching HRY.
	case DT_Caught:
		return caughtDialog[rand(caughtDialog.length)];
		break;
					
	// MaxG: Fail safe
	default:
		//CM("MGSneakActor [" $ Name $ "] :: Failed determining dialog in getRandDialog()");
		return None;
		break;
	}
}

// MaxG: A way to play dialog lines with a settable .int file. No need to override hpdilog.int.
function float playSubDialog(String dlgId, Sound dlgSound, optional String intFileName, optional bool bMessage)
{
	local string dlgString;
	local float	sndLen;
	local int		i;

	// MaxG: Get the string to go with the id
	if (intFileName == "")
	{
		dlgString = Localize("all", dlgId, "HPdialog");
	}
	else
	{
		dlgString = Localize("all", dlgId, intFileName);
	}
	
	// MaxG: Play the sound
	if (dlgSound != None)
	{
		// MaxG: Get the length
		sndLen = GetSoundDuration(dlgSound);
		catchSequenceDuration = sndLen;
			
		// MaxG: Play it
		PlaySound(dlgSound, , 2, , 100000, , false);
	}
	else
	{
		// MaxG: No sound, so just make up a length
		sndLen = (Len(dlgString) * 0.01) + 3.0;
	}

	dlgString = HandleFacialExpression(dlgString, sndLen);

	// MaxG: Now add the subtitle to the HUD
	if (bMessage)
	{
		HRY.MyHud.SetSubtitleText(dlgString, sndLen);
	}
		
	// MaxG: Return the length that the dialog will be on the screen
	return sndLen;
}

// MaxG: A function to handle playing the dialog.
//			Uses the playDialog() function.
function handleDialog(dialogType dialogType, String intFileName)
{
	local Sound dialog;
	
	// MaxG: Get a random line.
	dialog = getRandDialog(dialogType);
		
	//CM("[MGSneakActor::handleDialog] dialog = " $ dialog);
	
	// MaxG: Play the dialog.
	if (dialogType == DT_Caught)
	{
		// MaxG: Play the dialog line using subtitle text	 (bMessage = true)
		playSubDialog(String(dialog.name), dialog, intFileName, true);
	}
	else
	{
		// MaxG: Play the DT_Alarmed dialog without subtitle text.
		playSubDialog(String(dialog.name), dialog, intFileName, false);
	}
}


// MaxG: Calculate loudness in decibels.
function float CalculatePercievedLoudness(float power, float dist)
{
	local float loudness;
	
	// MaxG: Inverse square law.
	loudness = power * SOUND_INTENSITY_COEFFICIENT / ((dist * METERS_PER_UNIT) ** 2);
	// CM("Loudness per sq meter: " $ loudness);
	
	// MaxG: Watts/square meter to decibels.
	return 10.0 * LogE(loudness * INVERSE_HEARING_THRESHOLD) / LogE(10.0);
}


// MaxG: Use MGHarry's implementation of MakeSneakNoise()
//			 to determine if we can hear him.
function SneakHearNoise(float Loudness, Actor NoiseMaker)
{
	local Vector dist;
	local float percievedLoudness;
	local float distSQ;
	
	dist = DISTANCE(NoiseMaker);
	distSQ = VSIZESQ(dist);

	// MaxG: Ensure the actor is within hearing range. 0 disables hearing.
	if (abs(dist.z) <= verticalHearingRange && distSQ <= hearingRangeSQ && hearingRange != 0)
	{
		percievedLoudness = CalculatePercievedLoudness(Loudness, VSize(dist));
		
		// MaxG: This actor percieves the NoiseMaker as being loud enough to hear.
		if (percievedLoudness >= minHearingAlertThreshold)
		{
			if (distSQ > chasingDistSQ)
			{
                CurrentNoiseMaker = NoiseMaker;
				GoToState('ResetAndRun');
			}
			else
			{
				GoToState('ChaseHarry');
			}
		}
	}
}

// MaxG: Can the player be seen?
function bool SneakSeePlayer(Actor Seen)
{
	local Vector hitLoc;
	local Vector hitNorm;
	local Vector horizontalDist;
	local Vector headLocation;
	local Vector SeenTraceLocation;
	local Vector vDist;
	local float distSquared;
	local float verticalDist;
	local Actor TraceActor;

    if ( MGSneakZone(Seen.Region.Zone).bInvisibleZone )
    {
        return false;
    }
	
	vDist = DISTANCE(Seen);
	distSquared = VSIZESQ(vDist);
		
	horizontalDist.x = Seen.Location.x - Location.x;
	horizontalDist.y = Seen.Location.y - Location.y;
	
	verticalDist = Seen.Location.z - Location.Z;

	// MaxG: Get the head location.
	headLocation = location + vec(0,0, (CollisionHeight * 0.95));
	
	
	// MaxG: Get the center of the Seen actor.
	SeenTraceLocation = Seen.Location + Vec(0, 0, Seen.CollisionHeight / 2);
	
	// MaxG: First check if he's within distance.
	if (distSquared <= sneakSeeingRadiusSQ)
	{
		// MaxG: Determine if HRY is within horizontal FOV.
		if (horizontalDist DOT Vector(Rotation) > (VSize2D(horizontalDist) * halfCos))
		{
			// MaxG: Determine if HRY is within the vertical FOV.
			if (tanSquared * ((horizontalDist.x ** 2) + (horizontalDist.y ** 2)) > verticalDist ** 2)
			{
				// MaxG: Trace for collision.
				TraceActor = Trace(hitLoc, hitNorm, SeenTraceLocation, headLocation, true, Vec(4, 4, 4), true);
				
				//CM("TraceActor:				" $ TraceActor);
				//CM("SeenTraceLocation: " $ SeenTraceLocation);
				//CM("headLocation:			" $ headLocation);
				
				// MaxG: Check for opacity. The actor must be above the threshold to be seen.
				if (TraceActor == Seen && (Seen.opacity >= opacityThreshold || HRY.bLumosOn))
				{	
					//CM("TraceActor:				" $ TraceActor);
					//CM("SeenTraceL ocation: " $ SeenTraceLocation);
					//CM("headLocation:			" $ headLocation);
					//CM("[" $ Name $ "]::SneakSeePlayer ==> true");
					return true;
				}
			}
		}
	}
	
	//CM("[" $ Name $ "]::SneakSeePlayer ==> false");
	return false;
}



// MaxG: Basic intelligence to be called in state ticks.
function KeepLookout(float DeltaTime)
{
	local Vector dist;

	dist = DISTANCE(HRY);
		
	// MaxG: If seen, catch HRY.
	if (SneakSeePlayer(HRY))
	{
		//CM("[" $ Name $ "]::KeepLookout ==> Increment seeingAlertness = " $ seeingAlertness);
		IncrementSeeingAlertness(DeltaTime);
	}
	// MaxG: Only attempt to decrement if greater than 0.
	else if (seeingAlertness > 0)
	{
		//CM("[" $ Name $ "]::KeepLookout ==> Decrement seeingAlertness = " $ seeingAlertness);
		DecrementSeingAlertness(DeltaTime);
	}
	
	if (seeingAlertness > seeingCatchTime)
	{
		//CM("[" $ Name $ "]: I've seen you for " $ seeingAlertness $ " seconds!");
		CatchHarry();
	}
	
	// MaxG: If player gets too close, catch them.
	if (VSize(dist) <= autoCatchDist)
	{
		CatchHarry();
	}
}

event Bump(Actor Other)
{
	if (Other == HRY)
	{
		CatchHarry();
	}
}


function HandleHitWallTimer()
{
	// MaxG: If velocity is low, start a timer to see if this actor is stuck.
	if (VSize(Velocity) < maxStuckVelocity)
	{
		if (!HitWallTimer.bTimerSet)
		{
			HitWallTimer.StartTimer();
		}
		
		if (HitWallTimer.SecondsElapsed > maxStuckTime)
		{
			//CM("[" $ Name $ "]::HandleHitWallTimer ==> I'm stuck!");
			//CM("[" $ Name $ "]::HandleHitWallTimer ==> Velocity ==> " $ VSize(Velocity));
			HitWallTimer.StopTimer();
			GoToState('LookAround');
		}

        // MaxG: Special case for noisemakers close to the wall.
        if ( !CurrentNoiseMaker.IsA('Harry') )
        {
            if ( VSize( DISTANCE(CurrentNoiseMaker) ) <= 192 )
            {
                HitWallTimer.StopTimer();
                GoToState('LookAround');
            }
        }
	}
	else
	{
		//CM("[" $ Name $ "]::HandleHitWallTimer ==> I'm good now, resetting timer.");
		HitWallTimer.StopTimer();
	}
}


function IncrementSeeingAlertness(float Value)
{
	seeingAlertness += Value;
	
	//CM("[" $ Name $ "]::IncrementSeeingAlertness ==> " $ seeingAlertness);
}


function DecrementSeingAlertness(float Value)
{
	if (seeingAlertness > 0)
	{
		seeingAlertness -= Value;
	}
	
	if (seeingAlertness < 0)
	{
		seeingAlertness = 0;
	}
	
	//CM("[" $ Name $ "]::DecrementSeingAlertness ==> " $ seeingAlertness);
}


function CatchHarry()
{
    if (HRY.IsInState('SneakCaught'))
    {
        GoToState('HarryAlreadyCaught');
    }
	else if (HRY.bIsCaptured)
	{
		GoToState('HarryCaughtInCutscene');
	}
	else
	{
		GoToState('HarryCaught');
	}
}


event Destroyed()
{
	Controller.Destroy();

	Super.Destroyed();
}

function JumpToTarget()
{
    // MaxG: Jump.
    SetPhysics(PHYS_Falling);
    Velocity = ComputeTrajectoryByTime(Location, CurrentPatrolTarget.Location, MGSneakJumpPoint(PreviousPatrolTarget).JumpTime);
}

function JumpAtActor(Actor JumpTarget)
{
    // MaxG: Jump.
    SetPhysics(PHYS_Falling);

    // MaxG: Compute jump to base of target to ensure a proper landing.
    Velocity = ComputeTrajectoryByTime(Location, Vec(JumpTarget.Location.X, JumpTarget.Location.Y, JumpTarget.Location.Z - JumpTarget.CollisionHeight), CalculateJumpTime(Vec(JumpTarget.Location.X, JumpTarget.Location.Y, JumpTarget.Location.Z - JumpTarget.CollisionHeight)));
}


// MaxG: Calculate jump time base on running speed.
function float CalculateJumpTime(Vector JumpLocation)
{
	return VSize(HRY.Location - Location) / (GroundRunSpeed * 2);
}


function UnstuckAfterJump()
{
	/*if (!IsInState('HarryCaught'))
	{
		//CM("Landed with " $ VSize2D(Velocity));

		// MaxG: Hit a wall and got stuck. Give up.
		if (VSize2D(Velocity) < MaxJumpStuckVelocity)
		{
			CM("[" $ Name $ "]::UnstuckAfterJump ==> I got stuck, looking around.");
			
			if (IsInState('RunToHeardLocation'))
			{
				GoToState('LookAround');
			}
		}
	}*/

    // MaxG: Only do this if we can actually jump.
    if (!bCanJump)
    {
        return;
    }

	if (IsInState('RunToHeardLocation'))
	{
		// MaxG: Hit a wall and got stuck. Give up.
		if (VSize2D(Velocity) < MaxJumpStuckVelocity)
		{
			//CM("[" $ Name $ "]::UnstuckAfterJump::RunToHeardLocation==>LookAround");
			GoToState('LookAround');
		}
	}
	else if (IsInState('ChaseHarry'))
	{
		// MaxG: Hit a wall and got stuck. Give up
		// TODO: Solve.
		if (VSize2D(Velocity) < MaxJumpStuckVelocity * 0.0625)
		{
			//CM("[" $ Name $ "]::UnstuckAfterJump::ChaseHarry==>LookAround");
			GoToState('LookAround');
		}
	}
}

function HandleJumpingAtHarry()
{
	// MaxG: Space in front of actor.
	local Vector TraceFront;
	local Vector TraceProp;
	local Vector HX, HY, HZ;
	local Rotator Rot;
	local Actor TraceActor;
	local Vector HitLoc;
	local Vector HitNorm;

    // MaxG: Only jump if allowed.
    if (!bCanJump)
    {
        return;
    }

	Rot = Rotation;

	// Metallicafan212: Rotate by 90.
	Rot.Yaw -= (65535) / 4;

	// MaxG / Metallicafan212: Get the locally rotated space.
	GetAxes(Rot, HX, HY, HZ);

	// Metallicafan212: 32 units in front
	TraceFront = Location + (HY * 32);
	TraceFront.Z -= 32;

	// MaxG: Look for props 128 units in front.
	TraceProp = Location + (HY * 128);

	// MaxG: Debug.
	//Spawn(Class'TargetFX', Self, , TraceFront);

	// MaxG: First, check if we can even jump.
	if (Physics == PHYS_Walking)
	{
		
		//CM("HandleJumpingAtHarry ==> Vertical ==> " $ (Location.z - Harry.Location.Z + 28));

		// MaxG: Only jump if Harry is at or above this height.
		if (Location.z - HRY.Location.Z + MinElevationBeforeJumpingAtPlayer >= 0)
		{
			// MaxG: Do a trace to see if there is no ledge in front of this.
			//		 Trace returns false if BSP is detected.
			//		 Ends at TraceFront, starts 32 units above that.
			if (FastTrace(TraceFront, TraceFront + Vec(0, 0, 32)))
			{
				GoToState('JumpToHarry');
			}
		}
		else
		{
			// MaxG: Wait for the jump cooldown. No cooldown if there's nothing in front of this.
			if (Level.TimeSeconds >= NextJumpTime)
			{
				// MaxG: Trace for a prop in front of this.
				TraceActor = Trace(HitLoc, HitNorm, TraceProp, Location, true, Vec(1, 1, 1), true);

				//CM("Trace ==> " $ TraceActor);

				// MaxG: First, just check if the thing is static. If so we can break early.
				if (TraceActor.bStatic)
				{
					GoToState('JumpToHarry');
				}

				// MaxG: Look for a prop in her way.
				if (TraceActor.IsA('HProp'))
				{
					GoToState('JumpToHarry');
				}
			}
		}
	}

	//CM("[" $ Name $ "]::HandleJumpingAtHarry ==> Failed");
}


// === End Functions ============================================================
// ==============================================================================



// ******************************************************************************
// *** States *******************************************************************


state() SneakPatrol
{
	event BeginState()
	{
		//CM("[" $ Name $ "]: Entering state SneakPatrol.");

		GroundSpeed = GroundWalkSpeed;
	}

	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
				
		KeepLookout(DeltaTime);
	}	
	
	// MaxG: Halt the actor on EndState to prevent sliding.
	event EndState()
	{
		Super.EndState();
		Acceleration = Vec(0, 0, 0);
		Velocity = Vec(0, 0, 0);
	}


    begin:
        Controller.DebugRoute();

        LoopAnim(WalkAnim);

        if ( Controller.TargetIsEmpty(CurrentPatrolTarget) )
        {
            Controller.GiveNearestSneakNode();
        }

        if (Controller.RouteIsEmpty())
        {
            Controller.GivePathToTarget(CurrentPatrolTarget);
        }
        else
        {
            Controller.GiveNextMoveTarget();
        }

        MoveTo(CurrentMoveTarget.Location);

        Controller.RemoveCurrentMoveTarget();

        if (Controller.RouteIsEmpty())
        {
            Controller.OnReachPatrolTarget();
        }

        GoTo('begin');
}

state SneakPatrolPause
{
	/*event BeginState()
	{
		//CM("[" $ Name $ "]: Entering state SneakPatrolPause.");
	}*/

	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
				
		KeepLookout(DeltaTime);
	}

	// event EndState()
	// {
	// 	Super.EndState();
	// }	

	begin:
        // MaxG: Match the rotation of the node.
        TurnTo( Location +  ( 128 * Vector(PreviousPatrolTarget.Rotation) ) );

        for (itr_pause = 0; itr_pause < PreviousPatrolTarget.PauseAnimations.Length; itr_pause++)
        {
            PlayAnim(PreviousPatrolTarget.PauseAnimations[itr_pause]);
            FinishAnim();
        }

        GoToState('SneakPatrol');
}

state RunToStation
{
	event BeginState()
	{
		GroundSpeed = GroundRunSpeed;
						
		//CM("[" $ Name $ "]: Entering state RunToStation.");
		
	
		// MaxG: Make some grumblings if they exist.
		if (alarmedGrumblings.length > 0)
		{
			handleDialog(DT_Grumble, "");
		}
	}
	
	event Tick(float DeltaTime)
	{	
		Super.Tick(DeltaTime);
		
		KeepLookout(DeltaTime);
	}	
	
	// MaxG: Halt the actor on EndState to prevent sliding.
	event EndState()
	{
		Super.EndState();
		Acceleration = Vec(0, 0, 0);
		Velocity = Vec(0, 0, 0);
	}

	begin:
		
}

state JumpToPoint
{
	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
				
		KeepLookout(DeltaTime);
	}

	event Landed(Vector HitNormal)
	{
		GoToState('SneakPatrol');
	}

	begin:    
		TurnToward(CurrentPatrolTarget);

		PlayAnim(JumpAnim);

		JumpToTarget();
        Controller.OnReachJumpTarget();

		// MaxG: Fail safe in case the jump misses. 
		Sleep(8.0);

		SetLocation(CurrentPatrolTarget.Location);
		GoToState('SneakPatrol');
}


state JumpToHarry
{
	event BeginState()
	{
		Super.BeginState();

		NextJumpTime = Level.TimeSeconds + JumpCooldown;
	}

	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
		
		HandleHitWallTimer();
		
		KeepLookout(DeltaTime);
	}

	event Landed(Vector HitNormal)
	{
		//CM("[" $ Name $ "]::JumpToHarry ==> Landed ==> Going to ChaseHarry");

		UnstuckAfterJump();

		GotoState('ChaseHarry');
	}

	event EndState()
	{
		Super.EndState();

		RotationRate.Yaw = Default.RotationRate.Yaw;
	}

	begin:
		// MaxG: Make actor turn fast.
		RotationRate.Yaw *= 3;

		Velocity = Vec(0, 0, Velocity.Z);
		Acceleration = Vec(0, 0, Acceleration.Z);
		TurnTo(HRY.Location);

		RotationRate.Yaw = Default.RotationRate.Yaw;

		LoopAnim(JumpAnim);

		JumpAtActor(HRY);

		// MaxG: Clamp velocity.
		Velocity.Z = FClamp(Velocity.Z, MinJumpHeight, MaxJumpHeight);

		// MaxG: Fail safe in case the jump misses. 
		Sleep(12.0);
		//CM("[" $ Name $ "]::JumpToHarry ==> Failed ==> Going to SneakPatrol");
		GoToState('SneakPatrol');
		
}


// MaxG: Go to this state after trying to find the player but failing.
state LookAround
{
	event BeginState()
	{
		//CM("[" $ Name $ "]: Entering state LookAround.");
		
		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);

		
		// MaxG: Make him turn a bit faster.
		RotationRate.Yaw *= 1.20;

        Controller.ClearRoute();
	}
	
	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		KeepLookout(DeltaTime);
	}
	
	event EndState()
	{
		Super.EndState();
		
		// MaxG: Go to the nearest patrol.
		//CurrentPatrolTarget = FindNearestPatrolNode();

		// MaxG: Restore.
		RotationRate.Yaw = Default.RotationRate.Yaw;
	}
	
	begin:		
		// MaxG: Look.
		PlayAnim(lookAnim);
		
		// MaxG: Turn.
		TurnToward(HRY);
		
		handleDialog(DT_Alarmed, "");
		
		Sleep(lookAroundTime);
		
		// MaxG: Return.
		GoToState('SneakPatrol');
}

// MaxG: Go to this state for a random lookaround event.
state LookAroundSuspicious
{
	event BeginState()
	{		
		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);
	}
	
	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		KeepLookout(DeltaTime);
	}
	
	
	begin:
        PlayAnim(IdleAnim);

		TurnToward(HRY);

        Sleep(0.75);

		PlayAnim(lookAnim);
				
		Sleep(lookAroundTime);
		
		GoToState('SneakPatrol');
}

state HarryCaughtInCutscene
{
	event BeginState()
	{
		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);
		LoopAnim(idleAnim);
	}

	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);

		if (!HRY.bIsCaptured)
		{
			GoToState('HarryCaught');
		}
	}
}

state HarryAlreadyCaught
{
    ignores Bump, KeepLookout, SneakHearNoise, SneakSeePlayer, CatchHarry;

	event BeginState()
	{
		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);
	}

	begin:
        LoopAnim(idleAnim);
        DoTurnTo(HRY, false, true, true);
        Sleep(65536);
}

state HarryCaught
{
	ignores Bump, KeepLookout, SneakHearNoise, SneakSeePlayer;
	
	event BeginState()
	{			
		local Vector hVelocity;

		//CM("[" $ Name $ "]: Entering state HarryCaught.");
				
		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);

		// MaxG: Play cloak reveal sound effect in 2D.
		if (HRY.Opacity < 0.9)
		{
			PlaySound(CloakRevealSound, SLOT_Misc, CloakRevealSoundVolume, , , , True);
		}

		// MaxG: Prevent cutscenes and triggers from interrupting the catch sequence.
		HRY.KillAll(Class'CutScene');
		HRY.KillAll(Class'Triggers');

		// MaxG: Testing a cam transition.
		//HRY.Cam.SetTargetActor(Name);
		//HRY.Cam.TransitionToCameraMode(CM_Idle);

        HRY.DropCarryingActor();
		
		// MaxG: The wand goes through his face.
		HRY.Weapon.Destroy();

		// MaxG: Reveal HRY.
		HRY.bCloak = false;

		// MaxG: Store HRY's velocity.
		hVelocity = HRY.Velocity;
		HRY.GoToState('SneakCaught');

		// MaxG: Restore HRY's velocity, as it gets lost on state change.
		HRY.Velocity = hVelocity;
		HRY.DoTurnTo(Self, false, true, true);
	}
	
	begin:
		// MaxG: Turn and lock onto HRY.
		DoTurnTo(HRY, false, true, true);
		
		LoopAnim(caughtAnim);
		
		Sleep(sleepTimeBeforeCaughtDialog);
		
		// MaxG: Play the dialogue.
		handleDialog(DT_Caught, caughtDialogINT);
		
		
		// MaxG: Pause to let the dialogue finish.
		Sleep(catchSequenceDuration);
		
		// MaxG: An extra sleep to reduce awkwardness.
		Sleep(sleepTimeBeforeDeath);
		
		ConsoleCommand("LoadGame 0");
		Sleep(1.0);
		
		// MaxG: No cheese allowed.
		HRY.Destroy();
}

state ResetAndRun
{
    begin:
        GotoState('RunToHeardLocation');
}

state RunToHeardLocation
{
	event BeginState()
	{
		//CM("[" $ Name $ "]: Entering state RunToHeardLocation.");
		
		GroundSpeed = GroundRunSpeed;
		
		HitWallTimer.StopTimer();

        Controller.ClearRoute();
	}
	
	event Tick(float DeltaTime)
	{
		Super.Tick(DeltaTime);
		
		HandleHitWallTimer();
		
		KeepLookout(DeltaTime);

        HandleJumpingAtHarry();

		// MaxG: Animate based on walking/falling.
		if (Base != None)
		{
			LoopAnim(runAnim);
		}
		else
		{
			LoopAnim(JumpAnim);
		}
	}

    // MaxG: Do not run into other sneaky guys.
    event Bump(Actor Other)
    {
        Super.Bump(Other);

        if ( Other.IsA('MGSneakActor') )
        {
            if ( Other.IsInState('LookAround') )
            {
                GoToState('LookAround');
            }
        }
    }

    event Landed(Vector HitNormal)
	{
		Super.Landed(HitNormal);

		UnstuckAfterJump();
	}

    event EndState()
    {
        Super.EndState();

        Controller.ClearRoute();
    }

	begin:
        LoopAnim(RunAnim);

        Controller.ClearRoute();

        if ( FastTrace(CurrentNoiseMaker.Location, Location) )
        {
            MoveTo(CurrentNoiseMaker.Location);
            GoToState('LookAround');
        }
        else
        {
            GoTo('find');
        }
    
    find:
        Controller.DebugRoute();

        if (Controller.TargetIsEmpty(CurrentNodeDest))
        {
            Controller.GiveNearestNodeToNoiseMaker();
        }

        // MaxG: The route cache gets filled when give path is called.
        //       If it isn't empty, you can just get the next one.
        if (Controller.RouteIsEmpty())
        {
            Controller.GivePathToTarget(CurrentNodeDest);
        }
        else
        {
            Controller.GiveNextMoveTarget();
        }

        MoveTo(CurrentMoveTarget.Location);

        Controller.RemoveCurrentMoveTarget();

        if (Controller.RouteIsEmpty())
        {
            Controller.ClearRoute();
            MoveTo(CurrentNoiseMaker.Location);
            GoToState('LookAround');
        }

        GoTo('find');
}


state ChaseHarry
{
	event BeginState()
	{
		//CM("[" $ Name $ "]: Entering state ChaseHarry.");
		
		GroundSpeed = GroundRunSpeed;
		
		HitWallTimer.StopTimer();
	}

	event Tick(float DeltaTime)
	{
		local Vector dist;
		local float distSQ;
			
		Super.Tick(DeltaTime);
		
		dist = DISTANCE(HRY);
		distSQ = VSIZESQ(dist);
		
		// MaxG: In this case he can only hear the actor.
		//		 Go to where his footsteps were heard.
		if (distSQ > chasingDistSQ && !SneakSeePlayer(HRY))
		{
			GoToState('ResetAndRun');
		}
			
		HandleHitWallTimer();
			
		KeepLookout(DeltaTime);

        HandleJumpingAtHarry();

		// MaxG: Animate based on walking/falling.
		if (Base != None)
		{
			LoopAnim(runAnim);
		}
		else
		{
			LoopAnim('Jump');
		}
	}

    event Landed(Vector HitNormal)
	{
		Super.Landed(HitNormal);

		UnstuckAfterJump();
	}

	
	begin:
		LoopAnim(RunAnim);
		MoveToward(HRY);
		GoTo('begin');		
}


auto state() Idle
{
	ignores SneakSeePlayer, SneakHearNoise, bump;
	
	event BeginState()
	{
		//CM("[" $ Name $ "]: Entering state Idle.");
	}
	
	begin:
		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);
		LoopAnim(idleAnim);
}

state DamageEnd
{
	ignores Bump, KeepLookout, SneakHearNoise, SneakSeePlayer;
	
	event BeginState()
	{
		local Vector hVelocity;
				
		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);

		// MaxG: Prevent cutscenes and triggers from interrupting the catch sequence.
		HRY.KillAll(Class'CutScene');
		HRY.KillAll(Class'Triggers');
		
		// MaxG: The wand goes through his face.
		HRY.Weapon.Destroy();

		// MaxG: Store HRY's velocity.
		hVelocity = HRY.Velocity;
		HRY.GoToState('SneakCaught');

		// MaxG: Restore HRY's velocity, as it gets lost on state change.
		HRY.Velocity = hVelocity;
		HRY.DoTurnTo(Self, false, true, true);
	}

	begin:
		LoopAnim(IdleAnim);
		// MaxG: Turn and lock onto HRY.
		DoTurnTo(HRY, false, true, true);
		Sleep(2.0);
		ConsoleCommand("LoadGame 0");
		Sleep(1.0);
		HRY.Destroy();
}

// MaxG: Override the KnowWonder states.
state stateInactive
{
	event BeginState()
	{
		//CM("[" $ Name $ "]: In stateInactive, going to Idle.");
		GoToState('Idle');
	}
}

state stateIdle
{
	event BeginState()
	{
		//CM("[" $ Name $ "]: In stateIdle, going to Idle.");
		GoToState('Idle');
	}
}

// MaxG: These states are used in cutscenes.
state DoingCutAnimate extends DoingCutAnimate
{
	ignores SneakSeePlayer, SneakHearNoise, bump;
}

state DoingTalk extends DoingTalk
{
	ignores SneakSeePlayer, SneakHearNoise, bump;
}

state stateMovingToLoc extends stateMovingToLoc
{
	ignores SneakSeePlayer, SneakHearNoise, bump;
}

state stateTurningTo extends stateTurningTo
{
	ignores SneakSeePlayer, SneakHearNoise, bump;
}
// *** End States ***************************************************************
// ******************************************************************************

defaultproperties
{
    AccelRate=1536
    alarmedDialog(0)=Sound'AllDialog.usa.PC_Gms_Adv7bSlyth_32'
    autoCatchDist=64
    bAvoidLedges=False
    bCanFly=False
    bCanFly=True
    bCanJump=False
    bDebugPathing=False
    bDoRandomStop=False
    bStopAtLedges=False
    catchSequenceDuration=3.0
    caughtAnim="point_right"
    caughtDialog(0)=Sound'AllDialog.usa.pc_slm_adv7bslyth_11'
    caughtDialogINT="hpdialog"
    chasingDist=180
    CloakRevealSound=Sound'MGSounds.Main.HAR_visible'
    CloakRevealSoundVolume=0.5
    CollisionHeight=50
    CollisionRadius=18
    ControllerClass=Class'MGHP2.MGSneakController'
    FootstepSounds(0)=MultiSound'MGSounds.FootSteps.rug_harry'
    FootstepSounds(1)=MultiSound'MGSounds.FootSteps.wood_harry'
    FootstepSounds(2)=MultiSound'MGSounds.FootSteps.stone_harry'
    FootstepSounds(3)=MultiSound'MGSounds.FootSteps.cave_harry'
    FootstepSounds(4)=MultiSound'MGSounds.FootSteps.cloud_harry'
    FootstepSounds(5)=MultiSound'MGSounds.FootSteps.wet_harry'
    FootstepSounds(6)=MultiSound'MGSounds.FootSteps.grass_harry'
    FootstepSounds(7)=MultiSound'MGSounds.FootSteps.metal_harry'
    FootstepSounds(8)=MultiSound'MGSounds.FootSteps.ecto_harry'
    FootstepSounds(9)=MultiSound'MGSounds.FootSteps.acid_harry'
    FootStepVolume=4.25
    fovHorizontal=100.0
    fovVertical=36.0
    GroundRunSpeed=190
    GroundSpeed=190
    GroundWalkSpeed=80
    hearingRange=1536
    idleAnim="idle"
    JumpAnim="jump"
    JumpCooldown=2.0
    lookAnim="talk_comeHere"
    lookAroundTime=1.65
    MaxJumpHeight=448
    MaxJumpStuckVelocity=80.0
    MaxStuckTime=2.0
    MaxStuckVelocity=32.0
    Mesh=Mesh'MGModels.skSlytherinPrefectMesh'
    MinElevationBeforeJumpingAtPlayer=28.0
    minHearingAlertThreshold=42.0
    MinJumpHeight=208
    opacityThreshold=0.6
    RandomStopChance=30
    RandomStopRadius=96
    RotationRate=(Pitch=0,Roll=0,Yaw=35000)
    RunAnim="run"
    RunAnimName="run"
    seeingAlertnessDecayFactor=0.009
    seeingCatchTime=0.5
    sleepTimeBeforeCaughtDialog=0.85
    sleepTimeBeforeDeath=1.75
    sneakSeeingRadius=1024
    verticalHearingRange=104
    walkAnim="walk"
}