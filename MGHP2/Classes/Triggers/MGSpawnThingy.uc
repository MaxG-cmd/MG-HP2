class MGSpawnThingy extends SpawnThingy;

var(SpawnThingy) int NumItemsToSpawn;
var(SpawnThingy) Vector RandVelocity;
var(SpawnThingy) Vector BaseVelocity;
var(SpawnThingy) Rotator RandRotation;
var(SpawnThingy) bool bCopySpawnerRotation;

event Trigger (Actor Other, Pawn Instigator)
{
	local Actor SpawnedObject;
	local Vector Vel;
	local Rotator SpawnDirection;
	local Rotator SpawnedRotation;
	local int i;

	for (i = 0; i < NumItemsToSpawn; i++)
	{
		if (SpawnClass != None)
		{
			if (SpawnTag != 'None')
			{
				SpawnedObject = FancySpawn(SpawnClass,,SpawnTag,Location,,bKeepingTryingSpawnZOnly);
			}
			else
			{
				SpawnedObject = FancySpawn(SpawnClass,,,Location,,bKeepingTryingSpawnZOnly);
			}
			if ( (nameFirstPatrolPoint != 'None') && SpawnedObject.IsA('HPawn') )
			{
				HPawn(SpawnedObject).firstPatrolPointObjectName = nameFirstPatrolPoint;
				HPawn(SpawnedObject).bLoopPath = bLoopPatrolPath;
			}

			if (bCopySpawnerRotation)
			{
				SpawnedObject.SetRotation(Rotation);
			}

			if ( bThrowItem || SpawnedObject.IsA('Jellybean') && bDirectional )
			{
				Vel.X = BaseVelocity.X + Rand(int(RandVelocity.X * 2)) - RandVelocity.X;
				Vel.Y = BaseVelocity.Y + Rand(int(RandVelocity.Y * 2)) - RandVelocity.Y;
				Vel.Z = fAdditionalZVelocity + BaseVelocity.Z + Rand(int(RandVelocity.Z * 2)) - RandVelocity.Z;
				Vel = Vel >> Rotation;
				SpawnedObject.Velocity = Vel * fVelocityModifier;
				SpawnedObject.SetPhysics(PHYS_Falling);


				SpawnedRotation.Pitch = Rand(RandRotation.Pitch);
				SpawnedRotation.Yaw = Rand(RandRotation.Yaw);
				SpawnedRotation.Roll = Rand(RandRotation.Roll);

				SpawnedObject.SetRotation(SpawnedRotation);
			}
		}
	}
}

defaultproperties
{
	NumItemsToSpawn=1
	BaseVelocity=(X=64,Y=0,Z=32)
	bCopySpawnerRotation=False
}