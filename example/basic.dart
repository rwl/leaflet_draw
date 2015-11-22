import 'dart:html';

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
  drawLocal.draw.toolbar.buttons.polygon = 'Draw a polygon!';

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

  drawControl.onDrawCreated.listen((Layer layer) {
    if (layer is Marker) {
      layer.bindPopup('A popup!');
    }

    drawnItems.addLayer(layer);
  });

  drawControl.onDrawEdited.listen((LayerGroup layers) {
    var countOfEditedLayers = 0;
    layers.eachLayer((layer) {
      countOfEditedLayers++;
    });
    print("Edited $countOfEditedLayers layers");
  });

  document.getElementById('changeColor').onClick.listen((_) {
    drawControl.setDrawingOptions({
      'rectangle': {
        'shapeOptions': {'color': '#004a80'}
      }
    });
  });
}
