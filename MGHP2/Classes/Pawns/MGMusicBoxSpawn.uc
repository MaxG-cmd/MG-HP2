class MGMusicBoxSpawn extends MGSpawner;

defaultproperties
{
    OpenedAnimation=End
    ClosedAnimation=Start
    OpeningAnimation=Open
    ClosingAnimation=Close
    OpeningSound=Sound'HPSounds.General.spawner_music_box'
    SpawningSound=MultiSound'MGSounds.Magic.SpawnBeans'
    OpeningSoundVolume=0.8
    SpawningSoundVolume=1
    NumLives=2
    StayOpenTime=0.5
    SpawnMinPos=(X=8,Y=-16,Z=8)
    SpawnMaxPos=(X=16,Y=16,Z=38)
    SpawnMinVel=(Y=-32,Z=64)
    SpawnMaxVel=(X=112,Y=32,Z=200)
    SpawnItems(0)=(MinAmount=4,MaxAmount=10,SpawnBlockChance=100,SpawnItemChance=100,VelocityMultiplier=(X=1,Y=1,Z=1),SpawnClass=Class'MGHP2.MGBeanRotated',SpawnParticle=Class'HPParticle.Spawn_flash_1')
    SpawnItems(1)=(MinAmount=1,MaxAmount=2,SpawnBlockChance=5,SpawnItemChance=25,VelocityMultiplier=(X=2,Y=1,Z=1),SpawnClass=Class'MGHP2.MGChocolateFrog',SpawnParticle=Class'HPParticle.Spawn_flash_2')
    eVulnerableToSpell=SPELL_Alohomora
    Mesh=SkeletalMesh'HPModels.skmusicboxMesh'
    DrawScale=1.25
    CollisionRadius=16.2
    CollisionWidth=16.2
    CollisionHeight=13.06397
    CollideType=CT_Shape
}