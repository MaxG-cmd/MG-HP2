class MGParticleCarpeExp extends MGParticleFX;
 
defaultproperties
{
    ParticlesPerSec=(Base=2160)
    SourceWidth=(Base=8)
    SourceHeight=(Base=8)
    SourceDepth=(Base=8)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=60)
    bSteadyState=True
    Speed=(Base=0,Rand=160)
    Lifetime=(Base=0.7)
    ColorStart=(Base=(R=173,G=113,B=255))
    ColorEnd=(Base=(R=173,G=113,B=255))
    SpinRate=(Base=16,Rand=-32)
    Chaos=1
    Attraction=(X=32,Y=32,Z=64)
    GravityModifier=1
    ParticlesMax=30
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.Smoke1'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.Sparkle_BW'
} 



