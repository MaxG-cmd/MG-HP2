class MGbronzecauldron extends bronzecauldron;

/*
 * (MaxG)
 * (02/19/2020)
 *
 * This is a class that allows the designer to customize
 * the sound profile of the bronzecauldron class.
 * 
 * This class also adds randomness to the spawned bean
 * direction.
 *
 */

var() float fSoundVolume;
var() Sound hitSound;

var() class<Actor> spawnFlash;

state turnover
{
	function GenerateObject()
	{
		local vector dir, vel;
		local actor newspawn;
		local rotator	SpawnDirection;
		local int  iBean;
		local bool bPlayBeanSound;
        local rotator randDirection;

		bPlayBeanSound = true;

		if (bRandomBean)
        {
			SetupRandomBeans();
        }

        
		for (iBean = 0; iBean < iNumberOfBeans; iBean ++)
		{
			vel = ObjectStartVelocity[iBean];
			vel.x +=  (rand(64));

			SpawnDirection = rotation;
			SpawnDirection.yaw += 5000;

			vel = vel >> SpawnDirection;

			dir = ObjectStartPoint[iBean];

			dir = dir >> SpawnDirection;
			dir = dir + location;

			newspawn=Spawn(spawnFlash,,,dir,rot(0,0,0));
			newSpawn=Spawn(EjectedObjects[iBean],,, dir);

			if (newspawn.isa('chocolatefrog') || newspawn.isa('wizardcardicon'))
			{
				// Special case with frogs, let them jump
				vel.z *= 2;
				newSpawn.Velocity = vel * 2;
			}
			else
			{
				// Special case with beans, let them spill out		
				newSpawn.Velocity = vel;
				newSpawn.SetPhysics(PHYS_Falling);
                
                randDirection.pitch = rand(131072);
                randDirection.yaw = rand(131072);
                randDirection.roll = rand(131072);
                
                newSpawn.SetRotation(randDirection);
				newSpawn.DesiredRotation = randDirection;
			}
		}

		if(bPlayBeanSound)
		{
			switch(Rand(3))
			{
				case 0: PlaySound(sound'HPSounds.Magic_sfx.spawn_bean01', , fSoundVolume);   break;
				case 1: PlaySound(sound'HPSounds.Magic_sfx.spawn_bean02', , fSoundVolume);   break;
				case 2: PlaySound(sound'HPSounds.Magic_sfx.spawn_bean03', , fSoundVolume);   break;
			}
		}
	}

  begin:
	bProjTarget = false;
	eVulnerableToSpell = SPELL_None;

	PlaySound(hitSound, , fSoundVolume);
    
	PlayAnim('tipover'/*, [RootBone] 'move'*/);
	FinishAnim();
	GenerateObject();
	LoopAnim('tipped'/*, [RootBone] 'move'*/);
}

defaultproperties
{
    hitSound=sound'HPSounds.General.cauldron_flip'
    spawnFlash=class'Spawn_flash_2'
	fSoundVolume=0.65
	CollisionHeight=22
	bAlignBottomAlways=true
}