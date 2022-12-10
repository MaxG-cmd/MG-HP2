class MGDestroyTouchTrigger extends Trigger;

event Activate(Actor Other, Pawn EventInstigator)
{
    Super.Activate(Other, EventInstigator);

    // MaxG: Other activated the trigger, so destroy it.
    Other.Destroy();
}

defaultproperties
{
    bDoActionWhenTriggered=True
}