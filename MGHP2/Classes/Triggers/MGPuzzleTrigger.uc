class MGPuzzleTrigger extends PuzzleTrigger;

function MyToggleDoor()
{
    local Trigger t;

    if (Event != '')
    {
        foreach AllActors(Class 'Trigger', t, Event)
        {
            // MaxG: The original version only works with a mover???
            t.TriggerEvent(t.Event, None, None);
        }
    }
}