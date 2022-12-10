class MGParticleWingardium extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=30)
    SourceWidth=(Base=16)
    SourceHeight=(Base=0)
    SourceDepth=(Base=16)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=0)
    bSteadyState=True
    Speed=(Base=0,Rand=64)
    Lifetime=(Base=2)
    ColorStart=(Base=(G=255,B=255))
    ColorEnd=(Base=(G=255,B=255))
    AlphaEnd=(Base=0.5)
    SizeWidth=(Rand=8)
    SizeLength=(Rand=8)
    SizeEndScale=(Base=0)
    SpinRate=(Base=4,Rand=-8)
    AlphaGrowPeriod=0.1
    Attraction=(X=4,Y=4)
    GravityModifier=0.08
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Feather'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.Feather'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.Feather'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.FF_SmallPuff'
    Textures(4)=Texture'HPParticle.hp_fx.Particles.FF_SmallPuff'

    LightRadius=8
	LightRadiusInner=8
	LightSaturation=230
	LightBrightness=48
	LightHue=153
    LightType=LT_Steady
}