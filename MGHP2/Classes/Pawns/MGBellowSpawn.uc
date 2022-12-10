class MGBellowSpawn extends MGSpawner;

defaultproperties
{
    OpenedAnimation=End
    ClosedAnimation=Start
    OpeningAnimation=Open
    OpeningSound=Sound'HPSounds.General.spawner_oil_can'
    SpawningSound=MultiSound'MGSounds.Magic.SpawnBeans'
    OpeningSoundVolume=1
    SpawningSoundVolume=1
    NumLives=3
    SpawnMinPos=(X=18,Y=4,Z=2)
    SpawnMaxPos=(X=24,Y=-4,Z=6)
    SpawnMinVel=(X=32,Y=-64,Z=64)
    SpawnMaxVel=(X=128,Y=64,Z=230)
    SpawnItems(0)=(MinAmount=1,MaxAmount=12,SpawnBlockChance=100,SpawnItemChance=50,VelocityMultiplier=(X=1,Y=1,Z=1),SpawnClass=Class'MGHP2.MGBeanRotated',SpawnParticle=Class'HPParticle.Spawn_flash_1')
    SpawnItems(1)=(MinAmount=1,MaxAmount=2,SpawnBlockChance=5,SpawnItemChance=25,VelocityMultiplier=(X=2,Y=1,Z=1),SpawnClass=Class'MGHP2.MGChocolateFrog',SpawnParticle=Class'HPParticle.Spawn_flash_2')
    eVulnerableToSpell=SPELL_Flipendo
    Mesh=SkeletalMesh'HPModels.skbellowsMesh'
    DrawScale=2
    PrePivot=(X=-32)
    CollisionHeight=8
    bAlignBottomAlways=True
}