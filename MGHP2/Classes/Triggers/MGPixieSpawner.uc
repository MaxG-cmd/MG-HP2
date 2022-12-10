class MGPixieSpawner extends Trigger;

var() Name SpawnState;
var() float DelayBetweenSpawns;
var() Class<ParticleFX> SpawnParticle;

struct PixieProperties
{
    var() Name  PixiePathTag;
    var() float PixieInvincibilityDuration;
    var() float PixieAtPointRadius;
    var() float PixieChaseRadius;
    var() float PixieChaseCooldown;
    var() float PixieThrowCooldown;
    var() int   PixieMaxConsecutiveSpells;
    var() int   PixieHitsToKill;
    var() float PixieBiteRadius;
    var() float PixieBiteDamage;
    var() float PixieChanceOfChasing;
    var() float PixieChanceOfThrowing;
    var() float PixieMaxStuckVelocity;
    var() float PixieMaxStuckTime;

    var() Name      PixieEvent;
    var() Name      PixieTag;
    var() Name      PixieCutName;
    var() Rotator   PixieRotationRate;
    var() float     PixieAirSpeed;
    var() float     PixieAccelRate;
    var() float     PixieDrawScale;
    var() float     PixieCollisionRadius;
    var() float     PixieCollisionHeight;
};

var Array<MGPixie> Pixie;

var() Array<PixieProperties> Pixies;

var Vector TempSpawnLoc;

// MaxG: Optional. If (0, 0, 0), trigger location will be used.
var() Vector SpawnLocation;

var int i;

function Activate(Actor Other, Pawn EventInstigator)
{
    Super.Activate(Other, EventInstigator);

    GoToState('SpawnPixies');
}

state SpawnPixies
{
    begin:
        for (i = 0; i < Pixies.Length; i++)
        {
            if (SpawnLocation == Vec(0, 0, 0))
            {
                TempSpawnLoc = Location;
            }
            else
            {
                TempSpawnLoc = SpawnLocation;
            }

            // MaxG: Spawn and ignore collision.
            Pixie[i] = Spawn(Class'MGPixie', None, Pixies[i].PixieTag, TempSpawnLoc, , true );

            if (SpawnParticle != None)
            {
                Spawn(SpawnParticle, None, , TempSpawnLoc, );
            }

            Pixie[i].SetCollision(false, false, false);

            Pixie[i].PathTag            = Pixies[i].PixiePathTag;
            Pixie[i].InvincibilityDuration = Pixies[i].PixieInvincibilityDuration;
            Pixie[i].AtPointRadius      = Pixies[i].PixieAtPointRadius;
            Pixie[i].ChaseRadius        = Pixies[i].PixieChaseRadius;
            Pixie[i].ChaseCooldown      = Pixies[i].PixieChaseCooldown;
            Pixie[i].ThrowCooldown      = Pixies[i].PixieThrowCooldown;
            Pixie[i].MaxConsecutiveSpells = Pixies[i].PixieMaxConsecutiveSpells;
            Pixie[i].HitsToKill         = Pixies[i].PixieHitsToKill;
            Pixie[i].BiteRadius         = Pixies[i].PixieBiteRadius;
            Pixie[i].BiteDamage         = Pixies[i].PixieBiteDamage;
            Pixie[i].ChanceOfChasing    = Pixies[i].PixieChanceOfChasing;
            Pixie[i].ChanceOfThrowing   = Pixies[i].PixieChanceOfThrowing;
            Pixie[i].MaxStuckVelocity   = Pixies[i].PixieMaxStuckVelocity;
            Pixie[i].MaxStuckTime       = Pixies[i].PixieMaxStuckTime;

            Pixie[i].RotationRate   = Pixies[i].PixieRotationRate;
            Pixie[i].AccelRate      = Pixies[i].PixieAccelRate;
            Pixie[i].DrawScale      = Pixies[i].PixieDrawScale;
            Pixie[i].Event          = Pixies[i].PixieEvent;

            // MaxG: This is a string in the game. But a string is a dynamic array, which is problematic.
            Pixie[i].CutName                   = String(Pixies[i].PixieCutName);
            
            Pixie[i].SetCollisionSize(Pixies[i].PixieCollisionRadius, Pixies[i].PixieCollisionHeight);

            Sleep(DelayBetweenSpawns);
        }

        // MaxG: Enable collision.
        for (i = 0; i < Pixie.Length; i++)
        {
            Pixie[i].SetCollision(true, true, true);
            Pixie[i].GoToState(SpawnState);
            Pixie[i] = None;
        }

        GoToState('NormalTrigger');
}

defaultproperties
{
    Texture=Texture'HGame.SthingE'
    TriggerType=TT_ClassProximity
    bDoActionWhenTriggered=True
    SpawnState="FlyAround"
    DelayBetweenSpawns=0.1
    SpawnParticle=Class'HPParticle.PixieHit'
    Pixies(0)=(PixieInvincibilityDuration=2.8,PixieAtPointRadius=48,PixieChaseRadius=1024,PixieChaseCooldown=2,PixieThrowCooldown=0.4,PixieMaxConsecutiveSpells=2,PixieHitsToKill=3,PixieBiteRadius=64,PixieBiteDamage=12,PixieChanceOfChasing=20,PixieChanceOfThrowing=40,PixieMaxStuckVelocity=96,PixieMaxStuckTime=2,PixieTag=MGPixie,PixieCutName=Pixie1,PixieRotationRate=(Pitch=130000,Yaw=130000,Roll=130000),PixieAirSpeed=400,PixieAccelRate=768,PixieDrawScale=2,PixieCollisionRadius=24,PixieCollisionHeight=24)
}