part of leaflet.draw.draw.handler;

class Polygon extends Polyline {
  static final TYPE = 'polygon';

  var Poly = Polygon;

  Map options = {
    'showArea': false,
    'shapeOptions': {
      'stroke': true,
      'color': '#f06eaa',
      'weight': 4,
      'opacity': 0.5,
      'fill': true,
      'fillColor': null, //same as color by default
      'fillOpacity': 0.2,
      'clickable': true
    }
  };

  Polygon(map, options) : super(map, options) {
    // Save the type so super can fire, need to do this as cannot do this.TYPE :(
    //this.type = L.Draw.Polygon.TYPE;
  }

  _updateFinishHandler() {
    var markerCount = this._markers.length;

    // The first marker should have a click handler to close the polygon
    if (markerCount == 1) {
      this._markers[0].on('click', this._finishShape, this);
    }

    // Add and update the double click handler
    if (markerCount > 2) {
      this._markers[markerCount - 1].on('dblclick', this._finishShape, this);
      // Only need to remove handler if has been added before
      if (markerCount > 3) {
        this._markers[markerCount - 2].off('dblclick', this._finishShape, this);
      }
    }
  }

  _getTooltipText() {
    var text, subtext;

    if (this._markers.length == 0) {
      text = L.drawLocal.draw.handlers.polygon.tooltip.start;
    } else if (this._markers.length < 3) {
      text = L.drawLocal.draw.handlers.polygon.tooltip.cont;
    } else {
      text = L.drawLocal.draw.handlers.polygon.tooltip.end;
      subtext = this._getMeasurementString();
    }

    return {
      text: text,
      subtext: subtext
    };
  }

  _getMeasurementString() {
    var area = this._area;

    if (!area) {
      return null;
    }

    return L.GeometryUtil.readableArea(area, this.options.metric);
  }

  _shapeIsValid() {
    return this._markers.length >= 3;
  }

  _vertexChanged(latlng, added) {
    var latLngs;

    // Check to see if we should show the area
    if (!this.options.allowIntersection && this.options.showArea) {
      latLngs = this._poly.getLatLngs();

      this._area = L.GeometryUtil.geodesicArea(latLngs);
    }

    super._vertexChanged(latlng, added);
  }

  _cleanUpShape() {
    var markerCount = this._markers.length;

    if (markerCount > 0) {
      this._markers[0].off('click', this._finishShape, this);

      if (markerCount > 2) {
        this._markers[markerCount - 1].off('dblclick', this._finishShape, this);
      }
    }
  }


  // Checks a polygon for any intersecting line segments. Ignores holes.
  intersects() {
    var polylineIntersects,
    points = this._originalPoints,
    len, firstPoint, lastPoint, maxIndex;

    if (this._tooFewPointsForIntersection()) {
    return false;
    }

    polylineIntersects = L.Polyline.prototype.intersects.call(this);

    // If already found an intersection don't need to check for any more.
    if (polylineIntersects) {
    return true;
    }

    len = points.length;
    firstPoint = points[0];
    lastPoint = points[len - 1];
    maxIndex = len - 2;

    // Check the line segment between last and first point. Don't need to check the first line segment (minIndex = 1)
    return this._lineSegmentsIntersectsRange(lastPoint, firstPoint, maxIndex, 1);
  }
}
