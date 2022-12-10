class MGGhostWalking extends Trigger;

// MaxG: Nah.

var() bool bForceGhost;
var() bool bForceHuman;
var MGHarry h;

/*

function beginPlay() {

	forEach AllActors(class'MGHarry', h)
	{
		break;
	}
}


state() NormalTrigger {
	
	function Trigger(actor Other, pawn EventInstigator) {
		
		if (!bForceGhost && !bForceHuman)
		{
			h.bGhostHarry = !h.bGhostHarry;
		}
		else if (bForceGhost)
		{
			h.bGhostHarry = true;
		}
		else if (bForceHuman)
		{
			h.bGhostHarry = false;
		}
		else
		{
			level.playerHarryActor.ClientMessage("----==== GHOST FAILED, CHECK PROPERTIES ====----");
		}
	}
}
*/