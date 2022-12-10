class MGWizardCracker extends Projectile;

#define PlayerHarry Level.PlayerHarryActor

var() const bool bUseRandomTexture;
var() const float BounceFactor;
var() const float ThrowVelocity;
var() const float DamageMultiplier;
var() const float MaxDamage;
var() const float DamageRadius;
var() const float ExplosionFalloff;
var() const float ExplosionRadius;
var() const float ExplosionStrength;
var() const float ExplosionLoudness;
var() const Vector AdditionalNonPlayerVelocity;
var() const Vector AdditionalPlayerVelocity;
var() Array<Texture> RandomSkins;
var(CrackerSounds) Sound SwellingSound;
var(CrackerSounds) Sound ExplosionSound;
var(CrackerSounds) Sound LandSound;
var(CrackerFX) Class<ParticleFX> AttachFXClass;
var(CrackerFX) Class<ParticleFX> ExplodeFXClass1;
var(CrackerFX) Class<ParticleFX> ExplodeFXClass2;
var ParticleFX AttachedThrowFX;

var() Array<Name> ExplosionBlacklist;

// MaxG: 4 / PI^2
const EXPLOSION_CONSTANT = 0.4052847325801849365234375;

// MaxG: TODO: Bouncing physics.

event PreBeginPlay()
{
    local int RandTexture;

    //Super.PreBeginPlay();

    if (bUseRandomTexture)
    {
        RandTexture = Rand(RandomSkins.Length);
        
        Skin = RandomSkins[RandTexture];
    }
}

event PostBeginPlay()
{
    AttachedThrowFX = Spawn(AttachFXClass, Self, , Location);
}

function float CalculateExplosion(Actor A)
{
    local float distance;
    local float magnitude;

    distance = VSize(A.Location - Location);

    magnitude = ((ExplosionStrength * EXPLOSION_CONSTANT) * (aTan(ExplosionFalloff * ExplosionFalloff / distance)) ** 2);

    return magnitude;
}

// MaxG: Bad.
simulated function Explode(Vector HitLocation, Vector HitNormal)
{

}

singular function Touch(Actor Other)
{

}

function ExplodeCracker()
{
    local Pawn P;
    local MGWizardCracker C;
    local float magnitude;
    local float damage;
    local Vector dist;
    local int i;
    local bool bSkipActor;
    local bool bApplyAdditionalVelocity;

    bApplyAdditionalVelocity = false;

    MakeSneakNoise(ExplosionLoudness);

    forEach RadiusActors(Class'Pawn', P, ExplosionRadius)
    {
        bSkipActor = false;

        for (i = 0; i < ExplosionBlackList.Length; i++)
        {
            // MaxG: Ignore all blacklisted actors.
            if (P.isA(ExplosionBlacklist[i]))
            {
                bSkipActor = true;

                //CM("Ignoring Pawn{" $ P $ "} since it is a " $ ExplosionBlacklist[i]);

                break;
            }
        }
        
        if (!bSkipActor)
        {
            //CM("Exploding Pawn{" $ P $ "}");

            // MaxG: This avoids ruining actors that fly.
            if (P.Physics == PHYS_Walking)
            {
                P.SetPhysics(PHYS_Falling);
                bApplyAdditionalVelocity = true;
            }

            dist = P.Location - Location;
            
            magnitude = CalculateExplosion(P);

            P.Velocity += magnitude * Normal(dist);

            if (bApplyAdditionalVelocity)
            {
                if (P.IsA('Harry'))
                {
                    P.Velocity += AdditionalPlayerVelocity;
                }
                else
                {
                    P.Velocity += AdditionalNonPlayerVelocity;
                }
            }
            
            if (VSize(P.Location - Location) < DamageRadius)
            {
                damage = (magnitude ** 2) * DamageMultiplier * (1 / VSize(dist));

                damage = FClamp(damage, 0, MaxDamage);

                //CM("damage ==> " $ damage);

                P.TakeDamage(damage, None, Location, magnitude * Normal(P.Location - Location), 'Exploded');
            }
        }
    }
        
    PlaySound(ExplosionSound, SLOT_Interact, [Volume] RandRange(0.7, 2.0), [Radius] 4096, [Pitch] RandRange(0.8, 1.2),, false);

    Spawn(ExplodeFXClass1, Self, , Location, Rotation);
    Spawn(ExplodeFXClass2, Self, , Location, Rotation);
    
    Destroy();

    forEach RadiusActors(Class'MGWizardCracker', C, (ExplosionRadius / 2))
    {
        C.ExplodeCracker();
    }
}

function RandomSpin(float SpinRate)
{
    //DesiredRotation = RotRand();

    //DesiredRotation.Pitch = Rand(65536);
    //DesiredRotation.Yaw = Rand(65536);
    //DesiredRotation.Roll = Rand(65536);
    
    //CM("RandomSpin ==> " $ DesiredRotation);

    RotationRate.Yaw 	= SpinRate * 2 * FRand() - SpinRate;
    RotationRate.Pitch 	= SpinRate * 2 * FRand() - SpinRate;
    RotationRate.Roll 	= SpinRate * 2 * FRand() - SpinRate;
}

function MakeSneakNoise(float loudness)
{
    local MGSneakActor hearer;

    if ( MGSneakZone(Region.Zone).bSilentZone )
    {
        return;
    }
    
    forEach AllActors(class'MGhp2.MGSneakActor', hearer)
    {
        hearer.SneakHearNoise(loudness, self);
    }
}

event Tick(float DeltaTime)
{
    Super.Tick(DeltaTime);

    // MaxG: Destroy if in cutscene.
    if (PlayerHarry.bIsCaptured)
    {
        Destroy();
    }

    // MaxG: Update FX location.
    if (AttachedThrowFX != None)
    {
        AttachedThrowFX.SetLocation(Location);
    }
}



auto state WaitingToBeThrown
{

}

state StateBeingThrown
{
    event BeginState()
    {
        SetCollision(true, true, false);

        SetPhysics(PHYS_Falling);

        RandomSpin(80000);
    }

    event EndState()
    {

    }

    event Bump(Actor Other)
    {
        if (Other.isA('HChar'))
        {
            ExplodeCracker();
            return;
        }

        if (Other.isA('HProp'))
        {
            PlaySound(LandSound, SLOT_Interact, [Volume] RandRange(0.1, 0.3), [bNoOverride] true, [Radius] 768, [Pitch] RandRange(0.98, 1.04), , false);

            GoToState('WaitingToExplode');
        }
    }

    event HitWall(Vector HitNormal, Actor Wall)
    {
        // if (HitNormal.Z > 0.5)
        // {
        // 	Landed(HitNormal);
        // 	return;
        // }

        //Velocity = MirrorVectorByNormal(Velocity, HitNormal);
        //Velocity *= BounceFactor;

        PlaySound(LandSound, SLOT_Interact, [Volume] RandRange(0.1, 0.3), [bNoOverride] true, [Radius] 768, [Pitch] RandRange(0.98, 1.04), , false);
    }
    
    event Landed(Vector HitNormal)
    {
        DesiredRotation 	= Rotation;
        RotationRate.Pitch 	= 0;
        RotationRate.Yaw 	= 0;
        RotationRate.Roll 	= 0;

        PlaySound(LandSound, SLOT_Interact, [Volume] RandRange(0.2, 0.5), [bNoOverride] true, [Radius] 768, [Pitch] RandRange(0.98, 1.04), , false);
        
        GoToState('WaitingToExplode');
    }

    // MaxG: Account for it getting stuck.
    event Tick(float DeltaTime)
    {
        if (VSize(Velocity) < 2.0)
        {
            GoToState('WaitingToExplode');
        }

        Global.Tick(DeltaTime);
    }
}

state WaitingToExplode
{
    event Landed(Vector HitNormal)
    {
        DesiredRotation 	= Rotation;
        RotationRate.Pitch 	= 0;
        RotationRate.Yaw 	= 0;
        RotationRate.Roll 	= 0;

        PlaySound(LandSound, SLOT_Interact, [Volume] RandRange(0.2, 0.5), [bNoOverride] true, [Radius] 768, [Pitch] RandRange(0.98, 1.04), , false);
    }

    Begin:
        PlaySound(SwellingSound, SLOT_Misc, [Volume] RandRange(0.1, 0.3), [Radius] 1024, [Pitch] RandRange(1.0, 1.04), , false);
        PlayAnim('Swell', 3.0);
        FinishAnim();
        PlayAnim('Shake', 2.0);
        FinishAnim();

        ExplodeCracker();
}

event Destroyed()
{
    Super.Destroyed();

    if (AttachedThrowFX != None)
    {
        AttachedThrowFX.Destroy();
    }
}

defaultproperties
{
    //bBounce=False
    //bRealisticBounce=True
    AdditionalNonPlayerVelocity=(X=0,Y=0,Z=256);
    AdditionalPlayerVelocity=(X=0,Y=0,Z=128);
    AmbientGlow=32
    AttachFXClass=Class'MGHP2.MGParticleCrackerFly'
    bBlockActors=True
    bBlockPlayers=False
    bCanTeleport=True
    bCollideActors=True
    bCollideWorld=True
    bFixedRotationDir=True
    bMovable=True
    BounceFactor=0.5
    bRotateToDesired=False
    bStatic=False
    bUseRandomTexture=True
    CollisionHeight=7
    CollisionRadius=10
    DamageMultiplier=0.14
    DamageRadius=170
    DrawScale=0.9
    DrawType=DT_Mesh
    ExplodeFXClass1=Class'MGParticleWizardCrackerExplodeA'
    ExplodeFXClass2=Class'MGParticleWizardCrackerExplodeB'
    ExplosionBlacklist(0)="Camera"
    ExplosionBlacklist(1)="Sprite"
    ExplosionBlacklist(10)="Boeing747"
    ExplosionBlacklist(11)="BooksSaveBook"
    ExplosionBlacklist(12)="Boulder"
    ExplosionBlacklist(13)="BoulderChase"
    ExplosionBlacklist(14)="BowTrickleTwig"
    ExplosionBlacklist(15)="BronzeCauldron"
    ExplosionBlacklist(16)="CandleF"
    ExplosionBlacklist(17)="ChallengeStar"
    ExplosionBlacklist(18)="ChallengeStarFinal"
    ExplosionBlacklist(19)="chestbronze"
    ExplosionBlacklist(2)="BaseCam"
    ExplosionBlacklist(20)="CHGrate"
    ExplosionBlacklist(21)="ChickenLeg"
    ExplosionBlacklist(22)="CutSceneMarker"
    ExplosionBlacklist(23)="FawkesAshes"
    ExplosionBlacklist(24)="FinalStar"
    ExplosionBlacklist(25)="FordAnglia"
    ExplosionBlacklist(26)="FordAngliaDamaged"
    ExplosionBlacklist(27)="FordAngliaDamagedLow"
    ExplosionBlacklist(28)="GnomeHome"
    ExplosionBlacklist(29)="HAlohomora"
    ExplosionBlacklist(3)="CreatureGenerator"
    ExplosionBlacklist(30)="HAmbientStaticCritters"
    ExplosionBlacklist(31)="HAragogLair"
    ExplosionBlacklist(32)="HBathroom"
    ExplosionBlacklist(33)="HBooks"
    ExplosionBlacklist(34)="HBottlesJars"
    ExplosionBlacklist(35)="HCandlesLamps"
    ExplosionBlacklist(36)="HCauldron"
    ExplosionBlacklist(37)="HCave"
    ExplosionBlacklist(38)="HDecoration"
    ExplosionBlacklist(39)="HDiffindo"
    ExplosionBlacklist(4)="DebrisGenerator"
    ExplosionBlacklist(40)="HDishesCutlery"
    ExplosionBlacklist(41)="HFlipendo"
    ExplosionBlacklist(42)="HFurniture"
    ExplosionBlacklist(43)="HorklumpsHead"
    ExplosionBlacklist(44)="HorklumpsLump"
    ExplosionBlacklist(45)="HorklumpsStem"
    ExplosionBlacklist(46)="HPeeves"
    ExplosionBlacklist(47)="HPlants"
    ExplosionBlacklist(48)="HQuidditch"
    ExplosionBlacklist(49)="HSigns"
    ExplosionBlacklist(5)="Despawner"
    ExplosionBlacklist(50)="ImpHome"
    ExplosionBlacklist(51)="LessonBackground"
    ExplosionBlacklist(52)="LightRay"
    ExplosionBlacklist(53)="MGCarpeSwingTarget"
    ExplosionBlacklist(54)="MGProp"
    ExplosionBlacklist(55)="MushroomLight"
    ExplosionBlacklist(56)="MushroomLightBlue"
    ExplosionBlacklist(57)="PotionIngredients"
    ExplosionBlacklist(58)="QArmor"
    ExplosionBlacklist(59)="SnailTrail"
    ExplosionBlacklist(6)="GenericSpawner"
    ExplosionBlacklist(60)="SnakeBeam"
    ExplosionBlacklist(61)="SnakeRay"
    ExplosionBlacklist(62)="SnakeVenomPool"
    ExplosionBlacklist(63)="SpellBallTrail"
    ExplosionBlacklist(64)="SpellLessonShape"
    ExplosionBlacklist(65)="SpellLessonWand"
    ExplosionBlacklist(66)="SpikyPlantHeadSpikes"
    ExplosionBlacklist(67)="SpikyPlantStem"
    ExplosionBlacklist(68)="SpongifyPad"
    ExplosionBlacklist(69)="SpongifySheet"
    ExplosionBlacklist(7)="SavePoint"
    ExplosionBlacklist(70)="SpongifyTarget"
    ExplosionBlacklist(71)="ThunderClouds"
    ExplosionBlacklist(72)="VendorNimbusBroom"
    ExplosionBlacklist(73)="WaterPuddle"
    ExplosionBlacklist(74)="WhompedAngliaLow"
    ExplosionBlacklist(75)="WiggenWell"
    ExplosionBlacklist(76)="WindCloud"
    ExplosionBlacklist(77)="HiddenHPawn"
    ExplosionBlacklist(78)="QuidditchPawn"
    ExplosionBlacklist(79)="HiddenHPawn"
    ExplosionBlacklist(8)="TargetPoint"
    ExplosionBlacklist(80)="MGPropActive"
    ExplosionBlacklist(9)="Hedwig"
    ExplosionFalloff=16
    ExplosionLoudness=0.3
    ExplosionRadius=170
    ExplosionSound=Sound'HPSounds.Magic_sfx.Dueling_MIM_hit'
    ExplosionStrength=256
    LandSound=Sound'MGSounds.WizardCracker.WizardCrackerLand'
    Mass=128
    MaxDamage=41
    Mesh=SkeletalMesh'MGModels.WizardCracker'
    Physics=PHYS_Falling
    RandomSkins(0)=Texture'MGModelTex.wizardcrackers.moonsparkles'
    RandomSkins(1)=Texture'MGModelTex.wizardcrackers.greencracker'
    RandomSkins(2)=Texture'MGModelTex.wizardcrackers.purplecracker'
    RandomSkins(3)=Texture'MGModelTex.wizardcrackers.yellowcracker'
    SpecularGlow=1.5
    SpecularWidth=48
    SwellingSound=Sound'MGSounds.WizardCracker.WizardCrackerBuildup'
    ThrowVelocity=550
}