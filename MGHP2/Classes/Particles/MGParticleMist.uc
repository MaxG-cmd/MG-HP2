class MGParticleMist extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=40,Rand=10)
    SourceWidth=(Base=64)
    SourceHeight=(Base=64)
    AngularSpreadWidth=(Base=40,Rand=15)
    AngularSpreadHeight=(Base=20,Rand=15)
    bSteadyState=True
    Speed=(Base=12,Rand=20)
    Lifetime=(Base=12,Rand=2)
    ColorStart=(Base=(R=195,G=208,B=216))
    ColorEnd=(Base=(R=165,G=189,B=204))
    SizeWidth=(Base=4,Rand=6)
    SizeLength=(Base=4,Rand=6)
    SizeEndScale=(Base=0.001,Rand=2)
    SpinRate=(Base=-2,Rand=4)
    Chaos=8
    ChaosDelay=2
    Damping=0.25
    GravityModifier=0.01
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Smoke3'
    Rotation=(Pitch=16323)
	Opacity=0.15
}