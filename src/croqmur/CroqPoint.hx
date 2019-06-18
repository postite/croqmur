package croqmur;

import postite.dro.Couleur;

typedef CroquePoint={
    >PressPoint,
    ?color:Couleur
}
@:forward
abstract CroqPoint(CroquePoint) from CroquePoint to CroquePoint{

}