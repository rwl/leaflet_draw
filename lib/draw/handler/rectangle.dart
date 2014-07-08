part of leaflet.draw.draw.handler;

class Rectangle extends SimpleShape {

  static final TYPE = 'rectangle';

  Map options = {
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

  Rectangle(map, options) : super(map, options) {
    // Save the type so super can fire, need to do this as cannot do this.TYPE :(
    //this.type = L.Draw.Rectangle.TYPE;

    this._initialLabelText = L.drawLocal.draw.handlers.rectangle.tooltip.start;

    //L.Draw.SimpleShape.prototype.initialize.call(this, map, options);
  }

  _drawShape(latlng) {
    if (!this._shape) {
      this._shape = new L.Rectangle(new L.LatLngBounds(this._startLatLng, latlng), this.options.shapeOptions);
      this._map.addLayer(this._shape);
    } else {
      this._shape.setBounds(new L.LatLngBounds(this._startLatLng, latlng));
    }
  }

  _fireCreatedEvent() {
    var rectangle = new L.Rectangle(this._shape.getBounds(), this.options.shapeOptions);
    super._fireCreatedEvent(rectangle);
  }
}
