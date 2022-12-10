class MGDamageDevice extends Triggers;

var() int iDamageAmount;
var() float fRepeatRatePerSec;


function Timer()
{
	level.playerHarryActor.takeDamage(iDamageAmount, none, location, vec(0,0,0), '');
}

function Touch(actor touchedActor)
{
	if (touchedActor.isa('harry'))
	{
		setTimer((1 / fRepeatRatePerSec), True);
	}
}

function UnTouch(actor touchedActor)
{
	if (touchedActor.isa('harry'))
	{
		setTimer(0, False);
	}
}


defaultproperties
{
	bStatic=False
	bCanTeleport=True
	bCollideActors=True
	bHidden=True
	bCollideWorld=False
	bProjTarget=False
	bBlockPlayers=False
	bBlockActors=False
	Texture=Texture's_clipmarker'
	DrawScale=2
}