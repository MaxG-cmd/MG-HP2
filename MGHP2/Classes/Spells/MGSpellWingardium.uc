class MGSpellWingardium extends baseSpell;


function bool OnSpellHitHPawn( Actor aHit, vector vHitLocation)
{
	return HPawn(aHit).HandleSpellWingardium();
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
	Speed=400.0f
	SeekSpeed=3.0f
	fxFlyParticleEffectClass=Class'MGParticleWingSpell'

	// --- Base Spell
	spellType=SPELL_WingardiumLeviosa
	spellIcon=None
	
	// --- ParticleFX
    DrawType=DT_None

    LightRadius=6
	LightRadiusInner=8
	LightSaturation=230
	LightBrightness=48
	LightHue=153
}