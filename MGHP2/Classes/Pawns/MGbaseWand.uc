class MGbaseWand extends baseWand;

var() const Name actorName;
var Pawn thisPawn;

event postBeginPlay() {
	Super.postBeginPlay();
	
	
	forEach allActors(class'Pawn', thisPawn) {
		if (thisPawn.Name == actorName) {
			break;
		}
	}
	
	self.BecomeItem();
	thisPawn.AddInventory(self);
	self.WeaponSet(thisPawn);
	self.GiveAmmo(thisPawn);
	
}

defaultproperties
{
	fxChargeParticleFXClass=Class'MGhp2.MGWandGlow'
}