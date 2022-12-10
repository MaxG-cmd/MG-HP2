class MGPeeves extends Peeves;

/*
Rules of an MGPeeves fight:
	There will be two phases to this fight.
	
	The first phase will consist of Peeves flying around the battle arena with his
	shield up. He will throw the large targeting spell at the player. The player
	will have the ability	to reflect this spell back at Peeves by aiming and
	casting at it. This will disable Peeves's shield, and then the player will be able
	to damage him one time with Skurge. This will proceed until Peeves has 50% health.
	
	Phase two will be a slightly more traditional fight. Peeves will fly around the battle arena,
	casting both his purple targeting spell, and also his rapid-fire green hex. The player
	will be able to choose between casting at Peeves or dodging by flinging away with
	Carpe Retractum. The player can still reflect the purple spell, but can now also freely cast at him.
	This part of the fight should be faster, but also slightly harder with the extra green hex.
*/


#define PLAY_TAUNT PlaySound(TauntDialog[Rand(TauntDialog.Length)], SLOT_Talk, 1.0, , 512)

// how long he may remain invulnerable
var() float fInvulnDuration;

// how quickly Peeves will fly between points
var() float fMoveSpeed;

var() float fMoveSpeedPhase2;

// 4/(pi/2)
const fExplosionVal = 0.4052847325801849365234375;

const fHurtOpacity = 0.5;
var const float fOpacityRate;
var float fTimeLeft;
var float fOpacityAlpha;
var float fTimeElapsed;

var() const float fExplosionStrength;
var() const float fExplosionFalloff;

var() Array<Sound> TauntDialog;

var bool bVulnerable;

var MGParticleGravityWave		gravityWave;
var MGParticlePeevesShield		shieldParticle;
var MGParticlePeevesShieldEX	shieldEX;
var Actor sphere;
var vector vShieldOffset;

var int iCurrentFightPhase;


event BeginPlay()
{	
	vShieldOffset = vec([X]0, [Y]0, [Z]-64);
	
	CreateShield();
	DisableShield();
}

function float CalculateExplosion(actor a)
{
	local float distance;
	local float magnitude;

	distance = VSize(a.location - location);
	magnitude = ((fExplosionStrength * fExplosionVal) * (aTan(fExplosionFalloff * fExplosionStrength / distance)) ** 2);
	return magnitude;
}

// Send Harry into the air after hitting Peeves if Harry is too close.
// This acts as a retaliation by Peeves for getting hit.
function SendGravityWave()
{
	local MGHarry h;
	local float magnitude;
	
	forEach radiusActors(class'MGHarry', h, 1024)
	{
		h.setPhysics(PHYS_Falling);
		magnitude = calculateExplosion(h);
		h.velocity += magnitude * normal((h.location - location) * vec(1,1,0));
		h.velocity.z += magnitude / 1.10; // <-- Instead of an explosion, always send him in the air.
		//h.PlayAnim('spongify'); // <-- causes temporary casting lock due to animation overlap
		h.AnimFalling = 'spongify';
	}
	
	gravityWave = Spawn(class'MGParticleGravityWave', , , location + vShieldOffset);
}


// this function describes whether or not
// peeves can be hit by spells.
function bool IsVulnerable()
{
	return bVulnerable;
}

// when Harry blasts back this spell at him, take damage
function bool HandleSpellEctoLarge(optional baseSpell spell, optional Vector vHitLocation)
{
	
	// If we are in a Cutscene, simply end by returning true.
	// TODO: Test if this is actually the intended behavior.
	// 		 I have a feeling that we may want to return false.
	if (IsInState('CutIdle') || IsInState('DoingCutAnimate'))
	{
		return true;
	}
	
	// Update the fight phase since we were just hit.
	SetFightPhase();
	
	if (iCurrentFightPhase == 1)
	{
		// Since we are in phase 1...
		
		// The shield should break from the send-back
		DisableShield();
		
		// We're going to become vulnerable because we have no shield
		SetVulnerable();
		
		// The shield is going to visually explode
		shieldEX = Spawn(class'MGParticlePeevesShieldEX', sphere, , location + vShieldOffset);
		
		//CM("HandleSpellEctoLarge :: PHASE 1 :: MOVING TO POINT");
		//CM("HandleSpellEctoLarge :: VULNERABLE --> " $ IsVulnerable());
		
		// We're going to continue to move around the arena.
		// This does cause Peeves to jarringly stop his 
		// current movement, however.

		GotoNextPoint();
		GotoState('MoveToPoint');
		return true;
	}
	else
	{
		return Super.HandleSpellSkurge(spell,vHitLocation);
	}
	
	return true;
}

// Harry can cast skurge at Peeves in order to hurt him and win the fight
function bool HandleSpellSkurge(optional baseSpell spell, optional Vector vHitLocation)
{
	// Original does GotoState('stateHitBySpell') --> return true
	
	if (IsInState('CutIdle') || IsInState('DoingCutAnimate'))
	{
		return true;
	}
	
	SetFightPhase();
	
	if (IsVulnerable())
	{
		return Super.HandleSpellSkurge(spell,vHitLocation);
	}
	
	return true;
}


function Timer()
{
	SetVulnerable();
}

function SetVulnerable()
{
	//CM("SETTING " $ name $ " TO > VULNERABLE <");
	bVulnerable = true;
	
	// we must be able to target Peeves
	eVulnerableToSpell = SPELL_Skurge;
}

function SetInvulnerable()
{
	//CM("SETTING " $ name $ " TO > INVULNERABLE <");
	bVulnerable = false;
	
	// make it so he cannot be targeted!
	eVulnerableToSpell = SPELL_None;
}

function CreateShield()
{
	sphere = Spawn(class'MGPeevesShield', self, , location + vShieldOffset);
	shieldParticle = Spawn(class'MGParticlePeevesShield', sphere, , location + vShieldOffset);
}

function UpdateShield()
{
	sphere.SetLocation(location + vShieldOffset);
	shieldParticle.SetLocation(location + vShieldOffset);
	shieldEX.SetLocation(location + vShieldOffset);
	gravityWave.SetLocation(location + vShieldOffset);
}

function DisableShield()
{
	if (shieldParticle.bEmit)
	{
		PlaySound(Sound'MGSounds.Main.peevesShieldBreak', SLOT_None, [Volume]1.0, [Radius]4096, [Pitch]1.0, , false);		
	}
	
	shieldParticle.bEmit = false;
	//shieldParticle.bHidden = true;
}

function DestroyShield()
{
	shieldParticle.Destroy();
	sphere.Destroy();
}

function EnableShield()
{
	//CM("Enabling shield...");
	//CM("Turning on particles...");
	//CM("Sending gravity wave...");
	shieldParticle.bEmit = true;
	SendGravityWave();
	//shieldParticle.bHidden = false;
}

function bool IsShieldDisabled()
{
	return !shieldParticle.bEmit;
}

function DestroyAllSpells()
{
	local BaseSpell spell;
	
	forEach allActors(class'BaseSpell', spell)
	{
		spell.destroy();
	}
}

function SetFightPhase()
{
	if (health >= 50)
	{
		iCurrentFightPhase = 1;
	}
	else if (health < 50)
	{
		iCurrentFightPhase = 2;
		
		if (!IsShieldDisabled())
		{
			DisableShield();
			SetVulnerable();
		}
		
		fMoveSpeed = fMoveSpeedPhase2;
		// DO THIS IN CUT RELEASE
		/* if (IsVulnerable())
		{
			SetInvulnerable();
			SetTimer(fInvulnDuration, false);
		} */
		
		// Trigger a cutscene when entering phase 2.
		TriggerEvent(Event, None, None);
	}
	else
	{
		//cm("CANNOT RESOLVE PHASE NUMBER :: iCurrentFightPhase --> " $ iCurrentFightPhase);
	}
}

function bool ResolveFightPhase(bool bAutoMoveToPoint)
{
	if (iCurrentFightPhase == 1)
	{
		//cm("PHASE: " $ iCurrentFightPhase $ " :: GOING TO shieldAndShoot...");
		GotoState('shieldAndShoot');
		return true;
	}
	else if (iCurrentFightPhase == 2)
	{
		//cm("PHASE: " $ iCurrentFightPhase $ " :: WAITING...");
		
		if (bAutoMoveToPoint)
		{
			//cm("AUTOMATICALLY MOVING TO POINT ON PHASE RESOLUTION");
			GotoNextPoint();
			GotoState('MoveToPoint');
			return true;
		}
		else
		{
			// Else, just continue. The rest of the 
			// state flow logic should reside
			// inside of the state.
			return false;
		}
	}
	else
	{
		//cm("CANNOT RESOLVE FIGHT PHASE :: iCurrentFightPhase --> " $ iCurrentFightPhase);
		return false;
	}
}


function PlayerCutRelease()
{
	if (bGameOver == false)
	{
		if (iCurrentFightPhase == 1)
		{
			gotoState('stateWaitForTrigger');
		}
		else
		{
			ResolveFightPhase(true);
			
			if (IsVulnerable())
			{
				SetInvulnerable();
				SetTimer(fInvulnDuration, false);
			}	
			
		}
	}
	else
	{
		gotoState('stateDestroyPeeves');
	}

}

event Trigger(actor Other, pawn EventInstigator)
{
	if (type != Annoyance)
	{
		TriggerEvent( 'BossPeevesTrigger', self, None );
		ResolveFightPhase(true);
	}
}

event Tick(float deltaTime)
{
	// We want to know if this guy still exists.
	if (shieldParticle != None && !shieldParticle.bDeleteMe)
	{
		UpdateShield();
	}
	
	// I am going to try moving this to the HandleSpell functions.
	//SetFightPhase();
	
	if (IsVulnerable())
	{
		fOpacityAlpha += deltaTime * fOpacityRate;
	}
	else
	{
		fOpacityAlpha -= deltaTime * fOpacityRate;
	}
	
	// clamp our opacity between zero and one
	fOpacityAlpha = fClamp(fOpacityAlpha, 0, 1);
	
	Opacity = lerp(fOpacityAlpha, fHurtOpacity, default.opacity);
	
	super.Tick(deltaTime);
}

state MoveToPoint
{
		event Tick (float DeltaTime)
		{
			// this is the trajectory of Peeves to the next point
			local vector vMove;
			
			// distance to get to the next point (normalized)
			local float fDist, fmoveFactor;
			
			Global.Tick(DeltaTime);
			fTimeElapsed += DeltaTime;
			
			//Log("vDir: " $ vDir);
			//Log("The current point is " $ CurrentPoint $ " at " $ CurrentPoint.Location);
			fDist = fMoveSpeed * fTimeElapsed / VSize(vDir);
			if (fTimeElapsed < (VSize(vDir) / fMoveSpeed))
			{
					// instead, we want to interpolate smoothly between points for a more natural motion.
					fMoveFactor = 6.0 * (fDist - (fDist * fDist)) * fMoveSpeed;
					Log("Move Factor: " $ fMoveFactor);
					vMove = fMoveFactor * Normal(vDir);
					
					SetLocation(Location + (vMove * DeltaTime));
			}
			else
			{
					SetLocation(CurrentPoint.Location);
			}
			
			if ( VSize2D(Location - CurrentPoint.Location) < 10.00f )
			{
				if (ResolveFightPhase(false))
				{
					return;
				}
					
				//cm("CONTINUING AFTER PHASE RESOLUTION...");
				
				/* if (!IsShieldDisabled())
				{
					CM("SHIELD NOT DISABLED IN PHASE 2 AFTER RESOLVING FIGHT PHASE...");
					CM("DISABLING...");
					DisableShield();
					SetVulnerable();
				} */
				
				
				if (Rand(101) <= 30)
				{
					GotoState('stateHitHarryLittle');
				}
				else
				{
					GotoState('stateHitHarryLots');
				}
			}
			
			vTargetDir = Normal(PlayerHarry.Location - Location);
			DesiredRotation = rotator(vTargetDir);
		}

		event EndState()
		{
			// MaxG: Emote.
			if (Rand(11) < 4)
			{
				PLAY_TAUNT;
			}
			
			Super.EndState();
		}
		
	begin:
		SetFightPhase();
		vDir = CurrentPoint.location - location;
		LoopAnim('Flying');
		fTimeElapsed = 0.0;
}


state stateHitBySpell
{
		
	begin:


	if (IsShieldDisabled())
	{
		Health -= HitDamage;

		// stop all dialog
		StopPeevesDialog();

		// play his ouch sfx
		PeevesOuch();
		
		// If we are in phase 1 of the fight, we want to reenable the shield after a hit.
		// This should only happen on getting hit by Skurge.
		if (iCurrentFightPhase == 1)
		{
			EnableShield();
			SetInvulnerable();
			GotoNextPoint();
			GotoState('MoveToPoint');
		}
	}
	
	// At this point, we are not in phase 1.
	// Either Peeves will die, or he doesn't
	// have a shield and will just go into
	// ghost mode for a bit.
	if ( Health <= 0 )
	{
		bGameOver = true;
		PeevesYell();
		SendDefeatedTrigger();
		playerHarry.StopBossEncounter();
		DestroyAllSpells();
	}
	else
	{
		//CM("PEEVES HIT --> MAKING INVULNERABLE AND MOVING TO POINT");
		SetInvulnerable();
		setTimer(fInvulnDuration, false);
		
		//Exit Trigger 
		GotoNextPoint();
		GotoState('MoveToPoint');
	}
}

state stateHitHarryLots
{
	begin:

	//cm("==========================");
	//cm("ENTERING STATEHITHARRYLOTS");
	//cm("==========================");

	randSpells = rand(3) + 1;

	for (spellCount=0; spellCount <= randSpells; spellCount++ )
	{
		//Turn toward Harry
		vTargetDir = normal( playerHarry.location - location );
		desiredRotation = rotator(vTargetDir);

		PlayAnim('Throw',1.25);
		Sleep(0.5);

		if ( rand(2) == 0 )
		{
			throwSound = sound'HPSounds.Critters_sfx.peeves_throw';
		}
		else
		{
			throwSound = sound'HPSounds.Critters_sfx.peeves_throw2';
		}
				
		PlaySound( throwSound, SLOT_None, [Volume]RandRange(0.6, 1.0), [Radius]95000, [Pitch]RandRange(0.8, 1.2),, false );


		SpawnSpell(class'MGhp2.MGspellEcto', playerHarry);

		//Sleep(1.0);
		Sleep(0.05);

	}

	loopAnim('flying');

	ResolveFightPhase(false);

	switch (Rand(2))
	{
		case 0:
			GotoNextPoint();
			GotoState('MoveToPoint');
			break;
			
		case 1:
			GotoState('stateTormentHarry');
			break;
			
		default:
			break;
	}
}

state stateHitHarryLittle
{

	begin:

		//Turn toward Harry
		vTargetDir = normal( playerHarry.location - location );
		desiredRotation = rotator(vTargetDir);

		PlayAnim('Throw', 0.7);
		Sleep(0.88);

		if (rand(2) == 0)
		{
			throwSound = sound'HPSounds.Critters_sfx.peeves_throw';
		}
		else
		{
			throwSound = sound'HPSounds.Critters_sfx.peeves_throw2';
		}
				
		PlaySound([Sound]throwSound, [Slot]SLOT_None, [Volume]RandRange(0.6, 1.0), [Radius]95000, [Pitch]RandRange(0.8, 1.2),, false);


		SpawnSpell(class'MGhp2.MGspellEctoLarge',playerHarry);

		//Sleep(1.0);
		Sleep(0.05);

	

	loopAnim('flying');
	
	ResolveFightPhase(false);

	switch (Rand(2))
	{
		case 0:
			GotoNextPoint();
			GotoState('MoveToPoint');
			break;
			
		case 1:
			GotoState('stateTormentHarry');
			break;
			
		default:
			break;
	}
}

state shieldAndShoot
{

	begin:

		// Do not send another gravity wave.
		if (IsShieldDisabled() && (iCurrentFightPhase == 1))
		{
			EnableShield();
			SetInvulnerable();
		}
		
		//Turn toward Harry
		vTargetDir = normal( playerHarry.location - location );
		desiredRotation = rotator(vTargetDir);

		PlayAnim('Throw', 0.7);
		Sleep(0.88);

		if (rand(2) == 0)
		{
			throwSound = sound'HPSounds.Critters_sfx.peeves_throw';
		}
		else
		{
			throwSound = sound'HPSounds.Critters_sfx.peeves_throw2';
		}
				
		PlaySound(throwSound, SLOT_None, [Volume]RandRange(0.6, 1.0), [Radius]95000, [Pitch]RandRange(0.8, 1.2),, false);


		SpawnSpell(class'MGhp2.MGspellEctoLarge',playerHarry);

		//Sleep(1.0);
		Sleep(0.05);

	

	loopAnim('flying');


	//SetVulnerable();
	//DisableShield();
	
	GotoNextPoint();
	GotoState('MoveToPoint');
				
}

state stateTormentHarry
{
	begin:

	// Wait for a bit to give user a chance to hit you
	//sleep(0.7);

	loopAnim('idle');

//	MoveToward(CurrentPoint);

	//Turn toward Harry
	vTargetDir = normal( playerHarry.location - location );
	desiredRotation = rotator(vTargetDir);

	// Stop moving
	Acceleration = vect(0,0,0);
	Velocity	 = vect(0,0,0);

	switch(Rand(3))
	{
		case 0:
			PeevesTaunting();
			PLAY_TAUNT;
			playAnim('Taunt');
			break;
		default: 
			PeevesLaughing();
			if ( rand(2) == 0 )
			{
				playAnim('taunt_2');
			}
			else
			{
				playAnim('taunt_3');
			}
			sleep(1.0);
			break;
	}

	sleepTime = GetSoundDuration(peevesVoice);

	sleep(0.5);

	loopAnim('flying');

	GotoNextPoint();
	GotoState('MoveToPoint');
	
}


defaultproperties
{
	bVulnerable=true
	fOpacityRate=0.75
	fInvulnDuration=5.00
	fMoveSpeed=180
	fMoveSpeedPhase2=300
	fExplosionStrength=1664
	fExplosionFalloff=0.20
	iCurrentFightPhase=1

	TauntDialog(0)=Sound'AllDialog.usa.pc_pvs_chal2skurge_23'
	TauntDialog(1)=Sound'AllDialog.usa.pc_pvs_chal2skurge_24'
	TauntDialog(2)=Sound'AllDialog.usa.PC_PVS_happy02fx'
	TauntDialog(3)=Sound'AllDialog.usa.PC_PVS_happy03fx'
}