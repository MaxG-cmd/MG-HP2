class MGFadeDeathTrigger extends Trigger;

// Color the screen will fade to.
var() Vector fadeColor;

// Time it takes to fade out.
var() float fadeOutTime;

// The time at which this got triggered.
var float triggerTime;

// A reference to the MGHarry class
var MGHarry deadHarry;

// True when touched.
var bool bTriggered;


event PostBeginPlay()
{
	Super.PostBeginPlay();
	
	forEach AllActors(class'MGHarry', deadHarry)
	{
		break;
	}
}

function Activate(Actor Other, Pawn Instigator)
{
	local MGFadeDeathTrigger other_trigger;

	Super.Activate(Other, Instigator);
	
	// MaxG: Do not let other triggers interfere. Allows multiple in one area.
	ForEach AllActors(Class'MGFadeDeathTrigger', other_trigger)
	{
		if (other_trigger != Self)
		{
			other_trigger.Destroy();
		}
	}
	
	bTriggered = true;
	triggerTime = Level.TimeSeconds;
		
	if (deadHarry.CarpeStatue != None)
	{
		 deadHarry.Drop();
	}
	
	deadHarry.ClientFadeOut(fadeColor, fadeOutTime);
}

event Tick(float DeltaTime)
{
	if (bTriggered)
	{
		if ((triggerTime + fadeOutTime) <= level.timeSeconds)
		{
			deadHarry.ConsoleCommand("LoadGame 0");
		}
	}

	Super.Tick(DeltaTime);
}

defaultproperties
{
	bStatic=false
	bTriggerOnceOnly=true
	fadeColor=(X=0,Y=0,Z=0)
	fadeOutTime=2.0
}