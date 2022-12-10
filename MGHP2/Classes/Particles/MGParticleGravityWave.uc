class MGParticleGravityWave extends MGParticleFX;


defaultproperties
{
    ParticlesPerSec=(Base=2048)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=384)
    Lifetime=(Base=2,Rand=0.5)
    ColorStart=(Base=(R=30,G=52,B=255))
    ColorEnd=(Base=(G=30,B=131))
    AlphaEnd=(Base=0.5)
    SizeWidth=(Base=32)
    SizeLength=(Base=32)
    SizeEndScale=(Base=0)
    SpinRate=(Base=4,Rand=-8)
    SizeDelay=1
    Chaos=4
    Elasticity=0.25
    Attraction=(X=-32,Y=-32,Z=-32)
    ParticlesMax=192
    Textures(0)=FireTexture'HPParticle.hp_fx.Particles.LessonTrail'
}