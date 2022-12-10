class MGCloakTrigger extends Trigger;

var() enum eCloakType
{
	CT_EnableCloak,
	CT_DisableCloak,
	CT_ToggleCloak,
	CT_SmartToggle
} CloakType;

var(CloakSounds) Sound EnableCloakSound;
var(CloakSounds) float EnableVolume;
var(CloakSounds) Sound DisableCloakSound;
var(CloakSounds) float DisableVolume;

var bool bHasCloak;

var MGHarry Harry;


event BeginPlay()
{
	Super.BeginPlay();

	forEach AllActors(Class'MGHarry', Harry)
	{
		break;
	}
}

function PlayCloakSound()
{
	// MaxG: Play the sound in 2D.
	if (Harry.bCloak)
	{
		PlaySound(DisableCloakSound, , DisableVolume, , , , True);
	}
	else
	{
		PlaySound(EnableCloakSound, , EnableVolume, , , , True);
	}
}

function HandleCloak()
{
	switch (CloakType)
	{
		case CT_EnableCloak:
			if (!Harry.bCloak)
			{
				PlayCloakSound();
				Harry.bCloak = true;
			}
			break;
		case CT_DisableCloak:
			if (Harry.bCloak)
			{
				if (Harry.Opacity < 0.75)
				{
					PlayCloakSound();
				}
				Harry.bCloak = false;
			}
			break;
		case CT_ToggleCloak:
			PlayCloakSound();
			Harry.bCloak = !Harry.bCloak;
		case CT_SmartToggle:
			// MaxG: Only toggle the cloak if Harry has acquired the cloak.
			if (bHasCloak)
			{
				PlayCloakSound();
				Harry.bCloak = !Harry.bCloak;
			}
			else if (Harry.bCloak)
			{
				PlayCloakSound();
				Harry.bCloak = false;
				bHasCloak = true;
			}

			break;
	}
}

event Activate(Actor Other, Pawn EventInstigator)
{
	Super.Activate(Other, EventInstigator);

	HandleCloak();
}

defaultproperties
{
    DrawScale=1.0
	Texture=Texture'MGTech.Icons.sneakPointIcon'
	Style=STY_Translucent
	EnableCloakSound=Sound'MGSounds.Main.HAR_invisible'
	EnableVolume=0.66
	DisableCloakSound=Sound'MGSounds.Main.HAR_visible'
	DisableVolume=0.66
	bHasCloak=false
}