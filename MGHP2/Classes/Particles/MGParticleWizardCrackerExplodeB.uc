class MGParticleWizardCrackerExplodeB extends MGParticleFX;
 
defaultproperties
{
    ParticlesPerSec=(Base=3200)
    SourceWidth=(Base=4)
    SourceHeight=(Base=4)
    SourceDepth=(Base=4)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=1000,Rand=-600)
    Lifetime=(Base=3.0)
    ColorStart=(Base=(R=181,G=70,B=255),Rand=(R=4,G=255,B=36))
    ColorEnd=(Base=(R=53,G=108,B=255),Rand=(R=223,B=255))
    AlphaStart=(Base=0.2)
    AlphaEnd=(Base=0.2)
    SizeWidth=(Base=14,Rand=-4)
    SizeLength=(Base=14,Rand=-4)
    SizeEndScale=(Base=0)
    SpinRate=(Base=12,Rand=-24)
    SizeDelay=1
    Chaos=2
    Elasticity=0.5
    Damping=1
    GravityModifier=1
    ParticlesMax=32
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Glass'
}