library leaflet.draw.draw;

import 'package:leaflet/leaflet.dart' show LeafletMap, Handler;

import '../draw.dart';

class DrawToolbarOptions {
  ModeHandler polyline = new ModeHandler();
  ModeHandler polygon = new ModeHandler();
  ModeHandler rectangle = new ModeHandler();
  ModeHandler circle = new ModeHandler();
  ModeHandler marker = new ModeHandler();
}

class ModeHandler {
  bool enabled;
  Handler handler;
  String title;
}

class Action {
  bool enabled;
  String title;
  String text;
  Function callback;
  var context;
}

class DrawToolbar extends Toolbar {

  static final TYPE ='draw';

  /*Map options = {
    'polyline': {},
    'polygon': {},
    'rectangle': {},
    'circle': {},
    'marker': {}
  };*/
  DrawToolbarOptions options;

  String _toolbarClass;

  DrawToolbar(options) : super(options) {
    // Ensure that the options are merged correctly since L.extend is only shallow
    /*for (var type in this.options) {
      if (this.options.containsKey(type)) {
        if (options[type]) {
          this.options[type].addAll(options[type]);
        }
      }
    }*/
    if (options == null) {
      options = new DrawToolbarOptions();
    }

    this._toolbarClass = 'leaflet-draw-draw';
    //L.Toolbar.prototype.initialize.call(this, options);
  }

  getModeHandlers(LeafletMap map) {
    return [
      new ModeHandler()
        ..enabled = this.options.polyline
        ..handler = new Polyline(map, this.options.polyline)
        ..title = L.drawLocal.draw.toolbar.buttons.polyline
      ,
      new ModeHandler()
        ..enabled = this.options.polygon
        ..handler = new L.Draw.Polygon(map, this.options.polygon)
        ..title = L.drawLocal.draw.toolbar.buttons.polygon
      ,
      new ModeHandler()
        ..enabled = this.options.rectangle
        ..handler = new L.Draw.Rectangle(map, this.options.rectangle)
        ..title = L.drawLocal.draw.toolbar.buttons.rectangle
      ,
      new ModeHandler()
        ..enabled = this.options.circle
        ..handler = new L.Draw.Circle(map, this.options.circle)
        ..title = L.drawLocal.draw.toolbar.buttons.circle
      ,
      new ModeHandler()
        ..enabled = this.options.marker
        ..handler = new L.Draw.Marker(map, this.options.marker)
        ..title = L.drawLocal.draw.toolbar.buttons.marker
    ];
  }

  // Get the actions part of the toolbar
  getActions(handler) {
    return [
      new Action()
        ..enabled = handler.deleteLastVertex
        ..title = L.drawLocal.draw.toolbar.undo.title
        ..text = L.drawLocal.draw.toolbar.undo.text
        ..callback = handler.deleteLastVertex
        ..context = handler
      ,
      new Action()
        ..title = L.drawLocal.draw.toolbar.actions.title
        ..text = L.drawLocal.draw.toolbar.actions.text
        ..callback = this.disable
        ..context = this
    ];
  }

  setOptions(options) {
    L.setOptions(this, options);

    for (var type in this._modes) {
      if (this._modes.hasOwnProperty(type) && options.hasOwnProperty(type)) {
        this._modes[type].handler.setOptions(options[type]);
      }
    }
  }
}
