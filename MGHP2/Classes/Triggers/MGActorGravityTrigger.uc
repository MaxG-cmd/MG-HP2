	class MGActorGravityTrigger extends Triggers;

/*
* Class to artificially flavor the gravity of
* a given actor by the user. If the user fails
* to properly understand the variable names,
* they will be fed to the Unreal Goblin.
*/

// The user will provide a list
// of actors that can be affected 
// by this gravitification
var() Name actorTag; 

// The user can provide a desired
// new gravity. This will be converted
// into Unreal units. Default gravity is
// -512 u/s.
var() vector desiredGravity;


var bool bActive;


auto state() ToggleGravity
{
	function Trigger(actor other, pawn eventInstigator)
	{
		bActive = !bActive;
	}
}

state() ForceGravity
{
	function Trigger(actor other, pawn eventInstigator)
	{
		bActive = true;
	}
	
	function UnTrigger(actor other, pawn eventInstigator)
	{
		bActive = false;
	}
}

event Tick(float deltaTime)
{
	local Pawn p;
	
	if (bActive)
	{
		forEach allActors(Class'Pawn', p, actorTag)
		{
			if (p.physics == PHYS_Falling)
			{
				p.velocity += deltaTime * (desiredGravity - p.region.zone.zoneGravity);
			}
		}
	}
}

defaultproperties
{
	bActive=False
	Texture=Texture'HGame.HiddenPawn'
}