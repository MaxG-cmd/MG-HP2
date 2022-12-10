class MGAttachManager extends Actor;

var() Actor BaseObject;
var() Actor AttachObject;
var() Vector AttachOffset;

event Tick(float DeltaTime)
{
    if ( BaseObject == None || AttachObject == None )
    {
        Destroy();
        return;
    }

    AttachObject.SetLocation(BaseObject.Location + AttachOffset);
}

defaultproperties
{
    bHidden=True
}