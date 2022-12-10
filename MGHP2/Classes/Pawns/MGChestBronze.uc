class MGChestBronze extends MGSpawner;

defaultproperties
{
    OpenedAnimation=End
    ClosedAnimation=Start
    OpeningAnimation=Open
    OpeningSound=Sound'HPSounds.General.wood_chest_open'
    SpawningSound=MultiSound'MGSounds.Magic.SpawnBeans'
    OpeningSoundVolume=0.7
    SpawningSoundVolume=1
    NumLives=1
    SpawnMinPos=(X=8,Y=-32,Z=32)
    SpawnMaxPos=(X=-8,Y=32,Z=48)
    SpawnMinVel=(X=32,Y=-64,Z=64)
    SpawnMaxVel=(X=128,Y=64,Z=230)
    SpawnItems(0)=(MinAmount=4,MaxAmount=16,SpawnBlockChance=100,SpawnItemChance=100,VelocityMultiplier=(X=1,Y=1,Z=1),SpawnClass=Class'MGHP2.MGBeanRotated',SpawnParticle=Class'HPParticle.Spawn_flash_1')
    SpawnItems(1)=(MinAmount=1,MaxAmount=2,SpawnBlockChance=20,SpawnItemChance=25,VelocityMultiplier=(X=2,Y=1,Z=1),SpawnClass=Class'MGHP2.MGChocolateFrog',SpawnParticle=Class'HPParticle.Spawn_flash_2')
    eVulnerableToSpell=SPELL_Alohomora
    Mesh=SkeletalMesh'HPModels.skbronzechestMesh'
    PrePivot=(Z=-6)
    DrawScale=2
    CollideType=CT_Shape
}