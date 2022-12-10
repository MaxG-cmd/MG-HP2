class MGHarry extends harry;
 
// MaxG: You know, looking at this now, I'm not sure I did much better than KnowWonder in terms of variables...

var() bool bSuperjump;
var() bool bPatchBunnyHop;

var() bool bDisableMap;

// MaxG: Stock default = 0.2
var() float hyperJumpValue;

var(HarrySounds) float FootstepVolume;
var(HarrySounds) float LandVolume;
var(HarrySounds) float EmoteVolume;
var(HarrySounds) float IncantationVolume;

var(HarrySounds) MultiSound SoundLandMetal;
var(HarrySounds) MultiSound SoundLandRug;
var(HarrySounds) MultiSound SoundLandStone;
var(HarrySounds) MultiSound SoundLandWet;
var(HarrySounds) MultiSound SoundLandWood;

var(SneakHarry) bool bCloak;
var(SneakHarry) float invisibleValue;
var(SneakHarry) float opacityUnCloakRate;
var(SneakHarry) float opacityReCloakRate;
var(SneakHarry) float sneakGroundSpeed;
var(SneakHarry) float sneakAccelRate;
var(SneakHarry) byte InvisibleAmbientGlow;

// ------ Surfaces ---------------------------
// The noiseFactor this actor makes on a given surface.
var(SurfaceRadii) float surfaceCave;
var(SurfaceRadii) float surfaceCloud;
var(SurfaceRadii) float surfaceGrass;
var(SurfaceRadii) float surfaceMetal;
var(SurfaceRadii) float surfaceRug;
var(SurfaceRadii) float surfaceStone;
var(SurfaceRadii) float surfaceWet;
var(SurfaceRadii) float surfaceWood;
// ------ End Surfaces -----------------------

var(SpellSounds) Array<MultiSound> IncantationSounds;
var(SpellSounds) Array<Sound> 		 SpellFXSounds;

var(FootstepSounds) Array<MultiSound> FootstepSounds;

// MaxG: Unused.
/*
var(GhostHarry) bool bGhostHarry;
var(GhostHarry) float ghostGroundRunSpeed;
var(GhostHarry) float ghostGroundJumpSpeed;
var(GhostHarry) float ghostJumpZ;
*/

// MaxG: While sneaking, multiply output noise by this factor (make this < 1).
var(SneakHarry) float sneakNoiseReductionFactor;


var input byte bPushWingardium;
var input byte bPullWingardium;

var input byte bThrowWizardCracker;

var input byte bSneakMove;
var float TargetOpacity;
var float OpacityRate;
var byte TargetAmbientGlow;


// MaxG: For use with the MGMoveSpeedTrigger.
var float HitFloorSpeed;
var bool bHitFloor;

var float JumpTime;
var bool bDoBufferedJump;
var() float BufferedJumpVelocityModifier;
var() float BufferedJumpWindow;
var Name LandedAnim;
var Vector LandedVelocity;
var Vector BaseChangeVelocity;

var() float CastingRate;

//var() bool bAllowBrightnessBoosts;
//var() int BoostsBeforeDetected;
//var() float DetectedBoostSize;
//var() String CheatsDetectedMap;

var() bool bSaveOnLevelLoad;

var(CarpeHarry) float CarpeCursorDistance;
var(CarpeHarry) float CarpeHangAnimDist;

var(WingardiumHarry) Vector WingardiumOffset;
var(WingardiumHarry) Rotator WingardiumRotationRate;
var(WingardiumHarry) float WingardiumDropDist;
var(WingardiumHarry) float WingardiumMaxDist;
var(WingardiumHarry) float WingardiumMinDist;
var(WingardiumHarry) float WingardiumMoveDist;
var(WingardiumHarry) float WingardiumScrollDist;
var(WingardiumHarry) float WingardiumGroundSpeed;
var MGParticleFX WingLevitateFX;

//var bool bSaved;

//var EPhysics eSavedPhysics;
var float power;
//var Vector OldVelocity;
 
var MGCarpeStatue CarpeStatue;

//var int BoostCounter;

const RadsPerUnit = 0.0000958738019107840955257415771484375;
const METERS_PER_UNIT = 0.01905;
const KILOGRAMS_PER_UNIT = 0.45;
const FRICTION_COEFFICIENT = 0.30;
const SOUND_EFFICIENCY = 0.000008;

var StatusItemHealth harryHealth; 

// MaxG: Stuff for the foot particle stuff when you have no falling damage.
//		 0 = L, 1 = R.
//var() Class<ParticleFX> NoFallDamageFXClass;
//var() ParticleFX NoFallDamageFX[2];
 
// MaxG: Override CauseEvent to always allow regardless of bCheatsEnabled. 
exec function CauseEvent(name N)
{
	Local Actor A;

	foreach AllActors(class'Actor', A, N)
	{
		A.Trigger(Self, Self);
	}
}

exec function ULTIMATE()
{
	local CutScene C;
	local MGStatusItemWizardCracker K;
	local int i;

	CastingRate = 16384;
	bInstantAnims = true;
	bFraserMode = true;

	BufferedJumpVelocityModifier = 1.1;
	BufferedJumpWindow = 16384;

	AirControl = 1;

	MGHarryWand(Weapon).bAutoSelectSpell = false;
	
	foreach AllActors(class'CutScene', C)
	{
		C.bSkipAllowed = true;
	}
   
	foreach AllActors(class'MGStatusItemWizardCracker', K)
	{
		K.nMaxCount = 65536;
		K.nCount = 65536;
	}

	FootStepVolume = 0.75;
	IncantationVolume = 0.75;

	for (i = 0; i < FootstepSounds.Length; i++)
	{
		FootstepSounds[i] = MultiSound'MGSounds.Ultimate.UltimateFootsteps';
	}

	for (i = 0; i < IncantationSounds.Length; i++)
	{
		IncantationSounds[i] = MultiSound'MGSounds.Ultimate.UltimateIncantations';
	}

	CM("I AM THE ONE, DON'T WEIGH A TON");
	CM("DON'T NEED A GUN TO GET RESPECT UP ON THE STREET");
}

exec function CrackMeUp()
{
	local MGStatusItemWizardCracker K;
   
	foreach AllActors(class'MGStatusItemWizardCracker', K)
	{
		K.nMaxCount = 65536;
		K.nCount = 65536;
	}
}

function DoReflectSpells()
{
	PlaySound(Sound'HPSounds.Magic_sfx.Dueling_EXP_swoosh');
	HarryAnimChannel.GotoState('stateDefenceCast');
}

exec function ReflectSpells()
{
	if (HarryAnimChannel.IsInState('stateDefenceCast') || HarryAnimChannel.IsInState('stateCast'))
	{
		return;
	}

	if (!IsInState('PlayerWalking'))
	{
		return;
	}

	if ( WingardiumObject != None || CarryingActor != None || CarpeStatue != None )
	{
		return;
	}

	if (bIsCaptured)
	{
		return;
	}

	DoReflectSpells();
}

event Invulnerable()
{
	bInvulnerable = true;
	AmbientGlow = 255;
}

event Vulnerable()
{
	bInvulnerable = false;
	AmbientGlow = Default.AmbientGlow;
}

event PreBeginPlay()
{
	Super.PreBeginPlay();

	// MaxG: Wingardium.
	AddToSpellBook(Class'MGSpellWingardium');

	// MaxG: Make a SpellCursor.
	if (SpellCursor == None)
	{
		SpellCursor = Spawn(Class'MGspellCursor');
	}
	else if (!SpellCursor.IsA('MGSpellCursor'))
	{
			SpellCursor.Destroy();
		SpellCursor = Spawn(Class'MGspellCursor');
	}
	
		
	forEach allActors(Class'StatusItemHealth', harryHealth)
	{
		break;
	}
}

event PostBeginPlay()
{
	local int p;

	// MaxG: Spawn an MGBaseCam.
	if (Cam == None )
	{
		Cam = Spawn(Class'MGBaseCam');
	}
	else if (!Cam.IsA('MGBaseCam'))
	{
		Cam.Destroy();

		Cam = Spawn(Class'MGBaseCam');
	}

	if (bSaveOnLevelLoad)
	{
		SaveGame();
	}

	// MaxG: Spawn the no fall damage particles.
	/*for (p = 0; p < 2; p++)
	{
		if (NoFallDamageFX[p] == None)
		{
			NoFallDamageFX[p] = Spawn(NoFallDamageFXClass);
		}
	}

	AttachToBone(NoFallDamageFX[0], 'bip01 L Foot');
	AttachToBone(NoFallDamageFX[1], 'bip01 R Foot');

	NoFallDamageFX[0].RelativeLocation = Vec(2, 0, 0);
	NoFallDamageFX[1].RelativeLocation = Vec(2, 0, 0);

	// MaxG: Hide them.
	SetParticleEmission(NoFallDamageFX[0], false);
	SetParticleEmission(NoFallDamageFX[1], false);*/

	// MaxG: Spawn levitate effect and reuse it.
	WingLevitateFX = Spawn(Class'MGParticleWingardium');
	WingLevitateFX.SetEmission(false);

	Super.PostBeginPlay();
}

function SetParticleEmission(ParticleFX Emitter, bool bNewEmit)
{
	if (Emitter.IsA('MGParticleFX'))
	{
		MGParticleFX(Emitter).SetEmission(bNewEmit);
	}
	else
	{
		Emitter.EnableEmission(bNewEmit);
	}
}

function MakeSneakNoise(float loudness)
{
	local MGSneakActor hearer;

	if ( MGSneakZone(Region.Zone).bSilentZone )
	{
		return;
	}

	forEach AllActors(class'MGhp2.MGSneakActor', hearer)
	{
		hearer.SneakHearNoise(loudness, self);
	}
}

/*
//=====================ANGULAR MOMENTUM===========================================
function vector NormalReject(Vector A, Vector vNormal)
{
		return A - ((A Dot vNormal) * vNormal);
}


function float SpringRate(float fStartSpring, float fMaxAmplitude, int iMoverFluctuations, float Alpha)
{
		local float delta, kRaw, result;
		local int k;
		
		if ((fStartSpring <= 0.0) || (fStartSpring >= 1.0))
		{
				fStartSpring = 0.75;
		}
		
		if (Alpha <= fStartSpring)
		{
				return 1 / fStartSpring;
		}
		
		if (iMoverFluctuations <= 0 || iMoverFluctuations >= 32)
		{
				iMoverFluctuations = 1;
		}
		
		if((fMaxAmplitude <= 0.0) || (fMaxAmplitude >= 1.0))
		{
				fMaxAmplitude = 0.1;
		}
		
		delta = (1 - fStartSpring) / (2 * iMoverFluctuations);
		kRaw = (Alpha - delta - fStartSpring) / (2 * delta);
		k = kRaw;
		
		result = fMaxAmplitude / (delta * 2 ** k);
		if (k >= kRaw)
		{
				result *= -1;
		}
		return result;
}

function float MoverInterpRate(Mover m, float Alpha)
{
		switch (m.MoverGlideType)
		{
				case MV_GlideByTime:
						return 6 * (Alpha - Alpha ** 2);
				case MV_SpringByTime:
						return SpringRate((m.MoveTime - m.MoverSpringTime) / m.MoveTime,
															m.MoverMaxAmplitude,
															m.MoverFluctuations,
															Alpha) / m.MoveTime;
				default:
						return 1;
		}
}
//=======================END ANGULAR MOMENTUM==================================
*/


/*function ClientReStart()
{
	if (!bSaved)
	{
		Super(PlayerPawn).ClientReStart();
		
	} 
	else
	{
		BaseEyeHeight = Default.BaseEyeHeight;
		EyeHeight = BaseEyeHeight;

		if (Region.Zone.bWaterZone && (PlayerRestartState == 'PlayerWalking'))
		{
			if (HeadRegion.Zone.bWaterZone)
			{
				PainTime = UnderWaterTime;
			}
			setPhysics(PHYS_Swimming);
			gotoState('PlayerSwimming');
		}
		else
		{
			if (Physics != eSavedPhysics)
			{
				SetPhysics(eSavedPhysics);
			}
		}
	}
	bSaved = false;
}*/

// MaxG: Segmented saving.
/*exec function smoothSave(String slot)
{
	bSaved = True;
	eSavedPhysics = Physics;
	ConsoleCommand("savegame" @ slot);
	bSaved = false;
}*/

/*function ObliterateWand()
{
	local Actor i;
	
	for (i = inventory; i != none; i = i.inventory)
	{
		// Find if it's a wand
		if (i.isA('baseWand'))
		{
			// Now destroy
			i.destroy();
			
			// Break because we found it
			break;
		}
	}
}*/

event TravelPostAccept()
{
	local weapon weap;
	
	super.TravelPostAccept();
		
	
			
	//ObliterateWand();
	if (Weapon != None)
	{
		Weapon.Destroy();
	}

	//level.playerHarryActor.clientMessage("weapon is " $ weapon);
	//level.playerHarryActor.clientMessage("INVENTORY IS " $ inventory);
	
	
	if (Inventory == None)
	{
		weap = Spawn(class'MGharryWand', [SpawnOwner] self);
		weap.BecomeItem();
		AddInventory(weap);
		weap.WeaponSet(self);
		weap.GiveAmmo(self);
		//level.playerHarryActor.clientMessage(self $ " spawning weap " $ weap);
	}
	else
	{
		//level.playerHarryActor.clientMessage("not spawning weapon-****-INVENTORY is already " $inventory);
	}


	//ULTIMATE();
}

event TakeDamage(int Damage, Pawn InstigatedBy, Vector HitLocation, Vector Momentum, Name DamageType)
{
	local float shake_amount;

	Super.TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType);

	// MaxG: Shake for explosions.
	if (DamageType == 'Exploded')
	{
		shake_amount = float(Damage);
		
		shake_amount *= 1.25;

		ShakeView(0.14, shake_amount, shake_amount);
	}

	DropLevitatingObject();
}

//====================== INCANTATIONS ====================
function HandleSpellIncantationSound(ESpellType SpellType)
{
	local MultiSound SpellIncantation;
	local Sound	SpellSound;

	switch(SpellType)
	{
		case SPELL_Alohomora:
			SpellIncantation = IncantationSounds[0];
			SpellSound = SpellFXSounds[0];
			break;
		
		case SPELL_Flipendo:
			SpellIncantation = IncantationSounds[1];
			SpellSound = SpellFXSounds[1];
			break;

		case SPELL_Lumos:
			SpellIncantation = IncantationSounds[2];
			SpellSound = SpellFXSounds[2];
			break;

		case SPELL_Skurge:
			SpellIncantation = IncantationSounds[3];
			SpellSound = SpellFXSounds[3];
			break;

		case SPELL_Diffindo:
			SpellIncantation = IncantationSounds[4];
			SpellSound = SpellFXSounds[4];
			break;

		case SPELL_Rictusempra:
		case SPELL_DuelRictusempra:
			SpellIncantation = IncantationSounds[5];
			SpellSound = SpellFXSounds[5];
			break;

		case SPELL_Spongify:
			SpellIncantation = IncantationSounds[6];
			SpellSound = SpellFXSounds[6];
			break;
			
		case SPELL_LocomotorWibbly:
			
			SpellIncantation = None;
			SpellSound = SpellFXSounds[9];
			break;
		
		case SPELL_Reparo:
			
			SpellIncantation = None;
			SpellSound = SpellFXSounds[8];
			break;

		case SPELL_DuelMimblewimble:
			SpellIncantation = IncantationSounds[7];
			SpellSound = SpellFXSounds[8];
			break;
			
		case SPELL_DuelExpelliarmus:
			SpellIncantation = IncantationSounds[8];
			//SpellSound = SpellFXSounds[7];
			break;

		case SPELL_WingardiumLeviosa:
			
			SpellIncantation = None;
			SpellSound = SpellFXSounds[10];
			break;
	}
	
	// Play Incantation Sound
	// MaxG: Ghost unused.
	if (SpellIncantation != None && !bCloak /*&& !bGhostHarry*/)
	{
		PlaySound(SpellIncantation, SLOT_Talk, IncantationVolume, true);
	}
	
	// Play Spell SoundFX
	if (SpellSound != None)
	{
		PlaySound(SpellSound, SLOT_None, 1.0, true);
	}
}

//============= END INCANTATIONS ==============


// A function to trace the texture beneath Harry for footsteps.
// Theoretically, an int should still be an enum.
function int GetTextureSound()
{
	local Texture HitTexture;
	local int Flags;
	
	HitTexture = TraceTexture(Location + (vect(0,0,-128)), Location, Flags);
	
	if (HitTexture != None)
	{
		return HitTexture.FootstepSound;
	}
	else
	{
		return 0;
	}
}

// Determine what the noise factor should be based on our footstep sound.
function float GetNoiseFactor(int FootstepSound)
{
	local float noiseFactor;
	
	switch(FootstepSound)
	{
		case 1:
			noiseFactor = surfaceRug;					
			break;

		case 2:
			noiseFactor = surfaceWood;
			break;

		case 0:
			noiseFactor = surfaceStone;
			break;

		case 3:
			noiseFactor = surfaceCave;
			break;

		case 4:
			noiseFactor = surfaceCloud;
			break;

		case 5:
			noiseFactor = surfaceWet;
			break;

		case 6:
			noiseFactor = surfaceGrass;
			break;

		case 7:
			noiseFactor = surfaceMetal;
			break;
			
		default:
			noiseFactor = surfaceStone;
			break;
	}
	
	return noiseFactor;
}

simulated function PlayFootStep()
{
	local Sound step;

	local float noiseFactor;

	local float VelocityFootstepVolume;

	
	local int FootstepSound;
	
	FootstepSound = GetTextureSound();
	
	noiseFactor = GetNoiseFactor(FootstepSound);

	if (FootRegion.Zone.bWaterZone)
	{
		PlaySound(WaterStep, SLOT_Interact, 1, false, 1000.0, 1.0);
		noiseFactor = surfaceWet;
		return;
	}

	if (iEctoRefCount > 0)
	{
		step = FootstepSounds[8];
		noiseFactor = surfaceWet;
	}
	else if (iWebAnimRefCount > 0)
	{
		step = FootstepSounds[8];
		noiseFactor = surfaceWet;
	}
	else
	{
		switch(FootstepSound)
		{
			case 1:
				step = FootstepSounds[0];				
				break;

			case 2:
				step = FootstepSounds[1];
				break;

			case 0:
				step = FootstepSounds[2];
				break;

			case 3:
				step = FootstepSounds[3];
				break;

			case 4:
				step = FootstepSounds[4];
				break;

			case 5:
				step = FootstepSounds[5];
				break;

			case 6:
				step = FootstepSounds[6];
				break;

			case 7:
				step = FootstepSounds[7];
				break;
		}
		
	}

	// MaxG: Make footstep volume react to velocity.
	VelocityFootstepVolume = FootstepVolume * (VSize2D(Velocity) / GroundRunSpeed);

	// MaxG: Consider the noise factor. 
	VelocityFootstepVolume *= noiseFactor;

	// MaxG: Give it some boost, but clamp to max volume.
	VelocityFootstepVolume = FClamp(VelocityFootstepVolume, FootstepVolume * 0.5, FootstepVolume);

	//CM("Volume ==> " $ VelocityFootstepVolume);


	//PlaySound(step, SLOT_None, FootstepVolume, false, 1000.0, 0.9);
	PlaySound(step, SLOT_None, VelocityFootstepVolume, false, 1000.0, 0.9);

	if (bSneakMove > 0)
	{
		MakeSneakNoise(power * SOUND_EFFICIENCY * noiseFactor * sneakNoiseReductionFactor);
	}
	else
	{
		MakeSneakNoise(power * SOUND_EFFICIENCY * noiseFactor);
	}
}

function PlayLandedSound()
{
	local MultiSound LandSound;

	local Texture 	HitTexture;
	local int		Flags;

	local float 	AdjustedVolume;

	local float noiseFactor;

	
	if (FootRegion.Zone.bWaterZone)
	{
		LandSound = SoundLandWet;
		noiseFactor = surfaceWet;
	}

	HitTexture = TraceTexture(Location + (vect(0,0,-128)), Location, Flags );


	if (LandSound == None)
	{
		switch (HitTexture.FootstepSound)
		{
			case FOOTSTEP_Wood:
				LandSound = SoundLandWood;
				noiseFactor = surfaceWood;
				break;

			case FOOTSTEP_cloud:
			case FOOTSTEP_grass:
			case FOOTSTEP_Rug:
				LandSound = SoundLandRug;
				noiseFactor = surfaceRug;
				break;

			case FOOTSTEP_Stone:
			case FOOTSTEP_cave:
				LandSound = SoundLandStone;
				noiseFactor = surfaceStone;
				break;

			case FOOTSTEP_wet:
				LandSound = SoundLandWet;
				noiseFactor = surfaceWet;
				break;

			case FOOTSTEP_metal:
				LandSound = SoundLandMetal;
				noiseFactor = SurfaceMetal;
				break;
		}
	}

	//AdjustedVolume = power * SOUND_EFFICIENCY * noiseFactor * 120;
	AdjustedVolume = HitFloorSpeed / (JumpZ * (1 / LandVolume) * 0.75);

	//CM("PreAdjustedVolume ==> " $ AdjustedVolume);

	AdjustedVolume = FClamp(AdjustedVolume, LandVolume * 0.25, LandVolume);

	//CM("AdjustedVolume ==> " $ AdjustedVolume);
	
	PlaySound(LandSound, SLOT_Interact, AdjustedVolume, false, 1000.0);
}

//================ EMOTE SOUNDS =====================
function PlayLandedEmoteSound()
{
	local float AdjustedEmoteVolume;

	// MaxG: SLOT_Talk doesn't actually adjust volume...

	// MaxG: Based on how hard you hit the ground.
	AdjustedEmoteVolume = power * SOUND_EFFICIENCY * GetNoiseFactor(GetTextureSound()) * 65;

	//CM("PRE Adjusted = " $ AdjustedEmoteVolume);

	// MaxG: Give it some boost, but clamp to max volume.
	AdjustedEmoteVolume = FClamp(AdjustedEmoteVolume, EmoteVolume * 0.4, EmoteVolume);
	
	//CM("POST Adjusted = " $ AdjustedEmoteVolume);


	//if (!bGhostHarry)
	//{
		if (bIsGoyle)
		{
			switch (Rand(5))
			{
				case 0:
				PlaySound(Sound'PC_AsG_Adv7aSlyth_24', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 1:
				PlaySound(Sound'PC_AsG_Adv7aSlyth_24a', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 2:
				PlaySound(Sound'PC_AsG_Adv7aSlyth_24b', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 3:
				PlaySound(Sound'PC_AsG_Adv7aSlyth_24c', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 4:
				PlaySound(Sound'PC_AsG_Adv7aSlyth_24d', SLOT_Talk, AdjustedEmoteVolume);
				break;
				default:
			}
		}
		else
		{
			switch (Rand(5))
			{
				case 0:
				PlaySound(Sound'landing1', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 1:
				PlaySound(Sound'landing2', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 2:
				PlaySound(Sound'landing3', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 3:
				PlaySound(Sound'landing4', SLOT_Talk, AdjustedEmoteVolume);
				break;
				case 4:
				PlaySound(Sound'landing5', SLOT_Talk, AdjustedEmoteVolume);
				break;
				default:
			}
		}
	//}
}

function PlayFallingPullupEmoteSound()
{
	//if (!bGhostHarry)
	//{
		if (bIsGoyle)
		{
			switch (Rand(3))
			{
				case 0:
				PlaySound(Sound'AsG_pullup_3',SLOT_Talk, EmoteVolume);
				break;
				case 1:
				PlaySound(Sound'AsG_pullup_4',SLOT_Talk, EmoteVolume);
				break;
				case 2:
				PlaySound(Sound'AsG_pullup_6',SLOT_Talk, EmoteVolume);
				break;
				default:
			}
		}
		else
		{
			PlaySound(Sound'pull_up3',SLOT_Talk, EmoteVolume);
		}
	//}
}

function PlayEasyPullupEmoteSound()
{
	//if (!bGhostHarry)
	//{
		if ( bIsGoyle )
		{
			switch (Rand(3))
			{
				case 0:
				PlaySound(Sound'AsG_pullup_1',SLOT_Talk, EmoteVolume);
				break;
				case 1:
				PlaySound(Sound'AsG_pullup_2',SLOT_Talk, EmoteVolume);
				break;
				case 2:
				PlaySound(Sound'AsG_pullup_5',SLOT_Talk, EmoteVolume);
				break;
				default:
			}
		}
		else
		{
			PlaySound(Sound'EmotiveHarry5_b_pullup6',SLOT_Talk, EmoteVolume);
		}
	//}
}

function PlayHardPullupEmoteSound()
{
	//if (!bGhostHarry)
	//{
		if (bIsGoyle)
		{
			switch (Rand(3))
			{
				case 0:
				PlaySound(Sound'AsG_pullup_3',SLOT_Talk, EmoteVolume);
				break;
				case 1:
				PlaySound(Sound'AsG_pullup_4',SLOT_Talk, EmoteVolume);
				break;
				case 2:
				PlaySound(Sound'AsG_pullup_6',SLOT_Talk, EmoteVolume);
				break;
				default:
			}
		}
		else
		{
			PlaySound(Sound'EmotiveHarry5_a_pullup5',SLOT_Talk, EmoteVolume);
		}
	//}
}

function PlayHurtEmoteSound()
{
	if ( bIsGoyle )
	{
		switch (Rand(26))
		{
			case 0:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_26',SLOT_Talk);
			break;
			case 1:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_26a',SLOT_Talk);
			break;
			case 2:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_26b',SLOT_Talk);
			break;
			case 3:
			PlaySound(Sound'PC_AsG_Emote_13',SLOT_Talk);
			break;
			case 4:
			PlaySound(Sound'PC_AsG_Emote_13a',SLOT_Talk);
			break;
			case 5:
			PlaySound(Sound'PC_AsG_Emote_13b',SLOT_Talk);
			break;
			case 6:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_25',SLOT_Talk);
			break;
			case 7:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_25a',SLOT_Talk);
			break;
			case 8:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_25b',SLOT_Talk);
			break;
			case 9:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_25c',SLOT_Talk);
			break;
			case 10:
			PlaySound(Sound'PC_AsG_Emote_14',SLOT_Talk);
			break;
			case 11:
			PlaySound(Sound'PC_AsG_Emote_14a',SLOT_Talk);
			break;
			case 12:
			PlaySound(Sound'PC_AsG_Emote_14b',SLOT_Talk);
			break;
			case 13:
			PlaySound(Sound'PC_AsG_Emote_15',SLOT_Talk);
			break;
			case 14:
			PlaySound(Sound'PC_AsG_Emote_15a',SLOT_Talk);
			break;
			case 15:
			PlaySound(Sound'PC_AsG_Emote_15b',SLOT_Talk);
			break;
			case 16:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_27',SLOT_Talk);
			break;
			case 17:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_27a',SLOT_Talk);
			break;
			case 18:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_27b',SLOT_Talk);
			break;
			case 19:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_28',SLOT_Talk);
			break;
			case 20:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_28a',SLOT_Talk);
			break;
			case 21:
			PlaySound(Sound'PC_AsG_Adv7aSlyth_28b',SLOT_Talk);
			break;
			case 22:
			PlaySound(Sound'PC_AsG_Emote_16',SLOT_Talk);
			break;
			case 23:
			PlaySound(Sound'PC_AsG_Emote_16a',SLOT_Talk);
			break;
			case 24:
			PlaySound(Sound'PC_AsG_Emote_16b',SLOT_Talk);
			break;
			case 25:
			PlaySound(Sound'PC_AsG_Emote_17',SLOT_Talk);
			break;
			case 24:
			PlaySound(Sound'PC_AsG_Emote_17a',SLOT_Talk);
			break;
			case 25:
			PlaySound(Sound'PC_AsG_Emote_17b',SLOT_Talk);
			break;
			default:
		}
	} else {
		PlaySound(HurtSound[Rand(15)], SLOT_Talk, EmoteVolume);
	}
}

function PlayFallDeepEmoteSound()
{
	if (velocity.z < -128)
	{
		if ( bIsGoyle )
		{
			switch (Rand(5))
			{
				case 0:
				PlaySound(Sound'PC_AsG_Adv7aSlyth_29', SLOT_Talk, EmoteVolume);
				break;
				case 1:
				PlaySound(Sound'PC_AsG_Emote_19', SLOT_Talk, EmoteVolume);
				break;
				case 2:
				PlaySound(Sound'PC_AsG_Emote_19a', SLOT_Talk, EmoteVolume);
				break;
				case 3:
				PlaySound(Sound'PC_AsG_Emote_19b', SLOT_Talk, EmoteVolume);
				break;
				default:
			}
		}
		else
		{
			switch (Rand(2))
			{
				case 0:
					PlaySound(Sound'Hry_fall_100rev', SLOT_Talk, EmoteVolume);
					break;
				case 1:
					PlaySound(Sound'falldeep2', SLOT_Talk, EmoteVolume);
					break;
				default:
			}
		}
	}
}
// ============== END EMOTE SOUNDS ===============================

//========== Invisibility cloak functionality
function goInvis(float DeltaTime)
{
	if (Opacity != targetOpacity)
	{
		if (abs(targetOpacity - Opacity) < (opacityRate * DeltaTime))
		{
			Opacity = targetOpacity;
		}
		else
		{
			if (targetOpacity > Opacity)
			{
				Opacity += opacityRate * DeltaTime;
			}
			else if (targetOpacity < Opacity)
			{
				Opacity -= opacityRate * DeltaTime;
			}
		}
	}

	// MaxG: This can't be made generic for AmbientGlow since it's a byte.
	if (AmbientGlow != TargetAmbientGlow)
	{
		if (abs(TargetAmbientGlow - AmbientGlow) < (OpacityRate * DeltaTime))
		{
			//CM("Ambient reached ==> " $ AmbientGlow $ " = " $ TargetAmbientGlow);
			AmbientGlow = TargetAmbientGlow;
		}
		else
		{
			if (TargetAmbientGlow > AmbientGlow)
			{
				//CM("Ambient low ==> " $ AmbientGlow  $ " + " $ FMax(1, OpacityRate * DeltaTime));
				AmbientGlow += FMax(1, OpacityRate * DeltaTime);
			}
			else if (TargetAmbientGlow < AmbientGlow)
			{
				//CM("Ambient high ==> " $ AmbientGlow  $ " + " $ FMax(1, OpacityRate * DeltaTime));
				AmbientGlow -= FMax(1, OpacityRate * DeltaTime);
			}
		}
	}
}

// MaxG: Disable map.
event PlayerInput(float DeltaTime)
{
	if (bDisableMap)
	{
		bOpenMap = 0;
	}

	Super.PlayerInput(DeltaTime);
}

event PlayerTick(float DeltaTime)
{
	// -- Footstep power calculations --------
	local float forceGravity;
	local float forceFriction;
	local Vector forceTotal;
	local Vector deltaLocation;

	
	deltaLocation = (Location - OldLocation) * METERS_PER_UNIT;
	
	forceGravity = -Region.Zone.ZoneGravity.z * METERS_PER_UNIT * Mass * KILOGRAMS_PER_UNIT;
	
	forceFriction = forceGravity * FRICTION_COEFFICIENT;
	
	//forceTotal = Mass * KILOGRAMS_PER_UNIT * ((deltaLocation - OldVelocity) / deltaTime) + (forceFriction * Normal(deltaLocation));
	forceTotal = Mass * KILOGRAMS_PER_UNIT * ((deltaLocation - Velocity) / deltaTime) + (forceFriction * Normal(deltaLocation));
	
	power = abs(forceTotal Dot deltaLocation) / deltaTime;


	//OldVelocity = (Location - ReallyOldLocation);
	// -- End footstep power calculations ----

	bHitFloor = false;


	if (bCloak)
	{
		// MaxG: Do not cloak in these scenarios.
		if (bIsAiming ||
			HarryAnimChannel.IsInState('stateCasting') ||
			HarryAnimChannel.IsInState('stateDefenceCast') ||
			IsInState('LevitatingObject') ||
			CarryingActor != None ||
			HarryAnimChannel.IsInState('stateThrow') ||
			bLumosOn ||
			WingardiumObject != None)
		{
			targetOpacity = Default.Opacity;
			TargetAmbientGlow = Default.AmbientGlow;
			opacityRate = opacityUnCloakRate;
		}
		else
		{
			targetOpacity = invisibleValue;
			TargetAmbientGlow = InvisibleAmbientGlow;
			opacityRate = opacityReCloakRate;
		}
			 
		goInvis(deltaTime);
	}
	else
	{
		targetOpacity = Default.Opacity;
		TargetAmbientGlow = Default.AmbientGlow;
		opacityRate = opacityUnCloakRate;
		goInvis(deltaTime);
	}
	
	// MaxG (but later): Okay so here's the fix. Just get rid of it. Honestly not cool enough to keep RN.
	/*if (bGhostHarry)
	{
		bSneakMove = 0;
		SetCollision(true,false,false);
		Opacity = invisibleValue;
		GroundJumpSpeed = ghostGroundJumpSpeed;
		GroundSpeed = ghostGroundRunSpeed;
		JumpZ = ghostJumpZ;
	}
	else
	{*/
		//SetCollision(true,true,true);
		
		if ((!bIsAiming && !HarryAnimChannel.IsInState('stateCasting')))
		{
			targetOpacity = invisibleValue;
			TargetAmbientGlow = InvisibleAmbientGlow;
		}
		
		if (bSneakMove == 0 && !bIsCaptured && iEctoRefCount == 0)
		{
			GroundSpeed = default.GroundRunSpeed;
			GroundJumpSpeed = default.GroundJumpSpeed;
			JumpZ = default.JumpZ;
		}
	//}

	
	Weapon.Opacity = Opacity;

	
	ProcessSneak();
	ProcessSummonCracker();
	ProcessWingardiumForce(DeltaTime);
		
	if (bIsAiming && HarryAnimChannel.IsInState('stateCasting') && bAltFire == 0)
	{
		if (SpellCursor.isLockedOn() || !baseWand(Weapon).bAutoSelectSpell)
		{
			if (baseWand(Weapon).CurrentSpell == class'spellDuelExpelliarmus')
			{
				DoReflectSpells();
				return;
			}
		}
	}
	
	Super.PlayerTick(DeltaTime);
}

// MaxG: Override this function to patch firing blanks.
function Cast()
{
	local Actor BestTarget;
	//local Actor HitActor;
	local Rotator defaultAngle;
	local Rotator checkAngle;
	local Pawn hitPawn;
	local Vector objectDir;
	local int bestYaw;
	local int tempYaw;
	local int defaultYaw;
	local float bestDist;
	local float TempDist;
	local string SpellIncantation;

	//log("Cast!");
	
	if ( fTimeAfterHit > 0 )
	{
		if ( (fTimeAfterHit > 1.0) && bInDuelingMode )
		{
			if ( CurrentDuelSpell == 0 )
			{
				switch (Rand(6))
				{
					case 0:
					SpellIncantation = "PC_Hry_HryDuelMW_04";
					break;
					case 1:
					SpellIncantation = "PC_Hry_HryDuelMW_05";
					break;
					case 2:
					SpellIncantation = "PC_Hry_HryDuelMW_12";
					break;
					case 3:
					SpellIncantation = "PC_Hry_HryDuelMW_13";
					break;
					case 4:
					SpellIncantation = "PC_Hry_HryDuelMW_14";
					break;
					case 5:
					SpellIncantation = "PC_Hry_HryDuelMW_15";
					break;
					default:
				}
			} else
				if ( CurrentDuelSpell == 1 )
				{
					switch (Rand(6))
					{
						case 0:
						SpellIncantation = "PC_Hry_HryDuelMW_06";
						break;
						case 1:
						SpellIncantation = "PC_Hry_HryDuelMW_07";
						break;
						case 2:
						SpellIncantation = "PC_Hry_HryDuelMW_08";
						break;
						case 3:
						SpellIncantation = "PC_Hry_HryDuelMW_09";
						break;
						case 4:
						SpellIncantation = "PC_Hry_HryDuelMW_10";
						break;
						case 5:
						SpellIncantation = "PC_Hry_HryDuelMW_11";
						break;
						default:
					}
				} 
			else
					if ( CurrentDuelSpell == 2 )
					{
						switch (Rand(3))
						{
							case 0:
							SpellIncantation = "PC_Hry_HryDuelMW_01";
							break;
							case 1:
							SpellIncantation = "PC_Hry_HryDuelMW_02";
							break;
							case 2:
							SpellIncantation = "PC_Hry_HryDuelMW_03";
							break;
							default:
						}
					}
			if ( SpellIncantation != "" )
			{
				PlaySound(Sound(DynamicLoadObject("AllDialog." $ SpellIncantation,Class'Sound')),SLOT_Misc,0.75,True);
			}
		}
		return;
	}

	defaultAngle = Rotation;
	defaultAngle.Pitch = 0;
	defaultYaw = defaultAngle.Yaw;
	defaultYaw = defaultYaw & 65535;

	if ( defaultYaw > 32767 )
	{
		defaultYaw = defaultYaw - 65536;
	}

	BestTarget = None;

	if ( BossTarget != None )
	{
		Target = BossTarget;
	}

	if (!baseWand(Weapon).bAutoSelectSpell)
	{
		baseWand(Weapon).CastSpell(BossTarget,vect(0.00,0.00,0.00));
		baseWand(Weapon).LastCastedSpell.SeekSpeed *= 0.25;
	}
	else if (bInDuelingMode)
	{
		baseWand(Weapon).CastSpell(DuelOpponent,,DuelSpells[CurrentDuelSpell]);
		baseWand(Weapon).LastCastedSpell.SetSpellDirection(SpellCursor.Location - baseWand(Weapon).LastCastedSpell.Location);
	}
	else if (bHarryUsingSword)
	{
		baseWand(Weapon).CastSpell(None,,Class'spellSwordFire');
	}
	// MaxG: Do not fire blanks, use the previous target so it doesn't fly off into space. 
	else
	{
		if (SpellCursor.IsLockedOn())
		{
			//CM("Current ==> " $ SpellCursor.aCurrentTarget $ " || " $ SpellCursor.vTargetOffset);
			baseWand(Weapon).CastSpell(SpellCursor.aCurrentTarget, SpellCursor.vTargetOffset);
		}
		// MaxG: PREVENT Storage.
		else if ( !HarryAnimChannel.IsInState('stateDefenceCast') )
		{
			//CM("Previous ==> " $ SpellCursor.aLastTarget $ " || " $ SpellCursor.vTargetOffset);
			baseWand(Weapon).CastSpell(SpellCursor.aLastTarget, SpellCursor.vTargetOffset);
		}
	}
	/*else
	{
		//ClientMessage("Harry Can't cast a spell... SpellCursor.IsLockedOn = " $ string(SpellCursor.IsLockedOn()) $ " CurrentSpell = " $ string(baseWand(Weapon).CurrentSpell));
	}*/

	TurnOffSpellCursor();
}

function bool HandleSpellEctoLarge(optional MGSpellEctoLarge spell, optional vector vHitLocation)
{
	
	if (bReboundingSpells)
	{
		return false;
	}
	else if (!IsInState('stateDead'))
	{			
		doJump(96);
		velocity += spell.velocity * Vec(0.75, 0.75, 0.1);
		AnimFalling = 'spongify';
		
		TakeDamage(15, Pawn(spell.owner), vect(0,0,0), velocity, '' );
		return true; // we have a valid hit
	}
	else
	{
		return false;
	}
}

 
function ProcessSneak()
{
	local LumosLight lumosActor;
	
	if (bSneakMove > 0 && !bIsCaptured && !isInState('stateDead'))
	{
		GroundSpeed = sneakGroundSpeed;
		AccelRate = sneakAccelRate;
		//GroundJumpSpeed = GroundJumpSpeed;
		HarryAnimSet = HARRY_ANIM_SET_SNEAK;

		/*if (bLumosOn)
		{
			forEach allActors(class'LumosLight', lumosActor)
			{
				// For various technical reasons, it's much
				// simpler to just turn Lumos off instead
				// of trying to interpolate to an off state.
				
				//lumosActor.fLumosTimeToTurnOff = 2.0f;
				//lumosActor.fLumosTime = lumosActor.fLumosTimeToTurnOff;
				lumosActor.TurnOff();
				//bLumosOn = false;
			}
		}*/
	}
	else
	{
		// MaxG: Disable ghost.
		/*if (bGhostHarry)
		{
			HarryAnimSet = HARRY_ANIM_SET_SLEEPY; 
		}
		else
		{*/	if (!bIsCaptured && iEctoRefCount == 0 && !isInState('stateDead'))
			{
				GroundSpeed = default.GroundRunSpeed;
				AccelRate = default.AccelRate;
				GroundJumpSpeed = default.GroundJumpSpeed;
			}
			
			if (iEctoRefCount == 0 && (HarryAnimSet == HARRY_ANIM_SET_SNEAK || HarryAnimSet == HARRY_ANIM_SET_SLEEPY))
			{
				HarryAnimSet = default.HarryAnimSet;
			}
		//}
	}
}

function MoveWingardium(float dist)
{
	local float wing_dist;

	wing_dist = WingardiumDist + dist;

	WingardiumDist = FClamp(wing_dist, WingardiumMinDist, WingardiumMaxDist);
}

exec function MoveWingForward()
{
	// MaxG: Do not allow for double input.
	if (bPushWingardium <= 0)
	{
		MoveWingardium(WingardiumScrollDist);
	}
}

exec function MoveWingBackward()
{
	// MaxG: Do not allow for double input.
	if (bPullWingardium <= 0)
	{
		MoveWingardium(-WingardiumScrollDist);
	}
}

function ProcessWingardiumForce(float DeltaTime)
{
	// MaxG: Return if both.
	if (bPullWingardium > 0 && bPushWingardium > 0)
	{
		return;
	}

	if (bPushWingardium > 0)
	{
		MoveWingardium(WingardiumMoveDist * DeltaTime);
	}

	if (bPullWingardium > 0)
	{
		MoveWingardium(-WingardiumMoveDist * DeltaTime);
	}
}

function ProcessSummonCracker()
{
	local MGwizardCracker Cracker;
	local StatusGroup CrackerGroup;
	local StatusItem CrackerItem;

	CrackerItem  = ManagerStatus.GetStatusItem(Class'MGStatusGroupWizardCracker', Class'MGStatusItemWizardCracker');

	if (CrackerItem.nCount > 0)
	{
		CrackerGroup = ManagerStatus.GetStatusGroup(Class'MGStatusGroupWizardCracker');

		if (bThrowWizardCracker > 0
			&& CarryingActor == None
			&& HarryAnimChannel.CanPickSomethingUp()
			&& !isInState('StateDead')
			&& !IsCasting()
			&& !bIsCaptured)
		{
			StopAiming();

			HarryAnimChannel.GotoState('statePickupItem');
			PlayAnim('Pickup', 1, 0.15, [Type]HarryAnimType);

			Cracker = Spawn(class'MGWizardCracker', Self, , Location + Vec(0, 0, 48));

			SetCarryingActor(Cracker);

			AltFire(0);
			
			

			CrackerGroup.IncrementCount(Class'MGStatusItemWizardCracker', -1);
		}
	}
}


// MaxG: Override.
exec function AltFire (optional float f)
{
	local Vector V;
	local Rotator R;

	// MaxG: Patch quick throwing.
	if (HarryAnimChannel.IsInState('stateThrow'))
	{
		return;
	}

	// MaxG: Patch double-throw.
	//if ( HarryAnimChannel.IsCarryingActor() )
	if (CarryingActor != None)
	{
		if ( bThrow == False && IsInState('PlayerWalking') )
		{
			//ClientMessage("Throw!");
			HarryAnimChannel.GotoStateThrow();
			bThrow = True;
		}
	} 
	else 
	{
		// MaxG: Prevent cancel reflecting.
		if ( (Weapon != None) && (CarryingActor == None) &&	!bIsAiming && !HarryAnimChannel.IsInState('stateDefenceCast') )
		{
			Weapon.bPointing = True;
			StartAiming(bHarryUsingSword);
		}
	}
}

function DropCarryingActor(optional bool bLatentDrop)
{
	local bool bIsWizardCracker;

	DropLevitatingObject();

	if (CarryingActor == None)
	{
		return;
	}
	
	bIsWizardCracker = CarryingActor.isA('MGWizardCracker');

	if (CarryingActor != None)
	{
		CarryingActor.SetPhysics(PHYS_Falling);
		CarryingActor.SetOwner(None);
		CarryingActor.Velocity = vect(0.00,0.00,125.00);
		CarryingActor.Instigator = self;
		CarryingActor.bRotateToDesired = True;
		
		if (!bIsWizardCracker)
		{
			CarryingActor.SetCollision(True,True,True);
		}
		else
		{
			//CarryingActor.GoToState('WaitingToExplode');
			CarryingActor.GoToState('StateBeingThrown');
		}
		
		CarryingActor = None;
	}

	if ( IsInState('statePickupItem') )
	{
		GotoState('PlayerWalking');
	}

	if (!bLatentDrop)
	{
		HarryAnimChannel.GotoState('stateIdle');
		HarryAnimType = AT_Replace;
	}

	Weapon.bHidden = False;
}

function ThrowCarryingActor ()
{
	local Vector V;
	local Vector v2;
	local Rotator R;
	local Actor A;
	local Actor aTarget;
	local float ThrowVelocity;
	local bool bThrowingCracker;

	if (bThrow && (CarryingActor != None))
	{
		bThrow = False;
		A = CarryingActor;

		bThrowingCracker = A.IsA('MGWizardCracker');

		// MaxG: Patch throwing OOB.
		A.SetLocation(Location + Vec(0, 0, 8));

		DropCarryingActor(True);
		aTarget = AccurateThrowing(A);

		// MaxG: Patch throwing OOB.
		A.SetLocation(Location + Vec(0, 0, 8 * DrawScale));

		if ( aTarget != None )
		{
			
			HarryAccurateThrowObject(A,aTarget,True,True);
		}
		else
		{
			V = Normal(Cam.vForward + vect(0.00,0.00,0.50));

			if (A != None)
			{
				if (bThrowingCracker)
				{
					ThrowVelocity = MGWizardCracker(A).ThrowVelocity;
				}
				else
				{
					ThrowVelocity = HPawn(A).fThrowVelocity;
				}

				A.GotoState('stateBeingThrown');
			}
			else
			{
				ThrowVelocity = 400.0;
			}

			V *= ThrowVelocity;
			V += Velocity;
			A.Velocity = V;
		}
	}
}
 
function Falling()
{
	local float s;

	if (!bSuperjump)
	{
		//Limit his speed to 200 so puzzles arent' broken
		s = VSize2d( Velocity );
		if( s > GroundJumpSpeed )
			Velocity *= GroundJumpSpeed/s;

		//Change his ground speed so he cant go any faster then GroundJumpSpeed.	Will be restored when he lands.
		GroundSpeed = GroundJumpSpeed;
	}
}
 
function DoJump( optional float F )
{
	local float			TmpJumpZ;
	local vector		 v;
	local float			s;
	local Vector XNormal, YNormal, ZNormal, vOffset, vResult;
	local rotator Rate;
	local Mover baseMover;


	if (!bDoBufferedJump)
	{
		// MaxG: System for buffering jumps.
		JumpTime = Level.TimeSeconds;
	}

	//CM("Doing JUMP ==> " $ F);


	if(bKeepStationary || bInDuelingMode)
	{
		//CM("Returning because we're in dueling moed or bKeepStationary.");
		return;
	}

	// do not jump, if corraled by mover, 
	// otherwise harry will lose his base and can jump from coralled mover
	if(bCorraledByMover)
	{
		//CM("Returning because corraled.");
		return;
	}
	
	// if we are in ectoplasma then we cannot jump
	if(iEctoRefCount > 0)
	{
		// play the ectoJump anim
		PlayAnim(HarryAnims[HarryAnimSet].Jump , [TweenTime]0.2, [Type] HarryAnimType);
		HarryAnimChannel.DoEctoJump();
		//CM("Returning because ectoplasm.");
		return;
	}
	else if ( iSleepyAnimTimer > 0 )
	{
		// Play the sleepy jump. 
		PlayAnim(HarryAnims[HarryAnimSet].Jump , [TweenTime]0.2, [Type] HarryAnimType);
		HarryAnimChannel.DoSleepyJump();

		//CM("Returning because SleepyTimer.");
		return;
	}


	if ( Physics == PHYS_Walking )
	{
		//Not any more, now you can jump and cast
		//StopAiming();


		//if ( !bUpdating )
		//PlayOwnedSound(JumpSound, SLOT_Misc, 1.5, true, 1200, 1.0 );

		//if ( (Level.Game != None) && (Level.Game.Difficulty > 0) )
			//MakeNoise(0.1 * Level.Game.Difficulty);

		MountDelta = Location;

		// MaxG: Jump animation.
		if( VSize2D(Velocity) > 0 )
			PlayAnim( HarryAnims[HarryAnimSet].Jump2, [TweenTime]0.2, [Type] HarryAnimType);
		else
			PlayAnim( HarryAnims[HarryAnimSet].Jump , [TweenTime]0.2, [Type] HarryAnimType );
		
		
		if (!bSuperjump)
		{
			s = VSize2d(Velocity);
			if (s > GroundJumpSpeed)
			{
				Velocity *= GroundJumpSpeed / s;
			}

			GroundSpeed = GroundJumpSpeed;
		}
		

		// MaxG: wtf, was F not used in the stock code?!?!
		if (F == 0)
		{
			TmpJumpZ = JumpZ;
		}
		else
		{
			TmpJumpZ = F;
		}



		// MaxG: Jump less if sneaking.
		if (bSneakMove <= 0)
		{
			Velocity.Z = (Velocity.z * hyperJumpValue) + TmpJumpZ;
			
		}
		else
		{
			// MaxG: 70% height.
			Velocity.Z = TmpJumpZ * 0.70;
		}


		
		// if ((Base != Level) && (Base != None))
		// {
		// 	baseMover = Mover(Base);

		// 	if (baseMover != None)
		// 	{
		// 		if (baseMover.bInterpolating)
		// 		{
		// 			vResult = Vec(0,0,0);
		// 			vOffset = Location - Base.Location;
		// 			GetAxes(baseMover.Rotation, XNormal, YNormal, ZNormal);
		// 			Rate = baseMover.PhysRate * MoverInterpRate(baseMover, baseMover.PhysAlpha) * (baseMover.KeyRot[baseMover.KeyNum] - baseMover.OldRot);
		// 			//for each axis, project the offset onto the orthogonal plane and cross it with
		// 			//TODO: make sure we're taking the correct cross product
		// 			vResult += Rate.Roll * (XNormal Cross NormalReject(vOffset, XNormal));
		// 			vResult += Rate.Pitch * (YNormal Cross NormalReject(vOffset, YNormal));
		// 			vResult += Rate.Yaw * (ZNormal Cross NormalReject(vOffset, ZNormal));
		// 			//cancel the units
		// 			vResult *= RadsPerUnit;
		// 			Velocity += vResult;
		// 		}
		// 	}

		// 	Velocity += Base.Velocity;
		// }

		SetPhysics(PHYS_Falling);

		// if (VSize2D(OldVelocity) > VSize2D(Velocity))
		// {
		// 	Velocity = OldVelocity;
		// }

	}
}
 
function PlayinAir()
{
	if (AnimFalling != 'spongify')
	{
		PlayAnim(AnimFalling, [TweenTime]0.4, [Type]HarryAnimType);
	}
	else
	{
		LoopAnim(AnimFalling, [TweenTime]0.4, [Type]HarryAnimType);
	}
}

event Landed(vector HitNormal)
{	
	local float LastJumpTime;

	LastJumpTime = Level.TimeSeconds - JumpTime;
	
	LandedAnim = AnimFalling;
	LandedVelocity = Velocity;
	BaseChangeVelocity = Velocity;

	// MaxG: Patch bunnyhopping.
	//		 Addenum: This really just patches the "low jumps", but now with buffered inputs,
	//		 you can properly bunnyhop.
	if (bPatchBunnyHop)
	{
		Velocity.Z = 0;
	}

	if (!bSuperjump)
	{
		GroundSpeed = GroundRunSpeed;
	}
	
	
	power = Mass * KILOGRAMS_PER_UNIT * ((HitFloorSpeed * METERS_PER_UNIT) ** 2);
	
	MakeSneakNoise(power * SOUND_EFFICIENCY * GetNoiseFactor(GetTextureSound()));



	//CM("bSpellBallAction ==> " $ bSpellBallAction $ " | LastJumpTime ==> " $ LastJumpTime);

	// MaxG: System for buffering jumps.
	if (LastJumpTime <= BufferedJumpWindow && bSpellBallAction > 0)
	{
		bDoBufferedJump = true;
	}
}

function float CalculateFallDamage()
{
	// MaxG: A parabolic function for a damage curve. Similar to stock health damage.
	return (((HitFloorSpeed - 700) ** 2) * 0.001) + 20;
}

function StartAimSoundFX()
{
	if ( bInDuelingMode && (CurrentDuelSpell == 2) )
	{
		return;
	}

	// MaxG: Play it, but just a bit quieter.
	//PlaySound(Sound'Spell_aim',SLOT_Misc);
	PlaySound(Sound'Spell_aim', SLOT_Misc, 0.5, , , , True);


	if ( bInDuelingMode && (CurrentDuelSpell == 1) )
	{
		PlaySound(Sound'Dueling_MIM_buildup',SLOT_Interact);
	}
	else
	{
		PlaySound(Sound'spell_loop_nl',SLOT_Interact);
	}
}

state PlayerWalking
{
	// MaxG: Force stop rebounding.
	event EndState()
	{
		Super.EndState();

		bReboundingSpells = false;
	}

	event Landed(vector hitNormal)
	{
		local int	 i;

		// MaxG: Touching actor.
		local SpongifyPad SpongifyLandedActor;

		//clientMessage("landed: jump dist = " $VSize(Location-MountDelta) $ "	 tia="$fTimeInAir);
		
		Global.Landed(HitNormal);

		PlayLandedEmoteSound();

		PlayLandedSound();

		if (HarryAnimSet != HARRY_ANIM_SET_SLEEPY)
		{
			playanim(HarryAnims[HarryAnimSet].land, [TweenTime]0.25, [Type] HarryAnimType);
		}
		else
		{
			playanim(HarryAnims[HarryAnimSet].land, [TweenTime]1.5, [Type] HarryAnimType);
		}


		// Set our spell distance to the default if we landed from a spongify jump
		if( !bExtendedTargetting && AnimFalling == SpongifyFallAnim )
		{
			SpellCursor.SetLOSDistance(0);

			//SetParticleEmission(NoFallDamageFX[0], false);
			//SetParticleEmission(NoFallDamageFX[1], false);
		}
		
		// MaxG: Bad, recode.
		// See if we laneded on spongify!
		/*for (i = 0; i < ArrayCount(Touching); i++)
		{
			if (Touching[i].IsA('SpongifyPad') && SpongifyPad(Touching[i]).IsEnabled())
			{
				// We landed on a spongifyPad
				HitSpongifyPad = SpongifyPad(Touching[i]);
				
				// Set our spell distance longer so we can easily target the next spongify pad
				// The spell distance will revert back to normal once we land from a spongify pad
				if( !bExtendedTargetting )
					SpellCursor.SetLOSDistance(1024);

				// MaxG: Do not do a buffered jump.
				bDoBufferedJump = false;
			}
		}*/

		// MaxG: Check for Spongify landing.
		forEach TouchingActors(Class'SpongifyPad', SpongifyLandedActor)
		{
			// MaxG: Don't bounce if holding sneak.
			if (SpongifyLandedActor.IsEnabled() && bSneakMove <= 0)
			{
				// MaxG: Original code continues here.

				// We landed on a spongifyPad
				HitSpongifyPad = SpongifyLandedActor;
				
				// Set our spell distance longer so we can easily target the next spongify pad
				// The spell distance will revert back to normal once we land from a spongify pad
				if (!bExtendedTargetting)
				{
					SpellCursor.SetLOSDistance(1024);
				}

				// MaxG: Do not do a buffered jump.
				bDoBufferedJump = false;
			}
		}
		
		StopSpongifyEffects();

		// MaxG: Move fall damage into event BaseChanged.
		/*// We didn't land on a spongify pad and we are not falling from a spongify pad bounce
		if(AnimFalling != SpongifyFallAnim && HitSpongifyPad == None)
		{
			if ( hitFloorSpeed > 726)
			{
				TakeDamage(CalculateFallDamage(), self, location, vec(0,0,0), 'Falling' );
				//cm("Fall damage: " $ calculateFallDamage() * 1.2); // difficulty scale
				//cm("Health: " $ harryHealth.nCount);
			}
		}*/
		
		// Reset our falling animation
		AnimFalling = HarryAnims[HarryAnimSet].fall;

		// Reset our highestZ position
		fHighestZ = default.fHighestZ;
	}

	// MaxG: Handle fall damage.
	event BaseChanged(Actor OldBase, Actor NewBase)
	{
		Super.BaseChanged(OldBase, NewBase);

		if (NewBase != None && OldBase == None)
		{
			// MaxG: We landed; set the vel.
			BaseChangeVelocity -= NewBase.Velocity;

			HitFloorSpeed = abs(BaseChangeVelocity.Z);
			bHitFloor = true;
			
			//CM("BaseChange::" $ OldBase.Velocity $ "::" $ NewBase.Velocity);
			//CM("HitFloorSpeed::" $ HitFloorSpeed);
			//CM("BaseChangeVelocity::" $ BaseChangeVelocity);

			// MaxG: IDK why I need to do this, but if I don't then your
			//       falling vel gets stored into ledegrabs and you repeatedly
			//       take fall damage. This will probably cause a bug :)
			BaseChangeVelocity = Vec(0, 0, 0);

			if (LandedAnim != SpongifyFallAnim)
			{
				if (HitFloorSpeed > 726)
				{
					TakeDamage(CalculateFallDamage(), Self, Location, Vec(0,0,0), 'Falling' );
					//cm("Fall damage: " $ calculateFallDamage() * 1.2); // difficulty scale
					//cm("Health: " $ harryHealth.nCount);
				}
			}
		}
		// MaxG: This must be reset now.
		BaseChangeVelocity = Vec(0, 0, 0);


		// // MaxG: Check for walking off of a thingy.
		// if ( NewBase == None && OldBase != None )
		// {
		//     CM("BaseChange::Oldbase.Velocity = " $ OldBase.Velocity $ " :: NewBase.Velocity = " $ NewBase.Velocity);
		//     CM("PrevVelocity = " $ Velocity);
		//     Velocity += OldBase.Velocity;
		//     CM("Velocity = " $ Velocity);
		// }
	}
	
	event PlayerTick(float DeltaTime)
	{
		local actor a;
		local float d;
		local actor ca;

		Global.PlayerTick(DeltaTime);


		if( bTempKillHarry )
		{
			bTempKillHarry = false;
			KillHarry(true);
		}

		if( GetHealthCount() <= 0 )
		{
			KillHarry(true);
			return;
		}

		if( bIsAiming && HarryAnimChannel.IsInState('stateCasting') && bAltFire == 0 )
		{
			
				StopAimSoundFX();
				
				if( bInDuelingMode )
				{
					if(DuelSpells[CurrentDuelSpell] == class'spellDuelExpelliarmus')
					{
					 	PlaySound(Sound'HPSounds.Magic_sfx.Dueling_EXP_swoosh');
						HarryAnimChannel.GotoState( 'stateDefenceCast' );
					}
					else
						HarryAnimChannel.GotoState( 'stateDuelingCast' );
				}
				else
				if(	 SpellCursor.IsLockedOn() //If harry's locked on, he's in normal aim mode, so cast
					 || bHarryUsingSword && baseWand(weapon).SwordChargedUpEnough() //if using sword, and sword is charged up enough
					 || !baseWand(weapon).bAutoSelectSpell // if you're not in autoselect spell mode
					)
				{
					// MaxG: Fast casting.
					HarryAnimChannel.CastingRate = CastingRate;

					HarryAnimChannel.GotoState( 'stateCast' );
					/*if( bCastFastSpells )	//Old, may not be needed in HP2
					{
						AnimFrame = 0.09;
						AnimRate = 3;
					}*/
				}
				else
				{
					// We don't have a lock so lets stop casting
					HarryAnimChannel.GotoState('stateCancelCasting');

					// Stop Aiming
					StopAiming();					
				}
			//}
		}

		//Try and save how long you've been falling, and what you're original height was when you started falling
		ProcessFalling(DeltaTime);

		PlayerMove(DeltaTime);

		if( CarryingActor != none )
		{
			CarryingActor.setLocation( weaponLoc );//- vect(0,0,1 );
			CarryingActor.SetRotation( weaponRot );

			/*//Also, look for a spacebar throw
			if( hpconsole(player.console).bSpacePressed )
			{
				hpconsole(player.console).bSpacePressed = false;
				AltFire(0);
			}*/
		}
		
		// If we landed on a spongify pad then bounce harry
		if( HitSpongifyPad != None && HitSpongifyPad.IsEnabled() )
		{
			DoJump(0);
			HitSpongifyPad.OnBounce(self);
			AnimFalling = SpongifyFallAnim;
			PlayinAir();
			//cam.SetPitch(-8000);
			HitSpongifyPad = None;
			CreateSpongifyEffects();

			// MaxG: Enable FX.
			//SetParticleEmission(NoFallDamageFX[0], true);			
			//SetParticleEmission(NoFallDamageFX[1], true);	
		}
		
		// HP2 cam
		if( cam.IsInState('StateStandardCam') )//|| cam.IsInState('StateBossCam') )
		{
			// Force our desired Yaw to what the camera's yaw is, in this way harry will
			// always "lookAt" what the camera is looking at.
			DesiredRotation.Yaw = cam.rotation.Yaw & 0xFFFF;

			//SetRotation( DesiredRotation );
		}

		// MaxG: Do a buffered jump.
		if (bDoBufferedJump)
		{
			// MaxG: Preserve velocity.
			if (VSize2D(Velocity) > VSize2D(LandedVelocity))
			{
				// MaxG: If less than one, only apply if going fast.
				if (BufferedJumpVelocityModifier < 1.0)
				{
					if ( VSize2D(Velocity) > (GroundRunSpeed * 1.08) )
					{
						Velocity.X *= BufferedJumpVelocityModifier;
						Velocity.Y *= BufferedJumpVelocityModifier;
					}
				}
				else
				{
					//CM("Using actual velocity ::" $ Velocity);
					Velocity.X *= BufferedJumpVelocityModifier;
					Velocity.Y *= BufferedJumpVelocityModifier;
				}
			}
			else
			{
				// MaxG: If less than one, only apply if going fast.
				if (BufferedJumpVelocityModifier < 1.0)
				{
					if ( VSize2D(Velocity) > (GroundRunSpeed * 1.08) )
					{	
						Velocity.X = LandedVelocity.X * BufferedJumpVelocityModifier;
						Velocity.Y = LandedVelocity.Y * BufferedJumpVelocityModifier;
					}
				}
				else
				{
					//CM("Applying LandedVelocity ::" $ LandedVelocity);
					Velocity.X = LandedVelocity.X * BufferedJumpVelocityModifier;
					Velocity.Y = LandedVelocity.Y * BufferedJumpVelocityModifier;
				}
			}

			DoJump(JumpZ);

			bDoBufferedJump = false;
		}
	}
}

state CarpePull extends PlayerWalking
{
	ignores AltFire, Fire, DoJump, ProcessSneak, mount;
	
	event BeginState()
	{	
		bLockOutForward = true;
		bLockOutBackward = true;
		bLockOutStrafeLeft = true;
		bLockOutStrafeRight = true;
		//bKeepStationary = true;

		HarryAnimSet = HARRY_ANIM_SET_SWORD;

		PlayInAir();
	}
}

function Drop() {}

state CarpeSwinging extends PlayerWalking
{
	ignores ProcessSneak, ProcessSummonCracker;
	
	function Drop()
	{	
		if (CarpeStatue != None)
		{
			CarpeStatue.DropHarry();
		}

		CarpeStatue = None;
	}

	function StartAiming(bool bSword)
	{
		Drop();

		Super.StartAiming(bSword);
	}

	event Landed(Vector HitNormal)
	{
		Drop();
		Super.Landed(HitNormal);
	}

	event BeginState()
	{		
		AnimFalling = SpongifyFallAnim;
		SpellCursor.SetLOSDistance(CarpeCursorDistance);
		bNoFallingDamage = True;

		//SetParticleEmission(NoFallDamageFX[0], false);
		//SetParticleEmission(NoFallDamageFX[1], false);
	}

	event EndState()
	{
		HarryAnimSet = HARRY_ANIM_SET_MAIN;
		AnimFalling = SpongifyFallAnim;
		PlayInAir();
		//CM("ENDING ANIMSET " $ HarryAnimSet);
		//CM("ENDING ANIM ==> " $ HarryAnims[HarryAnimSet].Fall);

		if (CarpeStatue != None)
		{
			Drop();
		}
	}

	/*event EndState()
	{
		Super.EndState();
		//SetParticleEmission(NoFallDamageFX[0], true);
		//SetParticleEmission(NoFallDamageFX[1], true);
	}*/
	
	// Dynamically play an animation based on what Harry is doing.
	event PlayerTick(float DeltaTime)
	{
		local float fStatueZDistance;

		//CM("In CarpeSwinging " $ Rand(1000));

		if (Base != None)
		{
			CarpeStatue.DropHarry();
		}

		// MaxG: Drop if jump.
		if (bSpellBallAction > 0)
		{
			Drop();
		}

		// MaxG: Hack to stop from rebounding while carpe'ing.
		if (bReboundingSpells)
		{
			bReboundingSpells = false;
		}

		fStatueZDistance = carpeStatue.location.z - location.z;
		
		if (CarpeStatue.IsInState('Pulling'))
		{
			if (fStatueZDistance < CarpeHangAnimDist)
			{
				HarryAnimSet = HARRY_ANIM_SET_SWINGING;
			}
			else
			{
				HarryAnimSet = HARRY_ANIM_SET_HANGING;
			}

			//CM("LOOPING ANIMSET " $ HarryAnimSet);
			//CM("LOOPING ANIM ==> " $ HarryAnims[HarryAnimSet].Fall);
			
			LoopAnim(HarryAnims[HarryAnimSet].Fall);
		}

		
		
		Super.PlayerTick(DeltaTime);
	}
}
 
state SneakCaught extends PlayerWalking
{
	ignores Fire, AltFire, AnimEnd, Bump, DoJump, ProcessSneak, Mount, Touch, UnTouch, ReflectSpells;

	event BeginState()
	{
		PlayInAir();

		// MaxG: This gets set when climbing.
		if (Physics == PHYS_Projectile)
		{
			// MaxG: Stop from floating.
			SetPhysics(PHYS_Falling);
		}

		// MaxG: Make the turn smoother since MGHarry has a higher turn rate.
		RotationRate.Yaw = 30000;
	}

	event Landed(Vector HitNormal)
	{
		Super.Landed(HitNormal);

		Velocity = Vec(0, 0, 0);
		Acceleration = Vec(0, 0, 0);
	}

	event PlayerTick(float DeltaTime)
	{
		if (Base != None)
		{
			// MaxG: Play a caught-like anim.
			LoopAnim('look_mirror', 0.5);

			// MaxG: TODO: Verify this is needed.
			// MaxG: A hack that... partially works.
			//PlayFacialAnim('look_mirror', true, 0.0, 0.0);
		}
		else
		{
			ProcessFalling(DeltaTime);
		}

		// MaxG: Handle cloak opacity interpolation.
		targetOpacity = Default.Opacity;
		TargetAmbientGlow = Default.AmbientGlow;
		opacityRate = 2.5;
		goInvis(DeltaTime);
	}
}

/*function bool DetectBoost(float MinAmount)
{
	if (bAllowBrightnessBoosts)
	{
		return false;
	}

	if (VSize(Location - OldLocation) > MinAmount)
	{
		return true;
	}

	return false;
}*/

// MaxG: Update FX.
// state Mounting extends Mounting
// {
// 	event BeginState()
// 	{
//         HitFloorSpeed = 0;
// 		Super.BeginState();

// 		//SetParticleEmission(NoFallDamageFX[0], false);
// 		//SetParticleEmission(NoFallDamageFX[1], false);

// 		// MaxG: Reset boost counter.
// 		//BoostCounter = 0;

// 	}

// 	// event PlayerTick(float DeltaTime)
// 	// {
// 	// 	// MaxG: Detect a boost.
// 	// 	if (DetectBoost(DetectedBoostSize))
// 	// 	{
// 	// 		BoostCounter++;

// 	// 		//CM("BoostCounter ==> " $ BoostCounter);
// 	// 	}

// 	// 	if (BoostCounter >= BoostsBeforeDetected)
// 	// 	{
// 	// 		LoadLevel(CheatsDetectedMap);
// 	// 	}

// 	// 	Super.PlayerTick(DeltaTime);
// 	// }
// }

state MountFinish
{
	/*event BeginState()
	{
		Super.BeginState();

		SetParticleEmission(NoFallDamageFX[0], false);
		SetParticleEmission(NoFallDamageFX[1], false);
	}*/

	event EndState()
	{
		Super.EndState();

		// MaxG: System for buffering jumps.
		if (bSpellBallAction > 0)
		{
			LandedVelocity = Vec(0, 0, 0);
			bDoBufferedJump = true;
		}
	}

	/*event PlayerTick(float DeltaTime)
	{
		// MaxG: Detect a boost.
		if (DetectBoost(DetectedBoostSize))
		{
			BoostCounter++;

			//CM("BoostCounter ==> " $ BoostCounter);
		}

		if (BoostCounter >= BoostsBeforeDetected)
		{
			LoadLevel(CheatsDetectedMap);
		}

		Super.PlayerTick(DeltaTime);
	}*/
}

// MaxG: TODO :: BUG :: Animation tween rate randomly increases
//		 when you actually reflect the spell... wtf.
function bool HandleSpellPixie(BaseSpell Spell, Vector HitLocation)
{
	if (bReboundingSpells || bFraserMode || bInvulnerable)
	{
		return false;
	}
	else if (!IsInState('stateDead'))
	{
		DoJump(64);
		Velocity += Spell.Velocity * Vec(0.15, 0.15, 0.15);
		AnimFalling = 'spongify';
		
		TakeDamage(8, Pawn(Spell.Owner), Vect(0,0,0), Velocity, '' );

		RestoreVelocity = Velocity;

		GoToState('Dazzled');
		HarryAnimChannel.GoToState('Dazzeled');

		return true;
	}

	return false;
}

// MaxG: Animnotify in cast_expeliarmus
function ReboundNearbySpells()
{
	local BaseSpell Spell;

	//CM("Reflecting nearby spells...");

	// MaxG: Do not store spells.
	BaseWand(Weapon).SetCurrentSpell(None);

	ForEach RadiusActors(Class'BaseSpell', Spell, SpellReflectRadius)
	{
		if (Spell.IsA('SpellDuelExpelliarmus'))
		{
			break;
		}

		if (Spell.Owner == Self)
		{
			CM("Skipping " $ Spell $ ", for I am its overlord.");
			break;
		}
		
		//CM("Reflecting " $ Spell);
		Spell.Reflect(Self, Spell.SpellCharge, Spell.Speed * Spell.SpellSpeedReflectMultiplier);

		Spell.SeekSpeed *= Spell.SpellSeekSpeedReflectMultiplier;

		BaseWand(Weapon).FlashChargeParticles(class'MGParticleExpelShield');

		AttachToBone(MGHarryWand(Weapon).FlashParticle, 'Dummy18');


		MGHarryWand(Weapon).FlashParticle.RelativeLocation.Y = 32;
		MGHarryWand(Weapon).FlashParticle.RelativeLocation.Z = 8;
		MGHarryWand(Weapon).FlashParticle.RelativeRotation.Pitch = -16384;


		fTimeAfterShield = 1;
		
		HandleSpellIncantationSound(SPELL_DuelExpelliarmus);
	}	
}

state Dazzled extends PlayerWalking
{
	ignores AltFire, Fire, ReflectSpells;
	
	event BeginState()
	{
		Super.BeginState();

		Velocity = RestoreVelocity;

		// MaxG: Reverse the player input once dazzled by the spell.
		bReverseInput = true;
	}

	event EndState()
	{
		Super.EndState();

		bReverseInput = false;
	}
}



// MaxG: No stopping.
state statePickupItem extends PlayerWalking
{
	begin:
		HarryAnimType = AT_Combine;

		HarryAnimChannel.GotoState('statePickupItem');

		PlayAnim('Pickup',1.0,0.151,[Type]HarryAnimType);

		GotoState('PlayerWalking');
}

// MaxG: Drop on cutscene start.
function DisablePlayerInput()
{
	Super.DisablePlayerInput();

	DropCarryingActor();
}

function DropLevitatingObject()
{
	if (WingardiumObject != None)
	{
		WingardiumObject.GoToState(WingardiumObject.PreLevitateState);
		WingardiumObject.Velocity = WingardiumObject.WingVelocity;
		WingLevitateFX.SetEmission(false);
		WingardiumObject = None;

		GoToState('PlayerWalking');

		Velocity = RestoreVelocity;
	}
}

// MaxG: Recursively check for the Half-life flying bug.
function bool OnLevitatingActor(Pawn SpaghettiNMeatballs)
{
	if (bAllowSurfing)
	{
		return false;
	}

	if (SpaghettiNMeatballs.Base == WingardiumObject)
	{
		return true;
	}
	else if (!SpaghettiNMeatballs.Base.IsA('HPawn'))
	{
		return false;
	}
	else
	{
		return OnLevitatingActor( Pawn(SpaghettiNMeatballs.Base) );
	}
}

state LevitatingObject
{
	ignores ProcessSneak, ProcessSummonCracker;

	event BeginState()
	{
		local Rotator wing_fx_rot;

		Super.BeginState();      

		RotationRate = WingardiumRotationRate;

		HarryAnimSet = HARRY_ANIM_SET_LEVITATING;

		WingardiumDist = VSize(Location - WingardiumObject.Location);

		GroundRunSpeed = WingardiumGroundSpeed;
		GroundSpeed = WingardiumGroundSpeed;

		Velocity = RestoreVelocity;

		WingLevitateFX.SetLocation(WingardiumObject.Location - Vec( 0, 0, (WingardiumObject.CollisionHeight) ) );
		WingLevitateFX.SetEmission(true);

		wing_fx_rot.Pitch = WingLevitateFX.Rotation.Pitch;
		wing_fx_rot.Roll  = WingLevitateFX.Rotation.Roll;
		wing_fx_rot.Yaw   = WingardiumObject.Rotation.Yaw;

		WingLevitateFX.SourceWidth.Base = WingardiumObject.CollisionWidth;
		WingLevitateFX.SourceDepth.Base = WingardiumObject.CollisionRadius;
		WingLevitateFX.SetRotation(wing_fx_rot);
	}

	event EndState()
	{
		Super.EndState();

		// MaxG: Will happen when entering a cutscene.
		DropLevitatingObject();

		HarryAnimSet = HARRY_ANIM_SET_MAIN;

		RotationRate = Default.RotationRate;

		GroundRunSpeed = Default.GroundRunSpeed;
		GroundSpeed = GroundRunSpeed;

		// MaxG: Fix air anims.
		AnimFalling = HarryAnims[HarryAnimSet].Fall;
		PlayInAir();
	}

	function StartAiming(bool bSword)
	{
		DropLevitatingObject();
	}

	// MaxG: Force the dueling idle animation to play.
	function name GetCurrIdleAnimName()
	{
		IdleNums = 0;

		return HarryAnims[HarryAnimSet].Idle;
	}

	event Bump(Actor Other)
	{
		if (Other == WingardiumObject && !bAllowSurfing)
		{
			DropLevitatingObject();
		}

		Super.Bump(Other);
	}

	event Touch(Actor Other)
	{
		if (Other == WingardiumObject && !bAllowSurfing)
		{
			DropLevitatingObject();
		}

		Super.Touch(Other);
	}

	// MaxG: Drop on cutscene start.
	function DisablePlayerInput()
	{
		Super.DisablePlayerInput();

		DropLevitatingObject();
	}

	event PlayerTick(float DeltaTime)
	{
		local Vector target_location;
		local Vector added_location;
		local Vector move_direction;
		local Vector inital_location;
		local Vector smooth_location;
		local float object_distance;

		RestoreVelocity = Velocity;

		// MaxG: Drop if jump.
		if (bSpellBallAction > 0)
		{
			DropLevitatingObject();
		}

		// MaxG: Patch surfing.
		if (!bAllowSurfing)
		{
			if ( OnLevitatingActor(Self) )
			{
				DropLevitatingObject();
			}
		}

		if (Base == None)
		{
			DropLevitatingObject();
		}

		// MaxG: Just in case.
		if (WingardiumObject == None)
		{
			DropLevitatingObject();
		}

		// MaxG: Drop if too far away.
		if ( VSize(Location - WingardiumObject.Location) >= (WingardiumDropDist) )
		{
			DropLevitatingObject();
		}

		WingLevitateFX.SetLocation(WingardiumObject.Location - Vec( 0, 0, (WingardiumObject.CollisionHeight) ) );
		
		inital_location = WingardiumObject.Location;

		object_distance = FClamp(WingardiumDist, WingardiumMinDist, WingardiumMaxDist);

		// MaxG: Prevent wall stuckyness.
		if (WingardiumObject.BumpActorLocation != Vec(0, 0, 0))
		{
			smooth_location = WingardiumObject.Location - WingardiumObject.BumpActorLocation;
			smooth_location *= WingardiumObject.WingardiumSmoothDistance;

			WingardiumObject.BumpActorLocation = Vec(0, 0, 0);
		}

		// MaxG: In front of Harry.
		target_location = Cam.Location + (Cam.vForward * (Cam.CurrentSet.fLookAtDistance + object_distance));

		// MaxG: Helps make it not get stuck.
		target_location += WingardiumOffset;

		target_location += smooth_location;

		added_location = WingardiumObject.Location;

		move_direction = target_location - added_location;

		WingardiumObject.Velocity = move_direction * WingardiumObject.WingardiumMoveSpeed;
		
		WingardiumObject.WingVelocity = WingardiumObject.Velocity;

		Super.PlayerTick(DeltaTime);

		GroundRunSpeed = WingardiumGroundSpeed;
		GroundSpeed = WingardiumGroundSpeed;
	}
}


defaultproperties
{
	//ghostGroundJumpSpeed=60
	//ghostGroundRunSpeed=60
	//ghostJumpZ=130
	//Mesh=SkeletalMesh'MGModels.skHarryImprovedMesh'
	//NoFallDamageFXClass=Class'MGHP2.MGNoFallDamageFX'
	AirControl=0.5
	AmbientGlow=24
	AnimFalling="Fall"
	//bAllowBrightnessBoosts=false
	bCloak=false
	bDisableMap=True
	bDoBufferedJump=false
	bInheritBaseVel=True
	//BoostCounter=0
	//BoostsBeforeDetected=3
	bPatchBunnyHop=true
	bSaveOnLevelLoad=false
	bSuperjump=true
	BufferedJumpVelocityModifier=1.0
	BufferedJumpWindow=0.25
	CastingRate=3
	//CheatsDetectedMap="SeriousRoom.unr"
	//DetectedBoostSize=32.0
	EmoteVolume=0.65
	FootstepSounds(0)=MultiSound'MGSounds.FootSteps.rug_harry'
	FootstepSounds(1)=MultiSound'MGSounds.FootSteps.wood_harry'
	FootstepSounds(2)=MultiSound'MGSounds.FootSteps.stone_harry'
	FootstepSounds(3)=MultiSound'MGSounds.FootSteps.cave_harry'
	FootstepSounds(4)=MultiSound'MGSounds.FootSteps.cloud_harry'
	FootstepSounds(5)=MultiSound'MGSounds.FootSteps.wet_harry'
	FootstepSounds(6)=MultiSound'MGSounds.FootSteps.grass_harry'
	FootstepSounds(7)=MultiSound'MGSounds.FootSteps.metal_harry'
	FootstepSounds(8)=MultiSound'MGSounds.FootSteps.ecto_harry'
	FootstepSounds(9)=MultiSound'MGSounds.FootSteps.acid_harry'
	FootstepVolume=4.0
	GroundJumpSpeed=210
	GroundWalkSpeed=70
	HyperJumpValue=1.0
	IncantationSounds(0)=MultiSound'MGSounds.Incantations.Alohomora'
	IncantationSounds(1)=MultiSound'MGSounds.Incantations.Flipendo'
	IncantationSounds(2)=MultiSound'MGSounds.Incantations.Lumos'
	IncantationSounds(3)=MultiSound'MGSounds.Incantations.Skurge'
	IncantationSounds(4)=MultiSound'MGSounds.Incantations.Diffindo'
	IncantationSounds(5)=MultiSound'MGSounds.Incantations.rictusempra'
	IncantationSounds(6)=MultiSound'MGSounds.Incantations.spongify'
	IncantationSounds(7)=MultiSound'MGSounds.Incantations.mimblewimble'
	IncantationSounds(8)=MultiSound'MGSounds.Incantations.Expelliarmus'
	IncantationVolume=0.7
	InvisibleAmbientGlow=72
	InvisibleValue=0.50
	LandVolume=0.7
	Mesh=SkeletalMesh'MGModels.skMGHarryMesh'
	OpacityReCloakRate=0.5
	OpacityUnCloakRate=3.0
	RotationRate=(Pitch=20000,Yaw=131072,Roll=3072)
	WingardiumRotationRate=(Pitch=20000,Yaw=70000,Roll=3072)
	SneakAccelRate=128
	SneakGroundSpeed=60
	sneakNoiseReductionFactor=0.50
	SpellReflectRadius=96
	SoundLandMetal=MultiSound'MGSounds.Landing.LandMetal'
	SoundLandRug=MultiSound'MGSounds.Landing.LandRug'
	SoundLandStone=MultiSound'MGSounds.Landing.LandStone'
	SoundLandWet=MultiSound'MGSounds.Landing.LandWet'
	SoundLandWood=MultiSound'MGSounds.Landing.LandWood'
	SpellFXSounds(0)=Sound'HPSounds.Magic_sfx.cast_Alohomora'
	SpellFXSounds(1)=Sound'HPSounds.Magic_sfx.cast_Flipendo'
	SpellFXSounds(2)=Sound'HPSounds.Magic_sfx.cast_Lumos'
	SpellFXSounds(3)=Sound'HPSounds.Magic_sfx.cast_Skurge'
	SpellFXSounds(4)=Sound'HPSounds.Magic_sfx.cast_Diffindo'
	SpellFXSounds(5)=Sound'HPSounds.Magic_sfx.cast_Rictusempra'
	SpellFXSounds(6)=Sound'HPSounds.Magic_sfx.cast_Spongify'
	SpellFXSounds(7)=Sound'HPSounds.Magic_sfx.cast_Expelliarmus'
	SpellFXSounds(8)=Sound'HPSounds.Magic_sfx.cast_Mimblewimble'
	SpellFXSounds(9)=Sound'MGSounds.Main.spell_carpe_cast_alt'
	SpellFXSounds(10)=Sound'MGSounds.Magic.Cast_Wingardium'
	SurfaceCave=1.0
	SurfaceCloud=0.25
	SurfaceGrass=0.55
	SurfaceMetal=1.0
	SurfaceRug=0.24
	SurfaceStone=0.85
	SurfaceWet=1.0
	SurfaceWood=0.75
	CarpeCursorDistance=1024
	CarpeHangAnimDist=64
	WingardiumMaxDist=704
	WingardiumDropDist=832
	WingardiumMinDist=96
	WingardiumMoveDist=500
	WingardiumScrollDist=128
	WingardiumGroundSpeed=160
	WingardiumOffset=(X=0,Y=0,Z=20)
	bAllowSurfing=False
	GroundJumpSpeed=230
	GroundRunSpeed=230
	GroundSpeed=230
}