class MGBlackFire extends MGParticleFX;


defaultproperties
{
    ParticlesPerSec=(Base=256,Rand=64)
    SourceWidth=(Base=120)
    SourceHeight=(Base=0)
    bSteadyState=True
    Speed=(Base=100)
    Lifetime=(Base=1.75)
    ColorStart=(Base=(R=0,G=0,B=0))
    ColorEnd=(Base=(R=0))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=16,Rand=8)
    SizeLength=(Base=16,Rand=8)
    SizeEndScale=(Base=0)
    SpinRate=(Base=8,Rand=-16)
    SizeDelay=0.75
    Chaos=3
    Attraction=(X=0.25,Y=0.5)
    Damping=0.25
    Textures(0)=FireTexture'HPParticle.hp_fx.Particles.RiddleInk'
    Style=STY_Masked
}