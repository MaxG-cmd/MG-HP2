class MGloadTrigger extends Trigger;

//what save you wanna load
var() int iSaveNum;

auto state normalTrigger 
{
    // Event trigger function
    function trigger(actor other, pawn eventInstigator) 
    {
		level.playerHarryActor.consoleCommand("loadgame " $iSaveNum);
    }
}

defaultproperties
{
    iSaveNum=0
}