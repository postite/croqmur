package croqmur;
import croqmur.CrocPoint;
//import thx.color.Rgb;
//import croqmur.CoolColor;
import haxe.Timer;
import js.html.Console;
using tink.CoreApi;
//import postite.geom.CrocPoint;
import postite.dro.Couleur;

enum DroState{
	Norm;
	But2;
}
enum CroqState{
	Memoizing;
	Normal;
	Recording;

}

class Croq {
	public var positions:Array<CrocPoint> = [];
	var record:Bool=false;
	var play:Bool=false;
	var memo:CrocPoint;
	var point:CrocPoint;
	public var trailong:Int = 200;

	@:isVar
	public var colorLine(default,set):Couleur;
	public var size=10;
	
	public var _state:DroState=Norm;
	public var waz:Bool=false;
	public var mz:Array<CrocPoint>=[];
	public var rc:Array<CrocPoint>=[];
	public var roc:Array<CrocPoint>=[];
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

	function store(point:CrocPoint) {
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
		eventTrigger.trigger(Recording);
	}
	public function stopRec(){
		record=false;
		eventTrigger.trigger(Normal);
	}
	public function playRec(){
		if (record) return;
		trace( "play rec" +rc.length);
		//positions=positions.concat(rc);
		play=true;
	}


	function rec(point:CrocPoint){
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
		store([x, y, -1,colorLine]);
		if (tim !=null)
		tim.stop();
		
	}

	var tim:haxe.Timer;

    public function up(x,y,press){
       store([x,y,-1,colorLine]);
	      
    tim= new haxe.Timer(1000);
       tim.run = function(){
		   //if (positions.length > trailong )
           positions.shift();
           }
    }

	public function set_colorLine(col:Couleur){
		return  this.colorLine=col;
	}

	public function move(x, y, ?press:Int,?buttons:Int) {

		if( buttons==2)return;
		if (buttons==32 || buttons==5){
		state(But2);
		memoz=true;
		point = [x, y, press,colorLine];
		store(point);
		}else{
		memoz=false;
		state(Norm);
		point = [x, y, press,colorLine];
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

	function drawCircle(ctx:js.html.CanvasRenderingContext2D, _point:CrocPoint, ratio:Float,color:Couleur) {
		if (_point.press == -1)
			return;
		ctx.beginPath();
		ctx.arc(_point.x, _point.y, _point.press * size/2, 0, 2 * Math.PI, true);
		
		ctx.fillStyle=color;
		ctx.fill();
	}

	function drawTab(ctx:js.html.CanvasRenderingContext2D,befPoint:CrocPoint,curPoint:CrocPoint,ratio:Float,?color:Couleur=Noir){
			ctx.beginPath();
			
			ctx.lineWidth = (befPoint.press * size);
			ctx.lineJoin = "round";
			color=curPoint.color;
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
			//if(positions.length>trailong)
			ratio = (i + 1) / positions.length;
			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = positions[z];
			var curPoint = positions[i];
			drawTab(ctx,befPoint,curPoint,ratio,colorLine);
		}

		
		for (i in 0...mz.length) {
			// i++;
			if(mz.length>trailong)
			ratio = (i + 1) / mz.length;
			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = mz[z];
			var curPoint = mz[i];

			drawTab(ctx,befPoint,curPoint,ratio,Olive);
		}
		
		if(!play)return;
		for (i in 0...roc.length) {
			// i++;
			if(roc.length>trailong)
			ratio = (i + 1) / roc.length;

			var z = (i - 1 > 0) ? i - 1 : i;
			var befPoint = roc[z];
			var curPoint =roc[i];
			if(curPoint!=null)
			drawTab(ctx,befPoint,curPoint,ratio,Rouge);
			
		}
		roc.push(rc.shift());

		Timer.delay(function(){
			if( roc.length > trailong)
			roc.shift();	
		},1000);

		if(roc.length==0)
		play=false;
		
	//	drawCircle(ctx, point, 1);
		
		// store(point);
	}
}