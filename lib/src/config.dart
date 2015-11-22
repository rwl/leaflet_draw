library leaflet.draw.src.config;

import 'dart:js';

class DrawLocal {
  final _Draw draw = new _Draw();
  final _Edit edit = new _Edit();
}

class _Draw {
  final _DrawToolbar toolbar = new _DrawToolbar();
  final _DrawHandlers handlers = new _DrawHandlers();
}

class _DrawToolbar {
  final _DrawToolbarActions actions = new _DrawToolbarActions();
  final _DrawToolbarUndo undo = new _DrawToolbarUndo();
  final _DrawToolbarButtons buttons = new _DrawToolbarButtons();
}

class _DrawToolbarActions {
  void set title(String value) {
    context['L']['drawLocal']['draw']['toolbar']['actions']['title'] = value;
  }

  void set text(String value) {
    context['L']['drawLocal']['draw']['toolbar']['actions']['text'] = value;
  }
}

class _DrawToolbarUndo {
  void set title(String value) {
    context['L']['drawLocal']['draw']['toolbar']['undo']['title'] = value;
  }

  void set text(String value) {
    context['L']['drawLocal']['draw']['toolbar']['undo']['text'] = value;
  }
}

class _DrawToolbarButtons {
  void set polyline(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['polyline'] = value;
  }

  void set polygon(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['polygon'] = value;
  }

  void set rectangle(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']
        ['rectangle'] = value;
  }

  void set circle(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['circle'] = value;
  }

  void set marker(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['marker'] = value;
  }
}

class _DrawHandlers {
  final _DrawHandlersCircle circle = new _DrawHandlersCircle();
  final _DrawHandlersMarker marker = new _DrawHandlersMarker();
  final _DrawHandlersPolygon polygon = new _DrawHandlersPolygon();
  final _DrawHandlersPolyline polyline = new _DrawHandlersPolyline();
  final _DrawHandlersRectangle rectangle = new _DrawHandlersRectangle();
  final _DrawHandlersSimpleShape simpleshape = new _DrawHandlersSimpleShape();
}

class _DrawHandlersCircle {
  final _DrawHandlersCircleTooltip tooltip = new _DrawHandlersCircleTooltip();

  void set radius(String value) {
    context['L']['drawLocal']['draw']['handlers']['circle']['radius'] = value;
  }
}

class _DrawHandlersMarker {
  final _DrawHandlersMarkerTooltip tooltip = new _DrawHandlersMarkerTooltip();
}

class _DrawHandlersPolygon {
  final _DrawHandlersPolygonTooltip tooltip = new _DrawHandlersPolygonTooltip();
}

class _DrawHandlersPolyline {
  void set error(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['error'] = value;
  }

  final _DrawHandlersPolylineTooltip tooltip =
      new _DrawHandlersPolylineTooltip();
}

class _DrawHandlersRectangle {
  final _DrawHandlersRectangleTooltip tooltip =
      new _DrawHandlersRectangleTooltip();
}

class _DrawHandlersSimpleShape {
  final _DrawHandlersSimpleShapeTooltip tooltip =
      new _DrawHandlersSimpleShapeTooltip();
}

class _DrawHandlersCircleTooltip {
  void set start(String value) {
    context['L']['drawLocal']['draw']['handlers']['circle']['tooltip']
        ['start'] = value;
  }
}

class _DrawHandlersMarkerTooltip {
  void set start(String value) {
    context['L']['drawLocal']['draw']['handlers']['marker']['tooltip']
        ['start'] = value;
  }
}

class _DrawHandlersPolygonTooltip {
  void set start(String value) {
    context['L']['drawLocal']['draw']['handlers']['polygon']['tooltip']
        ['start'] = value;
  }

  void set cont(String value) {
    context['L']['drawLocal']['draw']['handlers']['polygon']['tooltip']
        ['cont'] = value;
  }

  void set end(String value) {
    context['L']['drawLocal']['draw']['handlers']['polygon']['tooltip']
        ['end'] = value;
  }
}

class _DrawHandlersPolylineTooltip {
  void set start(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['tooltip']
        ['start'] = value;
  }

  void set cont(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['tooltip']
        ['cont'] = value;
  }

  void set end(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['tooltip']
        ['end'] = value;
  }
}

class _DrawHandlersRectangleTooltip {
  void set start(String value) {
    context['L']['drawLocal']['draw']['handlers']['rectangle']['tooltip']
        ['start'] = value;
  }
}

class _DrawHandlersSimpleShapeTooltip {
  void set end(String value) {
    context['L']['drawLocal']['draw']['handlers']['rectangle']['tooltip']
        ['end'] = value;
  }
}

class _Edit {
  final _EditToolbar toolbar = new _EditToolbar();
  final _EditHanders handlers = new _EditHanders();
}

class _EditToolbar {
  final _EditToolbarActions actions = new _EditToolbarActions();
  final _EditToolbarButtons buttons = new _EditToolbarButtons();
}

class _EditToolbarActions {
  final _EditToolbarActionsSave save = new _EditToolbarActionsSave();
  final _EditToolbarActionsCancel cancel = new _EditToolbarActionsCancel();
}

class _EditToolbarActionsSave {
  void set title(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['save']
        ['title'] = value;
  }

  void set text(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['save']
        ['text'] = value;
  }
}

class _EditToolbarActionsCancel {
  void set title(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['cancel']
        ['title'] = value;
  }

  void set text(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['cancel']
        ['text'] = value;
  }
}

class _EditToolbarButtons {
  void set edit(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']['edit'] = value;
  }

  void set editDisabled(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']
        ['editDisabled'] = value;
  }

  void set remove(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']['remove'] = value;
  }

  void set removeDisabled(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']
        ['removeDisabled'] = value;
  }
}

class _EditHanders {
  final _EditHandersEdit edit = new _EditHandersEdit();
  final _EditHandersRemove remove = new _EditHandersRemove();
}

class _EditHandersEdit {
  final _EditHandersEditTooltip tooltip = new _EditHandersEditTooltip();
}

class _EditHandersEditTooltip {
  void set text(String value) {
    context['L']['drawLocal']['edit']['handlers']['edit']['tooltip']
        ['text'] = value;
  }

  void set subtext(String value) {
    context['L']['drawLocal']['edit']['handlers']['edit']['tooltip']
        ['subtext'] = value;
  }
}

class _EditHandersRemove {
  final _EditHandersRemoveTooltip tooltip = new _EditHandersRemoveTooltip();
}

class _EditHandersRemoveTooltip {
  void set text(String value) {
    context['L']['drawLocal']['edit']['handlers']['remove']['tooltip']
        ['text'] = value;
  }
}
