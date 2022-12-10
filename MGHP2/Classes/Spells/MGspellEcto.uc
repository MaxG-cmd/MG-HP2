class MGspellEcto extends spellEcto;

function PostBeginPlay()
{
	super.PostBeginPlay();
	InitSpell(none, playerHarry);
}

function OnSpellInit()
{
	gotoState('StateFlying');
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
	
	function bool OnSpellHitHarry( Actor aHit, vector HitLocation )
	{
		local vector moveVel;
		
		moveVel = (velocity * vec(0.15,0.15,0.1));
		
		playerHarry.doJump(0);
		playerHarry.velocity += moveVel;
		playerHarry.AnimFalling = 'spongify';
		
		aHit.TakeDamage(6, instigator, vect(0,0,0), moveVel, '' );
		fxHitHarryParticleEffect = spawn( fxHitHarryParticleEffectClass );
		return true; // we have a valid hit
	}

	begin:
}

defaultproperties
{
	// --- Spell Ecto
	Speed=500.0f
	SeekSpeed=3.0f
	SpellLifeTime=2.70

	fxFlyParticleEffectClass=class'MGhp2.MGEcto_fly'
	fxHitHarryParticleEffectClass=class'Skurge_hitHarry'
	
	// --- Base Spell
	spellType=SPELL_Ecto
	spellIcon=None
	
	SpellIncantation="spells3"
	QuietSpellIncantation="spells4"
	
	// --- ParticleFX
    DrawType=DT_None
}