class MGDestroyTrigger extends Trigger;

var() Array<Actor> ActorsToDestroy;
var() Array<Name> ActorTagsToDestroy;

event Activate(Actor Other, Pawn EventInstigator)
{
    local int i;
    local Actor A;

    Super.Activate(Other, EventInstigator);

    if (ActorsToDestroy.Length > 0)
    {
        for (i = 0; i < ActorsToDestroy.Length; i++)
        {
            ActorsToDestroy[i].Destroy();
        }
    }

    // MaxG: Additional functionality in case you need to destroy based on tag.
    if (ActorTagsToDestroy.Length > 0)
    {
        forEach AllActors(Class'Actor', A, ActorTagsToDestroy[i])
        {
            A.Destroy();
        }
    }
}

defaultproperties
{
    bDoActionWhenTriggered=True
}