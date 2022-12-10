class MGWandGlow extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=35,Rand=15)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=1,Rand=2)
    Lifetime=(Rand=0.5)
    ColorStart=(Base=(R=34,G=84,B=255))
    ColorEnd=(Base=(R=113,G=6,B=164))
    AlphaEnd=(Base=0.25)
    SizeWidth=(Rand=-1)
    SizeLength=(Rand=-1)
    SizeEndScale=(Base=0)
    SpinRate=(Base=5,Rand=10)
    SizeDelay=0.25
    SizeGrowPeriod=0.1
    Chaos=3
    Attraction=(X=1,Y=1,Z=1)
    Damping=0.5
    GravityModifier=0.03
    Textures(0)=Texture'HPParticle.hp_fx.Particles.flare4'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.flare4'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.flare4'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.flare4'
    Textures(4)=Texture'HPParticle.hp_fx.Particles.flare5'

    // MaxG: Light color.
    LightBrightness=96
    LightHue=154
    LightSaturation=35
    LightRadius=4
    LightRadiusInner=32
    LightType=LT_Steady
}