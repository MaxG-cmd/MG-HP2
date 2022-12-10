class MGGravityTrigger extends Trigger;

var() vector Gravity; //new gravity
var() vector defaultGravity;

function SetGrav()
{
    local ZoneInfo Z; //only works in the zone this actor is in
    
    forEach allActors(class'ZoneInfo', Z)
    {
		if (Z.ZoneGravity == defaultGravity)
		{
			Z.ZoneGravity = Gravity;
		}
		else
		{
			Z.ZoneGravity = defaultGravity;
		}
    }
}

state() OtherTriggerTurnsOn
{
	event Trigger(Actor Other, Pawn EventInstigator)
	{
		SetGrav();
		Super.Trigger(Other,EventInstigator);
	}	
}

defaultproperties
{
	defaultGravity=(z=-512)
	Gravity=(z=-256)
}