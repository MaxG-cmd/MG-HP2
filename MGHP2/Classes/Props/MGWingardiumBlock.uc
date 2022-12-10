class MGWingardiumBlock extends MGPropActive;

// MaxG: Prevent wall stuckyness.
state Levitating
{
	
	event BeginState()
	{
		Super.BeginState();

		CollideType = CT_AlignedCylinder;
		SetCollisionSize(CollisionRadius, CollisionHeight, 0.0);
	}

	event EndState()
	{
		Super.EndState();

		CollideType = CT_Box;
		SetCollisionSize(CollisionRadius, CollisionHeight, Default.CollisionWidth);
	}
}

defaultproperties
{
	Mesh=SkeletalMesh'MGModels.skWingardiumBlock'
	ScaleGlow=2
	SpecularGlow=0
	AmbientGlow=10
	CollisionRadius=32
	CollisionWidth=32
	CollisionHeight=32
	CollideType=CT_Box
	bCanLevitate=True
	eVulnerableToSpell=SPELL_WingardiumLeviosa
	Physics=PHYS_Falling
	WingardiumRotationAmount=(Pitch=1200,Yaw=0,Roll=300)
	WingardiumMoveSpeed=1.0
	SoundWingardiumLand=Sound'MGSounds.Wingardium.Block_Land1'
	bAlwaysPlayLandedSound=True 
	DespawnFX=Class'HPParticle.Explosion_02'
	bRespawnOnDestroy=True
}