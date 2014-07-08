part of leaflet.draw.edit.handler;

//L.Edit = L.Edit || {};

class Circle extends SimpleShape {

  Circle() : super();

  _createMoveMarker() {
    var center = this._shape.getLatLng();

    this._moveMarker = this._createMarker(center, this.options.moveIcon);
  }

  _createResizeMarker() {
    var center = this._shape.getLatLng(),
      resizemarkerPoint = this._getResizeMarkerPoint(center);

    this._resizeMarkers = [];
    this._resizeMarkers.push(this._createMarker(resizemarkerPoint, this.options.resizeIcon));
  }

  _getResizeMarkerPoint(latlng) {
    // From L.shape.getBounds()
    var delta = this._shape._radius * Math.cos(Math.PI / 4),
      point = this._map.project(latlng);
    return this._map.unproject([point.x + delta, point.y - delta]);
  }

  _move(latlng) {
    var resizemarkerPoint = this._getResizeMarkerPoint(latlng);

    // Move the resize marker
    this._resizeMarkers[0].setLatLng(resizemarkerPoint);

    // Move the circle
    this._shape.setLatLng(latlng);
  }

  _resize(latlng) {
    var moveLatLng = this._moveMarker.getLatLng(),
      radius = moveLatLng.distanceTo(latlng);

    this._shape.setRadius(radius);
  }
}
/*
L.Circle.addInitHook(function () {
  if (L.Edit.Circle) {
    this.editing = new L.Edit.Circle(this);

    if (this.options.editable) {
      this.editing.enable();
    }
  }

  this.on('add', function () {
    if (this.editing && this.editing.enabled()) {
      this.editing.addHooks();
    }
  });

  this.on('remove', function () {
    if (this.editing && this.editing.enabled()) {
      this.editing.removeHooks();
    }
  });
});
*/