class MGSneakFilch extends MGSneakActor;

var(SneakSounds) Sound LanternCreakSound;
var(SneakSounds) float LanternCreakSoundVolume;

// MaxG: Lantern.
var Light LanternLight;
var MGFilchFlare LanternFlare;

event PostBeginPlay()
{
	LanternLight = Spawn(Class'FilchLanternLight', Self, , Location);

	LanternFlare = Spawn(Class'MGFilchFlare', Self, , Location);

	// Metallicafan212:	Attach to bone tells the actor it's run on to attach the attachment to that bone
	//					Not telling an attachment to attach to the object
	//					Additionally, Spawning with self already sets the owner
	//					And attachtobone sets the owner as well, so the sets are not needed
	AttachToBone(LanternFlare, 'lantern');
	AttachToBone(LanternLight, 'lantern');

	// MaxG: I don't know why but if I don't do this it falls through the floor. I blame Andrew.
	LanternFlare.SetPhysics(PHYS_Flying);

	LanternFlare.RelativeLocation.Z = 8;
	LanternLight.RelativeLocation.Z = 8;

	Super.PostBeginPlay();
}

event Destroyed()
{
	LanternLight.Destroy();
	LanternFlare.Destroy();

	Super.Destroyed();
}


// MaxG: Go to this state after trying to find the player but failing.
state LookAround
{
	event BeginState()
	{
		Super.BeginState();
	}

	event EndState()
	{
		Super.EndState();
	}

	begin:	
		LoopAnim(idleAnim);

		// MaxG: Turn.
		TurnToward(HRY);

		PlayAnim('trans2holdlanternup');

		Sleep(0.05);

		PlaySound(LanternCreakSound, SLOT_None, LanternCreakSoundVolume);

		FinishAnim();

		handleDialog(DT_Alarmed, "");

		PlayAnim('transfromholdlanternup');
		FinishAnim();

		// MaxG: Look.
		PlayAnim(lookAnim);
		
		Sleep(lookAroundTime);
		
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
		LoopAnim('breathe');

		Sleep(SleepTimeBeforeCaughtDialog);

		PlayAnim('trans2talk');
		FinishAnim();
		LoopAnim('talk');
		
		// MaxG: Play the dialogue.
		handleDialog(DT_Caught, caughtDialogINT);

		// MaxG: Switch anims half way.		
		Sleep(catchSequenceDuration / 2);

		PlayAnim('transfromtalk');
		FinishAnim();

		PlayAnim('trans2curse');
		FinishAnim();

		LoopAnim('curse');

		// MaxG: Finish dialogue.
		Sleep(catchSequenceDuration / 2);
		
		PlayAnim('transfromcurse');
		FinishAnim();

		LoopAnim('breathe');

		// MaxG: An extra sleep to reduce awkwardness.
		Sleep(sleepTimeBeforeDeath);
		
		ConsoleCommand("LoadGame 0");
		Sleep(1.0);
		
		HRY.Destroy();
} 



defaultproperties
{
	alarmedDialog(0)=Sound'MGSounds.Filch.FIL_catchYou'
	alarmedDialog(1)=Sound'MGSounds.Filch.FIL_comeOut'
	alarmedDialog(2)=Sound'MGSounds.Filch.FIL_hearSomeone'
	alarmedDialog(3)=Sound'MGSounds.Filch.FIL_Intruder'
	alarmedDialog(4)=Sound'MGSounds.Filch.FIL_whereAreYou'
	alarmedDialog(5)=Sound'MGSounds.Filch.FIL_whereIsHe'
	alarmedDialog(6)=Sound'MGSounds.Filch.FIL_whosThere'
	alarmedDialog(7)=Sound'MGSounds.Filch.FIL_youPeeves'
	alarmedGrumblings(0)=Sound'MGSounds.Filch.FIL_cackle0'
	alarmedGrumblings(1)=Sound'MGSounds.Filch.FIL_cackle1'
	alarmedGrumblings(2)=Sound'MGSounds.Filch.FIL_grumble0'
	alarmedGrumblings(3)=Sound'MGSounds.Filch.FIL_wha'
	AnimSequence="breathe"
	autoCatchDist=72
	caughtAnim=curse
	caughtDialog(0)=Sound'MGSounds.Filch.FIL_inTrouble'
	caughtDialog(1)=Sound'MGSounds.Filch.FIL_noOneGetsPast'
	caughtDialog(2)=Sound'MGSounds.Filch.FIL_doAsTold'
	caughtDialogINT="MGDialog"
	CollisionHeight=56
	CollisionRadius=22
	DrawScale=1.06
	FootstepSounds(0)=MultiSound'MGSounds.FootSteps.rug_filch'
	FootstepSounds(1)=MultiSound'MGSounds.FootSteps.wood_filch'
	FootstepSounds(2)=MultiSound'MGSounds.FootSteps.stone_filch'
	FootStepVolume=2.0
	GroundRunSpeed=180
	GroundWalkSpeed=60
	idleAnim=Breathe
	LanternCreakSound=Sound'MGSounds.Filch.lantern_creak'
	LanternCreakSoundVolume=0.65
	lookAnim=Look
	lookAroundTime=3.0
	Mesh=SkeletalMesh'MGModels.skfilchlanternMesh'
	SleepTimeBeforeCaughtDialog=0.85
	sleepTimeBeforeDeath=0.5
}