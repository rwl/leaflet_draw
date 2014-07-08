library leaflet.draw.draw.handler;

import 'dart:html' show Element;
import 'package:leaflet/leaflet.dart' show LeafletMap, Handler;

part 'shape.dart';
part 'circle.dart';
part 'marker.dart';
part 'polyline.dart';
part 'polygon.dart';
part 'rectangle.dart';

class Feature extends Handler {
  //includes: L.Mixin.Events,

  Element _container, _overlayPane, _popupPane;

  Feature(LeafletMap map, options) : super(map) {
    this._container = map._container;
    this._overlayPane = map._panes.overlayPane;
    this._popupPane = map._panes.popupPane;

    // Merge default shapeOptions options with custom shapeOptions
    if (options && options.shapeOptions) {
      options.shapeOptions = L.Util.extend({}, this.options.shapeOptions, options.shapeOptions);
    }
    //L.setOptions(this, options);
  }

  enable() {
    if (this.enabled()) {
      return;
    }

    super.enable();

    this.fire('enabled', { handler: this.type });

    this._map.fire('draw:drawstart', { layerType: this.type });
  }

  disable() {
    if (!this.enabled()) { return; }

    super.disable();

    this._map.fire('draw:drawstop', { layerType: this.type });

    this.fire('disabled', { handler: this.type });
  }

  addHooks() {
    var map = this._map;

    if (map) {
      L.DomUtil.disableTextSelection();

      map.getContainer().focus();

      this._tooltip = new Tooltip(this._map);

      L.DomEvent.on(this._container, 'keyup', this._cancelDrawing, this);
    }
  }

  removeHooks() {
    if (this._map != null) {
      L.DomUtil.enableTextSelection();

      this._tooltip.dispose();
      this._tooltip = null;

      L.DomEvent.off(this._container, 'keyup', this._cancelDrawing, this);
    }
  }

  setOptions(options) {
    L.setOptions(this, options);
  }

  _fireCreatedEvent(layer) {
    this._map.fire('draw:created', { layer: layer, layerType: this.type });
  }

  // Cancel drawing when the escape key is pressed
  _cancelDrawing(e) {
    if (e.keyCode == 27) {
      this.disable();
    }
  }
}