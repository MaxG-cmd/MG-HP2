class MGCarpeStatueLaunch extends MGCarpeStatue;

// MaxG: Units per second.
var() float YankSpeed;

// MaxG: 1 - % of desired speed you need to be going to reach the target.
var() float YankCutoff;

var() float InitialLift;

var() float AutoDropDistance;


/* MaxG:    0: Do not account for gravity.
*           1: Exact gravity.
*          >1: Assume gravity is greater than it really is.
*/
var() float Lift;

var(CarpeSounds) Sound RopeSnapSound;

state() Pulling
{
    event BeginState()
    {
        local Vector temp_vel;

        // MaxG: Drop Harry if being held.
        if (Harry.CarpeStatue != None)
        {
            Harry.Drop();
        }

        Harry.CarpeStatue = Self;

        //Damping = DampingAmount * 2 * Sqrt(SpringAmount);

        temp_vel = Harry.Velocity;

        Harry.GoToState('CarpeSwinging');

        Harry.Velocity = temp_vel;

        Harry.DoJump(InitialLift);

        eVulnerableToSpell = SPELL_None;

        CarpeRope = Spawn(Class'MGCarpeRope', Harry, , Harry.Weapon.Location);
        CarpeRope.CTarget = Self;

        Super.BeginState();
    }

    event EndState()
    {
        eVulnerableToSpell = SPELL_LocomotorWibbly;

        Super.EndState();
    }

    event Tick(float DeltaTime)
    {
        local Vector velocity_required;
        local Vector velocity_added;
        local float time_to_reach_target;
        local float distance_to_harry;

        distance_to_harry = VSize( DIST(Harry) );

        Super.Tick(DeltaTime);

        if ( distance_to_harry <= AutoDropDistance )
        {
            Harry.Drop();
            return;
        }

        time_to_reach_target = distance_to_harry / YankSpeed;
        
        velocity_required = ComputeTrajectoryByTime(Harry.Location, Location + PullOffset, time_to_reach_target) - (Region.Zone.ZoneGravity * Lift);

        velocity_added = velocity_required - Harry.Velocity;

        if ( (velocity_added Dot Normal(velocity_required)) < (YankCutoff * VSize(velocity_required)) )
        {
            Harry.Drop();
        }
        else if (distance_to_harry > PullDeadzone)
        {
            velocity_added *= DeltaTime;

            Harry.Velocity += velocity_added;
        }
    }
}



defaultproperties
{
    PullOffset=(X=0,Y=0,Z=-44)
    InitialLift=64
    YankSpeed=1024
    YankCutoff=0.62
    Lift=1.55
    AutoDropDistance=96
    PullDeadzone=0
}