class MGKnightSpawner extends MGSpawner;

defaultproperties
{
    OpenedAnimation=End
    ClosedAnimation=Start
    OpeningAnimation=Open
    OpeningSound=Sound'HPSounds.General.knight_hit'
    SpawningSound=MultiSound'MGSounds.Magic.SpawnBeans'
    OpeningSoundVolume=0.666
    SpawningSoundVolume=1
    NumLives=2
    SpawnMinPos=(X=8,Y=-16,Z=32)
    SpawnMaxPos=(X=16,Y=16,Z=48)
    SpawnMinVel=(X=32,Y=-32,Z=64)
    SpawnMaxVel=(X=112,Y=32,Z=200)
    SpawnItems(0)=(MinAmount=4,MaxAmount=10,SpawnBlockChance=100,SpawnItemChance=100,VelocityMultiplier=(X=1,Y=1,Z=1),SpawnClass=Class'MGHP2.MGBeanRotated',SpawnParticle=Class'HPParticle.Spawn_flash_1')
    SpawnItems(1)=(MinAmount=1,MaxAmount=2,SpawnBlockChance=20,SpawnItemChance=25,VelocityMultiplier=(X=2,Y=1,Z=1),SpawnClass=Class'MGHP2.MGChocolateFrog',SpawnParticle=Class'HPParticle.Spawn_flash_2')
    SpawnItems(2)=(MinAmount=1,MaxAmount=2,SpawnBlockChance=50,SpawnItemChance=25,VelocityMultiplier=(X=1.5,Y=1,Z=1),SpawnClass=Class'MGHP2.MGWizardCrackerPickup',SpawnParticle=Class'HPParticle.Spawn_flash_3')
    eVulnerableToSpell=SPELL_Flipendo
    Mesh=SkeletalMesh'HProps.skKnightMesh'
    DrawScale=1.5
    PrePivot=(Y=8)
    ScaleGlow=1.25
    SpecularGlow=3
    CollisionRadius=31.4297
    CollisionWidth=31.4297
    CollisionHeight=45.5275
    CollideType=CT_Shape
}