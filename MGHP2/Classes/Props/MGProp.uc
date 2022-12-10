class MGProp extends HProp;

function MakeSneakNoise(float loudness)
{
	local MGSneakActor hearer;
	
    forEach AllActors(class'MGhp2.MGSneakActor', hearer)
    {
        hearer.SneakHearNoise(loudness, self);
    }
}

defaultproperties
{
    bStatic=True
    bCanTeleport=False
    bSelected=True
    SpecularGlow=0
    AmbientGlow=10
    bMovable=False
}