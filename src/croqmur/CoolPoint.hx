package croqmur;

typedef Point = {
	x:Float,
	y:Float,
	press:Float
}

@:forward
abstract CoolPoint(Point) from Point to Point {
	public function new(p:Point) {
		this = p;
	}

	@:from
	public static function fromArray(a:Array<Float>):CoolPoint {
		return new CoolPoint({x: a[0], y: a[1], press: a[2]});
	}
}