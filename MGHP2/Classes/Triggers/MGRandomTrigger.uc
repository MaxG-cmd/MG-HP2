class MGRandomTrigger extends Trigger;

// MaxG: Make all RandChance add up to 100 when using!
struct RandomEvent
{
    var() Name RandEvent;
    var() float RandChance;
};

var() Array<RandomEvent> RandomEvents;

function Name GetRandomEvent()
{
    local float sum_chance;
    local float random_chance;
    local int i;

    random_chance = RandRange(0.0, 100.0);
    sum_chance = 0;

    // CM("random_chance ==> " $ random_chance);

    // MaxG: Loop over the list of all events.
    for (i = 0; i < RandomEvents.Length; i++)
    {
        sum_chance += RandomEvents[i].RandChance;

        // CM("On item #" $ i $ ". Event ==> " $ RandomEvents[i].RandEvent);
        // CM("sum_chance ==> " $ sum_chance);
        // CM("Test ==> " $ random_chance $ " <= " $ sum_chance $ "?");

        // MaxG: Random event selected.
        if (random_chance <= sum_chance)
        {
            // CM("True");
            return RandomEvents[i].RandEvent;
        }

        // CM("False");
    }

    return 'None';
}

function Activate(Actor Other, Pawn EventInstigator)
{
    Super.Activate(Other, EventInstigator);

    TriggerEvent(GetRandomEvent(), Self, EventInstigator);
}

defaultproperties
{
    bDoActionWhenTriggered=True
}