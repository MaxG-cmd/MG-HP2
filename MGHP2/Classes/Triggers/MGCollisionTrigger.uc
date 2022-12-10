class MGCollisionTrigger extends Trigger;

// SetCollision function: setCollision(optional bool NewColActors, optional bool NewBlockActors, optional bool NewBlockPlayers)

var() Array<Name> CollisionTags;

var() bool bNewCollideActors;
var() bool bNewBlockActors;
var() bool bNewBlockPlayers;

var() class<Actor>    CollisionClass;

event Activate(Actor Other, Pawn EventInstigator)
{
	local int i;
	local Actor A;
	Super.Activate(Other, EventInstigator);

	for (i = 0; i < CollisionTags.Length; i++)
	{
		forEach AllActors(CollisionClass, A, CollisionTags[i])
		{
			A.SetCollision(bNewCollideActors, bNewBlockActors, bNewBlockPlayers);
		}
	}
}


defaultproperties
{
    CollisionClass=class'Actor'
	bDoActionWhenTriggered=True
}