class MGWizardCrackerPickup extends MGPropActive;

var() const bool bUseRandomTexture;
var() Array<Texture> RandomSkins;
var() int RandRotation;

event PreBeginPlay()
{
	local int RandTexture;

	Super.PreBeginPlay();

	if (bUseRandomTexture)
	{
		RandTexture = Rand(RandomSkins.Length);
		
		Skin = RandomSkins[RandTexture];
	}
}

event BeginPlay()
{
	local Rotator rRandRot;
	
	if (RandRotation != 0)
	{
		rRandRot.Yaw = Rand(RandRotation);
		rRandRot.Pitch = Rand(RandRotation);
		rRandRot.Roll = Rand(RandRotation);
		
		DesiredRotation = rRandRot;
	}
}

event Touch(Actor Other)
{
	local StatusItem CrackerItem;
	local StatusGroup CrackerGroup;

	if (Other == PlayerHarry)
	{
		CrackerItem = PlayerHarry.ManagerStatus.GetStatusItem(Class'MGStatusGroupWizardCracker', Class'MGStatusItemWizardCracker');
		CrackerGroup = PlayerHarry.ManagerStatus.GetStatusGroup(Class'MGStatusGroupWizardCracker');

		if (CrackerItem.nCount >= CrackerItem.nMaxCount)
		{
			return;
		}

		CrackerGroup.IncrementCount(Class'MGStatusItemWizardCracker', 1);

		//GoToState('PickupProp');
	}

	Super.Touch(Other);
}


defaultproperties
{
	SoundPickup=Sound'HPSounds.Magic_sfx.pickup11'
	AmbientGlow=65
	bBlockActors=False
	bBlockPlayers=False
	bCollideActors=True
	bCollideWorld=True
	bStatic=False
	bRotateToDesired=False
	bFixedRotationDir=True
	RotationRate=(Pitch=0,Yaw=10000,Roll=0)
	CollisionHeight=8
	CollisionRadius=24
	DrawScale=0.75
	Mesh=SkeletalMesh'MGModels.WizardCracker'
	Physics=PHYS_Falling
    bBlockCamera=False
    bPersistent=True
    bPickupOnTouch=True
    bProjTarget=False
    PickupFlyTo=FT_HudPosition
    classStatusGroup=Class'MGHP2.MGStatusItemWizardCracker'
	classStatusItem=Class'MGHP2.MGStatusGroupWizardCracker'
	bUseRandomTexture=True
	bCanTeleport=True
    bMovable=True
	RandomSkins(0)=Texture'MGModelTex.wizardcrackers.moonsparkles'
    RandomSkins(1)=Texture'MGModelTex.wizardcrackers.greencracker'
    RandomSkins(2)=Texture'MGModelTex.wizardcrackers.purplecracker'
    RandomSkins(3)=Texture'MGModelTex.wizardcrackers.yellowcracker'
	RandRotation=131072
    PickupFX=Class'MGHP2.MGParticleCrackerPickup'
}