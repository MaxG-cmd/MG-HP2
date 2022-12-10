class MGGridMover extends GridMover;

var() Class<BaseSpell> VulnerableToSpellClass;

state() BumpMove
{
    // MaxG: Only work for one spell.
	event Bump(Actor Other)
	{
        if (!Other.IsA(VulnerableToSpellClass.Name))
        {
			return;
        }

        Super.Bump(Other);
    }
}

defaultproperties
{
    VulnerableToSpellClass=Class'HGame.SpellFlipendo'
}