class MGLearnSpellsTrigger extends Trigger;

// MaxG: There are 28 spells in the Spells array.
var() Array<Class<BaseSpell>> SpellsToTeach;

function AddSpells()
{
    local int i;
    
	for (i = 0; i < SpellsToTeach.Length; i++)
	{
		if (SpellsToTeach[i] != None)
		{
			Harry(Level.PlayerHarryActor).AddToSpellBook( SpellsToTeach[i] );
		}
	}
}

event Activate(Actor Other, Pawn EventInstigator)
{
	Super.Activate(Other, EventInstigator);

	AddSpells();
}

defaultproperties
{
    DrawScale=1
	Texture=Texture'HPParticle.hp_fx.Particles.Goldstar01'
	Style=STY_Translucent
	bTriggerOnceOnly=True
	SpellsToTeach(0)=Class'HGame.spellDiffindo'
    SpellsToTeach(1)=Class'HGame.spellRictusempra'
    SpellsToTeach(2)=Class'HGame.spellSkurge'
    SpellsToTeach(3)=Class'HGame.spellSpongify'
    SpellsToTeach(4)=Class'HGame.spellDuelRictusempra'
    SpellsToTeach(5)=Class'HGame.spellDuelMimblewimble'
    SpellsToTeach(6)=Class'HGame.spellDuelExpelliarmus'
    SpellsToTeach(7)=Class'MGHP2.MGSpellWingardium'
	bDoActionWhenTriggered=True
	bCollideActors=False
}

