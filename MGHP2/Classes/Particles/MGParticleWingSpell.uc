class MGParticleWingSpell extends MGParticleFX;

DefaultProperties
{
    ParticlesPerSec=(Base=60)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=0,Rand=32)
    Lifetime=(Base=2)
    ColorStart=(Base=(G=255,B=255))
    ColorEnd=(Base=(G=255,B=255))
    AlphaEnd=(Base=0.5)
    SizeWidth=(Rand=8)
    SizeLength=(Rand=8)
    SizeEndScale=(Base=0)
    SpinRate=(Base=4,Rand=-8)
    AlphaGrowPeriod=0.1
    Attraction=(X=0.5,Y=0.5,Z=0.5)
    Damping=2
    GravityModifier=0.02
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Feather'
    Textures(1)=Texture'HPParticle.hp_fx.Particles.Feather'
    Textures(2)=Texture'HPParticle.hp_fx.Particles.Feather'
    Textures(3)=Texture'HPParticle.hp_fx.Particles.FF_SmallPuff'
    Textures(4)=Texture'HPParticle.hp_fx.Particles.FF_SmallPuff'

    LightRadius=6
	LightRadiusInner=8
	LightSaturation=230
	LightBrightness=32
	LightHue=153
    LightType=LT_Steady
}