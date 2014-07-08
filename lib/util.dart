part of leaflet.draw.ext;

// Ported from the OpenLayers implementation. See https://github.com/openlayers/openlayers/blob/master/lib/OpenLayers/Geometry/LinearRing.js#L270
geodesicArea(latLngs) {
  var pointsCount = latLngs.length,
      area = 0.0,
      d2r = L.LatLng.DEG_TO_RAD,
      p1,
      p2;

  if (pointsCount > 2) {
    for (var i = 0; i < pointsCount; i++) {
      p1 = latLngs[i];
      p2 = latLngs[(i + 1) % pointsCount];
      area += ((p2.lng - p1.lng) * d2r) * (2 + Math.sin(p1.lat * d2r) + Math.sin(p2.lat * d2r));
    }
    area = area * 6378137.0 * 6378137.0 / 2.0;
  }

  return Math.abs(area);
}

readableArea(area, isMetric) {
  var areaStr;

  if (isMetric) {
    if (area >= 10000) {
      areaStr = (area * 0.0001).toFixed(2) + ' ha';
    } else {
      areaStr = area.toFixed(2) + ' m&sup2;';
    }
  } else {
    area *= 0.836127; // Square yards in 1 meter

    if (area >= 3097600) { //3097600 square yards in 1 square mile
      areaStr = (area / 3097600).toFixed(2) + ' mi&sup2;';
    } else if (area >= 4840) {//48040 square yards in 1 acre
      areaStr = (area / 4840).toFixed(2) + ' acres';
    } else {
      areaStr = Math.ceil(area) + ' yd&sup2;';
    }
  }

  return areaStr;
}

readableDistance(distance, isMetric) {
  var distanceStr;

  if (isMetric) {
    // show metres when distance is < 1km, then show km
    if (distance > 1000) {
      distanceStr = (distance / 1000).toFixed(2) + ' km';
    } else {
      distanceStr = Math.ceil(distance) + ' m';
    }
  } else {
    distance *= 1.09361;

    if (distance > 1760) {
      distanceStr = (distance / 1760).toFixed(2) + ' miles';
    } else {
      distanceStr = Math.ceil(distance) + ' yd';
    }
  }

  return distanceStr;
}

/* LineUtil */

// Checks to see if two line segments intersect. Does not handle degenerate cases.
// http://compgeom.cs.uiuc.edu/~jeffe/teaching/373/notes/x06-sweepline.pdf
segmentsIntersect(/*Point*/ p,  /*Point*/ p1,  /*Point*/ p2,  /*Point*/ p3) {
  return _checkCounterclockwise(p, p2, p3) != _checkCounterclockwise(p1, p2, p3) && _checkCounterclockwise(p, p1, p2) != _checkCounterclockwise(p, p1, p3);
}

// check to see if points are in counterclockwise order
_checkCounterclockwise(/*Point*/ p,  /*Point*/ p1,  /*Point*/ p2) {
  return (p2.y - p.y) * (p1.x - p.x) > (p1.y - p.y) * (p2.x - p.x);
}

/* LatLngUtil */

// Clones a LatLngs[], returns [][]
cloneLatLngs(latlngs) {
  var clone = [];
  for (var i = 0,
      l = latlngs.length; i < l; i++) {
    clone.push(cloneLatLng(latlngs[i]));
  }
  return clone;
}

cloneLatLng(latlng) {
  return L.latLng(latlng.lat, latlng.lng);
}
