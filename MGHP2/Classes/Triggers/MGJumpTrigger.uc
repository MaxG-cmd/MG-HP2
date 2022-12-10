class MGJumpTrigger extends Triggers;

var() Pawn JumpPawn;
var() Actor JumpTarget;
var() Name JumpAnim;
var() float JumpAnimRate;
var() float JumpTime;

var bool bTriggered;

event Trigger(Actor Other, Pawn EventInstigator)
{
    bTriggered = true;
}

function LaunchActor()
{
    JumpPawn.SetPhysics(PHYS_Falling);

    if (JumpAnim != 'None')
    {
        JumpPawn.PlayAnim(JumpAnim, JumpAnimRate);
    }

    JumpPawn.Velocity = ComputeTrajectoryByTime(JumpPawn.Location, JumpTarget.Location, JumpTime);
}

event Tick(float DeltaTime)
{
    // MaxG: LauchActor does FA if I don't wait a tick. :|
    if (bTriggered)
    {
        LaunchActor();
        bTriggered = false;
    }
}

defaultproperties
{
    JumpAnimRate=1.0
    JumpTime=1.75
    bTriggered=False
}