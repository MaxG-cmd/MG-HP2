class MGActorVelocityVecTrigger extends Triggers;

var() Class<Actor> ObjectTriggerClass;
var() float MinTriggerSpeed;
var() float MinTriggerAngle;
var() bool bUse2DVelocity;
var() bool bDebugLog;


function bool EnoughToActivate(Actor Other)
{
    local Vector other_direction;
    local Vector distance;
    local float other_speed;
    local float calculated_angle;

    other_direction = Other.Velocity;
    distance = Other.Location - Location;
    
    if (bUse2DVelocity)
    {
        other_speed = VSize2D(other_direction);

        other_direction *= Vec(1, 1, 0);
        distance *= Vec(1, 1, 0);
    }
    else
    {
        other_speed = VSize(other_direction);
    }

    if (bDebugLog)
    {
        CM("other_speed = " $ other_speed);
    }

    if (other_speed >= MinTriggerSpeed)
    {
        calculated_angle = Normal(other_direction) Dot Normal(distance);

        if (bDebugLog)
        {
            CM("calculated_angle = " $ calculated_angle);
        }

        // MaxG: Make sure the object is moving toward this trigger.
        if (calculated_angle <= MinTriggerAngle)
        {
            return true;
        }
    }

    return false;
}

event Touch(Actor Other)
{
    if ( !ClassIsChildOf(Other.Class, ObjectTriggerClass) )
    {
        return;
    }

    if ( EnoughToActivate(Other) )
    {
        TriggerEvent(Event, Self, Level.PlayerHarryActor);
        Destroy();
    }

    Super.Touch(Other);
}

defaultproperties
{
    MinTriggerAngle=-0.9
    MinTriggerSpeed=280
    bUse2DVelocity=True
    bDebugLog=False
    ObjectTriggerClass=Class'MGHP2.MGWingardiumBlock'
    Texture=Texture'Engine.S_Trigger'
}