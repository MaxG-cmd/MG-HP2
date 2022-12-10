class MGChocolateFrog extends ChocolateFrog;

var() int HealthToAdd;
var() float InvulnerableTime;

var MGInvulnerabilityManager GMode;

event PostBeginPlay()
{
    // MaxG: Make this public.
    nPickupIncrement = HealthToAdd;
}

event Touch(Actor Other)
{
    // MaxG: The normal touch routine is absolute garbage
    //       and lets you get invuln and not pick up. WHY DOESN'T IT PICK UP?!
    //Super.Touch(Other);

    if (Other == PlayerHarry)
    {
        GMode = Spawn(Class'MGInvulnerabilityManager');
        
        GMode.SetInvulnerableTime(InvulnerableTime);

        DoPickupProp();
    }
}

state PickupProp extends PickupProp
{
    ignores Touch;
}

defaultproperties
{
    nPickupIncrement=0

    HealthToAdd=50

    InvulnerableTime=8

    bInstantPickup=True
    PickupFX=Class'MGHP2.MGParticleFrogPickup'
}