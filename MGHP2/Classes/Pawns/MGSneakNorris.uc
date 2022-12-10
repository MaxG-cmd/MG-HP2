class MGSneakNorris extends MGSneakActor;


state JumpToPoint
{
	begin:
		TurnToward(CurrentPatrolTarget);
		PlayAnim('Stand2Jump');

		// MaxG: Wait for her to animate.
		Sleep(0.42);

		JumpToTarget();
        Controller.OnReachJumpTarget();

		FinishAnim();

		LoopAnim('Jump');

		// MaxG: Sleep to sync her landing anim.
		Sleep(MGSneakJumpPoint(CurrentPatrolTarget).JumpTime - 0.81);
		PlayAnim('Jump2Stand');	

		// MaxG: Fail safe in case the jump misses. 
		Sleep(8.0);

		SetLocation(CurrentPatrolTarget.Location);
		GoToState('SneakPatrol');
}

state JumpToHarry
{
	begin:
		// MaxG: Make her turn fast.
		RotationRate.Yaw *= 3;

		Velocity = Vec(0, 0, Velocity.Z);
		Acceleration = Vec(0, 0, Acceleration.Z);
		TurnTo(HRY.Location);

		RotationRate.Yaw = Default.RotationRate.Yaw;

		LoopAnim('Jump');
    
		// MaxG: Jump.
		SetPhysics(PHYS_Falling);
		Velocity = ComputeTrajectoryByTime(Location, Vec(HRY.Location.X, HRY.Location.Y, HRY.Location.Z - HRY.CollisionHeight), CalculateJumpTime(Vec(HRY.Location.X, HRY.Location.Y, HRY.Location.Z - HRY.CollisionHeight)));

		// MaxG: Clamp velocity.
		Velocity.Z = FClamp(Velocity.Z, MinJumpHeight, MaxJumpHeight);


		// MaxG: Sleep to sync her landing anim.
		Sleep(CalculateJumpTime(HRY.Location) - 0.81);
		PlayAnim('Jump2Stand');	
		FinishAnim();
		LoopAnim('Jump');

		// MaxG: Fail safe in case the jump misses. 
		Sleep(12.0);
		CM("[" $ Name $ "]::JumpToHarry ==> Failed ==> Going to SneakPatrol");
		GoToState('SneakPatrol');
		
}


// MaxG: Go to this state after trying to find the player but failing.
state LookAround
{
	begin:	
		LoopAnim(idleAnim);

		// MaxG: Turn.
		TurnToward(HRY);

		handleDialog(DT_Alarmed, "");

		PlayAnim(lookAnim);
		FinishAnim();

		// MaxG: Return.
		GoToState('SneakPatrol');
}

state HarryCaught
{
    ignores Bump, KeepLookout, SneakHearNoise, SneakSeePlayer;
    
    event BeginState()
    {
        Super.BeginState();

        // MaxG: Turn and lock onto Harry.
        DoTurnTo(HRY, false, true, true);
    }

    begin:
    PlayAnim('hiss', 0.9, 0.5);	

    // MaxG: Play the dialogue.
    handleDialog(DT_Caught, caughtDialogINT);
            
    // MaxG: Pause to let the dialogue finish.
    Sleep(catchSequenceDuration);
    
    FinishAnim();

    PlayAnim('stand2sit');
    FinishAnim();

    LoopAnim('sit');

    // MaxG: An extra sleep to reduce awkwardness.
    Sleep(sleepTimeBeforeDeath);
    
    ConsoleCommand("LoadGame 0");
    Sleep(1.0);
    
    HRY.Destroy();
}

defaultproperties
{
    alarmedDialog(0)=Sound'MGSounds.Filch.NORRIS_meow0'
    AmbientGlow=20
    bCanJump=true
    caughtAnim=Hiss
    caughtDialog(0)=Sound'MGSounds.Filch.NORRIS_hiss0'
    caughtDialogINT="mgdialog"
    CollideType=CT_AlignedCylinder
    CollisionHeight=14
    CollisionRadius=12
    FootStepVolume=1.5
    fovHorizontal=90
    fovVertical=30
    GroundRunSpeed=155
    GroundWalkSpeed=40
    idleAnim=Breathe
    JumpCooldown=2.0
    lookAnim=Look
    MaxJumpHeight=448
    MaxJumpStuckVelocity=80.0
    Mesh=SkeletalMesh'MGModels.MrsNorrisMesh'
    minHearingAlertThreshold=39.0
    MinJumpHeight=208
    RotationRate=(Pitch=0,Roll=0,Yaw=65000)
    sleepTimeBeforeDeath=2.0
    VerticalHearingRange=200
}