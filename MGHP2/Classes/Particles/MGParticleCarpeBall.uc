class MGParticleCarpeBall extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=60)
    SourceWidth=(Base=0)
    SourceHeight=(Base=0)
    SourceDepth=(Base=0)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=0)
    bSteadyState=True
    Speed=(Base=3)
    Lifetime=(Base=1.25)
    ColorStart=(Base=(R=197,G=109,B=254))
    ColorEnd=(Base=(R=220,G=176,B=255))
    AlphaEnd=(Base=1)
    SizeWidth=(Base=4,Rand=2)
    SizeLength=(Base=4,Rand=2)
    SizeEndScale=(Base=0)
    SpinRate=(Base=8,Rand=-16)
    bSystemRelative=True
    AlphaGrowPeriod=0.1
    Chaos=0.55
    Attraction=(X=1,Y=1,Z=1)
    Distribution=DIST_OwnerMesh
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Dot_Neutral'
}