class MGSoundFX extends Trigger;

struct AllSounds
{
    var() Sound SoundToPlay;
    var() ESoundSlot SoundSlot;
    var() float SoundVolume;
    var() bool bDoNotOverrideCurSound;
    var() float SoundRadius;
    var() float SoundPitch;
    var() bool bPlay2D;
    var() bool bLoopSound;
    var() float DelayUntilNext;
};

var() Array<AllSounds> Sounds;

var int i;

function Activate(Actor Other, Pawn EventInstigator)
{
    Super.Activate(Other, EventInstigator);

    GoToState('PlayingSounds');
}

state PlayingSounds
{
    event BeginState()
    {
        Super.BeginState();

        //CM("[" $ Name $ "] entered " $ GetStateName());
    }

    begin:
        for (i = 0; i < Sounds.Length; i++)
        {
            // MaxG: Break if none.
            if (Sounds[i].SoundToPlay == None)
            {
                break;
            }

            // MaxG: Play the sound.
            PlaySound(Sounds[i].SoundToPlay, Sounds[i].SoundSlot, Sounds[i].SoundVolume, Sounds[i].bDoNotOverrideCurSound, Sounds[i].SoundRadius, Sounds[i].SoundPitch, Sounds[i].bPlay2D, Sounds[i].bLoopSound);
            
            if (Sounds.Length > 1)
            {
                // MaxG: Wait for it to finish.
                Sleep(GetSoundDuration(Sounds[i].SoundToPlay));
            }


            // MaxG: Extra sleep.
            if (Sounds[i].DelayUntilNext > 0)
            {
                Sleep(Sounds[i].DelayUntilNext);
            }
        }

        GoToState('NormalTrigger');
}

defaultproperties
{
    Texture=Texture'Engine.Snd_FX'
    bDoActionWhenTriggered=True
}