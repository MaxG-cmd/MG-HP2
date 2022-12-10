class MGActorStateTrigger extends Trigger;

var() bool bMustBeTouching;
var() Name StateToSendTo;
var() Actor StateActor;

function Activate(Actor Other, Pawn EventInstigator)
{
    local Actor temp_touching_actor;
    local bool b_touching;


    b_touching = false;

    Super.Activate(Other, EventInstigator);

    if (StateActor != None)
    {
        // MaxG: Must be touching the trigger to send to state.
        if (bMustBeTouching)
        {
            ForEach TouchingActors(Class'Actor', temp_touching_actor)
            {
                if (temp_touching_actor == StateActor)
                {
                    b_touching = true;
                    break;
                }
            }

            if (b_touching)
            {
                StateActor.GoToState(StateToSendTo);
            }
            else
            {
                CM("[" $ Name $ "]::Activate ==> [" $ StateActor.Name $ "] is not touching; state unchanged.");
            }
        }
        else
        {
            StateActor.GoToState(StateToSendTo);
        }
    }
    else
    {
        CM("[" $ Name $ "]::Activate ==> StateActor is none.");
    }
}

defaultproperties
{
    bDoActionWhenTriggered=True
    TriggerType=TT_ClassProximity
    bCollideActors=False
    bMustBeTouching=False
}