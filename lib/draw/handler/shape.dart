part of leaflet.draw.draw.handler;

abstract class SimpleShape extends Feature {

  Map options = {
    'repeatMode': false
  };

  String _endLabelText;
  bool _mapDraggable;

  SimpleShape(LeafletMap map, options) : super(map, options) {
    this._endLabelText = L.drawLocal.draw.handlers.simpleshape.tooltip.end;
  }

  addHooks() {
    super.addHooks();
    if (this._map != null) {
      this._mapDraggable = this._map.dragging.enabled();

      if (this._mapDraggable) {
        this._map.dragging.disable();
      }

      //TODO refactor: move cursor to styles
      this._container.style.cursor = 'crosshair';

      this._tooltip.updateContent({ text: this._initialLabelText });

      this._map
        .on('mousedown', this._onMouseDown, this)
        .on('mousemove', this._onMouseMove, this);
    }
  }

  removeHooks() {
    super.removeHooks();
    if (this._map != null) {
      if (this._mapDraggable) {
        this._map.dragging.enable();
      }

      //TODO refactor: move cursor to styles
      this._container.style.cursor = '';

      this._map
        .off('mousedown', this._onMouseDown, this)
        .off('mousemove', this._onMouseMove, this);

      L.DomEvent.off(document, 'mouseup', this._onMouseUp, this);

      // If the box element doesn't exist they must not have moved the mouse, so don't need to destroy/return
      if (this._shape) {
        this._map.removeLayer(this._shape);
        //delete this._shape;
        this._shape = null;
      }
    }
    this._isDrawing = false;
  }

  _onMouseDown(e) {
    this._isDrawing = true;
    this._startLatLng = e.latlng;

    L.DomEvent
      .on(document, 'mouseup', this._onMouseUp, this)
      .preventDefault(e.originalEvent);
  }

  _onMouseMove(e) {
    var latlng = e.latlng;

    this._tooltip.updatePosition(latlng);
    if (this._isDrawing) {
      this._tooltip.updateContent({ text: this._endLabelText });
      this._drawShape(latlng);
    }
  }

  _onMouseUp() {
    if (this._shape) {
      this._fireCreatedEvent();
    }

    this.disable();
    if (this.options.repeatMode) {
      this.enable();
    }
  }
}