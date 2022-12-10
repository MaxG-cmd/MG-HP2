class MGOilCanSpawn extends MGSpawner;

defaultproperties
{
    OpenedAnimation=End
    ClosedAnimation=Start
    OpeningAnimation=Open
    OpeningSound=Sound'HPSounds.General.spawner_oil_can'
    SpawningSound=MultiSound'MGSounds.Magic.SpawnBeans'
    OpeningSoundVolume=0.8
    SpawningSoundVolume=1
    NumLives=1
    SpawnMinPos=(X=16,Y=-4,Z=22)
    SpawnMaxPos=(X=20,Y=4,Z=26)
    SpawnMinVel=(X=32,Y=-16,Z=64)
    SpawnMaxVel=(X=128,Y=16,Z=192)
    SpawnItems(0)=(MinAmount=4,MaxAmount=10,SpawnBlockChance=100,SpawnItemChance=100,VelocityMultiplier=(X=1,Y=1,Z=1),SpawnClass=Class'MGHP2.MGBeanRotated',SpawnParticle=Class'HPParticle.Spawn_flash_1')
    SpawnItems(1)=(MinAmount=1,MaxAmount=2,SpawnBlockChance=5,SpawnItemChance=25,VelocityMultiplier=(X=2,Y=1,Z=1),SpawnClass=Class'MGHP2.MGChocolateFrog',SpawnParticle=Class'HPParticle.Spawn_flash_2')
    eVulnerableToSpell=SPELL_Flipendo
    Mesh=SkeletalMesh'HPModels.skoilcanMesh'
    DrawScale=2.75
    PrePivot=(Z=2)
    CollisionRadius=11
    CollisionHeight=15
    bAlignBottomAlways=True
    NumLives=2
}