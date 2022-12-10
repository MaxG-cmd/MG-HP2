class MGPeevesBoss extends HChar;

// var() float MaxFlyTargetErrorDist;

// // MaxG: Animations are hardcoded since I'm always going to use this mesh.
// //       Just a case where modularity is not needed.
// const ANIM_TO_FLY   = 'prefly';
// const ANIM_FLY      = 'Flying';
// const ANIM_IDLE     = 'Idle';
// const ANIM_NULL     = 'None';
// const ANIM_TAUNT_1  = 'Taunt';
// const ANIM_TAUNT_2  = 'taunt_2';
// const ANIM_TAUNT_3  = 'taunt_3';
// const ANIM_ATTACK   = 'throw';

// var PatrolPoint FlyTarget;

// #define DIST(Other) (Location - Other.Location)

// event Trigger(Actor Other, Pawn EventInstigator)
// {
// 	GoToState('Idle');

// 	Super.Trigger(Other, EventInstigator);
// }

// auto state Idle
// {
// 	Ignores TakeDamage;

// 	event Trigger(Actor Other, Pawn EventInstigator)
// 	{
// 		GoToState('FlyToPoint');

// 		Super.Trigger(Other, EventInstigator);
// 	}

// 	event BeginState()
// 	{
// 		eVulnerableToSpell=SPELL_None;
// 	}

// 	event EndState()
// 	{
// 		eVulnerableToSpell=SPELL_Skurge;
// 	}

// 	begin:
// 		Velocity = Vec(0, 0, 0);
// 		Acceleration = Vec(0, 0, 0);
// 		LoopAnim(ANIM_NULL);
// }

// // MaxG: From any location, fly to a target attack point.
// state FlyToPoint
// {
// 	event Tick(float DeltaTime)
// 	{
// 		local Vector MoveTrajectory;
// 		local Vector MoveDirection;
// 		local float Distance;
// 		local float MoveFactor;
// 		local float TimeElapsed;

// 		MoveDirection = DIST(FlyTarget);

// 		TimeElapsed += DeltaTime;

// 		Distance = AirSpeed * TimeElapsed / VSize(MoveDirection);

// 		if ( TimeElapsed < (VSize(MoveDirection) / AirSpeed) )
// 		{
// 			MoveFactor = 6.0 * (Distance - (Distance ** 2)) * AirSpeed;

// 			MoveTrajectory = MoveFactor * Normal(MoveDirection);
			
// 			SetLocation( Location + (MoveTrajectory * DeltaTime) );
// 		}
// 		else
// 		{
// 			SetLocation(FlyTarget.Location);
// 		}

// 		if ( MoveDirection <  MaxFlyTargetErrorDist )
// 		{
// 			// MaxG: State logic.
// 		}
// 	}
// }

defaultproperties
{
	EnemyHealthBar=EnemyBar_Peeves
	AirSpeed=150.00
	Physics=PHYS_FLYING
	eVulnerableToSpell=SPELL_Skurge
	Mesh=SkeletalMesh'HPModels.skpeevesMesh'
	DrawType=DT_Mesh
	AmbientGlow=32
	CollisionRadius=40.00
	CollisionHeight=40.00
	bCollideWorld=False
	bCollideActors=True
	bBlockActors=False
	bProjTarget=True
	RotationRate=(Pitch=80000,Yaw=80000,Roll=80000)
}