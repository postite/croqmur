package croqmur;
//import croqmur.CoolPoint;
//import thx.color.Rgb;
//import croqmur.CoolColor;
import haxe.Timer;
import js.html.Console;
using tink.CoreApi;
import postite.geom.CoolPoint;
import postite.dro.Couleur;
enum DroState{
	Norm;
	But2;
}
enum CroqState{
	Memoizing;
	Normal;

}
class Croq {
	public var positions:Array<CoolPoint> = [];
	var record:Bool=false;
	var play:Bool=false;
	var memo:CoolPoint;
	var point:CoolPoint;
	var trailong:Int = 200;
	public var size=10;
	public var _state:DroState=Norm;
	public var waz:Bool=false;
	public var mz:Array<CoolPoint>=[];
	public var rc:Array<CoolPoint>=[];
	public var roc:Array<CoolPoint>=[];
	public var event:Signal<CroqState>;
	var eventTrigger:SignalTrigger<CroqState>;
	var memoz:Bool=false;
	@:isVar
	public var length(default,set):Int;
	
	function set_length(n:Int){
		return trailong=n;
	}
	public function memoize():Bool{
		memoz=!memoz;
		return memoz;
		//memoz=true;
	}

	function store(point:CoolPoint) {
		if(memoz){
			 mz.push(point);
			
			 return ;
		}
		positions.push(point);
		if (positions.length > trailong)
			positions.shift();

	}

	public function startRec(){
		play=false;
		rc=[];
		roc=[];
		record=true;
	}
	public function stopRec(){
		record=false;
	}
	public function playRec(){
		if (record) return;
		trace( "play rec" +rc.length);
		//positions=positions.concat(rc);
		play=true;
	}


	function rec(point:CoolPoint){
		if( record ){
			rc.push(point);
			return;
		}
	}

	public function new() {
		memo =  [];
		point = [];
		eventTrigger=Signal.trigger();
		event=eventTrigger;
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

	public function move(x, y, ?press:Int,?buttons:Int) {

		if( buttons==2)return;
		if (buttons==32 || buttons==5){
		state(But2);
		memoz=true;
		point = [x, y, press];
		store(point);
		}else{
		memoz=false;
		state(Norm);
		point = [x, y, press];
		store(point);
		}
		rec(point);
	}
/*
	public function move(x, y, ?press:Int,?buttons:Int) {

		if( buttons==2)return;
		if (memoz){
			
		state(But2);
		memoz=true;
		point = [x, y, press];
		store(point);
		}else{
		memoz=false;
		state(Norm);
		point = [x, y, press];
		store(point);
		}
		
	}
	*/
	function doolMz(){
		trace('dool $memoz');
		waz=false;
		eventTrigger.trigger(Memoizing);
		var co=mz.copy();
		if ( co[0]!=null){
		co[0].press=-1;
		co[co.length-1].press=-1;
		}
		positions=positions.concat(co);

		mz=[];
	}
	function wazBut(){
		waz=true;
		eventTrigger.trigger(Normal);
		trace("wasBut");
	}

	inline function state(s:DroState){
		if( _state != s){
			if( s==Norm)wazBut();
			if( s==But2)doolMz();
			trace ("mzlength="+mz.length );
		untyped console.log('set state to $s');
		
		_state=s;
		}
	}

	function drawCircle(ctx:js.html.CanvasRenderingContext2D, _point:CoolPoint, ratio:Float,color:Couleur) {
		if (_point.press == -1)
			return;
		ctx.beginPath();
		ctx.arc(_point.x, _point.y, _point.press * size/2, 0, 2 * Math.PI, true);
		
		ctx.fillStyle=color;
		ctx.fill();
	}

	function drawTab(ctx:js.html.CanvasRenderingContext2D,befPoint:CoolPoint,curPoint:CoolPoint,ratio:Float,?color:Couleur=Noir){
			ctx.beginPath();
			ctx.lineWidth = (befPoint.press * size);
			ctx.lineJoin = "round";
			//var color:Couleur=Couleur.Bleu;

			var light=color.lighten(1-ratio);
			#if debug
			ctx.strokeStyle=Jaune;
			#else
			ctx.strokeStyle=light;
			#end
			
		//	trace('color=$color');
			if (befPoint.press != -1) {
				ctx.moveTo(befPoint.x, befPoint.y);
				ctx.lineTo(curPoint.x, curPoint.y);
                 ctx.stroke();
				 #if debug
				drawCircle(ctx, curPoint, ratio,Jaune);
				#else
				drawCircle(ctx, curPoint, ratio,light);
				#end
               
				
			} else {
				#if debug			
				drawCircle(ctx, point, ratio,Jaune);
				#else
				drawCircle(ctx, point, ratio,light);
				#end
			}
	}
    
	public function render(ctx:js.html.CanvasRenderingContext2D) {
		//trace( "render");
		var ratio:Float = 1.0;
		for (i in 0...positions.length) {
			// i++;
			ratio = (i + 1) / positions.length;
			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = positions[z];
			var curPoint = positions[i];

			drawTab(ctx,befPoint,curPoint,ratio,Prusse);
		}

		
		for (i in 0...mz.length) {
			// i++;
			ratio = (i + 1) / mz.length;
			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = mz[z];
			var curPoint = mz[i];

			drawTab(ctx,befPoint,curPoint,ratio,Olive);
		}

		if(!play)return;
		for (i in 0...roc.length) {
			// i++;
			ratio = (i + 1) / rc.length;
			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = rc[z];
			var curPoint =rc[i];

			drawTab(ctx,befPoint,curPoint,ratio,Rouge);
			
		}
		roc.push(rc.shift());

		Timer.delay(function(){
			if( roc.length > trailong)
			roc.shift();	
		},1000);

		if( roc.length==0)
		play=false;
		
	//	drawCircle(ctx, point, 1);
		
		// store(point);
	}
}