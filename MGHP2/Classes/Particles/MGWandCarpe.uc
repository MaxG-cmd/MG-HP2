class MGWandCarpe extends MGParticleFX;

event PostBeginPlay()
{
    local Rotator Rot;

    Super.PostBeginPlay();

    Rot.Pitch = 16384;

    SetRotation(Rot);
}

defaultproperties
{
    ParticlesPerSec=(Base=30)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=0)
    AngularSpreadHeight=(Base=0)
    bSteadyState=True
    Speed=(Base=32)
    Lifetime=(Base=1.25)
    ColorStart=(Base=(R=217,G=170,B=255))
    ColorEnd=(Base=(R=121,B=255))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=6)
    SizeLength=(Base=6)
    SizeEndScale=(Base=0)
    SpinRate=(Base=16,Rand=-32)
    SizeDelay=0.25
    SizeGrowPeriod=0.1
    Chaos=1
    Attraction=(X=6,Y=6,Z=8)
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_1'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.Sparkle_4'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.Dot_1'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.Dot_1'
    Textures(4)=Texture'HPParticle.hp_fx.Particles.Dot_1'

    // MaxG: Light color.
    LightBrightness=96
    LightHue=185
    LightSaturation=35
    LightRadius=4
    LightRadiusInner=32
    LightType=LT_Steady
}