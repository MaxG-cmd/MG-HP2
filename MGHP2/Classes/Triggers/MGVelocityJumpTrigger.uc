class MGVelocityJumpTrigger extends Trigger;

var() Vector TriggerVelocity;
var() float TriggerJumpZ;
var() Name TargetActorName;
var() bool bSetVelocity;
var() bool bMustHaveBase;
var Actor TargetActor;

event PostBeginPlay()
{
    Local Actor A;

    Super.PostBeginPlay();

    ForEach AllActors(Class'Actor', A)
    {
        if (A.Name == TargetActorName)
        {
            TargetActor = A;
            break;
        }
    }
}

event Activate(Actor Other, Pawn EventInstigator)
{
    Super.Activate(Other, EventInstigator);

    if (bMustHaveBase)
    {
        if (TargetActor.Base == None)
        {
            return;
        }
    }

    if (TriggerVelocity != Vec(0, 0, 0))
    {
        if (bSetVelocity)
        {
            TargetActor.Velocity = TriggerVelocity;
        }
        else
        {
            TargetActor.SetPhysics(PHYS_Falling);
            TargetActor.Velocity += TriggerVelocity;
        }
    }
    
    if (TriggerJumpZ != 0)
    {
        PlayerPawn(TargetActor).DoJump(TriggerJumpZ);
    }
}


defaultproperties
{
    TriggerVelocity=(X=0,Y=0,Z=0)
    TriggerJumpZ=245
    TargetActor="None"
    bDoActionWhenTriggered=True
    bSetVelocity=False
    bMustHaveBase=True
}