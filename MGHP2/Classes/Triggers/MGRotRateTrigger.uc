class MGRotRateTrigger extends Trigger;

var() Rotator NewRotationRate;
var() Name RotActorTag;

var Actor RotActor;

event BeginPlay()
{
    ForEach AllActors(Class'Actor', RotActor, RotActorTag)
    {
        break;
    }

    Super.BeginPlay();
}

function Activate(Actor Other, Pawn EventInstigator)
{
    RotActor.RotationRate = NewRotationRate;    

    Super.Activate(Other, EventInstigator);
}


defaultproperties
{
    NewRotationRate=(Pitch=20000,Yaw=131072,Roll=3072)
    bDoActionWhenTriggered=True
}