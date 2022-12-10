class MGspellCursor extends SpellCursor;

// Cache textures dynamically
var(SpellTextures) WetTexture     SpellCursors[28];
var(SpellTextures) string        SpellCursorTexNames[28];

function WetTexture GetGestureTexture( ESpellType SpellType )
{    
    // Check if it's loaded yet
    if(SpellCursors[SpellType] == none && SpellCursorTexNames[SpellType] != "")
    {
        // Load it
        SpellCursors[SpellType] = WetTexture(DynamicLoadObject(SpellCursorTexNames[SpellType], class'WetTexture'));
    }
    else if(SpellCursorTexNames[SpellType] == "")
    {
        return None;
    }
    
    // Return the loaded, cached texture
    return SpellCursors[SpellType];
}


// Update the cursor's position by following our LOS and see what we hit first
function UpdateCursor(optional bool bJustStopAtClosestPawnOrWall)
{
	local actor		tempHitActor;
	local bool		bHitActor;
	local vector	vFirstHitPos;

	// If we are not currently targeting then return
	if( bEmit == false && !bInvisibleCursor )
		return;
	
	// Reset our possible victim
	aPossibleTarget = none;
	bHitSomething	= false;
	
	// *** Set our LOS (line of sight) START point
	// (obtained from the player's location + offset to harry's eyes)
	vLOS_Start	= playerHarry.cam.CamTarget.location;//playerHarry.location + vec(0,0,playerHarry.EyeHeight);
	
	// *** Set our LOS END point
	if( playerHarry.bInDuelingMode )
	{
		vLOS_End = playerHarry.Location
		          + (vector(playerHarry.rotation) * fLOS_Distance);
	}
	else
	if( playerHarry.bHarryUsingSword )
	{
		vLOS_End =  playerHarry.cam.Location
		          + ( vector(playerHarry.cam.rotation+playerHarry.AimRotOffset) * (playerHarry.cam.CurrentSet.fLookAtDistance + fLOS_Distance) );
	}
	else
	{
		// (obtained by the camera's forward vector)
		// our line of sight END point is deturmined by the forward vector of the camera
		vLOS_End = playerHarry.cam.Location + 
			( playerHarry.cam.vForward * (playerHarry.cam.CurrentSet.fLookAtDistance + fLOS_Distance) );
	}

	// *** Set our LOS direction vector
	vLOS_Dir = normal(vLOS_End - vLOS_Start);
	
	// The trace line is from the camera's pos allong it's forward vector
	// we do this so we can find the point that Harry is aiming at
	tempHitActor = Trace(vHitLocation, vHitNormal, vLOS_End, playerHarry.cam.Location );

	if( tempHitActor != None && !tempHitActor.IsA('BaseHarry') )
	{
		// We hit a wall
		bHitSomething = true;
		
		// Set our new end point 
		// (add a small extension so if we hit an actor the next line check from harry to the end point will find it)
		vLOS_End = vHitLocation + (vLOS_Dir * 5.0);
	}
	
	// *** Check LOS collision with actors
	// test the line segment between harry and the possible target
	foreach TraceActors(class'actor', tempHitActor, vHitLocation, vHitNormal, vLOS_End, vLOS_Start)
	{
		// *** Hit actor, update end point and see if it is a potential target

		// Trivially reject objects
		if( tempHitActor == Owner || tempHitActor.IsA('Harry') ||
			( !tempHitActor.IsA('Pawn') && !tempHitActor.IsA('GridMover') && !tempHitActor.IsA('spellTrigger') && !tempHitActor.IsA('MGspellEctoLarge') && !tempHitActor.IsA('MGSpellPixieBall') && !tempHitActor.IsA('MGSpellBaseball') && !tempHitActor.IsA('MGInteractive')))
			continue;

		//DEBUG
		//if( bEmit && bDebugMode )
			//playerHarry.ClientMessage(" TraceActors Hit actor -> " $tempHitActor );
		
		// Save our first tempHitActor if it is visible
		if(!bHitActor && !tempHitActor.bHidden )
		{
			// We hit something ( although it may not be a valid target to lock onto )
			bHitSomething = true;
			bHitActor     = true;
			vFirstHitPos  = vHitLocation;
		}
		
		if( tempHitActor.eVulnerableToSpell == SPELL_None )
			continue;
		
		// --- See if we have a possible target
		if( playerHarry.IsInSpellBook( tempHitActor.eVulnerableToSpell ) || ( bJustStopAtClosestPawnOrWall ) )
		{
			// If we hit a spell trigger make sure it can be hit at this time
			if( tempHitActor.IsA('spellTrigger') && !spellTrigger(tempHitActor).bInitiallyActive )
				continue;
			

			// We found a possible target, if doing normal casting, set some vars, then break out
			if( !bJustStopAtClosestPawnOrWall )
			{
				aPossibleTarget = tempHitActor;
				vTargetOffset   = vHitLocation - aPossibleTarget.location;
			}
	
			// Weather it was a valid target or not we need to leave now that we hit our first object
			vLastValidHitPos = vHitLocation;
		}
		
		vLOS_End = vHitLocation;
		break;
	
	} // end for each actor
	
	// If we hit an actor but we didn't find a possible target then set our new end point at our first hitLocation
	if( aPossibleTarget == None && bHitActor )
		vLOS_End = vFirstHitPos;
	
	// *** Update Position 
	if( aCurrentTarget == None )
	{
		MGHarryWand(PlayerHarry.Weapon).ResetWandGlowFX();

		// Move our target to point where our LOS ends offset by a little bit
		MoveSmooth((vLOS_End - (vLOS_Dir * 8.0)) - Location);

		if( aPossibleTarget != None )
			SpellGesture.SetLocation( vLOS_End );
	}

}

/*function LockOn(Actor TargetActor)
{
	Super.LockOn(TargetActor);
	baseWand(PlayerHarry.Weapon).ChooseSpell(TargetActor.eVulnerableToSpell);
}*/

DefaultProperties
{
    SpellCursorTexNames(1)="SpellShapes.SpellFX.AlohomoraWet1"
    SpellCursorTexNames(3)="MGSpells.SpellWet.CarpeWet"
    SpellCursorTexNames(4)="SpellShapes.SpellFX.LumosWet1"
    SpellCursorTexNames(7)="MGSpells.SpellWet.WingardiumWet"
    //SpellCursorTexNames(11)="MGSpells.Wet.wetReparo"
    SpellCursorTexNames(13)="SpellShapes.SpellFX.FlipendoWet1"
    SpellCursorTexNames(19)="SpellShapes.SpellFX.DiffindoWet1"
    SpellCursorTexNames(20)="SpellShapes.SpellFX.SkurgeWet1"
    SpellCursorTexNames(21)="SpellShapes.SpellFX.SpongifyWet1"
    SpellCursorTexNames(22)="SpellShapes.SpellFX.RictusWet1"
    SpellCursorTexNames(27)="SpellShapes.SpellFX.ExpelWet1"
}