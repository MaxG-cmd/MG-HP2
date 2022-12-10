class MGPullLauncher extends Trigger;

var Harry PlayerHarry;
var() const float fTimeToHitTarget;

function PostBeginPlay()
{
  foreach AllActors(Class'Harry',PlayerHarry)
    break;
}

state() NormalTrigger
{
  function Trigger (Actor Other, Pawn EventInstigator)
  {
    Super.Trigger(Other,EventInstigator);
	PlayerHarry.DoJump(0);
	PlayerHarry.SetPhysics(PHYS_Falling);
	PlayerHarry.AnimFalling = PlayerHarry.SpongifyFallAnim;
	PlayerHarry.PlayinAir();
	//PlayerHarry.ClientMessage("INITIAL_VELOCITY=" $ PlayerHarry.velocity);
    PlayerHarry.Velocity = ComputeTrajectoryByTime(PlayerHarry.Location,Location,fTimeToHitTarget);
    //PlayerHarry.Velocity = Vec(1000,1000,1000);
	//PlayerHarry.ClientMessage("FINAL_VELOCITY=" $ PlayerHarry.velocity);
  }
}

function Vector ComputeTrajectoryByTime (Vector vPosStart, Vector vPosEnd, float fTimeEnd, optional float AlternateZAccel)
{
    local Vector Vel;
    local float ZAccel;
    ZAccel = Region.Zone.ZoneGravity.Z;
    fTimeEnd = FMax(0.0001,fTimeEnd);
    Vel = (vPosEnd - vPosStart) / fTimeEnd;
	Vel.z = ((vPosEnd.z - vPosStart.z) - (0.5f * ZAccel * (fTimeEnd*fTimeEnd)) ) / fTimeEnd;
	//PlayerHarry.ClientMessage("VEL_VALUE=" $ Vel);	
    return Vel;
}

defaultproperties
{
    fTimeToHitTarget=1.00;
}