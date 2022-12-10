class MGCarpeStatueSpring extends MGCarpeStatue;

var() float MaxPullForce;

var() float SpringAmount;

// MaxG: Minimum length of the rope. 
var() float RopeLength;

// MaxG: The minimum force required to break the rope.
var() float MinBreakingForce;

var() float DampingAmount;

var() float InitialLift;

var(CarpeSounds) Sound RopeSnapSound;

var float Damping;

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

        Damping = DampingAmount * 2 * Sqrt(SpringAmount);

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
        local vector v_force;
        local Vector v_dist;
        local Vector v_normal_dist;

        v_dist = DIST(Harry);

        v_normal_dist = Normal(v_dist) * ( VSize(v_dist) - RopeLength );

        v_force = ( (SpringAmount) * v_normal_dist ) - (Damping * Harry.Velocity);

        //CM("[" $ Name $ "]::Pulling::Tick ==> Calculated force: " $ VSize(v_force));
        //CM("[" $ Name $ "]::Pulling::Tick ==> Damping: " $ Damping);
        //CM("[" $ Name $ "]::Pulling::Tick ==> ForceDT: " $ VSize(DeltaTime * v_force) );

        if (VSize(v_dist) > PullDeadzone)
        {
            if ( (VSize(DeltaTime * v_force) > (MaxPullForce * DeltaTime)) && (MaxPullForce > 0) )
            {
                Harry.Velocity += VecClamp(DeltaTime * v_force, (MaxPullForce * DeltaTime) );
            }
            else
            {
                Harry.Velocity += DeltaTime * v_force;
            }
        }

        if (VSize(v_force) >= MinBreakingForce && MinBreakingForce > 0)
        {
            Harry.Drop();

            PlaySound(RopeSnapSound, SLOT_None, [Volume]2.70, [bNoOverride], [Radius], [Pitch]1.0);

		    Harry.PlaySound( Harry.HurtSound[ Rand(Harry.NUM_HURT_SOUNDS) ], [Slot], [Volume]Harry.EmoteVolume );
        }

        Super.Tick(DeltaTime);
    }
}

defaultproperties
{
    PullOffset=(X=0,Y=0,Z=32)
    PullDeadzone=64
    SpringAmount=4
    DampingAmount=0.3
    ReEnableTime=0.5
    RopeLength=16
    InitialLift=32
    MaxPullForce=1280
    MinBreakingForce=6400
    RopeSnapSound=Sound'MGSounds.Main.carpe_snap'
}