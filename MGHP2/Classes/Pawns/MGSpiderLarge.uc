class MGSpiderLarge extends SpiderLarge;

event TakeDamage(int Damage, Pawn EventInstigator, Vector HitLocation, Vector Momentum, name DamageType)
{
	//Super.TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType);

    // MaxG: Handle wizard crackers.
    if (DamageType == 'Exploded')
    {
        HandleSpellRictusempra();
    }
}

// MaxG: Override and destroy.
state OutForTheCount
{  
    begin:
        eVulnerableToSpell = SPELL_None;
        SetCollisionSize(15.0,20.0);
        
        if ( bDoEvent == True )
        {
            TriggerEvent('Event', self, None);
        }

        Velocity = vect(0.00,0.00,0.00);
        Acceleration = vect(0.00,0.00,0.00);
        PlayAnim('flippedOver',1.39999998);
        Sleep(0.723);
        PlaySound(Sound'SPI_large_LandOnBack',SLOT_None,RandRange(0.89999998,1.0),,200000.0,RandRange(0.81,1.25),,False);
        Sleep(0.5);
        LoopAnim('idleOnBack');

        Sleep(0.2);
        fxDestroy1ParticleEffect = Spawn(Class'WebFx',,,Location);
        fxDestroy2ParticleEffect = Spawn(Class'WebDust',,,Location);
        Sleep(0.1);
        fxDestroy1ParticleEffect.Shutdown();
        fxDestroy2ParticleEffect.Shutdown();
        Sleep(0.05);
        Destroy();
}