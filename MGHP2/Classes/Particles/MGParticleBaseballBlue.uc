class MGParticleBaseballBlue extends MGParticleFX;

defaultproperties
{
	DefaultLightBrightness=215
	ParticlesPerSec=(Base=960,Rand=0)
	SourceWidth=(Base=0)
	SourceHeight=(Base=0)
	AngularSpreadWidth=(Base=180)
	AngularSpreadHeight=(Base=180)
	bSteadyState=True
	Speed=(Base=2)
	Lifetime=(Base=0.2,Rand=0.1)
	ColorStart=(Base=(R=0,G=19,B=255,A=0),Rand=(R=0,G=0,B=0,A=0))
	ColorEnd=(Base=(R=48,G=120,B=254,A=0),Rand=(R=0,G=0,B=0,A=0))
	AlphaEnd=(Base=0.5)
	SizeWidth=(Base=16,Rand=24)
	SizeLength=(Base=16,Rand=24)
	SizeEndScale=(Base=0)
	SpinRate=(Base=8,Rand=-16)
	AlphaGrowPeriod=0.1
	Chaos=2
	Attraction=(X=1,Y=1,Z=1)
	Textures(0)=Texture'HPParticle.particle_fx.noisy1_pfx'
	Textures(1)=Texture'HPParticle.particle_fx.noisy6_pfx'
	Textures(2)=Texture'HPParticle.particle_fx.noisy5_pfx'
	Textures(3)=Texture'HPParticle.particle_fx.noisy7_pfx'
}