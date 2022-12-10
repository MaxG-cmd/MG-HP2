class MGWandSpongify extends MGParticleFX;

event PostBeginPlay()
{
    local Rotator Rot;

    Super.PostBeginPlay();

    Rot.Pitch = 16384;

    SetRotation(Rot);
}

defaultproperties
{
    AttachedParticleClasses(0)=Class'MGWandSpongifyGlow'
    ParticlesPerSec=(Base=1)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=4)
    AngularSpreadHeight=(Base=4)
    bSteadyState=True
    Speed=(Base=32,Rand=64)
    Lifetime=(Base=1.5,Rand=0.5)
    ColorStart=(Base=(R=50,G=147,B=60),Rand=(R=30,G=80,B=90))
    ColorEnd=(Base=(R=55,G=147,B=92),Rand=(R=30,G=80,B=90))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=1,Rand=4)
    SizeLength=(Base=1,Rand=4)
    SizeEndScale=(Base=0)
    SpinRate=(Base=3,Rand=-6)
    SizeDelay=1
    SizeGrowPeriod=0.05
    Chaos=1
    Elasticity=0.5
    Attraction=(X=1,Y=1,Z=1)
    GravityModifier=0.15
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Les_Sparkle_01'
}