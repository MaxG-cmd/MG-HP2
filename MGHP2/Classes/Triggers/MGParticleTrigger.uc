class MGParticleTrigger extends Trigger;

// MaxG: Counter.
var int j;

struct EventParticle
{
    var() Name OutEvent;
    var() float OutDelay;
};

var() Array<EventParticle> EventParticles;

var ParticleFX ParticleToTrigger;

function Activate(Actor Other, Pawn EventInstigator)
{
    Super.Activate(Other, EventInstigator);

    GoToState('Triggered');
}

state Triggered
{
    function Activate(Actor Other, Pawn EventInstigator)
    {
        CM("[" $ Name $ "]::Triggered ==> Activated while in state Triggered. Nothing will be done.");
    }

    begin:
        for (j = 0; j < EventParticles.Length; j++)
        {
            Sleep(EventParticles[j].OutDelay);

            forEach AllActors(Class'ParticleFX', ParticleToTrigger, EventParticles[j].OutEvent)
            {
                if (ParticleToTrigger.IsA('MGParticleFX'))
                {
                    MGParticleFX(ParticleToTrigger).ToggleEmission();
                }
                else
                {
                    ParticleToTrigger.bEmit = !ParticleToTrigger.bEmit;
                }
            }
        }

        // MaxG: Return.
        GoToState('NormalTrigger');
}