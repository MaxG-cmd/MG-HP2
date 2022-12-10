class MGSpellReparo extends baseSpell;


function PostBeginPlay()
{
	Super.PostBeginPlay();
		
	// Init our seeking current Dir var
	CurrentDir = normal(vector(Rotation) + vec(0,0,0.3f) );
}

function OnSpellShutdown()
{
}


function bool OnSpellHitHPawn( Actor aHit, vector vHitLocation)
{
	// All HPawns have a HandleSpell function
	return HPawn(aHit).HandleSpellAlohomora( self, vHitLocation );
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
	}

	event Tick( float fTimeDelta )
	{
		super.Tick( fTimeDelta );
		
		// update our seeking direction
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
	Speed=300.0f
	SeekSpeed=6.0f
	fxFlyParticleEffectClass=class'MGreparo_fly'

	// --- Base Spell
	spellType=SPELL_Reparo
	spellIcon=None
	
	// --- ParticleFX
    DrawType=DT_None
}