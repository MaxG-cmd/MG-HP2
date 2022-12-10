class MGHarryWand extends baseWand;

struct WandGlowFX
{
	var() Class<BaseSpell> WandSpellClass;

	var() Class<ParticleFX> WandGlowParticleClass;

	var ParticleFX WandParticle;
};

var() Array<WandGlowFX> WandGlowParticles;

var ParticleFX DefaultParticle;

var ParticleFX FlashParticle;


// MaxG:  TODO Bug. Save/load will not purge old ones.
event BeginPlay()
{
	local int i;
	local float WandEndOffset;

	WandEndOffset = 8.0;

	DefaultParticle = Spawn(fxChargeParticleFXClass);
	SetParticleEmission(DefaultParticle, false);


	// MaxG: Attach.
	//AttachToBone(DefaultParticle, 'WandAttach');
	//DefaultParticle.RelativeLocation.Z = WandEndOffset;

	for (i = 0; i < WandGlowParticles.Length; i++)
	{
		// MaxG: Spawn the particle.
		if (WandGlowParticles[i].WandParticle == None)
		{
			// MaxG: Do not spawn duplicate particles.
			if (WandGlowParticles[i].WandGlowParticleClass == None || WandGlowParticles[i].WandGlowParticleClass == fxChargeParticleFXClass)
			{
				WandGlowParticles[i].WandParticle = DefaultParticle;
				//CM("Set " $ WandGlowParticles[i].WandSpellClass $ "'s particle to " $ DefaultParticle);
			}
			else
			{
				WandGlowParticles[i].WandParticle = Spawn(WandGlowParticles[i].WandGlowParticleClass);
				//CM("Spawned " $ WandGlowParticles[i].WandParticle);
			}

			// MaxG: Make them not emit.
			SetParticleEmission(WandGlowParticles[i].WandParticle, false);

			// MaxG: Attach.
			//AttachToBone(WandGlowParticles[i].WandParticle, 'WandAttach');
			//WandGlowParticles[i].WandParticle.RelativeLocation.Z = WandEndOffset;
		}
	}

	Super.BeginPlay();
}


function StartGlowingWand(Class<baseSpell> GlowSpellClass)
{
	SetWandGlowFX(GlowSpellClass);

	bGlowingWand = True;

	//CM("Entered StartGlowingWand ==> " $ GlowSpellClass);
}

function StopGlowingWand()
{
	bGlowingWand = False;

	if (fxChargeParticles != None)
	{
		SetParticleEmission(fxChargeParticles, false);
	}

	//CM("Entered StopGlowingWand");
}

function StartChargingSpell(bool bChargeSpell, optional bool in_bHarryUsingSword, optional Class<baseSpell> ChargeSpellClass)
{
	//CM("Entered StartChargingSpell ==> " $ ChargeSpellClass);


	bSpellCharges = bChargeSpell;

	if (in_bHarryUsingSword)
	{
		fxSwordParticles.EnableEmission(True);
	}
	else
	{
		SetWandGlowFX(ChargeSpellClass);
	}

	fSpellChargeTime = 0.0;
	fSpellCharge = 0.0;
	fSwordFXTime = 0.0;
}

function CastSpell(optional actor aTarget, optional vector aTargetOffset, optional class<basespell> spellClass)
{
	if (aTarget != None)
	{
		// MaxG: Sort of a hack to make Carpe instant. This should be changed if any more instant spells are added.
		if (aTarget.eVulnerableToSpell == SPELL_LocomotorWibbly && !playerHarry.isInState('stateDead'))
		{
			StopChargingSpell();

			playerHarry.HandleSpellIncantationSound(SPELL_LocomotorWibbly);

			aTarget.gotoState('Pulling');

			
			
			return;
		}
	}
	
	super.CastSpell(aTarget, aTargetOffset, spellClass);
}


function Class<baseSpell> GetClassFromSpellType(ESpellType eSpellType)
{
	switch (eSpellType)
	{
		case SPELL_Flipendo:
			return class'spellFlipendo';

		case SPELL_Lumos:
			return class'spelllumos';

		case SPELL_Alohomora:
			return class'spellAlohomora';

		case SPELL_Skurge:
			return class'spellSkurge';

		case SPELL_Rictusempra:
			return class'spellRictusempra';

		case SPELL_Diffindo:
			return class'spellDiffindo';

		case SPELL_Spongify:
			return class'spellSpongify';

		case SPELL_LocomotorWibbly:
			return Class'MGSpellCarpe';

		case SPELL_WingardiumLeviosa:
			return Class'MGSpellWingardium';

		case SPELL_Reparo:
			return class'MGspellReparo';

		case SPELL_DuelRictusempra:
			return class'spellDuelRictusempra';

		case SPELL_DuelMimblewimble:
			return class'spellDuelMimblewimble';

		case SPELL_DuelExpelliarmus:
			return class'spellDuelExpelliarmus';
	}

	fxChargeParticleFXClass = Default.fxChargeParticleFXClass;

	return None;
}

function ChooseSpell(ESpellType ESpellType, optional bool bForceSelection)
{
	//CM("Entered ChooseSpell ==> " $ ESpellType);
	SetCurrentSpell(GetClassFromSpellType(ESpellType), bForceSelection);

	// MaxG: Set the effect.
	SetWandGlowFX(GetClassFromSpellType(ESpellType));
}

event Tick(float DeltaTime)
{
	local Vector WandEndPoint;
	local float fScale;
	local int k;

	Super.Tick(DeltaTime);

	//CM("fxChargeParticles ==> " $ fxChargeParticles);
	//CM("fxChargeParticleFXClass ==> " $ fxChargeParticleFXClass);


	if ((Pawn(Owner) != None) && (Pawn(Owner).Weapon == self))
	{
		if (bUsingSword)
		{
			if ( fxSwordParticles.bEmit )
			{
				fSwordFXTime += DeltaTime;
			}

			fSwordFXTime = FMin(fSwordFXTime,fSwordFXTimeSpan);

			if ((fSwordFXTime >= 1.89999998) && (fSwordFXTime - DeltaTime < 1.89999998))
			{
				PlaySound(Sound'sword_loop',SLOT_Interact);
			}

			fScale = fSwordFXTime / fSwordFXTimeSpan;
			WandEndPoint = Pawn(Owner).WeaponLoc - (Vec(0.0,0.0,fSwordLength * fScale) >> Pawn(Owner).WeaponRot);
			fxSwordParticles.SetLocation(WandEndPoint);
			ScaleParticles(fxSwordParticles,fSwordFXStartScale + (fSwordFXEndScale - fSwordFXStartScale) * fScale);
		}
		else if (fxChargeParticles.bEmit || TheLumosLight.bLumosOn)
		{
			if (bSpellCharges && (fSpellCharge < 1.0))
			{
				fSpellChargeTime = FMin(fSpellChargeTime + DeltaTime,fSpellChargeTimeSpan);
				fSpellCharge = FMin(1.0,fSpellChargeTime / fSpellChargeTimeSpan);

				// MaxG: Do not scale the particles! This is awful!
				//ScaleParticles(fxChargeParticles,GetChargeParticleFXScale(fSpellCharge));
			}

			/*WandEndPoint = GetWandEndPoint();

			if (fxChargeParticles != None)
			{
				fxChargeParticles.SetLocation(WandEndPoint);
			}*/
		}
	}

	WandEndPoint = GetWandEndPoint();

	/*if (fxChargeParticles != None)
	{
		fxChargeParticles.SetLocation(WandEndPoint);
	}*/

	// MaxG: Update location of all particles.
	for (k = 0; k < WandGlowParticles.Length; k++)
	{
		if (WandGlowParticles[k].WandParticle != None)
		{
			WandGlowParticles[k].WandParticle.SetLocation(WandEndPoint);
		}
	}

	if (TheLumosLight.bLumosOn)
	{
		TheLumosLight.UpdateLocation(WandEndPoint);
	}
}


// MaxG: Override to not call Shutdown().
function StopChargingSpell()
{
	bSpellCharges = False;
	fSpellChargeTime = 0.0;
	fSpellCharge = 0.0;

	SetParticleEmission(fxChargeParticles, false);
	SetParticleEmission(fxSwordParticles, false);
}

function SetWandGlowFX(Class<baseSpell> NewSpellFX)
{
	local int i;

	//CM("Entered SetWandGlowFX ==> " $ NewSpellFX);

	if (fxChargeParticleFXClass != NewSpellFX)
	{
		if (fxChargeParticles != None)
		{
			SetParticleEmission(fxChargeParticles, false);
		}

		if (NewSpellFX == None)
		{
			fxChargeParticles = DefaultParticle;

			SetParticleEmission(DefaultParticle, true);

			return;
		}

		for (i = 0; i < WandGlowParticles.Length; i++)
		{

			//CM("WandSpellClass ==> " $ WandGlowParticles[i].WandSpellClass);

			// MaxG: If class is of same type, unhide the particle.
			if (NewSpellFX == WandGlowParticles[i].WandSpellClass)
			{
				fxChargeParticles = WandGlowParticles[i].WandParticle;

				fxChargeParticleFXClass = WandGlowParticles[i].WandGlowParticleClass;

				SetParticleEmission(fxChargeParticles, true);

				//CM("Updated fxChargeParticles ==> " $ fxChargeParticles);

				//CM("Updated fxChargeParticleFXClass ==> " $ fxChargeParticleFXClass);

				return;
			}
		}

		CM("[" $ Name $ "]::SetWandGlowFX ==> Warning: Failed to set effect. Class " $ NewSpellFX $ " not found in array.");
	}
}

function ResetWandGlowFX()
{
	local int i;

	//CM("Entered ResetWandGlowFX");
	//CM("fxChargeParticleFXClass ==> " $ fxChargeParticleFXClass);

	if (fxChargeParticleFXClass != Default.fxChargeParticleFXClass)
	{
		//CM("Entered ResetWandGlowFX");
		//CM("fxChargeParticleFXClass ==> " $ fxChargeParticleFXClass);

		fxChargeParticleFXClass = Default.fxChargeParticleFXClass;

		if (fxChargeParticles != None)
		{
			SetParticleEmission(fxChargeParticles, false);
		}

		fxChargeParticles = DefaultParticle;

		SetParticleEmission(DefaultParticle, true);
	}
}

function SetParticleEmission(ParticleFX Emitter, bool bNewEmit)
{
	//CM("Entered SetParticleEmission ==> " $ Emitter);


	if (Emitter.IsA('MGParticleFX'))
	{
		MGParticleFX(Emitter).SetEmission(bNewEmit);
	}
	else
	{
		Emitter.EnableEmission(bNewEmit);
	}
}


// MaxG: Override this function so it doesn't crash.
function FlashChargeParticles(Class<ParticleFX> classFX)
{
	// MaxG: Spawn a new explosion.
	FlashParticle = Spawn(classFX);
}

// MaxG: Override to spawn spell at wand endpoint.
function Projectile ProjectileFire2 (Class<Projectile> ProjClass, float ProjSpeed, bool bWarn, optional bool bUseWeaponForProjRot, optional Actor aTarget)
{
  local Vector vStart;
  local Vector vEnd;
  local float fDistance;
  local Rotator R;
  local Projectile proj;

  Owner.MakeNoise(Pawn(Owner).SoundDampening);
  if ( bUsingSword )
  {
    vStart = Pawn(Owner).WeaponLoc - (Vec(0.0,0.0,fSwordLength * fSwordFXTime / fSwordFXTimeSpan) >> Pawn(Owner).WeaponRot);
    vEnd = harry(Owner).SpellCursor.Location;
    if ( bUseWeaponForProjRot )
    {
      R = Pawn(Owner).WeaponRot;
    } else {
      if ( vEnd == vect(0.00,0.00,0.00) )
      {
        R = harry(Owner).Cam.Rotation;
      } else {
        R = rotator(vEnd - vStart);
      }
    }
    proj = Spawn(ProjClass,Owner,,vStart,R);
  } else {
    //vStart = Pawn(Owner).WeaponLoc + (Vec(0.0,0.0,20.0) >> Pawn(Owner).WeaponRot);
    vStart = GetWandEndPoint();
    if ( bUseWeaponForProjRot )
    {
      R = Pawn(Owner).WeaponRot;
    } else {
      if ( Owner.IsA('harry') )
      {
        R = harry(Owner).Cam.Rotation;
      } else {
        R = Pawn(Owner).Rotation;
      }
    }
    proj = Spawn(ProjClass,Owner,,vStart,R);
    if ( aTarget.IsA('BossRailMove') )
    {
      baseSpell(proj).SeekSpeed *= 0.25;
    }
    if ( proj == None )
    {
      if ( Pawn(Owner).IsA('PlayerPawn') )
      {
        vStart = PlayerPawn(Owner).Location + Vec(0.0,0.0,PlayerPawn(Owner).EyeHeight);
      } else //{
        if ( Pawn(Owner).IsA('Pawn') )
        {
          vStart = Pawn(Owner).Location;
        }
      //}
      proj = Spawn(ProjClass,Owner,,vStart,R);
    }
  }
  return proj;
}

defaultproperties
{
	fxChargeParticleFXClass=Class'MGHP2.MGWandGlow'

	WandGlowParticles(0)=(WandSpellClass=Class'MGSpellCarpe',WandGlowParticleClass=Class'MGHP2.MGWandCarpe')
	WandGlowParticles(1)=(WandSpellClass=Class'MGSpellReparo',WandGlowParticleClass=Class'MGHP2.MGWandGlow')
	WandGlowParticles(2)=(WandSpellClass=Class'spellAlohomora',WandGlowParticleClass=Class'MGHP2.MGWandAlohomora')
	WandGlowParticles(3)=(WandSpellClass=Class'spellDiffindo',WandGlowParticleClass=Class'MGHP2.MGWandDiffindo')
	WandGlowParticles(4)=(WandSpellClass=Class'spellDuelExpelliarmus',WandGlowParticleClass=Class'MGHP2.MGWandGlow')
	WandGlowParticles(5)=(WandSpellClass=Class'spellDuelMimblewimble',WandGlowParticleClass=Class'MGHP2.MGWandGlow')
	WandGlowParticles(6)=(WandSpellClass=Class'spellDuelRictusempra',WandGlowParticleClass=Class'MGHP2.MGWandGlow')
	WandGlowParticles(7)=(WandSpellClass=Class'spellFlipendo',WandGlowParticleClass=Class'MGHP2.MGWandFlipendo')
	WandGlowParticles(8)=(WandSpellClass=Class'spellLumos',WandGlowParticleClass=Class'MGHP2.MGWandLumos')
	WandGlowParticles(9)=(WandSpellClass=Class'spellRictusempra',WandGlowParticleClass=Class'MGHP2.MGWandRictusempra')
	WandGlowParticles(10)=(WandSpellClass=Class'spellSkurge',WandGlowParticleClass=Class'MGHP2.MGWandSkurge')
	WandGlowParticles(11)=(WandSpellClass=Class'spellSpongify',WandGlowParticleClass=Class'MGHP2.MGWandSpongify')
	WandGlowParticles(12)=(WandSpellClass=Class'MGSpellWingardium',WandGlowParticleClass=Class'MGHP2.MGWandWingardium')

    fAutoHitDistance=96.0

	//ThirdPersonMesh=SkeletalMesh'MGModels.MGWand'
	//Mesh=SkeletalMesh'MGModels.MGWand'
	
	//DrawScale3D=(X=1.25,Y=1.25,Z=1.3)
}