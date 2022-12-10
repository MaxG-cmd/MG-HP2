class MGBeanRotated extends MGBean;

/*
 * A jellybean that spawns with a randomized rotation.
 */

var() int RandRotation;

event BeginPlay()
{
	local rotator rRandRot;
	
	rRandRot.yaw = rand(RandRotation);
	rRandRot.pitch = rand(RandRotation);
	rRandRot.roll = rand(RandRotation);
	
	//SetRotation(rRandRot);
	DesiredRotation = rRandRot;
}

defaultproperties
{
	RandRotation=131072
	AmbientGlow=150
	Skin=Texture'HProps.Skins.skBeanPurpleTex0'
	//bRotateToDesired=True
	//RotationRate=(Pitch=1000,Yaw=1000,Roll=1000)
}