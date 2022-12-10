class MGmoveSpeedTrigger extends Triggers;

/*
============================================
whatever class this is: A trigger that will event
                once Harry is above a certain
                speed and if he's touchin it.
============================================
*/

// ---- Configurable variables ----

// MinTriggerSpeed: Minimum speed Harry needs to be traveling to trigger the event
var() const float 	minTriggerSpeed;

// MinTriggerTime: Timer time between detecting harry above the speed and actually triggering the event
var() const float 	minTriggerTime;

// bMustHaveBase: Force Harry to have a base to trigger the event
var() const bool 	bMustHaveBase;

// ---- Internal ----

// bAlreadyTriggered: A boolean to make it trigger only once
var bool bAlreadyTriggered;

// savedHarry: Harry that is captured between touch and untouch
var MGHarry savedHarry;

var bool bSetTimer;

// we gotta know when he lands
var bool bHadBase;

// fTimer: our timer, less expensive, we're poor.
var float fTimer;


event preBeginPlay()
{
	super.preBeginPlay();
	fTimer = minTriggerTime;
	bHadBase = true;
}


// On the start of a touch, this event is fired
event Touch(Actor other)
{
	if(other.isA('MGHarry'))
	{
		// Save him
		savedHarry = MGHarry(other);
		
		//savedHarry.ClientMessage("MOVESPEEDTRIGGER --> TOUCHED");
	}
}

// Fired when harry stops touching the actor
event UnTouch(Actor other)
{
	if(other.isA('mGHarry'))
	{
		//MGHarry(other).clientMessage("MOVESPEEDTRIGGER --> UNTOUCHED");
		
		// Unset it
		savedHarry = None;
	}
}

event Tick(float deltaTime)
{    
	super.Tick(deltaTime);
	
	// Check if harry is touching us
	if(savedHarry != None && !bAlreadyTriggered)
    {
		// 50; we use 50 since you can kinda stub your toesies and land. Typical vert for that is ~38.
		if(savedHarry.base != None && !bHadBase && savedHarry.hitFloorSpeed >= 50 && savedHarry.bHitFloor)
		{
			savedHarry.ClientMessage("TRIGGERING ON LANDED WITH VERTICAL -> " $ savedHarry.hitFloorSpeed);
			TriggerEvent(Event, self, savedHarry);
			bAlreadyTriggered = true;
			return;
		}
	
		if (VSize(savedHarry.velocity) >= minTriggerSpeed && savedHarry.base != None)
		{
			fTimer -= deltaTime;
		}
		else
		{
			fTimer = minTriggerTime;
		}
		
		if (fTimer <= 0)
		{
			savedHarry.ClientMessage("TRIGGERING ON SPEED -> " $ VSize(savedHarry.velocity));
			TriggerEvent(Event, self, savedHarry);
			bAlreadyTriggered = true;
			return;
		}
		
		bHadBase = savedHarry.base != None;
		
	}
}


defaultproperties
{
    minTriggerSpeed=65
    minTriggerTime=0.034
}