part of draw;

abstract class Toolbar {

  Map _modes;
  List _actionButtons;
  var _activeMode;

  Toolbar(options) {
    L.setOptions(this, options);

    this._modes = {};
    this._actionButtons = [];
    this._activeMode = null;
  }

  getModeHandlers(LeafletMap map);

  getActions(handler);

  enabled() {
    return this._activeMode != null;
  }

  disable() {
    if (!this.enabled()) { return; }

    this._activeMode.handler.disable();
  }

  addToolbar(LeafletMap map) {
    var container = L.DomUtil.create('div', 'leaflet-draw-section'),
      buttonIndex = 0,
      buttonClassPrefix = this._toolbarClass || '',
      modeHandlers = this.getModeHandlers(map),
      i;

    this._toolbarContainer = L.DomUtil.create('div', 'leaflet-draw-toolbar leaflet-bar');
    this._map = map;

    for (i = 0; i < modeHandlers.length; i++) {
      if (modeHandlers[i].enabled) {
        this._initModeHandler(
          modeHandlers[i].handler,
          this._toolbarContainer,
          buttonIndex++,
          buttonClassPrefix,
          modeHandlers[i].title
        );
      }
    }

    // if no buttons were added, do not add the toolbar
    if (!buttonIndex) {
      return;
    }

    // Save button index of the last button, -1 as we would have ++ after the last button
    this._lastButtonIndex = --buttonIndex;

    // Create empty actions part of the toolbar
    this._actionsContainer = L.DomUtil.create('ul', 'leaflet-draw-actions');

    // Add draw and cancel containers to the control container
    container.appendChild(this._toolbarContainer);
    container.appendChild(this._actionsContainer);

    return container;
  }

  removeToolbar() {
    // Dispose each handler
    for (var handlerId in this._modes) {
      if (this._modes.hasOwnProperty(handlerId)) {
        // Unbind handler button
        this._disposeButton(
          this._modes[handlerId].button,
          this._modes[handlerId].handler.enable,
          this._modes[handlerId].handler
        );

        // Make sure is disabled
        this._modes[handlerId].handler.disable();

        // Unbind handler
        this._modes[handlerId].handler
          .off('enabled', this._handlerActivated, this)
          .off('disabled', this._handlerDeactivated, this);
      }
    }
    this._modes = {};

    // Dispose the actions toolbar
    for (var i = 0, l = this._actionButtons.length; i < l; i++) {
      this._disposeButton(
        this._actionButtons[i].button,
        this._actionButtons[i].callback,
        this
      );
    }
    this._actionButtons = [];
    this._actionsContainer = null;
  }

  _initModeHandler(handler, container, buttonIndex, classNamePredix, buttonTitle) {
    var type = handler.type;

    this._modes[type] = {};

    this._modes[type].handler = handler;

    this._modes[type].button = this._createButton({
      title: buttonTitle,
      className: classNamePredix + '-' + type,
      container: container,
      callback: this._modes[type].handler.enable,
      context: this._modes[type].handler
    });

    this._modes[type].buttonIndex = buttonIndex;

    this._modes[type].handler
      .on('enabled', this._handlerActivated, this)
      .on('disabled', this._handlerDeactivated, this);
  }

  _createButton(options) {
    var link = L.DomUtil.create('a', options.className || '', options.container);
    link.href = '#';

    if (options.text) {
      link.innerHTML = options.text;
    }

    if (options.title) {
      link.title = options.title;
    }

    L.DomEvent
      .on(link, 'click', L.DomEvent.stopPropagation)
      .on(link, 'mousedown', L.DomEvent.stopPropagation)
      .on(link, 'dblclick', L.DomEvent.stopPropagation)
      .on(link, 'click', L.DomEvent.preventDefault)
      .on(link, 'click', options.callback, options.context);

    return link;
  }

  _disposeButton(button, callback) {
    L.DomEvent
      .off(button, 'click', L.DomEvent.stopPropagation)
      .off(button, 'mousedown', L.DomEvent.stopPropagation)
      .off(button, 'dblclick', L.DomEvent.stopPropagation)
      .off(button, 'click', L.DomEvent.preventDefault)
      .off(button, 'click', callback);
  }

  _handlerActivated(e) {
    // Disable active mode (if present)
    this.disable();

    // Cache new active feature
    this._activeMode = this._modes[e.handler];

    L.DomUtil.addClass(this._activeMode.button, 'leaflet-draw-toolbar-button-enabled');

    this._showActionsToolbar();

    this.fire('enable');
  }

  _handlerDeactivated() {
    this._hideActionsToolbar();

    L.DomUtil.removeClass(this._activeMode.button, 'leaflet-draw-toolbar-button-enabled');

    this._activeMode = null;

    this.fire('disable');
  }

  _createActions(handler) {
    var container = this._actionsContainer,
      buttons = this.getActions(handler),
      l = buttons.length,
      li, di, dl, button;

    // Dispose the actions toolbar (todo: dispose only not used buttons)
    for (int di = 0, dl = this._actionButtons.length; di < dl; di++) {
      this._disposeButton(this._actionButtons[di].button, this._actionButtons[di].callback);
    }
    this._actionButtons = [];

    // Remove all old buttons
    while (container.firstChild) {
      container.removeChild(container.firstChild);
    }

    for (var i = 0; i < l; i++) {
      if (/*'enabled' in buttons[i] && */!buttons[i].enabled) {
        continue;
      }

      li = L.DomUtil.create('li', '', container);

      button = this._createButton({
        title: buttons[i].title,
        text: buttons[i].text,
        container: li,
        callback: buttons[i].callback,
        context: buttons[i].context
      });

      this._actionButtons.push({
        button: button,
        callback: buttons[i].callback
      });
    }
  }

  _showActionsToolbar() {
    var buttonIndex = this._activeMode.buttonIndex,
      lastButtonIndex = this._lastButtonIndex,
      toolbarPosition = this._activeMode.button.offsetTop - 1;

    // Recreate action buttons on every click
    this._createActions(this._activeMode.handler);

    // Correctly position the cancel button
    this._actionsContainer.style.top = toolbarPosition + 'px';

    if (buttonIndex == 0) {
      L.DomUtil.addClass(this._toolbarContainer, 'leaflet-draw-toolbar-notop');
      L.DomUtil.addClass(this._actionsContainer, 'leaflet-draw-actions-top');
    }

    if (buttonIndex == lastButtonIndex) {
      L.DomUtil.addClass(this._toolbarContainer, 'leaflet-draw-toolbar-nobottom');
      L.DomUtil.addClass(this._actionsContainer, 'leaflet-draw-actions-bottom');
    }

    this._actionsContainer.style.display = 'block';
  }

  _hideActionsToolbar() {
    this._actionsContainer.style.display = 'none';

    L.DomUtil.removeClass(this._toolbarContainer, 'leaflet-draw-toolbar-notop');
    L.DomUtil.removeClass(this._toolbarContainer, 'leaflet-draw-toolbar-nobottom');
    L.DomUtil.removeClass(this._actionsContainer, 'leaflet-draw-actions-top');
    L.DomUtil.removeClass(this._actionsContainer, 'leaflet-draw-actions-bottom');
  }
}
