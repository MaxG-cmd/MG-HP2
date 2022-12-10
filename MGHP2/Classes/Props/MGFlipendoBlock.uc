class MGFlipendoBlock extends MGPropActive;

var() float PushGridSize;
var() float GridSize;   
var() float BlockFrictionCoef;
var() float StopSpeedFac;
var() bool bUseSpawnLocOffset;

var Vector SlidingVelocity;

function AlignToGrid()
{
    local float AlignedX;
    local float AlignedY;

    // MaxG: Align to grid. Add back the grid offset.
    AlignedX = Round(Location.X / GridSize) * GridSize;
    AlignedY = Round(Location.Y / GridSize) * GridSize;

    if (bUseSpawnLocOffset)
    {
        AlignedX += (AlignedX % GridSize) + (SpawnLocation.X % GridSize);
        AlignedY += (AlignedY % GridSize) + (SpawnLocation.Y % GridSize);
    }

    SetLocation( Vec(AlignedX, AlignedY, Location.Z) );
}

function Vector GetDirection(Vector HitLocLocal)
{
    if ( Abs(HitLocLocal.X) < Abs(HitLocLocal.Y) )
    {
        if (HitLocLocal.Y < 0)
        {
            return Vec(0, -1, 0);
        }
        else
        {
            return Vec(0, 1, 0);
        }
    }
    else
    {
        if (HitLocLocal.X < 0)
        {
            return Vec(-1, 0, 0);
        }
        else
        {
            return Vec(1, 0, 0);
        }
    }
}

function StopSliding()
{
    Acceleration = Vec(0, 0, 0);
    Velocity = Vec(0, 0, 0);
    SlidingVelocity = Vec(0, 0, 0);
    DesiredSpeed = 0;
    AlignToGrid();

    GoToState('BlockStationary');
}


auto state BlockStationary
{
    function bool HandleSpellFlipendo(optional baseSpell Spell, optional Vector HitLocation)
    {
        local Vector direction;

        // MaxG: Get the location difference from the hit location.
        //       Account for auto-hit spells.
        if ( HitLocation == Location )
        {
            direction = Location - PlayerHarry.Location;
        }
        else
        {
            direction = Location - HitLocation;
        }

        DesiredSpeed = Sqrt(2 * BlockFrictionCoef * PushGridSize);
        Velocity = GetDirection(direction) * DesiredSpeed;
        SlidingVelocity = GetDirection(direction) * DesiredSpeed;

        GoToState('BlockSliding');

        return true;
    }
}

state BlockSliding
{
    function bool HandleSpellFlipendo(optional baseSpell Spell, optional Vector vHitLocation)
    {
        return true;
    }

    event Touch(Actor Other)
    {
        if (Other.bStatic || Other.IsA('MGFlipendoBlock'))
        {
            StopSliding();
        }
    }

    event Bump(Actor Other)
    {
        if (Other.bStatic || Other.IsA('HProp'))
        {
            StopSliding();
        }
    }

    event HitWall(Vector HitNormal, Actor Wall)
    {
        StopSliding();
    }

    event BaseChanged(Actor OldBase, Actor NewBase)
    {
        if (NewBase == None)
        {
            GoToState('BlockFalling');
        }
    }

    event BeginState()
    {
        if ( VSize2D(SlidingVelocity) > 8.0 )
        {
            Velocity = SlidingVelocity;
            Velocity.Z = 0;
        }
    }

    event Tick(float DeltaTime)
    {
        if ( VSize2D(Velocity) < (DesiredSpeed * StopSpeedFac) )
        {
            StopSliding();
            return;
        }

        if ( VSize2D(Velocity) > VSize2D(SlidingVelocity) )
        {
            Velocity = Vec(SlidingVelocity.X, SlidingVelocity.Y, Velocity.Z);
        }

        Acceleration = -Normal(Velocity) * BlockFrictionCoef;

        // MaxG: Alternative velocity based method.
        //Velocity -= Normal(Velocity) * BlockFrictionCoef * DeltaTime;
    }
}

state BlockFalling
{
    event Landed(Vector V)
    {
        Super.Landed(V);

        SlidingVelocity = Velocity;
        GoToState('BlockSliding');
    }
}

defaultproperties
{
    AmbientGlow=35
    bCanTeleport=True
    bCanLedgeFall=True
    bEdShouldSnap=True
    BlockFrictionCoef=512.0
    bMovable=True
    bNoZoneFriction=True
    bRotateToDesired=False
    bStatic=False
    bUseSpawnLocOffset=True
    CollideType=CT_Box
    CollisionHeight=47
    CollisionRadius=46 // MaxG: Needs to be smaller to fit for some reason.
    CollisionWidth=46
    eVulnerableToSpell=SPELL_Flipendo
    GridSize=8.0
    LODBias=8
    MaxStepHeight=1
    Mesh=SkeletalMesh'MGModels.FlipendoBlock'
    Physics=PHYS_Walking
    PushGridSize=96
    ScaleGlow=2
    StopSpeedFac=0.02
}