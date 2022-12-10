class MGRepulsionForce extends Trigger;
 
var() float fAccelAmount;


event Tick(float DeltaTime)
{
	local Pawn P;
	
	if (bInitiallyActive)
	{
		
		forEach TouchingActors(Class'Pawn', P)
		{
			if (IsRelevant(P))
			{
				P.Velocity += ((Vector(Rotation) * fAccelAmount) / getDist(P));
			}
		}
	}
	
	Super.Tick(DeltaTime);
}


function float getDist(Actor Other)
{
	local Vector a;
	
	a = (Other.location - location);
	
	return (a Dot Vector(Rotation));
}



defaultproperties
{
	fAccelAmount=128
	bDirectional=True
}