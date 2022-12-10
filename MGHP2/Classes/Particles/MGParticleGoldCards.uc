class MGParticleGoldCards extends MGParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=6,Rand=4)
     SourceWidth=(Base=20,Rand=50)
     SourceHeight=(Base=20,Rand=50)
     SourceDepth=(Base=10,Rand=20)
     AngularSpreadWidth=(Base=180,Rand=180)
     AngularSpreadHeight=(Base=30,Rand=35)
     Speed=(Base=15,Rand=40)
     Lifetime=(Rand=1.5)
     ColorStart=(Base=(R=255,G=174,B=45),Rand=(R=30,G=30,B=30))
     ColorEnd=(Base=(R=255,G=174,B=45),Rand=(R=90,G=90,B=90))
     SizeWidth=(Base=2,Rand=4)
     SizeLength=(Base=2,Rand=4)
     SizeEndScale=(Base=2,Rand=4)
     Chaos=6
	SpinRate=(Base=2,Rand=2)
     Attraction=(X=6,Y=6)
	Gravity=(Z=-32)
     Damping=3
     Textures(0)=Texture'HPParticle.hp_fx.Particles.Les_Sparkle_01'
}
