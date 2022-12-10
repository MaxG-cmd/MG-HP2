class MGCutscene extends Cutscene;


// MaxG: Force DelayLevelFadein to work.
event PostBeginPlay()
{
	Super.PostBeginPlay();

	// Metallicafan212: Set if we need to delay the fade in
	if (bLevelLoadStarts && bDelayLevelFadeIn)
	{
		Harry(Level.PlayerHarryActor).FadeRate = 0;
	}
}

defaultproperties
{
	bDelayLevelFadeIn=true
}