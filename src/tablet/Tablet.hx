package tablet;
import js.Browser.document;


typedef PenApi={
    pointerType:String,
    pressure:Int,
    isEraser:Bool
}
class Tablet{

var plugin:Plugin;
 function new () {
     plugin = cast document.querySelector(
        'object[type=\'application/x-wacomtabletplugin\']');
    if (plugin ==null) {
        plugin = cast document.createElement('object');
        plugin.type = 'application/x-wacomtabletplugin';
        plugin.style.position = 'absolute';
        plugin.style.top = '-1000px';
        document.body.appendChild(plugin);
    }
    //return plugin;
}

public static function pen(){
    var tablet = new Tablet();
    return tablet.plugin.penAPI;
}
// Croquis.Tablet.pen = function () {
//     var plugin = Croquis.Tablet.plugin();
    
//     return plugin.penAPI;
// }

public static function pressure(){
    var pen = pen();
    return (pen!=null && pen.pointerType!=null) ? pen.pressure : 1;
}

public static function isEraser():Bool{
     var pen = pen();
    return (pen!=null) ? pen.isEraser : false;
}
// Croquis.Tablet.pressure = function () {
//     var pen = Croquis.Tablet.pen();
    
//     return (pen && pen.pointerType) ? pen.pressure : 1;
// }
// Croquis.Tablet.isEraser = function () {
//     var pen = Croquis.Tablet.pen();
//     return pen ? pen.isEraser : false;
// }

}

class Plugin extends js.html.Element{
    public var type:String;
    public var penAPI:PenApi;
}