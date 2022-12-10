class MGCandleFlare extends MGProp;

event BeginPlay()
{
	Super.BeginPlay();

	// MaxG: Make it look the same in game as it does in ed.
	DrawScale *= 0.5;
}

defaultproperties
{
    bSpriteRelativeScale=True
    DrawType=DT_Sprite
    Texture=Texture'MGTech.flares.LanternFlare'
	Mesh=None
    DrawScale=1.8
    CollisionRadius=4
    CollisionHeight=4
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
    bProjTarget=False
    bBlockCamera=False
}