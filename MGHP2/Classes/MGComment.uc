class MGComment extends Actor;

var() string comment;

event PreBeginPlay()
{
	Destroy();
}

defaultproperties
{
	Texture=Texture'MGhp2.MGcommentTex'
	DrawScale=0.75
	Style=STY_Masked
	bHidden=True
}