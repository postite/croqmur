// package murmur.display;
// import boidz.IRenderable;
// import boidz.render.canvas.CanvasRender;
import js.Browser.document as doc;
// import murmur.display.Croquis.CroquisJs;
import js.html.CanvasRenderingContext2D;

import keyboard.KeyBoardManager;
import keyboard.KeyCode as K;
import croqmur.Croq;
import tablet.Tablet;


class App {
	var KB:KeyBoardManager = KeyBoardManager.getInstance();
	var raf:(Float->Void)->Int;

	

	public function new() {
		trace( "new App");
		var can = doc.createCanvasElement();
		can.width = 800;
		can.height = 800;
		doc.body.appendChild(can);
		raf = js.Browser.window.requestAnimationFrame;

		var croc = new Croco(null);
		croc.memoize();

		var display = new CanvasRender(can);
		display.addRenderable(croc);
		

		function step(timestamp:Float) {
			// trace("hop");
			display.render();
			raf(step);
		}

		raf(step);

        KB.addListener(Shift,croc.memoize);

		new keyboard.Keynote();

		
	}

	

	public static function main() {
		new App();
	}
}

class CanvasRender{
	var map:Map<IRenderable, Bool>;
	var canvas:js.html.CanvasElement;

	public function new(can:js.html.CanvasElement) {
		map = new Map();
		canvas = can;
		this.ctx = can.getContext2d();
	}

	public function addRenderable(ir:IRenderable) {
		map.set(ir, true);
	}

	public function clear() {
		ctx.clearRect(0, 0, canvas.width, canvas.height);
	}

	public function render() {
		this.clear();
		for (renderable in map.keys()) {
			if (renderable.enabled) {
				// renderEngine.beforeEach();
				renderable.render(this);
				// renderEngine.afterEach();
			}
		}
	}

	public var ctx:js.html.CanvasRenderingContext2D;
}

interface IRenderable {
	public var enabled:Bool;
	public function render(ctx:CanvasRender):Void;
}

class Croco implements IRenderable {
	public var croq:Croq;
	public var enabled = true;
    var tablette:Tablet;
	
    public function memoize(){
		trace( "meme");
		croq.memoize();
    }

	public function new(dims) {
		croq = new Croq();
		init();
	}

	public function init() {
		tablette=new tablet.Tablet();
		doc.addEventListener('pointerdown', function(e) {
			setPointerEvent(e);
			croq.down(e.clientX, e.clientY, (e.pointerType == "pen") ? e.pressure : 1);
			doc.addEventListener('pointermove', onMouseMove);
			doc.addEventListener('pointerup', onMouseUp);
		});

		trace("hello croquis last");
	}

	function onMouseMove(e) {
		setPointerEvent(e);
		// trace(e.pressure);
		// trace(e.pointerType);
		croq.move(e.clientX, e.clientY, (e.pointerType == "pen") ? e.pressure : 1);
	}

	function onMouseUp(e) {
		setPointerEvent(e);
		croq.up(e.clientX, e.clientY, (e.pointerType == "pen") ? e.pressure : 1);
		doc.removeEventListener('pointermove', onMouseMove);
		doc.removeEventListener('pointerup', onMouseUp);
		trace( "up"+croq.mz);
	}

	// function setPointerEvent(e:Dynamic) {
	// 	// trace("tablet="+ untyped __js__('Croquis.Tablet.pen().pointerType'));
	// 	if (e.pointerType != "pen" && Tablet.pen()!=null && Tablet.pen().pointerType!=null) { // it says its not a pen but it might be a wacom pen

	// 		e.pointerType = "pen";
	// 		e.pressure = Tablet.pressure();
	// 		if (Tablet.isEraser()) {
	// 			trace(("eraser"));
	// 			untyped (Object).defineProperties(e, {
	// 					"button": {value: 5},
	// 					"buttons": {value: 32}
	// 				});
	// 		}
	// 	}
	// }

	function setPointerEvent(e:Dynamic) {
		var pen=tablette.pen();
		// trace("tablet="+ untyped __js__('Croquis.Tablet.pen().pointerType'));
		if (e.pointerType != "pen" && pen!=null && pen.pointerType!=null) { // it says its not a pen but it might be a wacom pen

			e.pointerType = "pen";
		
			e.pressure = tablette.pressure();
			if (tablette.isEraser()) {
				trace(("eraser"));
				untyped (Object).defineProperties(e, {
						"button": {value: 5},
						"buttons": {value: 32}
					});
			}
		}
	}

	public function render(render:CanvasRender) {
		croq.render(render.ctx);
	}
}

 



