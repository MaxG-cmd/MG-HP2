class MGtriggerLight extends Light;

// MaxG: Obsolete class.

var float minBrightness;
var float maxBrightness;
var float changeRate;
var float brightnessInitial;
var float brightnessCurrent;
var() float brightnessOn;
var() float changeTime;
var() float changeTimeOff;
var bool isOn;

function getChangeRate()
{
	if (isOn)
	{
		if (changeTime != 0)
		{
			changeRate = (brightnessOn - brightnessInitial) / changeTime;
		}
		else
		{
			//Set this to a high number so that it instantly changes
			changeRate = 9999999999999999;
		}
	}
	else
	{
		if (changeTimeOff != 0)
		{
			changeRate = (brightnessOn - brightnessInitial) / changeTimeOff;
		}
		else
		{
			//Set this to a high number so that it instantly changes
			changeRate = 9999999999999999;
		}
	}
	
	//cm("changeRate for " $ name $ " = " $ changeRate);
	
}

event preBeginPlay()
{
	super.preBeginPlay();
	
	brightnessOn = fClamp(brightnessOn, 0, 255);
	brightnessInitial = LightBrightness;
	
	getChangeRate();
	
	minBrightness = fMin(brightnessInitial, brightnessOn);
	maxBrightness = fMax(brightnessInitial, brightnessOn);
	DrawType = DT_None;
}

state() triggerControls
{
	event trigger(actor other, pawn eventInstigator)
	{
		super.trigger(other, eventInstigator);
		isOn = true;
		//cm("TRIGGRED =====> ON? " $ isOn);
		getChangeRate();
	}

	event unTrigger(actor other, pawn eventInstigator)
	{
		super.unTrigger(other, eventInstigator);
		isOn = false;
		//cm("TRIGGRED =====> ON? " $ isOn);
		getChangeRate();
	}
}

auto state() triggerToggles
{
	event trigger(actor other, pawn eventInstigator)
	{
		super.trigger(other, eventInstigator);
		isOn = !isOn;
		//cm("TRIGGRED =====> ON? " $ isOn);
		getChangeRate();
	}
}

event Tick(float deltaTime)
{	
	
	//getChangeRate();
	//cm("lightBrightness IS " $ lightBrightness);
	//cm("CURRENT IS " $ brightnessCurrent);

	if (isOn)
	{
		brightnessCurrent += changeRate * deltaTime;
	}
	else
	{
		brightnessCurrent -= changeRate * deltaTime;
	}
	
	brightnessCurrent = fClamp(brightnessCurrent, minBrightness, maxBrightness);
	lightBrightness = fClamp(brightnessCurrent, minBrightness, maxBrightness);
}

defaultproperties
{
	bNoDelete=False
	bHidden=False
    bStatic=False
    bMovable=True
	Texture=Texture'MGhp2.MGtriggerLightTex'
	Style=STY_Masked
	bNoSmooth=True
}
