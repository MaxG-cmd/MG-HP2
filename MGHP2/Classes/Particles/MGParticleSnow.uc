class MGParticleSnow extends MGParticleFX;
 
 
defaultproperties
{
     SourceDepth=(Base=1560.000000)
     SourceWidth=(Base=992.000000)
     SourceHeight=(Base=32.000000)
     AngularSpreadWidth=(Base=2.000000,Rand=1.000000)
     AngularSpreadHeight=(Base=2.000000,Rand=1.000000)
     speed=(Base=1.000000,Rand=0.000000)
     Lifetime=(Base=34.000000,Rand=4.000000)
     ColorStart=(Base=(R=254,G=254,B=254))
     ColorEnd=(Base=(R=0,G=0,B=0))
     SizeWidth=(Base=2.000000,Rand=5.000000)
     SizeLength=(Base=2.000000,Rand=5.000000)
     ParticlesPerSec=(Base=150.000000,Rand=8.000000)
     SizeEndScale=(Base=2.000000,Rand=1)
     Chaos=5
	 Gravity=(Z=-18)
     Textures(0)=Texture'MGTech.particles.SnowDot'
	 Opacity=1.0
	 Elasticity=0.5
}