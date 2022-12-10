class MGSoundLoader extends Actor;

// MaxG: Any sounds you want to preload.

var() Array<Sound> SoundsToLoad;

defaultproperties
{
	bStatic=True
	bHidden=True
	bMovable=False
	bCanTeleport=False
	Texture=Texture'Engine.Engine.S_Inventory'
	CollisionRadius=0
	CollisionHeight=0
	DrawScale=3
}