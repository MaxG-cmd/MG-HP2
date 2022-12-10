class MGSpellCarpe extends baseSpell;


function PostBeginPlay()
{
	Super.PostBeginPlay();
}

function OnSpellShutdown()
{
}



function bool OnSpellHitHPawn( Actor aHit, vector vHitLocation)
{
	return HPawn(aHit).HandleSpellSpongify( self, vHitLocation );
}





// --------------------------------------------------------------------------------------------
// *** States

state auto StateIdle
{
	begin:
	GotoState('StateFlying');
}

state StateFlying
{
	event BeginState()
	{
		// set our velocity in the direction we are facing * speed
		Velocity	 = vector(Rotation) * Speed;
		Acceleration = Velocity;
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

	begin:
}

// --------------------------------------------------------------------------------------------
// *** DefaultProperties

defaultproperties
{
	// --- Spell Spongify
	Speed=999999
	SeekSpeed=200.0
	fxFlyParticleEffectClass=class'MGhp2.MGParticlePurpleEcto'
	
	// --- Base Spell
	spellType=SPELL_LocomotorWibbly
	spellIcon=None
	
	SpellIncantation=""
	QuietSpellIncantation=""
	
	fxHitParticleEffectClass=class'spongify_hit'

	
	// --- Projectile
	
	// --- ParticleFX
    DrawType=DT_None
}
