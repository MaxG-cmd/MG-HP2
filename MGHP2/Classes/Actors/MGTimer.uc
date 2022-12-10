class MGTimer extends Actor;

var bool bTimerSet;
var float SecondsElapsed;
var float StartTime;
var float GoalTime;

// MaxG: Trigger any arbitrary function with the name in this Name.
//       Note: OWNER must be the one with the function!
var Name TriggerFunction;


event BeginPlay()
{
	SecondsElapsed = 0.0;
}

function StartTimer()
{
	StartTime = Level.TimeSeconds;
	SecondsElapsed = 0.0;
	bTimerSet = true;
	
	CM("[" $ Name $ "]: Starting timer :: SecondsElapsed = " $ SecondsElapsed);
}

function StopTimer()
{
	bTimerSet = false;
	SecondsElapsed = 0.0;
	
	CM("[" $ Name $ "]: Stopping timer :: SecondsElapsed = " $ SecondsElapsed);
}


event Tick(float DeltaTime)
{
	Super.Tick(DeltaTime);
	
	if (bTimerSet)
	{
		SecondsElapsed = Level.TimeSeconds - StartTime;

		if (GoalTime > 0.0 && TriggerFunction != 'None')
		{
			if (SecondsElapsed >= GoalTime)
			{
				StopTimer();
				Owner.CallFunction(TriggerFunction);
			}
		}
	}
	
	//CM("[" $ Name $ "]: SecondsElapsed = " $ SecondsElapsed);
}

defaultproperties
{
	bHidden=true
	CollisionRadius=0
	CollisionHeight=0
	bMovable=false
	SecondsElapsed=0.0
	StartTime=0.0
	bTimerSet=false
}