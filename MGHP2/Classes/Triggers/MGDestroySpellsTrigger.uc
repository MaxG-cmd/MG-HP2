class MGDestroySpellsTrigger extends Trigger;

function Activate(Actor Other, Pawn EventInstigator)
{
    local BaseSpell S;

    Super.Activate(Other, EventInstigator);

    // MaxG: Destroy all spells.
    foreach AllActors(Class'HGame.BaseSpell', S)
    {
        S.Destroy();
    }
}

defaultproperties
{
    bDoActionWhenTriggered=True
    TriggerType=TT_ClassProximity
}