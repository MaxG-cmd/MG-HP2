class MGSpawner extends HPawn;

#define PLAY_OPENING_SOUND PlaySound(OpeningSound, SLOT_None, OpeningSoundVolume, false, 4096.0, 1.0, false, false)
#define PLAY_CLOSING_SOUND PlaySound(ClosingSound, SLOT_None, ClosingSoundVolume, false, 4096.0, 1.0, false, false)
#define PLAY_SPAWNING_SOUND PlaySound(SpawningSound, SLOT_None, SpawningSoundVolume, false, 4096.0, 1.0, false, false)
#define SPAWN_AMOUNT RandRange(SpawnItems[itA].MinAmount, SpawnItems[itA].MaxAmount)

var(MGSpawnerAnimations) Name OpenedAnimation;
var(MGSpawnerAnimations) Name ClosedAnimation;
var(MGSpawnerAnimations) Name OpeningAnimation;
var(MGSpawnerAnimations) Name ClosingAnimation;

var(MGSpawnerSounds) Sound OpeningSound;
var(MGSpawnerSounds) Sound ClosingSound;
var(MGSpawnerSounds) Sound SpawningSound;

var(MGSpawnerSounds) float OpeningSoundVolume;
var(MGSpawnerSounds) float ClosingSoundVolume;
var(MGSpawnerSounds) float SpawningSoundVolume;

struct SpawnItem
{
    var() bool bMakePersistent;
    
    // MaxG: Amounts to spawn.
    var() int MinAmount;
    var() int MaxAmount;

    // MaxG: Chance this block will get spawned.
    var() float SpawnBlockChance;

    // MaxG: Chance each item will get spawned.
    var() float SpawnItemChance;

    // MaxG: Multiply this individual actor's velocity by this amount.
    var() Vector VelocityMultiplier;

    var() Class<Actor> SpawnClass;
    var() Class<ParticleFX> SpawnParticle;
};

var() int NumLives;
var int NumHits;

// MaxG: Loop iterators.
var int itA;
var int itB;

// MaxG: If this is zero, then it will only play the spawn sound once.
var() float DelayBtwSpawns;
var() float StayOpenTime;
var() float InitialSpawnDelay;

var() Vector SpawnMinPos;
var() Vector SpawnMaxPos;
var() Vector SpawnMinVel;
var() Vector SpawnMaxVel;

var Vector RotatedSpawnPos;

var Name EndEvent;
var float RandDecision;

// MaxG: This sucks :)
var ESpellType SavedSpellType;

// MaxG: The list of items to spawn.
var() Array<SpawnItem> SpawnItems;

var Actor SpawnActor;

event PreBeginPlay()
{
    SavedSpellType = eVulnerableToSpell;

    Super.PreBeginPlay();
}

function Vector GetSpawnVelocity(Vector Multiplier)
{
    local Vector result;

    result.X = RandRange(SpawnMinVel.X, SpawnMaxVel.X);
    result.Y = RandRange(SpawnMinVel.Y, SpawnMaxVel.Y);
    result.Z = RandRange(SpawnMinVel.Z, SpawnMaxVel.Z);

    result *= Multiplier;

    // MaxG: Match rotation.
    result = result >> Rotation;

    return result;
}

function Vector GetRotatedSpawnPos()
{
    local Vector result;
    local Vector pos;

    pos.X = RandRange(SpawnMinPos.X, SpawnMaxPos.X);
    pos.Y = RandRange(SpawnMinPos.Y, SpawnMaxPos.Y);
    pos.Z = RandRange(SpawnMinPos.Z, SpawnMaxPos.Z);

    result = (pos >> Rotation) + Location;

    return result;
}

// MaxG: Allow for proper spell handling.
function bool IsRelevant(Actor Other)
{
    if (Other == None)
    {
        return false;
    }

    if ( BaseSpell(Other).SpellType == eVulnerableToSpell)
    {
        return true;
    }

    return false;
}


auto state AwaitingSpell
{
    event Trigger(Actor Other, Pawn EventInstigator)
    {
        GoToState('Opening');
    }

    event BeginState()
    {
        eVulnerableToSpell = SavedSpellType;
    }

    event EndState()
    {
        eVulnerableToSpell = SPELL_None;
    }

    // MaxG: Detect spells.
    event Touch(Actor Other)
    {
        if ( IsRelevant(Other) )
        {
            NumHits++;
            GoToState('Opening');
            BaseSpell(Other).HitAndDestroy();
        }
    }

    begin:
        LoopAnim(ClosedAnimation);
}

state Opening
{
    begin:
        PLAY_OPENING_SOUND;
        PlayAnim(OpeningAnimation);
        FinishAnim();
        GoToState('SpawningItems');
}

state SpawningItems
{
    begin:
        Sleep(InitialSpawnDelay);

        TriggerEvent(Event, Self, Self);

        if (DelayBtwSpawns <= 0)
        {
            PLAY_SPAWNING_SOUND;
        }

        // MaxG: Loop through all items to spawn.
        for (itA = 0; itA < SpawnItems.Length; itA++)
        {

            RandDecision = RandRange(0.0, 100.0);

            // MaxG: Skip if random.
            if (SpawnItems[itA].SpawnBlockChance <= RandDecision)
            {
                continue;
            }

            for (itB = 0; itB < SPAWN_AMOUNT; itB++)
            {

                RandDecision = RandRange(0.0, 100.0);

                // MaxG: Skip if random.
                if (SpawnItems[itA].SpawnItemChance <= RandDecision)
                {
                    continue;
                }

                RotatedSpawnPos = GetRotatedSpawnPos();

                // MaxG: Spawn the particle. Ignore collision.
                Spawn( SpawnItems[itA].SpawnParticle, None, , RotatedSpawnPos, Rotation, true );

                // MaxG: Spawn the item
                SpawnActor = Spawn( SpawnItems[itA].SpawnClass, None, , RotatedSpawnPos, Rotation, true );

                SpawnActor.Velocity = GetSpawnVelocity(SpawnItems[itA].VelocityMultiplier);

                SpawnActor.bPersistent = SpawnItems[itA].bMakePersistent;

                SpawnActor = None;

                if (DelayBtwSpawns > 0)
                {
                    PLAY_SPAWNING_SOUND;
                    Sleep(DelayBtwSpawns);
                }
            }
        }

        Sleep(StayOpenTime);

        if (NumHits >= NumLives)
        {   
            GoToState('OutOfLives');
        }
        else
        {
            PlayAnim(ClosingAnimation);
            FinishAnim();
            GoToState('AwaitingSpell');
        }
}


state OutOfLives
{
    event BeginState()
    {
        TriggerEvent(EndEvent, Self, Self);
    }

    begin:
        LoopAnim(OpenedAnimation);
}


defaultproperties
{
    CentreOffset=(X=0,Y=0,Z=24)
    bGestureFaceHorizOnly=False
    NumHits=0
}