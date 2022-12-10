class MGSpellPixieBall extends SpellDuelMimblewimble;

event PostBeginPlay()
{
	super.PostBeginPlay();
	InitSpell(none, playerHarry);
}

function OnSpellInit()
{
	gotoState('StateFlying');
}

function bool OnSpellHitHPawn( Actor aHit, vector vHitLocation)
{
	if (aHit.isA('MGPixie') && owner != aHit)
	{
		return MGPixie(aHit).HandleSpellPixie(self, vHitLocation);
	}
	else
	{
		return false;
	}
}

auto state StateFlying
{
	event BeginState()
	{
		// set our velocity in the direction we are facing * speed
		Velocity	 = vector(Rotation) * Speed;

	}

	event Tick( float fTimeDelta )
	{
		super.Tick( fTimeDelta );
		
		UpdateRotationWithSeeking( fTimeDelta );

		// Update our fly particles
		if( fxFlyParticleEffect != None )
		{
			fxFlyParticleEffect.SetLocation( location );
		}
	}
	
	
	function bool OnSpellHitHarry(Actor aHit, vector HitLocation)
	{
		local MGHarry MGH;
		
		local bool bHandled;
		
		MGH = MGHarry(aHit);
					
		
		if ((MGH != None) && (owner != aHit))
		{
			
			bHandled = MGH.HandleSpellPixie(self, HitLocation);
					
			return bHandled;
		}
		else
		{
			return false;
		}
	}

	begin:
}

defaultproperties
{
	Speed=360.0f
	SeekSpeed=1.0f
	SpellLifeTime=4

	SpellSeekSpeedReflectMultiplier=4
	SpellSpeedReflectMultiplier=1.25

	eVulnerableToSpell=SPELL_DuelExpelliarmus
	bProjTarget=True
	CollisionRadius=16.0f
	CollisionHeight=16.0f

	LightRadius=6
	LightRadiusInner=128
	LightSaturation=32
	LightBrightness=76
	LightHue=154

	fxFlyParticleEffectClass=Class'MGHP2.MGParticlePixieBall'
	fxHitParticleEffectClass=Class'HPParticle.duelMimblewimble_hit'
	
	SpellType=SPELL_Ecto
	spellIcon=None
	
	SpellIncantation="spells3"
	QuietSpellIncantation="spells4"
	
	DrawType=DT_None
	
	// MaxG: Particle startup bug.
	//DrawType=DT_Mesh
	//Mesh=SkeletalMesh'MGModels.WizardCracker'
	//DrawScale=0.8
	//Style=STY_Normal
}