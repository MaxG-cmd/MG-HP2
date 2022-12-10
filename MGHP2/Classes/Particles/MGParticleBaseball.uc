class MGParticleBaseball extends MGParticleFX;

defaultproperties
{
    DefaultLightBrightness=215
    ParticlesPerSec=(Base=120)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=2)
    Lifetime=(Base=0.4,Rand=0.5)
    ColorStart=(Base=(R=91,G=255,B=120))
    ColorEnd=(Base=(R=0,G=225,B=130))
    AlphaEnd=(Base=0.5)
    SizeWidth=(Base=16,Rand=24)
    SizeLength=(Base=16,Rand=24)
    SizeEndScale=(Base=0)
    SpinRate=(Base=8,Rand=-16)
    AlphaGrowPeriod=0.1
    Chaos=2
    Attraction=(X=1,Y=1,Z=1)
    Textures(0)=Texture'HPParticle.particle_fx.noisy1_pfx'
    Textures(1)=Texture'HPParticle.particle_fx.noisy6_pfx'
    Textures(2)=Texture'HPParticle.particle_fx.noisy5_pfx'
    Textures(3)=Texture'HPParticle.particle_fx.noisy7_pfx'
}