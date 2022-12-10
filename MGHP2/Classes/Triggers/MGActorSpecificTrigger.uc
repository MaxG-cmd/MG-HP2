class MGActorSpecificTrigger extends Trigger;

struct SpecificActor
{
	// MaxG: Name of the actor.
	var() Name CurrentActorName;

	// MaxG: Still able to activate the trigger?
	var bool bStillRelevant;
};

var() Array<SpecificActor> SpecificActors;

event BeginPlay()
{
	local Actor A;
	local int i;

	Super.BeginPlay();

	for (i = 0; i < SpecificActors.Length; i++)
	{
		SpecificActors[i].bStillRelevant = true;
	}

	// MaxG: Making this work would mean overriding a lot of stuff and I don't want to.
	//		 Don't need the functionality anyway.
	bTriggerOnceOnly = false;
}

// MaxG: Actor is only relevant if it is in the list and bStillRelevant.
function bool IsRelevant(Actor Other)
{
	local int i;

	//CM("Checking relevancy to " $ Other);

	// MaxG: Check every actor.
	for (i = 0; i < SpecificActors.Length; i++)
	{
		// MaxG: Is Other in the array?
		if (Other.Name == SpecificActors[i].CurrentActorName)
		{
			// MaxG: Other is in the array, but is it relevant?
			if (SpecificActors[i].bStillRelevant)
			{
				return true;
			}
		}
	}

	return false;
}

// MaxG: Override Activate.
function Activate(Actor Other, Pawn Instigator)
{
	//local Actor A;
	local int i;

	// MaxG: Find the actor in the list and disable it.
	for (i = 0; i < SpecificActors.Length; i++)
	{
		if (Other.Name == SpecificActors[i].CurrentActorName)
		{
			SpecificActors[i].bStillRelevant = false;
		}
	}

	//CM("Activated by " $ Other);

	Super.Activate(Other, Instigator);
}