class MGParticleSmallMagicExp extends MGParticleFX;
 
defaultproperties
{
    ParticlesPerSec=(Base=9000)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=24,Rand=8)
    Lifetime=(Base=0.75,Rand=0.25)
    ColorStart=(Base=(R=102,G=64,B=255),Rand=(R=6,G=168,B=255))
    ColorEnd=(Base=(R=159,G=43,B=255),Rand=(R=26,B=147))
    SizeWidth=(Base=2,Rand=2)
    SizeLength=(Base=2,Rand=2)
    Chaos=1
    Attraction=(X=2,Y=2,Z=2)
    Damping=2
    ParticlesMax=32
    Textures(0)=Texture'HPParticle.hp_fx.Particles.flare4'
} 



