class MGMagicBean extends MGBean;

var() EPhysics physics1;
var() EPhysics physics2;
var() float fDelay1;
var() float fDelay2;
var bool bTimer1Over;

struct MaxMin
{
	var() float Max;
	var() float Min;
};
var MaxMin VelRange;

Function BeginPlay() {
	
	SetTimer(fDelay1, true);
	
}

Function Timer() {
	
	if (bTimer1Over == False) {
		
		setCollision(true, true, false);
		SetPhysics(physics1);
		Velocity.X=velocity.x + RandRange(VelRange.min,VelRange.max);
		Velocity.y=velocity.y + RandRange(VelRange.min,VelRange.max);
		Velocity.z=velocity.z + RandRange(VelRange.min,VelRange.max);
		bTimer1Over = True;
		SetTimer(fDelay2, false);
		
	} else {
		
		SetPhysics(physics2);
		
	}
	
}


defaultproperties
{
	Physics1=PHYS_Projectile
	Physics2=PHYS_Falling
	fDelay1=1.3
	fDelay2=12
	bRotateToDesired=False
	bCollideActors=False
	bBlockActors=False
	CollisionRadius=12
	AmbientGlow=130
	VelRange=(Min=-250,Max=250)
	//attachedparticleclass=class'MGparticlebeansparkles'
	Skin=Texture'HProps.Skins.skBeanPurpleTex0'
}