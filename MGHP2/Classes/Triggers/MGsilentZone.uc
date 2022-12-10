class MGsilentZone extends Triggers;

event Touch(Actor Other)
{	
	if (Other.isa('MGHarry'))
	{
		MGHarry(Other).bSilent = true;
		//CM("bSilent: True");
	}
}

event UnTouch(Actor Other)
{	
	if (Other.isa('MGHarry'))
	{
		MGHarry(Other).bSilent = false;
		//CM("bSilent: False");
	}
}

defaultproperties
{
	bStatic=false
	bCanTeleport=true
    DrawType=DT_Sprite
    CollisionRadius=32
    CollisionWidth=32
    CollisionHeight=32
    CollideType=CT_Box
	bCollideActors=true
    bCollideWorld=false
    bBlockActors=false
    bBlockPlayers=false
	bProjTarget=false
	Texture=Texture'Engine.S_Flag'
}