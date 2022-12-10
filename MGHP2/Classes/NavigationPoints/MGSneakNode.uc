class MGSneakNode extends PathNode;

var() MGSneakNode DestinationNode;

// MaxG: If not none, fully play all anims in the list before moving on.
var() Array<Name> PauseAnimations;


defaultproperties
{
    Texture=Texture'MGTech.Icons.sneakPointIcon'
}