library leaflet.draw;

import 'dart:html';
import 'dart:async';
import 'dart:js';
import 'package:leaflet/leaflet.dart';
import 'package:leaflet/leaflet.dart' as leaflet;
import 'src/config.dart';

final DrawLocal drawLocal = new DrawLocal();

class Draw implements Control {
  final JsObject control;

  factory Draw({String position, Map draw, Map edit}) {
    var config = {};
    if (position != null) config['position'] = position;
    if (draw != null) config['draw'] = draw;
    if (edit != null) {
      if (edit['featureGroup'] is FeatureGroup) {
        edit = new Map.from(edit);
        edit['featureGroup'] = edit['featureGroup'].layer;
      }
      config['edit'] = edit;
    }
    var _config = new JsObject.jsify(config);
    var control = new JsObject(context['L']['Control']['Draw'], [_config]);
    return new Draw._(control);
  }

  Draw._(this.control);

  void setDrawingOptions(Map draw) {
    var _draw = new JsObject.jsify(draw);
    control.callMethod('setDrawingOptions', [_draw]);
  }

  Stream<Layer> get onDrawCreated {
    const type = 'draw:created';
    JsObject map = control['_map'];
    if (map == null) {
      throw new StateError(
          'Add Draw control to LeafletMap before subscribing to $type');
    }
    Function fn;
    var ctrl = new StreamController<Layer>(onCancel: () {
      map.callMethod('off', [type, fn]);
    });
    fn = (JsObject e) {
      var layerType = e['layerType'], l = e['layer'];
      Layer layer;
      switch (layerType) {
        case 'marker':
          layer = new Marker.wrap(l);
          break;
        case 'polyline':
          layer = new Polyline.wrap(l);
          break;
        case 'polygon':
          layer = new Polygon.wrap(l);
          break;
        case 'rectangle':
          layer = new leaflet.Rectangle.wrap(l);
          break;
        case 'circle':
          layer = new Circle.wrap(l);
          break;
        default:
          throw new UnimplementedError(layerType);
      }
      ctrl.add(layer);
    };
    map.callMethod('on', [type, fn]);
    return ctrl.stream;
  }

  Stream<LayerGroup> get onDrawEdited {
    const type = 'draw:edited';
    JsObject map = control['_map'];
    if (map == null) {
      throw new StateError(
          'Add Draw control to LeafletMap before subscribing to $type');
    }
    Function fn;
    var ctrl = new StreamController<LayerGroup>(onCancel: () {
      map.callMethod('off', [type, fn]);
    });
    fn = (JsObject e) {
      var group = new LayerGroup.wrap(e['layers']);
      ctrl.add(group);
    };
    map.callMethod('on', [type, fn]);
    return ctrl.stream;
  }
}

//class DrawCreatedEvent {
//  final AbstractLayer layer;
//  final String layerType;
//  DrawCreatedEvent(this.layer, this.layerType);
//}
//
//class AbstractLayer implements Layer {
//  final JsObject layer;
//  AbstractLayer(this.layer);
//}
