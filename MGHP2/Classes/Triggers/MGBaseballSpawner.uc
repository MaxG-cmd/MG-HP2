class MGBaseballSpawner extends Trigger;

var() Name BaseballEvent;
var() float BallSpeed;
var() float BallLifetime;
var() float DelayBeforeSpawn;
var() Vector BallReflectVelocity;
var() Vector BallSpawnVelocity;
var() Class<MGSpellBaseball> BallClass; 

var MGSpellBaseball Ball;

function SpawnTheSpell()
{
	Ball = Spawn(BallClass, , , Location);

	Ball.Event = BaseballEvent;
	Ball.Speed = BallSpeed;
	Ball.InitialLifetime = BallLifetime;

	Ball.ReflectVelocity = BallReflectVelocity;

	Ball.GoToState('StateFlying');

	Ball.Velocity = BallSpawnVelocity;

	Ball = None;
}

event Timer()
{
	SpawnTheSpell();
}

event Activate(Actor Other, Pawn EventInstigator)
{
	Super.Activate(Other, EventInstigator);

	SetTimer(DelayBeforeSpawn, false);
}

defaultproperties
{
	Texture=Texture'MGTech.Icons.BaseballIcon'
	BallSpeed=360
	BallLifetime=6.0
	DelayBeforeSpawn=1.0
	bDoActionWhenTriggered=True
	BallClass=Class'MGHP2.MGSpellBaseball'
}