class MGParticleWallLamp extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=1)
    SourceWidth=(Base=2)
    SourceHeight=(Base=2)
    SourceDepth=(Base=2)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=0,Rand=4)
    Lifetime=(Base=5)
    ColorStart=(Base=(G=255,B=255))
    ColorEnd=(Base=(G=240,B=240))
    AlphaStart=(Base=0.1)
    SizeWidth=(Base=24,Rand=32)
    SizeLength=(Base=24,Rand=32)
    AlphaGrowPeriod=0.25
    Textures(0)=Texture'HPParticle.hp_fx.General.CandleFSepia'
    DrawScale=1.5
}