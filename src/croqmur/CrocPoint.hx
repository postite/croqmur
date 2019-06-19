package croqmur;

import postite.dro.Couleur;
import postite.geom.CoolPoint;

typedef CroquePoint={
    >PressPoint,
    ?color:Couleur
}

@:forward
abstract CrocPoint(CroquePoint) from CroquePoint to CroquePoint{
    public function new(x,y,?p,?c:Couleur=Prusse) {
		this = {x:x,y:y,press:p,color:c};
	}
    @:from
	public static function fromArray(a:Array<Any>):CrocPoint {
		return new CrocPoint( a[0], a[1], a[2],a[3]);
	}
}