class MGSneakController extends Actor;

#define DISTANCE(Other) (Location - Other.Location)
#define VSIZESQ(Vecta) ((Vecta.x ** 2) + (Vecta.y ** 2) + (Vecta.z ** 2))
//;

var MGSneakActor S;

function DM(String Message)
{
    if (S.bDebugPathing)
    {
        CM("[" $ S.Name $ "]::" $ Message);
    }
}

function SetSneakActor(MGSneakActor NewSneakActor)
{
    DM("SetSneakActor");
    S = NewSneakActor;

    DM("SetSneakActor ==> " $ S);
}

function bool ContinuePatrolling()
{
    local bool result;

    DM("ContinuePatrolling");

    result = S.CurrentMoveTarget != S.CurrentPatrolTarget;

    DM("ContinuePatrolling ==> " $ result);

    return result;
}

function GetNextPatrolTarget()
{
    DM("GetNextPatrolTarget");
    S.CurrentPatrolTarget = S.CurrentPatrolTarget.DestinationNode;
    
    DM("GetNextPatrolTarget ==> " $ S.CurrentPatrolTarget);
}

function OnReachJumpTarget()
{
    DM("OnReachJumpTarget");

    S.PreviousPatrolTarget = S.CurrentPatrolTarget;

    DM("OnReachJumpTarget PreviousPatrolTarget ==> " $ S.PreviousPatrolTarget);

    EmptyPath();

    GetNextPatrolTarget();

    GivePathToTarget(S.CurrentPatrolTarget);
}

function OnReachPatrolTarget()
{
    local int i;

    DM("OnReachPatrolTarget");

    S.PreviousPatrolTarget = S.CurrentPatrolTarget;

    EmptyPath();

    GetNextPatrolTarget();

    GivePathToTarget(S.CurrentPatrolTarget);

    DM("OnReachPatrolTarget PreviousPatrolTarget ==> " $ S.PreviousPatrolTarget);

    for (i = 0; i < S.PreviousPatrolTarget.PauseAnimations.Length; i++)
    {
        DM("OnReachPatrolTarget PauseAnimations[" $ i $ "]::" $ S.PreviousPatrolTarget.PauseAnimations[i]);
    }

    // MaxG: Jump if relevant.
    if ( S.PreviousPatrolTarget.IsA('MGSneakJumpPoint') )
    {
        DM("OnReachPatrolTarget ==> PreviousPatrolTarget is a MGSneakJumpPoint");
        DM("OnReachPatrolTarget ==> Jumping to " $ S.CurrentPatrolTarget $ " from " $ S.PreviousPatrolTarget);
        S.GoToState('JumpToPoint');
    }

    // MaxG: Account for Patrol pauses.
    if (S.PreviousPatrolTarget.PauseAnimations.Length > 0)
    {
        DM("OnReachPatrolTarget ==> Patrol pausing...");
        S.GoToState('SneakPatrolPause');
    }
}

function MGSneakNode FindNearestSneakNode()
{
    local float curDist;
	local float tempDist;
	local Vector curPointDist;
	local MGSneakNode curPoint;
	local MGSneakNode nearestPoint;
	
    DM("FindNearestSneakNode");

    curDist = 65536;

	forEach AllActors(Class'MGSneakNode', curPoint, S.BasePathTag)
	{
        curPointDist = DISTANCE(curPoint);
        tempDist = VSIZESQ(curPointDist);
        
        if (tempDist < curDist)
        {
            curDist = tempDist;
            nearestPoint = curPoint;
        }
	}

	return nearestPoint;
}

function PathNode FindNearestNode(Vector Target)
{
    local float curDist;
	local float tempDist;
	local Vector curPointDist;
	local PathNode curPoint;
	local PathNode nearestPoint;
	
    DM("FindNearestSneakNode");

    curDist = 65536;

	forEach AllActors(Class'PathNode', curPoint)
	{
        curPointDist = Target - curPoint.Location;
        tempDist = VSIZESQ(curPointDist);
        
        if (tempDist < curDist)
        {
            curDist = tempDist;
            nearestPoint = curPoint;
        }
	}

	return nearestPoint;
}

function GiveNearestSneakNode()
{
    DM("GiveNearestSneakNode");
    S.CurrentPatrolTarget = FindNearestSneakNode();

    DM("GiveNearestSneakNode ==> " $ S.CurrentPatrolTarget);
}

function GiveNearestNodeToNoiseMaker()
{
    DM("GiveNearestSneakNode");
    S.CurrentNodeDest = FindNearestNode(S.CurrentNoiseMaker.Location);

    DM("GiveNearestSneakNode ==> " $ S.CurrentPatrolTarget);
}

function GivePathToTarget(Actor A)
{
    DM("GivePathToTarget");

    S.CurrentMoveTarget = S.FindPathToward(A, false, true);

    DM("GivePathToTarget ==> Pathing to " $ S.CurrentMoveTarget);
    DM("GivePathToTarget ==> RouteCache[0] = " $ S.RouteCache[0]);
    DM("GivePathToTarget ==> Goal " $ A);
}

function GiveNextMoveTarget()
{
    DM("GiveNextMoveTarget");

    // MaxG: Do not give the actor a None. 
    if (S.RouteCache[0] == None)
    {
        DM("GiveNextMoveTarget ==> RouteCache was none");
        S.CurrentMoveTarget = S.CurrentPatrolTarget;
    }
    else
    {
        DM("GiveNextMoveTarget ==> RouteCache not none");
        S.CurrentMoveTarget = S.RouteCache[0];    
    }

    DM("GiveNextMoveTarget ==> " $ S.CurrentMoveTarget);
}

function RemoveCurrentMoveTarget()
{
    DM("RemoveCurrentMoveTarget");
    DM("RemoveCurrentMoveTarget ==> " $ S.RouteCache[0]);
    S.RouteCache.Remove(0);
}

function ClearRoute()
{
    DM("ClearRoute");
    EmptyPath();
    S.CurrentPatrolTarget = None;
    S.CurrentNodeDest = None;
}

function EmptyPath()
{
    DM("EmptyPath");
    S.RouteCache.Remove(0, S.RouteCache.Length);
}

function bool RouteIsEmpty()
{
    local bool result;

    DM("RouteIsEmpty");

    result = S.RouteCache.Length <= 0;

    DM("RouteIsEmpty ==> " $ result);

    return result;
}

function bool TargetIsEmpty(Actor A)
{
    local bool result;

    DM("TargetIsEmpty");

    result = A == None;

    DM("TargetIsEmpty ==> " $ result);

    return result;
}

function DebugRoute()
{
    DM("DebugRoute");
    DM("CurrentPatrolTarget ==> " $ S.CurrentPatrolTarget);
    DM("CurrentMoveTarget ==> " $ S.CurrentMoveTarget);

    DebugRouteCache();
}

function DebugRouteCache()
{
    local int i;

    DM("DebugRouteCache");

    for (i = 0; i < S.RouteCache.Length; i++)
    {
        DM("RouteCache[" $ i $ "] = " $ S.RouteCache[i]);
    }
}

/* function MGSneakNode FindNearestNode(Vector Target, Class<NavigationPoint> NodeClass, Optional Name PathTag)
{
    local float curDist;
	local float tempDist;
	local Vector curPointDist;
	local NavigationPoint curPoint;
	local NavigationPoint nearestPoint;
	
    DM("FindNearestSneakNode");

    curDist = 65536;

	forEach AllActors(NodeClass, curPoint, PathTag)
	{
        curPointDist = Target - curPoint.Location;

        tempDist = VSIZESQ(curPointDist);
        
        if (tempDist < curDist)
        {
            curDist = tempDist;
            nearestPoint = curPoint;
        }
	}

	return nearestPoint;
} */

defaultproperties
{
    bHidden=True
}