part of leaflet.draw.edit.handler;

//L.Edit = L.Edit || {};

abstract class SimpleShape extends Handler {

  Map options = {
    'moveIcon': new L.DivIcon({
      'iconSize': new L.Point(8, 8),
      'className': 'leaflet-div-icon leaflet-editing-icon leaflet-edit-move'
    }),
    'resizeIcon': new L.DivIcon({
      'iconSize': new L.Point(8, 8),
      'className': 'leaflet-div-icon leaflet-editing-icon leaflet-edit-resize'
    })
  };

  SimpleShape(shape, options) : super(options) {
    this._shape = shape;
    //L.Util.setOptions(this, options);
  }

  addHooks() {
    if (this._shape._map) {
      this._map = this._shape._map;

      if (!this._markerGroup) {
        this._initMarkers();
      }
      this._map.addLayer(this._markerGroup);
    }
  }

  removeHooks() {
    if (this._shape._map) {
      this._unbindMarker(this._moveMarker);

      for (var i = 0, l = this._resizeMarkers.length; i < l; i++) {
        this._unbindMarker(this._resizeMarkers[i]);
      }
      this._resizeMarkers = null;

      this._map.removeLayer(this._markerGroup);
      /*delete */this._markerGroup = null;
    }

    this._map = null;
  }

  updateMarkers() {
    this._markerGroup.clearLayers();
    this._initMarkers();
  }

  _initMarkers() {
    if (!this._markerGroup) {
      this._markerGroup = new L.LayerGroup();
    }

    // Create center marker
    this._createMoveMarker();

    // Create edge marker
    this._createResizeMarker();
  }

  _createMoveMarker();// {
    // Children override
  //}

  _createResizeMarker();// {
    // Children override
  //}

  _createMarker(latlng, icon) {
    var marker = new L.Marker(latlng, {
      draggable: true,
      icon: icon,
      zIndexOffset: 10
    });

    this._bindMarker(marker);

    this._markerGroup.addLayer(marker);

    return marker;
  }

  _bindMarker(marker) {
    marker
      .on('dragstart', this._onMarkerDragStart, this)
      .on('drag', this._onMarkerDrag, this)
      .on('dragend', this._onMarkerDragEnd, this);
  }

  _unbindMarker(marker) {
    marker
      .off('dragstart', this._onMarkerDragStart, this)
      .off('drag', this._onMarkerDrag, this)
      .off('dragend', this._onMarkerDragEnd, this);
  }

  _onMarkerDragStart(e) {
    var marker = e.target;
    marker.setOpacity(0);

    this._shape.fire('editstart');
  }

  _fireEdit() {
    this._shape.edited = true;
    this._shape.fire('edit');
  }

  _onMarkerDrag(e) {
    var marker = e.target,
      latlng = marker.getLatLng();

    if (marker == this._moveMarker) {
      this._move(latlng);
    } else {
      this._resize(latlng);
    }

    this._shape.redraw();
  }

  _onMarkerDragEnd(e) {
    var marker = e.target;
    marker.setOpacity(1);

    this._fireEdit();
  }

  _move();// {
    // Children override
  //},

  _resize();// {
    // Children override
  //}
}
