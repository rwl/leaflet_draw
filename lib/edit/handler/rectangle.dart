part of leaflet.draw.edit.handler;

//L.Edit = L.Edit || {};

class Rectangle extends SimpleShape {

  Rectangle() : super();

  _createMoveMarker() {
    var bounds = this._shape.getBounds(),
      center = bounds.getCenter();

    this._moveMarker = this._createMarker(center, this.options.moveIcon);
  }

  _createResizeMarker() {
    var corners = this._getCorners();

    this._resizeMarkers = [];

    for (var i = 0, l = corners.length; i < l; i++) {
      this._resizeMarkers.push(this._createMarker(corners[i], this.options.resizeIcon));
      // Monkey in the corner index as we will need to know this for dragging
      this._resizeMarkers[i]._cornerIndex = i;
    }
  }

  _onMarkerDragStart(e) {
    super._onMarkerDragStart(e);

    // Save a reference to the opposite point
    var corners = this._getCorners(),
      marker = e.target,
      currentCornerIndex = marker._cornerIndex;

    this._oppositeCorner = corners[(currentCornerIndex + 2) % 4];

    this._toggleCornerMarkers(0, currentCornerIndex);
  }

  _onMarkerDragEnd(e) {
    var marker = e.target,
      bounds, center;

    // Reset move marker position to the center
    if (marker == this._moveMarker) {
      bounds = this._shape.getBounds();
      center = bounds.getCenter();

      marker.setLatLng(center);
    }

    this._toggleCornerMarkers(1);

    this._repositionCornerMarkers();

    super._onMarkerDragEnd.call(e);
  }

  _move(newCenter) {
    var latlngs = this._shape.getLatLngs(),
      bounds = this._shape.getBounds(),
      center = bounds.getCenter(),
      offset, newLatLngs = [];

    // Offset the latlngs to the new center
    for (var i = 0, l = latlngs.length; i < l; i++) {
      offset = [latlngs[i].lat - center.lat, latlngs[i].lng - center.lng];
      newLatLngs.push([newCenter.lat + offset[0], newCenter.lng + offset[1]]);
    }

    this._shape.setLatLngs(newLatLngs);

    // Reposition the resize markers
    this._repositionCornerMarkers();
  }

  _resize(latlng) {
    var bounds;

    // Update the shape based on the current position of this corner and the opposite point
    this._shape.setBounds(L.latLngBounds(latlng, this._oppositeCorner));

    // Reposition the move marker
    bounds = this._shape.getBounds();
    this._moveMarker.setLatLng(bounds.getCenter());
  }

  _getCorners() {
    var bounds = this._shape.getBounds(),
      nw = bounds.getNorthWest(),
      ne = bounds.getNorthEast(),
      se = bounds.getSouthEast(),
      sw = bounds.getSouthWest();

    return [nw, ne, se, sw];
  }

  _toggleCornerMarkers(opacity) {
    for (var i = 0, l = this._resizeMarkers.length; i < l; i++) {
      this._resizeMarkers[i].setOpacity(opacity);
    }
  }

  _repositionCornerMarkers() {
    var corners = this._getCorners();

    for (var i = 0, l = this._resizeMarkers.length; i < l; i++) {
      this._resizeMarkers[i].setLatLng(corners[i]);
    }
  }
}

/*
L.Rectangle.addInitHook(function () {
  if (L.Edit.Rectangle) {
    this.editing = new L.Edit.Rectangle(this);

    if (this.options.editable) {
      this.editing.enable();
    }
  }
}
*/