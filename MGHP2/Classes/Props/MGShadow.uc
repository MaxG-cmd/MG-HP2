class MGShadow extends MGProp;

defaultproperties
{
    Mesh=SkeletalMesh'HProps.skSheetTestMesh'
    DrawScale=0.3
    SpecularGlow=0
    AmbientGlow=0
    Opacity=0.6
    MultiSkins(0)=Texture'MGTech.Utilities.ShadowDark1'
    CollisionRadius=16
    CollisionWidth=2
    CollisionHeight=16
    CollideType=CT_Box
    bCollideActors=False
    bCollideWorld=False
    bBlockActors=False
    bBlockPlayers=False
    bProjTarget=False
    bAlignBottom=False
    bBlockCamera=False
}