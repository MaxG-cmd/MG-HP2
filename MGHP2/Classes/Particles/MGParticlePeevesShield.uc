class MGParticlePeevesShield extends MGParticleFX;



defaultproperties
{
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    bSteadyState=True
	Attraction=(X=0.5,Y=0.5,Z=0.5)
	bSystemRelative=True
	bVelocityRelative=True
    Speed=(Base=0)
    Lifetime=(Base=2)
	ParticlesPerSec=(Base=200)
    ColorStart=(Base=(R=150,G=63,B=254))
    //ColorStart=(Base=(R=72,G=255,B=77),Rand=(B=24))
    ColorEnd=(Base=(R=150,G=63,B=254))
	AlphaStart=(Base=0.75)
    AlphaEnd=(Base=0.5)
    SizeWidth=(Base=12)
    SizeLength=(Base=12)
    SizeEndScale=(Base=0)
    SpinRate=(Base=1,Rand=-2)
    AlphaDelay=1
    ColorDelay=0.75
    SizeDelay=1
    SizeGrowPeriod=0.25
    Chaos=0
    GravityModifier=0
    Textures(0)=FireTexture'HPParticle.hp_fx.Particles.LessonTrail'
	bEmit=False
	Distribution=DIST_OwnerMesh
	Physics=PHYS_Rotating
    bFixedRotationDir=True
    RotationRate=(Yaw=20000)
} 



