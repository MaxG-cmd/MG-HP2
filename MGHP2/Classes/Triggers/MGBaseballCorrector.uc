class MGBaseballCorrector extends Trigger;

var() Vector SnapVelocity;

event Activate(Actor Other, Pawn EventInstigator)
{
	if (!Other.IsA('MGSpellBaseball'))
	{
		return;
	}

	Other.Velocity = SnapVelocity;
}

defaultproperties
{
	ReTriggerDelay=2.0
}