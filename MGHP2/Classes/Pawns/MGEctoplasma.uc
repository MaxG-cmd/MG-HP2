class MGEctoplasma extends Ectoplasma;

// MaxG: Allow for shrinkifying.
event Trigger(Actor Other, Pawn EventInstigator)
{
		if (bGrowOnEvent)
		{
            if (IsInState('StateHiding') || IsInState('StateHidingQuiet'))
            {
                    GoToState('StateShowing');
            }
            else
            {
                    GoToState('StateHidingQuiet');
            }
		}
		else
		{
				GoToState('StateHiding');
		}
}

state() StateHidingQuiet extends StateHiding
{
		event BeginState()
		{
            bCollideWorld = False;

            eVulnerableToSpell = SPELL_None;

            fTimeSpent = 0.0;

            if ( (aSlimedHPawn != None) && aSlimedHPawn.IsA('harry') )
            {
                    Harry(aSlimedHPawn).EctoRefSub();
            }

            aSlimedHPawn = None;
		}
}