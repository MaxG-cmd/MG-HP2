class MGLevelLoadSoundFX extends Keypoint;

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
    var() Name EventOnEndSound;
};

var() Array<AllSounds> Sounds;

var() float InitialPlayDelay;

var int i;

auto state PlayingSounds
{

    event BeginState()
    {
        CM("[" $ Name $ "] entered " $ GetStateName());
    }

    begin:
        if (InitialPlayDelay > 0)
        {
            Sleep(InitialPlayDelay);
        }

        for (i = 0; i < Sounds.Length; i++)
        {
            // MaxG: Break if none.
            if (Sounds[i].SoundToPlay == None)
            {
                break;
            }

            // MaxG: Play the sound.
            PlaySound(Sounds[i].SoundToPlay, Sounds[i].SoundSlot, Sounds[i].SoundVolume, Sounds[i].bDoNotOverrideCurSound, Sounds[i].SoundRadius, Sounds[i].SoundPitch, Sounds[i].bPlay2D, Sounds[i].bLoopSound);
            
            // MaxG: Wait for it to finish.
            Sleep(GetSoundDuration(Sounds[i].SoundToPlay));

            // MaxG: Extra sleep.
            if (Sounds[i].DelayUntilNext > 0)
            {
                Sleep(Sounds[i].DelayUntilNext);
            }

            // MaxG: Even to Trigger.
            if (Sounds[i].EventOnEndSound != 'None')
            {
                TriggerEvent(Sounds[i].EventOnEndSound, Self, Level.PlayerHarryActor);
            }
        }
}

defaultproperties
{
    Texture=Texture'Engine.Snd_FX'
    bStatic=False
}