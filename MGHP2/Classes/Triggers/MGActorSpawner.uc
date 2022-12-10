class MGActorSpawner extends Trigger;
/*  
struct SpawnActor
{
	var() String SpawnProperty;
	var() String SpawnValue;
};

struct SpawnItem
{   
	var() bool bUseSpawnLoc;

	// MaxG: Amounts to spawn.
	var() int NumToSpawn;

	var() Vector SpawnLoc;

	var() Class<Actor> SpawnClass;
	var() Class<ParticleFX> SpawnParticle;

	var() Array<SpawnActor> SpawnProps;
};

var() float DelayBtwSpawns;
var() Array<SpawnItem> SpawnItems;

var int i;
var int j;
var int k;
var Actor A;

event Activate(Actor Other, Pawn EventInsigator)
{
	Super.Activate(Other, EventInsigator);

	GotoState('Spawning');
}

state Spawning
{
	begin:
		for (i = 0; i < SpawnItems.Length; i++)
		{
			for (j = 0; j < SpawnItems[i].NumToSpawn; j++)
			{
				A = Spawn(SpawnItems[i].SpawnClass, , , , , true);

				if (SpawnItems[i].bUseSpawnLoc)
				{
					A.SetLocation(SpawnItems[i].SpawnLoc);
					Spawn(SpawnItems[i].SpawnParticle, , , SpawnItems[i].SpawnLoc);
				}
				else
				{ 
					Spawn(SpawnItems[i].SpawnParticle, , , Location);
				}

				for (k = 0; k < SpawnItems[i].SpawnProps.Length; k++)
				{
					A.SetPropertyText(SpawnItems[i].SpawnProps[k].SpawnProperty, SpawnItems[i].SpawnProps[k].SpawnValue);
				}

				Sleep(DelayBtwSpawns);
			}
		}
		GoToState('NormalTrigger');
}*/

defaultproperties
{
	Texture=Texture'HGame.SthingE'
	TriggerType=TT_ClassProximity
	bDoActionWhenTriggered=True
	DelayBtwSpawns=0.1
}