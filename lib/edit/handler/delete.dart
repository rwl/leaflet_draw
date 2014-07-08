part of leaflet.draw.edit.handler;

class Delete extends Handler {

  static final TYPE = 'remove'; // not delete as delete is reserved in js

  //includes: L.Mixin.Events,

  Delete(map, options) : super(options) {
    //L.Handler.prototype.initialize.call(this, map);

    L.Util.setOptions(this, options);

    // Store the selectable layer group for ease of access
    this._deletableLayers = this.options.featureGroup;

    if (!(this._deletableLayers is FeatureGroup)) {
      throw new Error('options.featureGroup must be a L.FeatureGroup');
    }

    // Save the type so super can fire, need to do this as cannot do this.TYPE :(
    this.type = L.EditToolbar.Delete.TYPE;
  }

  enable() {
    if (this._enabled || !this._hasAvailableLayers()) {
      return;
    }
    this.fire('enabled', { handler: this.type});

    this._map.fire('draw:deletestart', { handler: this.type });

    L.Handler.prototype.enable.call(this);

    this._deletableLayers
      .on('layeradd', this._enableLayerDelete, this)
      .on('layerremove', this._disableLayerDelete, this);
  }

  disable() {
    if (!this._enabled) { return; }

    this._deletableLayers
      .off('layeradd', this._enableLayerDelete, this)
      .off('layerremove', this._disableLayerDelete, this);

    super.disable();

    this._map.fire('draw:deletestop', { handler: this.type });

    this.fire('disabled', { handler: this.type});
  }

  addHooks() {
    var map = this._map;

    if (map) {
      map.getContainer().focus();

      this._deletableLayers.eachLayer(this._enableLayerDelete, this);
      this._deletedLayers = new L.layerGroup();

      this._tooltip = new L.Tooltip(this._map);
      this._tooltip.updateContent({ text: L.drawLocal.edit.handlers.remove.tooltip.text });

      this._map.on('mousemove', this._onMouseMove, this);
    }
  }

  removeHooks() {
    if (this._map) {
      this._deletableLayers.eachLayer(this._disableLayerDelete, this);
      this._deletedLayers = null;

      this._tooltip.dispose();
      this._tooltip = null;

      this._map.off('mousemove', this._onMouseMove, this);
    }
  }

  revertLayers() {
    // Iterate of the deleted layers and add them back into the featureGroup
    this._deletedLayers.eachLayer((layer) {
      this._deletableLayers.addLayer(layer);
    }, this);
  }

  save() {
    this._map.fire('draw:deleted', { layers: this._deletedLayers });
  }

  _enableLayerDelete(e) {
    var layer = e.layer || e.target || e;

    layer.on('click', this._removeLayer, this);
  }

  _disableLayerDelete(e) {
    var layer = e.layer || e.target || e;

    layer.off('click', this._removeLayer, this);

    // Remove from the deleted layers so we can't accidently revert if the user presses cancel
    this._deletedLayers.removeLayer(layer);
  }

  _removeLayer(e) {
    var layer = e.layer || e.target || e;

    this._deletableLayers.removeLayer(layer);

    this._deletedLayers.addLayer(layer);
  }

  _onMouseMove(e) {
    this._tooltip.updatePosition(e.latlng);
  }

  _hasAvailableLayers() {
    return this._deletableLayers.getLayers().length != 0;
  }
}
