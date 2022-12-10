class MGParticleCrackerPickup extends MGParticleFX;

defaultproperties
{
    ParticlesPerSec=(Base=120)
    SourceWidth=(Base=8)
    SourceHeight=(Base=4)
    SourceDepth=(Base=8)
    AngularSpreadWidth=(Base=180)
    AngularSpreadHeight=(Base=90)
    Speed=(Base=64,Rand=64)
    Lifetime=(Base=3)
    ColorStart=(Base=(R=26,G=255,B=140),Rand=(R=100,G=37,B=184))
    ColorEnd=(Base=(G=255,B=255))
    SizeWidth=(Rand=8)
    SizeLength=(Rand=8)
    SizeEndScale=(Base=0)
    SpinRate=(Base=4,Rand=-8)
    Elasticity=0.1
    Attraction=(X=4,Y=4)
    Damping=4
    GravityModifier=0.4
    ParticlesMax=20
    Textures(0)=Texture'HPParticle.hp_fx.Particles.Les_Sparkle_04'
    LastUpdateLocation=(X=418.2217,Y=-1615.81,Z=-480.3587)
    LastEmitLocation=(X=418.2217,Y=-1615.81,Z=-480.3587)
}