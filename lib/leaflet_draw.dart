library leaflet.draw;

import 'dart:html';
import 'dart:js';
import 'package:leaflet/leaflet.dart';

class Draw implements Control {
  static set draw_toolbar_actions_title(String value) {
    context['L']['drawLocal']['draw']['toolbar']['actions']['title'] = value;
  }

  static set draw_toolbar_actions_text(String value) {
    context['L']['drawLocal']['draw']['toolbar']['actions']['text'] = value;
  }

  static set draw_toolbar_undo_title(String value) {
    context['L']['drawLocal']['draw']['toolbar']['undo']['title'] = value;
  }

  static set draw_toolbar_undo_text(String value) {
    context['L']['drawLocal']['draw']['toolbar']['undo']['text'] = value;
  }

  static set draw_toolbar_buttons_polyline(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['polyline'] = value;
  }

  static set draw_toolbar_buttons_polygon(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['polygon'] = value;
  }

  static set draw_toolbar_buttons_rectangle(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']
        ['rectangle'] = value;
  }

  static set draw_toolbar_buttons_circle(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['circle'] = value;
  }

  static set draw_toolbar_buttons_marker(String value) {
    context['L']['drawLocal']['draw']['toolbar']['buttons']['marker'] = value;
  }

  static set draw_handlers_circle_tooltip_start(String value) {
    context['L']['drawLocal']['draw']['handlers']['circle']['tooltip']
        ['start'] = value;
  }

  static set draw_handlers_circle_radius(String value) {
    context['L']['drawLocal']['draw']['handlers']['circle']['radius'] = value;
  }

  static set draw_handlers_marker_tooltip_start(String value) {
    context['L']['drawLocal']['draw']['handlers']['marker']['tooltip']
        ['start'] = value;
  }

  static set draw_handlers_polygon_tooltip_start(String value) {
    context['L']['drawLocal']['draw']['handlers']['polygon']['tooltip']
        ['start'] = value;
  }

  static set draw_handlers_polygon_tooltip_cont(String value) {
    context['L']['drawLocal']['draw']['handlers']['polygon']['tooltip']
        ['cont'] = value;
  }

  static set draw_handlers_polygon_tooltip_end(String value) {
    context['L']['drawLocal']['draw']['handlers']['polygon']['tooltip']
        ['end'] = value;
  }

  static set draw_handlers_polyline_error(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['error'] = value;
  }

  static set draw_handlers_polyline_tooltip_start(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['tooltip']
        ['start'] = value;
  }

  static set draw_handlers_polyline_tooltip_cont(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['tooltip']
        ['cont'] = value;
  }

  static set draw_handlers_polyline_tooltip_end(String value) {
    context['L']['drawLocal']['draw']['handlers']['polyline']['tooltip']
        ['end'] = value;
  }

  static set draw_handlers_rectangle_tooltip_start(String value) {
    context['L']['drawLocal']['draw']['handlers']['rectangle']['tooltip']
        ['start'] = value;
  }

  static set draw_handlers_simpleshape_tooltip_end(String value) {
    context['L']['drawLocal']['draw']['handlers']['rectangle']['tooltip']
        ['end'] = value;
  }

  static set edit_toolbar_actions_save_title(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['save']
        ['title'] = value;
  }

  static set edit_toolbar_actions_save_text(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['save']
        ['text'] = value;
  }

  static set edit_toolbar_actions_cancel_title(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['cancel']
        ['title'] = value;
  }

  static set edit_toolbar_actions_cancel_text(String value) {
    context['L']['drawLocal']['edit']['toolbar']['actions']['cancel']
        ['text'] = value;
  }

  static set edit_toolbar_buttons_edit(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']['edit'] = value;
  }

  static set edit_toolbar_buttons_editDisabled(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']
        ['editDisabled'] = value;
  }

  static set edit_toolbar_buttons_remove(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']['remove'] = value;
  }

  static set edit_toolbar_buttons_removeDisabled(String value) {
    context['L']['drawLocal']['edit']['toolbar']['buttons']
        ['removeDisabled'] = value;
  }

  static set edit_handlers_edit_tooltip_text(String value) {
    context['L']['drawLocal']['edit']['handlers']['edit']['tooltip']
        ['text'] = value;
  }

  static set edit_handlers_edit_tooltip_subtext(String value) {
    context['L']['drawLocal']['edit']['handlers']['edit']['tooltip']
        ['subtext'] = value;
  }

  static set edit_handlers_remove_tooltip_text(String value) {
    context['L']['drawLocal']['edit']['handlers']['remove']['tooltip']
        ['text'] = value;
  }

  final JsObject control;

  factory Draw({String position, Map draw, Map edit}) {
    var config = {};
    if (position != null) config['position'] = position;
    if (draw != null) config['draw'] = draw;
    if (edit != null) {
      if (edit['featureGroup'] is FeatureGroup) {
        edit = new Map.from(edit);
        edit['featureGroup'] = edit['featureGroup'].layer;
      }
      config['edit'] = edit;
    }
    var _config = new JsObject.jsify(config);
    var control = new JsObject(context['L']['Control']['Draw'], [_config]);
    return new Draw._(control);
  }

  Draw._(this.control);

  void setDrawingOptions(Map draw) {
    var _draw = new JsObject.jsify(draw);
    control.callMethod('setDrawingOptions', [_draw]);
  }
}
