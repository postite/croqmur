class Stabilizer{
    /*

    class Stabilizer{

	var interval:Int=5;
	var follow:Float;
	var paramTable:Array<Point>;
	var current:Point;
	var first:Point;
	var last:Point;
	var upCalled:Bool;

	function new(down:(Point)->Void,
				move:(Point)->Void,
				up:(Point)->Void,
                level, weight:Float,
                x, y, pressure, _interval:Int=5){

			interval=_interval;
			follow=Math.min(0.95, Math.max(0, weight));
			paramTable=[];
			current={x:x,y:y,press:pressure};

			for ( i in 0...level )
				paramTable.push({x:x,y:y,press:pressure});

			first=paramTable[0];
			last =paramTable[paramTable.length - 1];
			upCalled=false;
			if (down != null)
        	down(current);

			//window.setTimeout(_move, interval);
			haxe.Timer.delay(_move.bind(false),interval);

				}

	function getParamTable(){
		return paramTable;
	}
	function move  (x, y, pressure) {
        current.x = x;
        current.y = y;
        current.press = pressure;
    }
    function up (x, y, pressure) {
        current.x = x;
        current.y = y;
        current.press = pressure;
        upCalled = true;
    }

	inline function dlerp(a:Float, d:Float, t:Float):Float{
        return a + d * t;
    }

	function _move(?justCalc:Bool=false) {
        var curr;
        var prev;
        var dx;
        var dy;
        var dp;
        var delta = 0.0;
        first.x = current.x;
        first.y = current.y;
        first.press = current.press;
        for (i in 1 ...paramTable.length) {
            curr = paramTable[i];
            prev = paramTable[i - 1];
            dx = prev.x - curr.x;
            dy = prev.y - curr.y;
            dp = prev.press - curr.press;
            delta += Math.abs(dx);
            delta += Math.abs(dy);
            curr.x = dlerp(curr.x, dx, follow);
            curr.y = dlerp(curr.y, dy, follow);
            curr.press = dlerp(curr.press, dp, follow);
        }
        if (justCalc)
            return delta;
        if (upCalled) {
            while(delta > 1) {
                move(last.x, last.y, last.press);
                delta = _move(true);
            }
            up(last.x, last.y, last.press);
			
        }
        else {
            move(last.x, last.y, last.press);
			haxe.Timer.delay(_move.bind(false),interval);
            
        }
		return .0; //juste pour mettre un return 
    }
	}  
    */
}