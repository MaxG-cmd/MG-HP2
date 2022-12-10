class MGSpellBaseball extends BaseSpell;

var bool bReflected;

var float InitialLifeTime;

var() Sound BounceSound;

var() Vector ReflectVelocity;

event PostBeginPlay()
{
	Super.PostBeginPlay();
	InitSpell(None, None);
}

function Reflect(Actor aNewOwner, float fNewCharge, float fNewSpeed)
{
	local Vector V;

    //Super.Reflect(aNewOwner, fNewCharge, fNewSpeed);

	bReflected = true;

	if (ReflectVelocity != Vec(0, 0, 0))
	{
		Velocity = ReflectVelocity;
		eVulnerableToSpell = SPELL_None;
		return;
	}

	// MaxG: Go towards the camera.
	V = Normal(PlayerHarry.Cam.vForward);

	//CM("Pre V: " $ V);

	V *= Vec(fNewSpeed, fNewSpeed, fNewSpeed);

	//CM("Post V: " $ V);

	Velocity = V;

    // MaxG: Reverse.
    //Velocity *= Vec(-1, -1, -1);
}

event HitWall(Vector HitNormal, Actor Wall)
{
    Velocity = MirrorVectorByNormal(Velocity, HitNormal);

	PlaySound(BounceSound, SLOT_None, 0.5, , 4096);
	//CM("Mirrored.");
}

event Destroyed()
{
	local Actor A;

	Super.Destroyed();

	if (Event != 'None')
	{
		forEach AllActors(Class'Actor', A, Event)
		{
			A.Trigger(Self, PlayerHarry);
		}
	}
}

// MaxG: For spawning.
auto state WaitingToStart
{
	ignores Tick;
}

state StateFlying
{
	event BeginState()
	{
		SpellLifeTime = InitialLifeTime;
	}

	event Tick(float DeltaTime)
	{
		//CM("SpellLifeTime = " $ SpellLifeTime);
		//CM("InitialLifeTime = " $ InitialLifeTime);

		// MaxG: Only destroy if reflected.
		//CM("bReflected " $ bReflected);
		if (bReflected)
		{
			SpellLifeTime -= DeltaTime;

			//CM("SpellLifeTime ==> " $ SpellLifeTime);

			if (SpellLifeTime <= 0)
			{
				OnSpellShutdown();
				Destroy();
			}
		}

		if (fxFlyParticleEffect != None)
		{
			fxFlyParticleEffect.SetLocation(Location);
		}
		
		//CM("Velocity: " $ Velocity);

		// MaxG: Bad TODO remove :)
		Velocity += DeltaTime * (-Region.Zone.ZoneGravity / 2);
	}
}

defaultproperties
{
	// MaxG: Bad TODO remove :)
	bBounce=True
	Physics=PHYS_Falling

	bHidden=True
	DrawType=DT_Sprite
	DrawScale=0.5
	Texture=Texture'MGTech.Icons.BaseballIcon'
	Style=STY_Normal

	BounceSound=Sound'HPSounds.Magic_sfx.Dueling_switch2RIC'

	SoundRadius=4
	SoundPitch=96
    SoundVolume=255
	AmbientSound=Sound'HPSounds.General.torch01'
	SoundVolMult=8

	Speed=360.0f
	SeekSpeed=0
	SpellLifeTime=16
	LifeSpan=0
	bReflected=False

	SpellSeekSpeedReflectMultiplier=0
	SpellSpeedReflectMultiplier=1.0

	LightRadius=5
	LightRadiusInner=48
	LightSaturation=65
	LightBrightness=215
	LightHue=111


	eVulnerableToSpell=SPELL_DuelExpelliarmus
	bProjTarget=True
	CollisionRadius=8.0f
	CollisionHeight=8.0f

	fxFlyParticleEffectClass=Class'MGHP2.MGParticleBaseball'
    fxHitParticleEffectClass=Class'HPParticle.duelMimblewimble_hit'
	
	SpellType=SPELL_Vermillious
	SpellIcon=None
	
	SpellIncantation="spells3"
	QuietSpellIncantation="spells4"
}