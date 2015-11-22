import 'dart:html';
import 'dart:js';

import 'package:leaflet/leaflet.dart';
import 'package:leaflet_draw/leaflet_draw.dart';

main() {
  var map = new LeafletMap.selector('map', new MapOptions()
    ..layers = [osmLayer]
    ..center = new LatLng(-37.7772, 175.2756)
    ..zoom = 15);

  var drawnItems = new FeatureGroup();
  map.addLayer(drawnItems);

  // Set the title to show on the polygon button
  Draw.draw_toolbar_buttons_polygon = 'Draw a polygon!';

  var drawControl = new Draw(
      position: 'topright',
      draw: {
        'polyline': {'metric': true},
        'polygon': {
          'allowIntersection': false,
          'showArea': true,
          'drawError': {'color': '#b00b00', 'timeout': 1000},
          'shapeOptions': {'color': '#bada55'}
        },
        'circle': {
          'shapeOptions': {'color': '#662d91'}
        },
        'marker': false
      },
      edit: {'featureGroup': drawnItems, 'remove': false});
  map.addControl(drawControl);

  map.on('draw:created').listen((JsObject e) {
    var type = e['layerType'], layer = e['layer'];

    if (type == 'marker') {
      layer.bindPopup('A popup!');
    }

    drawnItems.addJsLayer(layer);
  });

  map.on('draw:edited').listen((JsObject e) {
//    var layers = e['layers'];
//    var countOfEditedLayers = 0;
//    layers.eachLayer((layer) {
//      countOfEditedLayers++;
//    });
//    print("Edited $countOfEditedLayers layers");
  });

  document.getElementById('changeColor').onClick.listen((_) {
    drawControl.setDrawingOptions({
      'rectangle': {
        'shapeOptions': {'color': '#004a80'}
      }
    });
  });
}
