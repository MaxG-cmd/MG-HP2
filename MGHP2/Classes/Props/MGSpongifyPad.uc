class MGSpongifyPad extends SpongifyPad;

//======CONFIGURABLE=========
var() bool bForceVelocity;
var() float boingVolume;
var() Sound boingSound;
var() Sound PadTurnOnSound;
var() Vector PadSheetOffset;

//======== VARS=============
var ParticleFX padParticles;

var MGTimer EnabledTimer;
//============================
//****************************
//============================

event PreBeginPlay()
{
	Super.PreBeginPlay();
	padParticles = Spawn(fxSparklesClass, self,,, Rotator(Vec(0,0,1)));
	fxSparkles = None;
	padParticles.bEmit = False;
	fxSparklesClass = None;

	EnabledTimer = Spawn(class'MGTimer');
}

event PostBeginPlay()
{
	Super.PostBeginPlay();

	CreateFX();
}

function CreateFX()
{
	local Vector hwd; 
	local Vector hwdRotated; 

	fxSheet = Spawn(Class'SpongifySheet',self,,Location);
	fxSheet.DesiredRotation = rot(0,0,0);
	fxSheet.DesiredRotation.Yaw += 16383;
	fxSheet.SetRotation(fxSheet.DesiredRotation);

	if ( CollideType == CT_AlignedCylinder || CollideType == CT_OrientedCylinder || CollisionWidth == 0 )
	{
		hwd = Vec(CollisionRadius,CollisionRadius,CollisionHeight);
	}
	else
	{
		hwd = Vec(CollisionRadius,CollisionWidth,CollisionHeight);
	}
	
	hwdRotated = hwd >> Rotation;
	fxSparkles = Spawn(fxSparklesClass,self,,Location);
	fxSparkles.SourceDepth.Base = hwdRotated.X * 2.0;
	fxSparkles.SourceWidth.Base = hwdRotated.Y * 2.0;
	fxSparkles.SourceHeight.Base = hwdRotated.Z * 1.0;

	fxSheet.bHidden = true;
	fxSparkles.bEmit = false;
}

function TurnOnSpecialFX()
{
	fxSheet.bHidden = false;
	fxSparkles.bEmit = true;

	fxSheet.DrawScale = DrawScale;
}

function TurnOffSpecialFX()
{
	if (fxSparkles != None)
	{
		fxSparkles.bEmit = false;
	}
	if (fxSheet != None)
	{
		fxSheet.bHidden = true;
	}
}

event Tick(float DeltaTime)
{
	fxSparkles = None;
}



function UpdateSpecialFX(float DeltaTime)
{
	local Vector tempVec;

	//Super.UpdateSpecialFX(DeltaTime);

	// MaxG: Just paste the original. Smh. This sucks.
	fxSparkles.SetRotation(Rotation);
	fxSparkles.SetLocation(Location);
	fxSheet.DesiredRotation = Rotation;

	fxSheet.DesiredRotation.Yaw += 16384;
	fxSheet.SetRotation(fxSheet.DesiredRotation);
	//fxSheet.SetLocation(Location);

	if (bBouncing)
	{
		if ( fxSheet.DrawScale > DrawScale )
		{
			fxSheet.DrawScale -= 4 * DeltaTime;
		}
		else
		{
			fxSheet.DrawScale = DrawScale;
			bBouncing = False;
		}
	}


	tempVec = Location + PadSheetOffset;

	// MaxG: Make it stop floating.
	fxSheet.SetLocation(tempVec);

	PadParticles.SetLocation(Location);
}

function OnBounce(actor other)
{
	local vector tempVelocity;

	// If the object that hit us is falling and has a negitave z velocity we should bounce it!
	if (other.IsA('harry'))
	{		
		if(Target != None)
		{
			tempVelocity = ComputeTrajectoryByTime(location, Target.location, fTimeToHitTarget);
			
			if (bForceVelocity)
			{
				other.Velocity = tempVelocity;
			}
			else
			{
				other.Velocity.z =  tempVelocity.z;
				other.Velocity.x += tempVelocity.x;
				other.Velocity.y += tempVelocity.y;
			}
		}
		else
		{
			if (bForceVelocity)
			{
				other.Velocity = PadDir * PadSpeed;
			}
			else
			{
				other.Velocity.z = PadDir.z * PadSpeed;
				other.Velocity.x += PadDir.x * PadSpeed;
				other.Velocity.y += PadDir.y * PadSpeed;
			}
		}

		//fxSheet.DrawScale = fxSheet.default.DrawScale * 2;
		fxSheet.DrawScale *= 2;
		bBouncing = true;

		// Play spongify soundFX
		PlaySound(boingSound, SLOT_None, boingVolume, true);
	}
}


state stateEnabled
{
	event BeginState()
	{
		if (!EnabledTimer.bTimerSet)
		{
			EnabledTimer.StartTimer();
		}
	}

	event EndState()
	{
		EnabledTimer.StopTimer();
	}

	event Tick(float DeltaTime)
	{
		UpdateSpecialFX(DeltaTime);

		if (EnabledTimer.SecondsElapsed >= fTimeEnabled)
		{
			GoToState('stateGoingToDisabled');
		}

		//CM("fTimeEnabled = " $ fTimeEnabled);
		//CM("EnabledTimer.SecondsElapsed = " $ EnabledTimer.SecondsElapsed);
	}
  
}


state stateGoingToEnabled
{
	event BeginState()
	{
		local vector  vNewPos;
		local rotator rNewRot;

		PadParticles.bEmit = True;

		eVulnerableToSpell = SPELL_None;

		TurnOnSpecialFX();

		rNewRot = rotator(PadDir);

		DesiredRotation.yaw = rNewRot.yaw;

		rLast = DesiredRotation;

		PlaySound(PadTurnOnSound, SLOT_None, , true);

		//SetLocation( vStartPosition + vec(0,0, fRaiseAmount) );
		SetLocation( Location + vec(0,0, fRaiseAmount) );
		fxSheet.SetLocation( location );
	}

	event Tick(float fTimeDelta)
	{
		local float fNewZ;

		UpdateSpecialFX(fTimeDelta);

		//if (rLast == rotation && (fxSheet.location.z - PadSheetOffset.z) == vStartPosition.z + fRaiseAmount)
		if (rLast == rotation)
		{
			GoToState('stateEnabled');
		}
	
		rLast = rotation;
	}


}

state stateGoingToDisabled
{
	event BeginState()
	{
		DesiredRotation = rot(0,0,0);

		//SetLocation( vStartPosition );

		SetLocation(Location - vec(0,0, fRaiseAmount));

		fxSheet.SetLocation(location - PadSheetOffSet);
	}
	event Tick(float fTimeDelta)
	{
		UpdateSpecialFX(fTimeDelta);

		// MaxG: This is bad and hacky. Too bad!
		fxSheet.SetLocation(location - PadSheetOffSet);

		if( rLast == rotation )
			GoToState('stateDisabled');
		rLast = rotation;
	}

	event EndState()
	{
		padParticles.bEmit=False;
	}
}


defaultProperties
{
	fxSparklesClass=Class'MGhp2.MGParticleSpongifySparkles'
	boingSound=Sound'HPSounds.Magic_sfx.SPN_bounce_on'
	PadTurnOnSound=Sound'HPSounds.Magic_sfx.SPN_activate'
	boingVolume=0.75
	bForceVelocity=True
	PadSheetOffset=(X=0,Y=0,Z=-12)
	fTimeEnabled=15.0
}