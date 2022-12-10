class MGRandomSoundFX extends Keypoint;

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
    var() float PlayFrequency;
};

var() Array<AllSounds> Sounds;

var() float MinTimeBetweenSounds;
var() float MaxTimeBetweenSounds;

var float DelayBeforeNextSound;

var int SoundIndex;

function int GetRandomSoundIndex()
{
    local float sum_chance;
    local float random_chance;
    local int i;

    random_chance = RandRange(0.0, 100.0);
    sum_chance = 0;

    //CM("Random chance is " $ random_chance);

    // MaxG: Loop over the list of all events.
    for (i = 0; i < Sounds.Length; i++)
    {
        // MaxG: Accumulate frequency. Each sound has a different frequency.
        sum_chance += Sounds[i].PlayFrequency;

        //CM("Sum chance is " $ sum_chance);

        // MaxG: Random event selected.
        if (random_chance <= sum_chance)
        {
            return i;
        }
    }

    return 0;
}

auto state WaitingToPlay
{
    event BeginState()
    {
        DelayBeforeNextSound = RandRange(MinTimeBetweenSounds, MaxTimeBetweenSounds);
    }

    begin:
        Sleep(DelayBeforeNextSound);
        GoToState('PlayingSounds');
}

state PlayingSounds
{
    begin:
        SoundIndex = GetRandomSoundIndex();

        // MaxG: Play the sound.
        PlaySound(Sounds[SoundIndex].SoundToPlay, Sounds[SoundIndex].SoundSlot, Sounds[SoundIndex].SoundVolume, Sounds[SoundIndex].bDoNotOverrideCurSound, Sounds[SoundIndex].SoundRadius, Sounds[SoundIndex].SoundPitch, Sounds[SoundIndex].bPlay2D, Sounds[SoundIndex].bLoopSound);
        
        // MaxG: Wait for it to finish.
        Sleep(GetSoundDuration(Sounds[SoundIndex].SoundToPlay));

        GoToState('WaitingToPlay');
}

defaultproperties
{
    Texture=Texture'Engine.Snd_FX'
    bStatic=False
}