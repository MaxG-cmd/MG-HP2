class MGspellEctoLarge extends spellEcto;

function PostBeginPlay()
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
	if (aHit.isA('MGPeeves') && owner != aHit)
		return MGPeeves(aHit).HandleSpellEctoLarge(self, vHitLocation);
	else
		return false;
}



state StateFlying
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
			
			bHandled = MGH.HandleSpellEctoLarge(self, HitLocation);
			
			if (bHandled)
			{
				fxHitHarryParticleEffect = spawn(fxHitHarryParticleEffectClass);
			}
			
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
	// --- Spell Ecto
	Speed=700.0f
	SeekSpeed=5.5f
	SpellLifeTime=5.0

	SpellSeekSpeedReflectMultiplier=4
	SpellSpeedReflectMultiplier=1.25

	fxFlyParticleEffectClass=class'MGhp2.MGParticlePurpleEcto'
	fxHitHarryParticleEffectClass=class'MGhp2.MGParticlePurpleEctoEXPLODE'
	
	// --- Base Spell
	spellType=SPELL_Ecto
	spellIcon=None
	
	SpellIncantation="spells3"
	QuietSpellIncantation="spells4"
	
	fxHitParticleEffectClass=class'MGhp2.MGParticlePurpleEctoEXPLODE'
	fxReactParticleEffectClass=class'MGhp2.MGParticlePurpleEctoEXPLODE'

	// --- ParticleFX
    DrawType=DT_None
	
	eVulnerableToSpell=SPELL_DuelExpelliarmus
	bProjTarget=True
	CollisionRadius=26.0f
	CollisionHeight=26.0f
}