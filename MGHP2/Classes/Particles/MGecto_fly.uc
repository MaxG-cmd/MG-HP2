class MGEcto_fly extends Ecto_fly;

defaultproperties
{
	ParticlesPerSec=(Base=800)
    SourceWidth=(Base=4)
    SourceHeight=(Base=4)
    SourceDepth=(Base=4)
    Speed=(Base=0,Rand=0)
    Lifetime=(Base=0.25,Rand=0)
    SizeWidth=(Base=90)
    SizeLength=(Base=90)
    SizeEndScale=(Base=1,Rand=0)
    bVelocityRelative=True
    AlphaDelay=0.1
    Chaos=4
    Elasticity=0.5
    GravityModifier=0.02
    bSteadyState=True
    ColorStart=(Base=(R=104,G=167,B=78))
    ColorEnd=(Base=(R=66,G=167,B=37))
    SpinRate=(Base=-2,Rand=4)
    Damping=0.5
    Textures(0)=Texture'HPParticle.hp_fx.Particles.blob32'
}


