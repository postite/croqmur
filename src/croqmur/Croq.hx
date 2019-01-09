package croqmur;
import croqmur.CoolPoint;
@:enum abstract Col(String) from String to String{
    var ocre="201, 185, 101";
    var brique ="198, 88, 29";
    var prusse="43, 117, 153";
    var olive="86, 126, 62";
}
class Croq {
	public var positions:Array<CoolPoint> = [];

	var memo:CoolPoint;
	var point:CoolPoint;
	var trailong:Int = 200;

	var mz:Array<CoolPoint>=[];

	var memoz:Bool=false;

	public function memoize(){
		memoz=!memoz;
	}

	function store(point:CoolPoint) {
		if( memoz){
			 mz.push(point);
			 return ;
		}
		positions.push(point);
		if (positions.length > trailong)
			positions.shift();

	}

	public function new() {
		memo =  [];
		point = [];
	}

	public function down(x, y, press) {


		store([x, y, -1]);
		if (tim !=null)
		tim.stop();
	}

	var tim:haxe.Timer;
    public function up(x,y,press){
       store([x,y,-1]);
    tim= new haxe.Timer(100);
       tim.run = function(){
           
           positions.shift();
           }
    }

	public function move(x, y, press) {
		point = [x, y, press];
		store(point);
	}

	function drawCircle(ctx:js.html.CanvasRenderingContext2D, _point:CoolPoint, ratio:Float,?rgb:Col="204, 102, 153") {
		if (_point.press == -1)
			return;
		ctx.beginPath();
		ctx.arc(_point.x, _point.y, _point.press * 10, 0, 2 * Math.PI, true);
		ctx.fillStyle = 'rgba($rgb, ${ratio})';
		ctx.fill();
	}

	function drawTab(ctx:js.html.CanvasRenderingContext2D,befPoint:Point,curPoint:Point,ratio:Float,?rgb="204, 102, 153"){
			
			ctx.beginPath();
			ctx.lineWidth = (befPoint.press * 20);
			ctx.lineJoin = "round";
			ctx.strokeStyle = 'rgba( $rgb , ${ratio})';

			if (befPoint.press != -1) {
				ctx.moveTo(befPoint.x, befPoint.y);
				ctx.lineTo(curPoint.x, curPoint.y);
                 ctx.stroke();
				drawCircle(ctx, curPoint, ratio,brique);
               
				
			} else {			
				drawCircle(ctx, point, ratio,ocre);
			}
	}
    
	public function render(ctx:js.html.CanvasRenderingContext2D) {
		var ratio:Float = 1.0;
		for (i in 0...positions.length) {
			// i++;
			ratio = (i + 1) / positions.length;
			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = positions[z];
			var curPoint = positions[i];

			drawTab(ctx,befPoint,curPoint,ratio,prusse);
		}

		for (i in 0...mz.length) {
			// i++;
			ratio = (i + 1) / positions.length;
			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = mz[z];
			var curPoint = mz[i];

			drawTab(ctx,befPoint,curPoint,ratio,olive);
		}

	//	drawCircle(ctx, point, 1);

		// store(point);
	}
}