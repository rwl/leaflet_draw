library draw;

import 'dart:html';
import 'package:leaflet/leaflet.dart';

part 'toolbar.dart';
part 'tooltip.dart';

class DrawOptions extends ControlOptions {
  Map draw;
  bool edit = false;
  DrawOptions() {
    position = ControlPosition.TOPLEFT;
  }
}

class Draw extends Control {

  DrawOptions get drawOptions => options as DrawOptions;

  Map _toolbars;

  Draw(drawOptions) : super(drawOptions) {
    if (L.version < '0.7') {
      throw new Error('Leaflet.draw 0.2.3+ requires Leaflet 0.7.0+. Download latest from https://github.com/Leaflet/Leaflet/');
    }

    var toolbar;

    this._toolbars = {};

    // Initialize toolbars
    if (DrawToolbar && this.options.draw != null) {
      toolbar = new DrawToolbar(this.options.draw);

      this._toolbars[DrawToolbar.TYPE] = toolbar;

      // Listen for when toolbar is enabled
      this._toolbars[DrawToolbar.TYPE].on('enable', this._toolbarEnabled, this);
    }

    if (EditToolbar && this.options.edit) {
      toolbar = new EditToolbar(this.options.edit);

      this._toolbars[EditToolbar.TYPE] = toolbar;

      // Listen for when toolbar is enabled
      this._toolbars[EditToolbar.TYPE].on('enable', this._toolbarEnabled, this);
    }
  }

  onAdd(LeafletMap map) {
    final container = document.createElement('div', 'leaflet-draw'),
      addedTopClass = false,
      topClassName = 'leaflet-draw-toolbar-top',
      toolbarContainer;

    for (var toolbarId in this._toolbars) {
      if (this._toolbars.hasOwnProperty(toolbarId)) {
        toolbarContainer = this._toolbars[toolbarId].addToolbar(map);

        if (toolbarContainer) {
          // Add class to the first toolbar to remove the margin
          if (!addedTopClass) {
            if (!DomUtil.hasClass(toolbarContainer, topClassName)) {
              DomUtil.addClass(toolbarContainer.childNodes[0], topClassName);
            }
            addedTopClass = true;
          }

          container.appendChild(toolbarContainer);
        }
      }
    }

    return container;
  }

  onRemove() {
    for (var toolbarId in this._toolbars) {
      if (this._toolbars.hasOwnProperty(toolbarId)) {
        this._toolbars[toolbarId].removeToolbar();
      }
    }
  }

  setDrawingOptions(options) {
    for (var toolbarId in this._toolbars) {
      if (this._toolbars[toolbarId] is DrawToolbar) {
        this._toolbars[toolbarId].setOptions(options);
      }
    }
  }

  _toolbarEnabled(e) {
    var enabledToolbar = e.target;

    for (var toolbarId in this._toolbars) {
      if (this._toolbars[toolbarId] != enabledToolbar) {
        this._toolbars[toolbarId].disable();
      }
    }
  }
}