class MGParticlePeevesShieldEX extends MGParticleFX;



defaultproperties
{
    ParticlesPerSec=(Base=4096)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=180)
    bSteadyState=True
    Speed=(Base=0,Rand=32)
    Lifetime=(Base=1.5)
    //ColorStart=(Base=(R=150,G=63,B=254))
    ColorStart=(Base=(R=200,G=43,B=70))
    ColorEnd=(Base=(R=63,G=237,B=115))
    AlphaStart=(Base=0.75)
    AlphaEnd=(Base=0)
    SizeWidth=(Base=12)
    SizeLength=(Base=12)
    SizeEndScale=(Base=0)
    SpinRate=(Base=2,Rand=-4)
    bSystemRelative=True
    SizeDelay=0.5
    Chaos=16
    Elasticity=0
    Attraction=(X=0,Y=0,Z=4)
    Damping=2
    GravityModifier=0
    ParticlesMax=512
    Textures(0)=FireTexture'HPParticle.hp_fx.Particles.LessonTrail'
	Distribution=DIST_OwnerMesh
	Physics=PHYS_Rotating
    bFixedRotationDir=True
    RotationRate=(Yaw=50000)
} 



