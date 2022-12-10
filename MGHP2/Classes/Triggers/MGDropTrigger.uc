class MGDropTrigger extends Triggers;

#define MG MGHarry(Level.PlayerHarryActor)

var() Sound PoofSound;
var() Class<ParticleFX> PoofFX;

function PoofActor()
{
    local HPawn poof_actor;

    if (MG.CarryingActor != None && !MG.CarryingActor.IsA('MGWizardCracker'))
    {
        poof_actor = HPawn(MG.CarryingActor);

        MG.DropCarryingActor();

        Spawn(PoofFX, , , poof_actor.Location);

        poof_actor.SetLocation(poof_actor.SpawnLocation);

        Spawn(PoofFX, , , poof_actor.Location);

        MG.PlaySound(PoofSound, SLOT_None, [Volume] 0.5, [Radius] 1024, [Pitch] , , false);
    }
}

event Tick(float DeltaTime)
{
    local MGHarry H;

    Super.Tick(DeltaTime);

    ForEach TouchingActors(Class'MGHarry', H)
    {
        if (H != None)
        {
            PoofActor();
        }
    }
}

defaultproperties
{
    PoofSound=Sound'HPSounds.Magic_sfx.cast_Expelliarmus'
    PoofFX=Class'HPParticle.DustCloud02_small'
}