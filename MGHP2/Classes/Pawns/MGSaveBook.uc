class MGSaveBook extends HPawn;

var() Sound SndSaveSound;
var() float SaveSoundVolume;
var() bool bStopMovementOnSave;
var() int MinSaveHealth;
var() float BobAmount;
var() float BobRate;
var() float DelayBeforeSaveSound;
var() float ReEnableRate;
var() bool bSaveOnceOnly;
var() Name RespawnLocationTargetTag;

var Actor RespawnLocationTarget;
var float OpacityAlpha;
var Vector StartLocation;

event BeginPlay()
{
	Super.BeginPlay();

	StartLocation = Location;

    if (RespawnLocationTargetTag != 'None')
    {
        ForEach AllActors(Class'Actor', RespawnLocationTarget, RespawnLocationTargetTag)
        {
            break;
        }
    }
}

// MaxG: Disable and re-enable.
event Trigger(Actor Other, Pawn EventInstigator)
{
    if (IsInState('SavingGame'))
    {
        CM("[" $ Name $ "]::Trigger ==> Triggered in SavingGame. Event ignored.");
        return;
    }

    if (IsInState('AwaitingSave'))
    {
        GoToState('Disabled');
    }
    else
    {
        GoToState('AwaitingSave');
    }
}

auto state() AwaitingSave
{
	event Touch(Actor Other)
	{
		Super.Touch(Other);

		// MaxG: Start saving.
		if (Other.IsA('Harry') && Other.IsInState('PlayerWalking'))
		{
			// MaxG: Do not save if dead.
			if (PlayerHarry.GetHealthCount() > 0)
			{
				GoToState('SavingGame');
			}
		}
	}

	// MaxG: Bob up and down.
	event Tick(float DeltaTime)
	{
		SetLocation(StartLocation + ( Vec( (BobAmount * 0.20) * Cos((Level.TimeSeconds * 1) * BobRate), 0.0, BobAmount * Sin((Level.TimeSeconds * 2) * BobRate)) >> Rotation));
	}
}

state SavingGame
{
	ignores Touch;

	event BeginState()
	{
		if (bStopMovementOnSave)
		{
			PlayerHarry.Velocity = Vec(0, 0, 0);
			PlayerHarry.Acceleration = Vec(0, 0, 0);

            if (RespawnLocationTarget != None)
            {
			    PlayerHarry.SetLocation(RespawnLocationTarget.Location);
            }

			PlayerHarry.SetPhysics(PHYS_Walking);
		}

		if (PlayerHarry.GetHealthCount() < MinSaveHealth)
		{
			PlayerHarry.SetHealth(MinSaveHealth);
		}

        OpacityAlpha = 0;
        Opacity = 0;
	}

    event Tick(float DeltaTime)
    {
        if (bSaveOnceOnly)
        {
            return;
        }

        //CM("OpacityAlpha ==> " $ OpacityAlpha);

        OpacityAlpha += ReEnableRate * DeltaTime;

        // MaxG: Clamp opacity to 0 and 1.
        OpacityAlpha = fClamp(OpacityAlpha, 0, 1);

        // MaxG: Interpolate to full opacity.
        Opacity = Lerp(OpacityAlpha, 0, 1);

        if (Opacity >= 0.999)
        {
            Opacity = 1;

            GoToState('AwaitingSave');
        }
    }

	begin:
        // MaxG: Save.
        if (bStopMovementOnSave)
        {
            PlayerHarry.SaveGame();
        }
        else
        {
            PlayerHarry.SmoothSave("0");
        }

        // MaxG: Sleep and then play save sound.
        Sleep(DelayBeforeSaveSound);

        PlaySound(SndSaveSound, SLOT_None, [Volume]SaveSoundVolume, [Radius]32768, [Pitch]1.0, , false);

        if (bSaveOnceOnly)
        {
            Sleep(0.5);
            Destroy();
        }
}

state() Disabled
{
    event BeginState()
    {
        bHidden = true;
        SetCollision(false, false, false);
        SoundVolMult = 0;
    }

    event EndState()
    {
        bHidden = false;
        SetCollision(true, false, false);
        SoundVolMult = Default.SoundVolMult;
    }
}

defaultproperties
{
	SndSaveSound=Sound'MGSounds.Main.saveBookSound'
	bStopMovementOnSave=true
	MinSaveHealth=75
	BobAmount=2
    BobRate=1.8
    DelayBeforeSaveSound=0.15
    bSaveOnceOnly=False
    ReEnableRate=0.03125
    SaveSoundVolume=1.5

    Mesh=SkeletalMesh'HPModels.SavePointFloatBookMesh'
    AmbientSound=Sound'HPSounds.menu_sfx.Save_book_loop'
    AmbientGlow=48
    SoundRadius=16
    SoundVolume=44
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
}