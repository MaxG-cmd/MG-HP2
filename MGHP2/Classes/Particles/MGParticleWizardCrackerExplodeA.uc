class MGParticleWizardCrackerExplodeA extends MGParticleFX;
 
defaultproperties
{
    ParticlesPerSec=(Base=3200)
    SourceWidth=(Base=4)
    SourceHeight=(Base=4)
    SourceDepth=(Base=4)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=600,Rand=-500)
    Lifetime=(Base=2,Rand=-1.8)
    ColorStart=(Base=(R=139,G=45,B=255),Rand=(G=232,B=29))
    ColorEnd=(Base=(R=53,G=255,B=88),Rand=(R=140,B=255))
    SizeWidth=(Rand=-4)
    SizeLength=(Rand=-4)
    SpinRate=(Base=12,Rand=-24)
    Chaos=16
    Elasticity=0.5
    Attraction=(X=-1,Y=-1,Z=-1)
    Damping=4
    GravityModifier=0.25
    ParticlesMax=240
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
 
}