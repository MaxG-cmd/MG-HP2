class MGParticleFX extends ParticleFX;

// MaxG: Thanks, Andrew!
 
var() Array<class<ParticleFX>>  AttachedParticleClasses;
var() Array<Vector>             AttachedParticleOffset;

var   Array<ParticleFX>         AttachedParticles;

var float DeltaBrightness;
var float CurrentBrightness;

var() float ChangeRate;
var() float DefaultLightBrightness;

event PostBeginPlay()
{
	local int i;

	// Metallicafan212:    Super it
	Super.PostBeginPlay();
	
	// Metallicafan212:    Create the particles
	CreateAttachedParticles();

	if (Default.LightBrightness != 0)
	{
		DefaultLightBrightness = Default.LightBrightness;
	}
}

function CreateAttachedParticles()
{
	local int i;
	local Vector offset;
	
	// Metallicafan212:    Do an early break if we have none
	if (AttachedParticleClasses.Length == 0)
		return;
		
	for (i = 0; i < AttachedParticleClasses.Length; i++)
	{
		// Metallicafan212:    Spawn it
		if (i <= AttachedParticleOffset.Length)
		{
			offset = AttachedParticleOffset[i];
		}
		else
		{
			offset = vect(0, 0, 0);
		}
		
		AttachedParticles[i] = ParticleFX(FancySpawn(AttachedParticleClasses[i], self,, location + offset));
		
		// Metallicafan212:    Make C++ deal with it
		AttachedParticles[i].setRotation(AttachedParticleClasses[i].default.rotation);
		AttachedParticles[i].setPhysics(PHYS_Trailer);

		// MaxG: Update emission.
		AttachedParticles[i].bEmit = bEmit;
		
		// Metallicafan212:    Set the offset
		if (offset != vect(0, 0, 0))
		{
			AttachedParticles[i].bTrailerPrePivot = true;
			AttachedParticles[i].PrePivot = offset;
		}
	}
}

function SetEmission(bool bNewEmit)
{
	local int i;

	// MaxG: Update this particle.
	bEmit = bNewEmit;

	for (i = 0; i < AttachedParticles.Length; i++)
	{
		// MaxG: Make the attached particles update.
		AttachedParticles[i].bEmit = bEmit;
	}
}

function ToggleEmission()
{
	local int i;

	// MaxG: Update this particle.
	bEmit = !bEmit;

	for (i = 0; i < AttachedParticles.Length; i++)
	{
		// MaxG: Make the attached particles update.
		AttachedParticles[i].bEmit = bEmit;
	}
}

event Destroyed()
{
	local int i;

	for (i = 0; i < AttachedParticles.Length; i++)
	{
		// MaxG: Kill children.
		AttachedParticles[i].Destroy();
	}

	Super.Destroyed();
}

// MaxG: Interpolate the brightness to make it less jarring.
event Tick(float DeltaTime)
{
	if (LightRadius > 0)
	{
		if (bEmit)
		{
			DeltaBrightness = ChangeRate * DeltaTime;
		}
		else
		{
			DeltaBrightness = -ChangeRate * DeltaTime;
		}

		//CM("[" $ Name $ "].Default.LightBrightness = " $ Default.LightBrightness);
		//CM("DeltaBrightness ==> " $ DeltaBrightness);

		CurrentBrightness += DeltaBrightness;

		//CM("LightBrightness ==> " $ LightBrightness);
		//CM("[------------]");

		CurrentBrightness = FClamp(CurrentBrightness, 0, DefaultLightBrightness);

		LightBrightness = FClamp(CurrentBrightness, 0, DefaultLightBrightness);
	}

    Super.Tick(DeltaTime);
}


defaultproperties
{
	CurrentBrightness=0
    ChangeRate=160
	DefaultLightBrightness=0
    MinTimeBtwEmit=2
    MaxTimeBtwEmit=10
    MinEmitPeriod=0.1
    MaxEmitPeriod=0.9
}