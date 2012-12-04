// Copyright (c) 2012, Alexandre Ardhuin
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library google_maps;

import 'dart:html' as html;
import 'package:js/js.dart' as js;
import 'optional.dart';
import 'js_wrap.dart' as jsw;

// utility to get js.Proxy even if out of scope
dynamic findIn(List elements, Object o) => elements.filter((e) => e == o).reduce(null, (previousValue, e) => (previousValue != null ? previousValue : e));

// js.Proxy for "google.maps"
final maps = js.retain(js.context.google.maps);

// start GMaps wrapping
class GMap extends MVCObject {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new GMap.fromJsProxy(jsProxy);
  static bool isInstance(js.Proxy jsProxy) => js.instanceof(jsProxy, maps.Map);

  /// Creates a new map inside of the given HTML container, which is typically a DIV element.
  GMap(html.Node mapDiv, [MapOptions opts]) : super.newInstance(maps.Map, [mapDiv, opts]);
  GMap.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  // js methods

  /// Sets the viewport to contain the given bounds.
  void fitBounds(LatLngBounds bounds) { $.fitBounds(bounds); }
  /// Returns the lat/lng bounds of the current viewport. If more than one copy of the world is visible, the bounds range in longitude from -180 to 180 degrees inclusive. If the map is not yet initialized (i.e. the mapType is still null), or center and zoom have not been set then the result is `null`.
  LatLngBounds get bounds => $.getBounds().map(LatLngBounds.INSTANCIATOR).value;
  /// Returns the position displayed at the center of the map. Note that this [LatLng] object is *not* wrapped. See [LatLng] for more information.
  LatLng get center => $.getCenter().map(LatLng.INSTANCIATOR).value;
  ///
  html.Node get div => $.getDiv().value;
  /// Returns the compass heading of aerial imagery. The heading value is measured in degrees (clockwise) from cardinal direction North.
  num get heading => $.getHeading().value;
  ///
  Object get mapTypeId {
    final result = $.getMapTypeId().value;
    final mapTypeId = MapTypeId.find(result);
    if ( mapTypeId != null ) {
      return mapTypeId;
    } else {
      return result;
    }
  }
  /// Returns the current [Projection]. If the map is not yet initialized (i.e. the mapType is still null) then the result is null. Listen to `projection_changed` and check its value to ensure it is not null.
  Projection get projection => $.getProjection().map(Projection.INSTANCIATOR).value;
  /// Returns the default [StreetViewPanorama] bound to the map, which may be a default panorama embedded within the map, or the panorama set using `setStreetView()`. Changes to the map's `streetViewControl` will be reflected in the display of such a bound panorama.
  StreetViewPanorama get streetView => $.getStreetView().map(StreetViewPanorama.INSTANCIATOR).value;
  /// Returns the angle of incidence for aerial imagery (available for `SATELLITE` and `HYBRID` map types) measured in degrees from the viewport plane to the map plane. A value of `0` indicates no angle of incidence (no tilt) while 45° imagery will return a value of `45`.
  num get tilt => $.getTilt().value;
  ///
  num get zoom => $.getZoom().value;
  /// Changes the center of the map by the given distance in pixels. If the distance is less than both the width and height of the map, the transition will be smoothly animated. Note that the map coordinate system increases from west to east (for x values) and north to south (for y values).
  void panBy(num x, num y) { $.panBy(x, y); }
  /// Changes the center of the map to the given [LatLng]. If the change is less than both the width and height of the map, the transition will be smoothly animated.
  void panTo(LatLng latLng) { $.panTo(latLng); }
  /// Pans the map by the minimum amount necessary to contain the given [LatLngBounds]. It makes no guarantee where on the map the bounds will be, except that as much of the bounds as possible will be visible. The bounds will be positioned inside the area bounded by the map type and navigation (pan, zoom, and Street View) controls, if they are present on the map. If the bounds is larger than the map, the map will be shifted to include the northwest corner of the bounds. If the change in the map's position is less than both the width and height of the map, the transition will be smoothly animated.
  void panToBounds(LatLngBounds latLngBounds) { $.panToBounds(latLngBounds); }
  /// 
  set center(LatLng latLng) => $.setCenter(latLng);
  /// Sets the compass heading for aerial imagery measured in degrees from cardinal direction North.
  set heading(num heading) => $.setHeading(heading);
  ///
  set mapTypeId(Object mapTypeId) {
    if (mapTypeId is String || mapTypeId is MapTypeId) {
      $.setMapTypeId(mapTypeId);
    } else {
      throw new UnsupportedError("Parameter must be of type String or MapTypeId");
    }
  }
  ///
  set options(MapOptions options) => $.setOptions(options);
  /// Binds a [StreetViewPanorama] to the map. This panorama overrides the default [StreetViewPanorama], allowing the map to bind to an external panorama outside of the map. Setting the panorama to null binds the default embedded panorama back to the map.
  set streetView(StreetViewPanorama panorama) => $.setStreetView(panorama);
  /// Sets the angle of incidence for aerial imagery (available for `SATELLITE` and `HYBRID` map types) measured in degrees from the viewport plane to the map plane. The only supported values are `0`, indicating no angle of incidence (no tilt), and `45` indicating a tilt of 45°.
  set tilt(num tilt) => $.setTilt(tilt);
  ///
  set zoom(num zoom) => $.setZoom(zoom);

  // js properties

  /// Additional controls to attach to the map. To add a control to the map, add the control's `<div>` to the [MVCArray] corresponding to the [ControlPosition] where it should be rendered.
  Controls get controls => $.controls.map(Controls.INSTANCIATOR).value;
  /// Additional controls to attach to the map. To add a control to the map, add the control's `<div>` to the [MVCArray] corresponding to the [ControlPosition] where it should be rendered.
  set controls(Controls controls) => $.controls = controls;
  /// A registry of [MapType] instances by string ID.
  MapTypeRegistry get mapTypes => $.mapTypes.map(MapTypeRegistry.INSTANCIATOR).value;
  /// A registry of [MapType] instances by string ID.
  set mapTypes(MapTypeRegistry mapTypes) => $.mapTypes = mapTypes;
  /// Additional map types to overlay.
  MVCArray<MapType> get overlayMapTypes => $.overlayMapTypes.map((js.Proxy jsProxy) => new MVCArray.fromJsProxy(jsProxy, (js.Proxy jsProxy) => new MapType.fromJsProxy(jsProxy))).value;
  /// Additional map types to overlay.
  set overlayMapTypes(MVCArray<MapType> overlayMapTypes) => $.overlayMapTypes = overlayMapTypes;

  // js events

  GMapEvents get on => new GMapEvents._(this);
}

class GMapEvents {
  /// This event is fired when the viewport bounds have changed.
  static final BOUNDS_CHANGED = "bounds_changed";
  /// This event is fired when the map center property changes.
  static final CENTER_CHANGED = "center_changed";
  /// This event is fired when the user clicks on the map (but not when they click on a marker or infowindow).
  static final CLICK = "click";
  /// This event is fired when the user double-clicks on the map. Note that the click event will also fire, right before this one.
  static final DBLCLICK = "dblclick";
  /// This event is repeatedly fired while the user drags the map.
  static final DRAG = "drag";
  /// This event is fired when the user stops dragging the map.
  static final DRAGEND = "dragend";
  /// This event is fired when the user starts dragging the map.
  static final DRAGSTART = "dragstart";
  /// This event is fired when the map heading property changes.
  static final HEADING_CHANGED = "heading_changed";
  /// This event is fired when the map becomes idle after panning or zooming.
  static final IDLE = "idle";
  /// This event is fired when the mapTypeId property changes.
  static final MAPTYPEID_CHANGED = "maptypeid_changed";
  /// This event is fired whenever the user's mouse moves over the map container.
  static final MOUSEMOVE = "mousemove";
  /// This event is fired when the user's mouse exits the map container.
  static final MOUSEOUT = "mouseout";
  /// This event is fired when the user's mouse enters the map container.
  static final MOUSEOVER = "mouseover";
  /// This event is fired when the projection has changed.
  static final PROJECTION_CHANGED = "projection_changed";
  /// Developers should trigger this event on the map when the div changes size: `google.maps.event.trigger(map, 'resize')`.
  static final RESIZE = "resize";
  /// This event is fired when the DOM contextmenu event is fired on the map container.
  static final RIGHTCLICK = "rightclick";
  /// This event is fired when the visible tiles have finished loading.
  static final TILESLOADED = "tilesloaded";
  /// This event is fired when the map tilt property changes.
  static final TILT_CHANGED = "tilt_changed";
  /// This event is fired when the map zoom property changes.
  static final ZOOM_CHANGED = "zoom_changed";
  
  final GMap _gmap;

  GMapEvents._(this._gmap);

  NoArgsEventListenerAdder get boundsChanged => new NoArgsEventListenerAdder(_gmap, BOUNDS_CHANGED);
  NoArgsEventListenerAdder get centerChanged => new NoArgsEventListenerAdder(_gmap, CENTER_CHANGED);
  MouseEventListenerAdder get click => new MouseEventListenerAdder(_gmap, CLICK);
  MouseEventListenerAdder get dblclick => new MouseEventListenerAdder(_gmap, DBLCLICK);
  NoArgsEventListenerAdder get drag => new NoArgsEventListenerAdder(_gmap, DRAG);
  NoArgsEventListenerAdder get dragend => new NoArgsEventListenerAdder(_gmap, DRAGEND);
  NoArgsEventListenerAdder get dragstart => new NoArgsEventListenerAdder(_gmap, DRAGSTART);
  NoArgsEventListenerAdder get headingChanged => new NoArgsEventListenerAdder(_gmap, HEADING_CHANGED);
  NoArgsEventListenerAdder get idle => new NoArgsEventListenerAdder(_gmap, IDLE);
  NoArgsEventListenerAdder get maptypeidChanged => new NoArgsEventListenerAdder(_gmap, MAPTYPEID_CHANGED);
  MouseEventListenerAdder get mousemove => new MouseEventListenerAdder(_gmap, MOUSEMOVE);
  MouseEventListenerAdder get mouseout => new MouseEventListenerAdder(_gmap, MOUSEOUT);
  MouseEventListenerAdder get mouseover => new MouseEventListenerAdder(_gmap, MOUSEOVER);
  NoArgsEventListenerAdder get projectionChanged => new NoArgsEventListenerAdder(_gmap, PROJECTION_CHANGED);
  NoArgsEventListenerAdder get resize => new NoArgsEventListenerAdder(_gmap, RESIZE);
  MouseEventListenerAdder get rightclick => new MouseEventListenerAdder(_gmap, RIGHTCLICK);
  NoArgsEventListenerAdder get tilesloaded => new NoArgsEventListenerAdder(_gmap, TILESLOADED);
  NoArgsEventListenerAdder get tiltChanged => new NoArgsEventListenerAdder(_gmap, TILT_CHANGED);
  NoArgsEventListenerAdder get zoomChanged => new NoArgsEventListenerAdder(_gmap, ZOOM_CHANGED);
}

class Controls extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new Controls.fromJsProxy(jsProxy);

  Controls() : super.fromJsProxy(js.array([]));
  Controls.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  MVCArray<html.Node> getNodes(ControlPosition controlPosition) => $[controlPosition.value].map((js.Proxy jsProxy) => new MVCArray.fromJsProxy(jsProxy)).value;
  void setNodes(ControlPosition controlPosition, MVCArray<html.Node> nodes) { $[controlPosition.value.toString()] = nodes; }
}

class MapOptions extends jsw.IsJsProxy {
  set backgroundColor(String backgroundColor) => $.backgroundColor = backgroundColor;
  set center(LatLng center) => $.center = center;
  set disableDefaultUI(bool disableDefaultUI) => $.disableDefaultUI = disableDefaultUI;
  set disableDoubleClickZoom(bool disableDoubleClickZoom) => $.disableDoubleClickZoom = disableDoubleClickZoom;
  set draggable(bool draggable) => $.draggable = draggable;
  set draggableCursor(String draggableCursor) => $.draggableCursor = draggableCursor;
  set draggingCursor(String draggingCursor) => $.draggingCursor = draggingCursor;
  set heading(num heading) => $.heading = heading;
  set keyboardShortcuts(bool keyboardShortcuts) => $.keyboardShortcuts = keyboardShortcuts;
  set mapMaker(bool mapMaker) => $.mapMaker = mapMaker;
  set mapTypeControl(bool mapTypeControl) => $.mapTypeControl = mapTypeControl;
  set mapTypeControlOptions(MapTypeControlOptions mapTypeControlOptions) => $.mapTypeControlOptions = mapTypeControlOptions;
  set mapTypeId(Object mapTypeId) {
    if (mapTypeId is String || mapTypeId is MapTypeId) {
      $.mapTypeId = mapTypeId;
    } else {
      throw new UnsupportedError("Parameter must be of type String or MapTypeId");
    }
  }
  set maxZoom(num maxZoom) => $.maxZoom = maxZoom;
  set minZoom(num minZoom) => $.minZoom = minZoom;
  set noClear(bool noClear) => $.noClear = noClear;
  set overviewMapControl(bool overviewMapControl) => $.overviewMapControl = overviewMapControl;
  set overviewMapControlOptions(OverviewMapControlOptions overviewMapControlOptions) => $.overviewMapControlOptions = overviewMapControlOptions;
  set panControl(bool panControl) => $.panControl = panControl;
  set panControlOptions(PanControlOptions panControlOptions) => $.panControlOptions = panControlOptions;
  set rotateControl(bool rotateControl) => $.rotateControl = rotateControl;
  set rotateControlOptions(RotateControlOptions rotateControlOptions) => $.rotateControlOptions = rotateControlOptions;
  set scaleControl(bool scaleControl) => $.scaleControl = scaleControl;
  set scaleControlOptions(ScaleControlOptions scaleControlOptions) => $.scaleControlOptions = scaleControlOptions;
  set scrollwheel(bool scrollwheel) => $.scrollwheel = scrollwheel;
  set streetView(StreetViewPanorama streetView) => $.streetView = streetView;
  set streetViewControl(bool streetViewControl) => $.streetViewControl = streetViewControl;
  set streetViewControlOptions(StreetViewControlOptions streetViewControlOptions) => $.streetViewControlOptions = streetViewControlOptions;
  set styles(List<MapTypeStyle> styles) => $.styles = styles;
  set tilt(num tilt) => $.tilt = tilt;
  set zoom(num zoom) => $.zoom = zoom;
  set zoomControl(bool zoomControl) => $.zoomControl = zoomControl;
  set zoomControlOptions(ZoomControlOptions zoomControlOptions) => $.zoomControlOptions = zoomControlOptions;
}

class MapTypeId extends jsw.IsEnum<String> {
  static final HYBRID = new MapTypeId._(maps.MapTypeId.HYBRID);
  static final ROADMAP = new MapTypeId._(maps.MapTypeId.ROADMAP);
  static final SATELLITE = new MapTypeId._(maps.MapTypeId.SATELLITE);
  static final TERRAIN = new MapTypeId._(maps.MapTypeId.TERRAIN);

  static final _INSTANCES = [HYBRID, ROADMAP, SATELLITE, TERRAIN];

  static MapTypeId find(Object o) => findIn(_INSTANCES, o);

  MapTypeId._(String value) : super(value);

  bool operator ==(Object other) => value == (other is MapTypeId ? (other as MapTypeId).value : other);
}

class MapTypeControlOptions extends jsw.IsJsProxy {
  set mapTypeIds(List<Object> mapTypeIds) {
    if (!mapTypeIds.filter((e) => !(e is String || e is MapTypeId)).isEmpty) {
      throw new UnsupportedError("Elements in list must be of type String or MapTypeId");
    }
    $.mapTypeIds = mapTypeIds;
  }
  set position(ControlPosition position) => $.position = position;
  set style(MapTypeControlStyle style) => $.style = style;
}

class MapTypeControlStyle extends jsw.IsEnum<int> {
  static final DEFAULT = new MapTypeControlStyle._(maps.MapTypeControlStyle.DEFAULT);
  static final DROPDOWN_MENU = new MapTypeControlStyle._(maps.MapTypeControlStyle.DROPDOWN_MENU);
  static final HORIZONTAL_BAR = new MapTypeControlStyle._(maps.MapTypeControlStyle.HORIZONTAL_BAR);

  static final _INSTANCES = [DEFAULT, DROPDOWN_MENU, HORIZONTAL_BAR];

  static MapTypeControlStyle find(Object o) => findIn(_INSTANCES, o);

  MapTypeControlStyle._(int value) : super(value);

  bool operator ==(Object other) => value == (other is MapTypeControlStyle ? (other as MapTypeControlStyle).value : other);
}

class OverviewMapControlOptions extends jsw.IsJsProxy {
  set opened(bool opened) => $.opened = opened;
}

class PanControlOptions extends jsw.IsJsProxy {
  set position(ControlPosition position) => $.position = position;
}

class RotateControlOptions extends jsw.IsJsProxy {
  set position(ControlPosition position) => $.position = position;
}

class ScaleControlOptions extends jsw.IsJsProxy {
  set position(ControlPosition position) => $.position = position;
  set style(ScaleControlStyle style) => $.style = style;
}

class ScaleControlStyle extends jsw.IsEnum<String> {
  static final DEFAULT = new ScaleControlStyle._(maps.ScaleControlStyle.DEFAULT);

  static final _INSTANCES = [DEFAULT];

  static ScaleControlStyle find(Object o) => findIn(_INSTANCES, o);

  ScaleControlStyle._(String value) : super(value);

  bool operator ==(Object other) => value == (other is ScaleControlStyle ? (other as ScaleControlStyle).value : other);
}

class StreetViewControlOptions extends jsw.IsJsProxy {
  set position(ControlPosition position) => $.position = position;
}

class ZoomControlOptions extends jsw.IsJsProxy {
  set position(ControlPosition position) => $.position = position;
  set style(ZoomControlStyle style) => $.style = style;
}

class ZoomControlStyle extends jsw.IsEnum<int> {
  static final DEFAULT = new ZoomControlStyle._(maps.ZoomControlStyle.DEFAULT);
  static final LARGE = new ZoomControlStyle._(maps.ZoomControlStyle.LARGE);
  static final SMALL = new ZoomControlStyle._(maps.ZoomControlStyle.SMALL);

  static final _INSTANCES = [DEFAULT, LARGE, SMALL];

  static ZoomControlStyle find(Object o) => findIn(_INSTANCES, o);

  ZoomControlStyle._(int value) : super(value);

  bool operator ==(Object other) => value == (other is ZoomControlStyle ? (other as ZoomControlStyle).value : other);
}

class ControlPosition extends jsw.IsEnum<int> {
  static final BOTTOM_CENTER = new ControlPosition._(maps.ControlPosition.BOTTOM_CENTER);
  static final BOTTOM_LEFT = new ControlPosition._(maps.ControlPosition.BOTTOM_LEFT);
  static final BOTTOM_RIGHT = new ControlPosition._(maps.ControlPosition.BOTTOM_RIGHT);
  static final LEFT_BOTTOM = new ControlPosition._(maps.ControlPosition.LEFT_BOTTOM);
  static final LEFT_CENTER = new ControlPosition._(maps.ControlPosition.LEFT_CENTER);
  static final LEFT_TOP = new ControlPosition._(maps.ControlPosition.LEFT_TOP);
  static final RIGHT_BOTTOM = new ControlPosition._(maps.ControlPosition.RIGHT_BOTTOM);
  static final RIGHT_CENTER = new ControlPosition._(maps.ControlPosition.RIGHT_CENTER);
  static final RIGHT_TOP = new ControlPosition._(maps.ControlPosition.RIGHT_TOP);
  static final TOP_CENTER = new ControlPosition._(maps.ControlPosition.TOP_CENTER);
  static final TOP_LEFT = new ControlPosition._(maps.ControlPosition.TOP_LEFT);
  static final TOP_RIGHT = new ControlPosition._(maps.ControlPosition.TOP_RIGHT);

  static final _INSTANCES = [BOTTOM_CENTER, BOTTOM_LEFT, BOTTOM_RIGHT, LEFT_BOTTOM, LEFT_CENTER, LEFT_TOP, RIGHT_BOTTOM, RIGHT_CENTER, RIGHT_TOP, TOP_CENTER, TOP_LEFT, TOP_RIGHT];

  static ControlPosition find(Object o) => findIn(_INSTANCES, o);

  ControlPosition._(int value) : super(value);

  bool operator ==(Object other) => value == (other is ControlPosition ? (other as ControlPosition).value : other);
}

class Marker extends MVCObject {
  static final num MAX_ZINDEX = maps.Marker.MAX_ZINDEX;
  static bool isInstance(js.Proxy jsProxy) => js.instanceof(jsProxy, maps.Marker);

  Marker([MarkerOptions opts]) : super.newInstance(maps.Marker, [opts]);
  Marker.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  // js methods

  Animation get animation => $.getAnimation().map(Animation.find).value;
  bool get clickable => $.getClickable().value;
  String get cursor => $.getCursor().value;
  bool get draggable => $.getDraggable().value;
  bool get flat => $.getFlat().value;
  Object get icon {
    final result = $.getIcon().value;
    if (result == null) {
      return result;
    } else if (result is String) {
      return result;
    } else if (result is js.Proxy) {
      return new MarkerImage.fromJsProxy(result);
    } else {
      throw new Exception("Unsupported result");
    }
  }
  Object get map {
    final result = $.getMap().value;
    if (result == null) {
      return result;
    } else if (GMap.isInstance(result)) {
      return new GMap.fromJsProxy(result);
    } else if (StreetViewPanorama.isInstance(result)) {
      return new StreetViewPanorama.fromJsProxy(result);
    } else {
      throw new Exception("Unsupported result");
    }
  }
  LatLng get position => $.getPosition().map(LatLng.INSTANCIATOR).value;
  Object get shadow {
    final result = $.getShadow().value;
    if (result == null) {
      return result;
    } else if (result is String) {
      return result;
    } else if (result is js.Proxy) {
      return new MarkerImage.fromJsProxy(result);
    } else {
      throw new Exception("Unsupported result");
    }
  }
  MarkerShape get shape => $.getShape().map(MarkerShape.INSTANCIATOR).value;
  String get title => $.getTitle().value;
  bool get visible => $.getVisible().value;
  num get zIndex => $.getZIndex().value;
  set animation(Animation animation) => $.setAnimation(animation);
  set clickable(bool clickable) => $.setClickable(clickable);
  set cursor(String cursor) => $.setCursor(cursor);
  set draggable(bool draggable) => $.setDraggable(draggable);
  set flat(bool flag) => $.setFlat(flag);
  set icon(Object icon) {
    if (icon == null || icon is String || icon is MarkerImage) {
      $.setIcon(icon);
    } else {
      throw new UnsupportedError("Parameter must be of type String or MarkerImage");
    }
  }
  set map(Object map) {
    if (map == null || map is GMap || map is StreetViewPanorama) {
      $.setMap(map);
    } else {
      throw new UnsupportedError("Parameter must be of type GMap or StreetViewPanorama");
    }
  }
  set options(MarkerOptions options) => $.setOptions(options);
  set position(LatLng latlng) => $.setPosition(latlng);
  set shadow(Object shadow) {
    if (shadow is String || shadow is MarkerImage) {
      $.setShadow(shadow);
    } else {
      throw new UnsupportedError("Parameter must be of type String or MarkerImage");
    }
  }
  set title(String title) => $.setTitle(title);
  set visible(bool visible) => $.setVisible(visible);
  set zIndex(num zIndex) => $.setZIndex(zIndex);

  // js events

  MarkerEvents get on => new MarkerEvents._(this);
}

class MarkerEvents {
  static final ANIMATION_CHANGED = "animation_changed";
  static final CLICK = "click";
  static final CLICKABLE_CHANGED = "clickable_changed";
  static final CURSOR_CHANGED = "cursor_changed";
  static final DBLCLICK = "dblclick";
  static final DRAG = "drag";
  static final DRAGEND = "dragend";
  static final DRAGGABLE_CHANGED = "draggable_changed";
  static final DRAGSTART = "dragstart";
  static final FLAT_CHANGED = "flat_changed";
  static final ICON_CHANGED = "icon_changed";
  static final MOUSEDOWN = "mousedown";
  static final MOUSEOUT = "mouseout";
  static final MOUSEOVER = "mouseover";
  static final MOUSEUP = "mouseup";
  static final POSITION_CHANGED = "position_changed";
  static final RIGHTCLICK = "rightclick";
  static final SHADOW_CHANGED = "shadow_changed";
  static final SHAPE_CHANGED = "shape_changed";
  static final TITLE_CHANGED = "title_changed";
  static final VISIBLE_CHANGED = "visible_changed";
  static final ZINDEX_CHANGED = "zindex_changed";
  
  final Marker _marker;

  MarkerEvents._(this._marker);

  NoArgsEventListenerAdder get animationChanged => new NoArgsEventListenerAdder(_marker, ANIMATION_CHANGED);
  MouseEventListenerAdder get click => new MouseEventListenerAdder(_marker, CLICK);
  NoArgsEventListenerAdder get clickableChanged => new NoArgsEventListenerAdder(_marker, CLICKABLE_CHANGED);
  NoArgsEventListenerAdder get cursorChanged => new NoArgsEventListenerAdder(_marker, CURSOR_CHANGED);
  MouseEventListenerAdder get dblclick => new MouseEventListenerAdder(_marker, DBLCLICK);
  MouseEventListenerAdder get drag => new MouseEventListenerAdder(_marker, DRAG);
  MouseEventListenerAdder get dragend => new MouseEventListenerAdder(_marker, DRAGEND);
  NoArgsEventListenerAdder get draggableChanged => new NoArgsEventListenerAdder(_marker, DRAGGABLE_CHANGED);
  MouseEventListenerAdder get dragstart => new MouseEventListenerAdder(_marker, DRAGSTART);
  NoArgsEventListenerAdder get flatChanged => new NoArgsEventListenerAdder(_marker, FLAT_CHANGED);
  NoArgsEventListenerAdder get iconChanged => new NoArgsEventListenerAdder(_marker, ICON_CHANGED);
  MouseEventListenerAdder get mousedown => new MouseEventListenerAdder(_marker, MOUSEDOWN);
  MouseEventListenerAdder get mouseout => new MouseEventListenerAdder(_marker, MOUSEOUT);
  MouseEventListenerAdder get mouseover => new MouseEventListenerAdder(_marker, MOUSEOVER);
  MouseEventListenerAdder get mouseup => new MouseEventListenerAdder(_marker, MOUSEUP);
  NoArgsEventListenerAdder get positionChanged => new NoArgsEventListenerAdder(_marker, POSITION_CHANGED);
  MouseEventListenerAdder get rightclick => new MouseEventListenerAdder(_marker, RIGHTCLICK);
  NoArgsEventListenerAdder get shadowChanged => new NoArgsEventListenerAdder(_marker, SHADOW_CHANGED);
  NoArgsEventListenerAdder get shapeChanged => new NoArgsEventListenerAdder(_marker, SHAPE_CHANGED);
  NoArgsEventListenerAdder get titleChanged => new NoArgsEventListenerAdder(_marker, TITLE_CHANGED);
  NoArgsEventListenerAdder get visibleChanged => new NoArgsEventListenerAdder(_marker, VISIBLE_CHANGED);
  NoArgsEventListenerAdder get zindexChanged => new NoArgsEventListenerAdder(_marker, ZINDEX_CHANGED);
}


class MarkerOptions extends jsw.IsJsProxy {
  set animation(Animation animation) => $.animation = animation;
  set clickable(bool clickable) => $.clickable = clickable;
  set cursor(String cursor) => $.cursor = cursor;
  set draggable(bool draggable) => $.draggable = draggable;
  set flat(bool flat) => $.flat = flat;
  set icon(Object icon) {
    if (icon is String || icon is MarkerImage || icon is Symbol) {
      $.icon = icon;
    } else {
      throw new UnsupportedError("Parameter must be of type String, MarkerImage or Symbol");
    }
  }
  set map(Object map) {
    if (map is GMap || map is StreetViewPanorama) {
      $.map = map;
    } else {
      throw new UnsupportedError("Parameter must be of type GMap or StreetViewPanorama");
    }
  }
  set optimized(bool optimized) => $.optimized = optimized;
  set position(LatLng position) => $.position = position;
  set raiseOnDrag(bool raiseOnDrag) => $.raiseOnDrag = raiseOnDrag;
  set shadow(Object shadow) {
    if (shadow is String || shadow is MarkerImage || shadow is Symbol) {
      $.shadow = shadow;
    } else {
      throw new UnsupportedError("Parameter must be of type String, MarkerImage or Symbol");
    }
  }
  set shape(MarkerShape shape) => $.shape = shape;
  set title(String title) => $.title = title;
  set visible(bool visible) => $.visible = visible;
  set zIndex(num zIndex) => $.zIndex = zIndex;
}

class MarkerImage extends jsw.IsJsProxy {
  MarkerImage(String url, [Size size, Point origin, Point anchor, Size scaledSize]) : super.newInstance(maps.MarkerImage, [url, size, origin, anchor, scaledSize]);
  MarkerImage.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  Point get anchor => $.anchor.map(Point.INSTANCIATOR).value;
  set anchor(Point anchor) => $.anchor = anchor;
  Point get origin => $.origin.map(Point.INSTANCIATOR).value;
  set origin(Point origin) => $.origin = origin;
  Size get scaledSize => $.scaledSize.map(Size.INSTANCIATOR).value;
  set scaledSize(Size scaledSize) => $.scaledSize = scaledSize;
  Size get size => $.size.map(Size.INSTANCIATOR).value;
  set size(Size size) => $.size = size;
  String get url => $.url.value;
  set url(String url) => $.url = url;
}

class MarkerShape extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new MarkerShape.fromJsProxy(jsProxy);

  MarkerShape() : super();
  MarkerShape.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  List<num> get coords => $.coords.map((js.Proxy jsProxy) => new jsw.JsList<num>.fromJsProxy(jsProxy, null)).value;
  set coords(List<num> coords) => $.coords = coords;
  MarkerShapeType get type => MarkerShapeType.find($.type.value);
  set type(MarkerShapeType type) => $.type = type.value;
}

class MarkerShapeType extends jsw.IsEnum<String> {
  static final CIRCLE = new MarkerShapeType._("circle");
  static final POLY = new MarkerShapeType._("poly");
  static final RECT = new MarkerShapeType._("rect");

  static final _INSTANCES = [CIRCLE, POLY, RECT];

  static MarkerShapeType find(Object o) => findIn(_INSTANCES, o);

  MarkerShapeType._(String value) : super(value);

  bool operator ==(Object other) => value == (other is MarkerShapeType ? (other as MarkerShapeType).value : other);
}

class Symbol extends jsw.IsJsProxy {
  Point get anchor => $.anchor.map(Point.INSTANCIATOR).value;
  set anchor(Point anchor) => $.anchor = anchor;
  String get fillColor => $.fillColor.value;
  set fillColor(String fillColor) => $.fillColor = fillColor;
  num get fillOpacity => $.fillOpacity.value;
  set fillOpacity(num fillOpacity) => $.fillOpacity = fillOpacity;
  Object get path {
    final result = $.path.value;
    if (result is String) {
      return result;
    } else if (result is js.Proxy) {
      return SymbolPath.find(result);
    } else {
      throw new Exception("Unsupported result");
    }
  }
  set path(Object path) {
    if (path is String || path is SymbolPath) {
      $.path = path;
    } else {
      throw new UnsupportedError("Parameter must be of type String or SymbolPath");
    }
  }
  num get rotation => $.rotation.value;
  set rotation(num rotation) => $.rotation = rotation;
  num get scale => $.scale.value;
  set scale(num scale) => $.scale = scale;
  String get strokeColor => $.strokeColor.value;
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  num get strokeOpacity => $.strokeOpacity.value;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  num get strokeWeight => $.strokeWeight.value;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
}

class SymbolPath extends jsw.IsEnum<int> {
  static final BACKWARD_CLOSED_ARROW = new SymbolPath._(maps.SymbolPath.BACKWARD_CLOSED_ARROW);
  static final BACKWARD_OPEN_ARROW = new SymbolPath._(maps.SymbolPath.BACKWARD_OPEN_ARROW);
  static final CIRCLE = new SymbolPath._(maps.SymbolPath.CIRCLE);
  static final FORWARD_CLOSED_ARROW = new SymbolPath._(maps.SymbolPath.FORWARD_CLOSED_ARROW);
  static final FORWARD_OPEN_ARROW = new SymbolPath._(maps.SymbolPath.FORWARD_OPEN_ARROW);

  static final _INSTANCES = [BACKWARD_CLOSED_ARROW, BACKWARD_OPEN_ARROW, CIRCLE, FORWARD_CLOSED_ARROW, FORWARD_OPEN_ARROW];

  static SymbolPath find(Object o) => findIn(_INSTANCES, o);

  SymbolPath._(int value) : super(value);

  bool operator ==(Object other) => value == (other is SymbolPath ? (other as SymbolPath).value : other);
}

class Animation extends jsw.IsEnum<int> {
  static final BOUNCE = new Animation._(maps.Animation.BOUNCE);
  static final DROP = new Animation._(maps.Animation.DROP);

  static final _INSTANCES = [BOUNCE, DROP];

  static Animation find(Object o) => findIn(_INSTANCES, o);

  Animation._(int value) : super(value);

  bool operator ==(Object other) => value == (other is Animation ? (other as Animation).value : other);
}

class InfoWindow extends MVCObject {
  InfoWindow([InfoWindowOptions opts]) : super.newInstance(maps.InfoWindow, [opts]);
  InfoWindow.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  void close() { $.close(); }
  Object get content {
    final result = $.getContent().value;
    if (result is String || result is html.Node) {
      return result;
    } else {
      throw new Exception("Unsupported result");
    }
  }
  LatLng get position => $.getPosition().map(LatLng.INSTANCIATOR).value;
  num get zIndex => $.getZIndex().value;
  void open([Object map, MVCObject anchor]) {
    if (map is GMap || map is StreetViewPanorama) {
      $.open(map, anchor);
    } else {
      throw new UnsupportedError("Parameter must be of type GMap or StreetViewPanorama");
    }
  }
  set content(Object content) {
    if (content is String || content is html.Node) {
      $.setContent(content);
    } else {
      throw new UnsupportedError("Parameter must be of type String or Node");
    }
  }
  set options(InfoWindowOptions options) => $.setOptions(options);
  set position(LatLng position) => $.setPosition(position);
  set zIndex(num zIndex) => $.setZIndex(zIndex);

  InfoWindowEvents get on => new InfoWindowEvents._(this);
}

class InfoWindowEvents {
  static final CLOSECLICK = "closeclick";
  static final CONTENT_CHANGED = "content_changed";
  static final DOMREADY = "domready";
  static final POSITION_CHANGED = "position_changed";
  static final ZINDEX_CHANGED = "zindex_changed";
  
  final InfoWindow _infoWindow;

  InfoWindowEvents._(this._infoWindow);

  NoArgsEventListenerAdder get closeclick => new NoArgsEventListenerAdder(_infoWindow, CLOSECLICK);
  NoArgsEventListenerAdder get contentChanged => new NoArgsEventListenerAdder(_infoWindow, CONTENT_CHANGED);
  NoArgsEventListenerAdder get domready => new NoArgsEventListenerAdder(_infoWindow, DOMREADY);
  NoArgsEventListenerAdder get positionChanged => new NoArgsEventListenerAdder(_infoWindow, POSITION_CHANGED);
  NoArgsEventListenerAdder get zindexChanged => new NoArgsEventListenerAdder(_infoWindow, ZINDEX_CHANGED);
}

class InfoWindowOptions extends jsw.IsJsProxy {
  set content(Object content) {
    if (content is String || content is html.Node) {
      $.content = content;
    } else {
      throw new UnsupportedError("Parameter must be of type String or Node");
    }
  }
  bool get disableAutoPan => $.disableAutoPan.value;
  set disableAutoPan(bool disableAutoPan) => $.disableAutoPan = disableAutoPan;
  num get maxWidth => $.maxWidth.value;
  set maxWidth(num maxWidth) => $.maxWidth = maxWidth;
  Size get pixelOffset => $.pixelOffset.map(Size.INSTANCIATOR).value;
  set pixelOffset(Size pixelOffset) => $.pixelOffset = pixelOffset;
  LatLng get position => $.position.map(LatLng.INSTANCIATOR).value;
  set position(LatLng position) => $.position = position;
  num get zIndex => $.zIndex.value;
  set zIndex(num zIndex) => $.zIndex = zIndex;
}

class Polyline extends MVCObject {
  static bool isInstance(js.Proxy jsProxy) => js.instanceof(jsProxy, maps.Polyline);

  Polyline([PolylineOptions opts]) : super.newInstance(maps.Polyline, [opts]);
  Polyline.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  bool get editable=> $.getEditable().value;
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  MVCArray<LatLng> get path => $.getPath().map((js.Proxy jsProxy) => new MVCArray.fromJsProxy(jsProxy, (js.Proxy jsProxy) => new LatLng.fromJsProxy(jsProxy))).value;
  bool get visible => $.getVisible().value;
  set editable(bool editable) => $.setEditable(editable);
  set map(GMap map) => $.setMap(map);
  set options(PolylineOptions options) => $.setOptions(options);
  set path(Object path) {
    if (path is MVCArray<LatLng> || path is List<LatLng>) {
      $.setPath(path);
    } else {
      throw new UnsupportedError("Parameter must be of type MVCArray<LatLng> or List<LatLng>");
    }
  }
  set visible(bool visible) => $.setVisible(visible);

  PolylineEvents get on => new PolylineEvents._(this);
}

class PolylineEvents {
  static final CLICK = "click";
  static final DBLCLICK = "dblclick";
  static final MOUSEDOWN = "mousedown";
  static final MOUSEMOVE = "mousemove";
  static final MOUSEOUT = "mouseout";
  static final MOUSEOVER = "mouseover";
  static final MOUSEUP = "mouseup";
  static final RIGHTCLICK = "rightclick";
  
  final Polyline _polyline;

  PolylineEvents._(this._polyline);

  PolyMouseEventListenerAdder get click => new PolyMouseEventListenerAdder(_polyline, CLICK);
  PolyMouseEventListenerAdder get dblclick => new PolyMouseEventListenerAdder(_polyline, DBLCLICK);
  PolyMouseEventListenerAdder get mousedown => new PolyMouseEventListenerAdder(_polyline, MOUSEDOWN);
  PolyMouseEventListenerAdder get mousemove => new PolyMouseEventListenerAdder(_polyline, MOUSEMOVE);
  PolyMouseEventListenerAdder get mouseout => new PolyMouseEventListenerAdder(_polyline, MOUSEOUT);
  PolyMouseEventListenerAdder get mouseover => new PolyMouseEventListenerAdder(_polyline, MOUSEOVER);
  PolyMouseEventListenerAdder get mouseup => new PolyMouseEventListenerAdder(_polyline, MOUSEUP);
  PolyMouseEventListenerAdder get rightclick => new PolyMouseEventListenerAdder(_polyline, RIGHTCLICK);
}

class PolylineOptions extends jsw.IsJsProxy {
  set clickable(bool clickable) => $.clickable = clickable;
  set editable(bool editable) => $.editable = editable;
  set geodesic(bool geodesic) => $.geodesic = geodesic;
  set icons(List<IconSequence> icons) => $.icons = icons;
  set map(GMap map) => $.map = map;
  set path(Object path) {
    if (path is MVCArray<LatLng> || path is List<LatLng>) {
      $.path = path;
    } else {
      throw new UnsupportedError("Parameter must be of type MVCArray<LatLng> or List<LatLng>");
    }
  }
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
  set visible(bool visible) => $.visible = visible;
  set zIndex(num zIndex) => $.zIndex = zIndex;
}

class IconSequence extends jsw.IsJsProxy {
  IconSequence() : super();
  IconSequence.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  set icon(Symbol icon) => $.icon = icon;
  set offset(String offset) => $.offset = offset;
  set repeat(String repeat) => $.repeat = repeat;
}

class Polygon extends MVCObject {
  static bool isInstance(js.Proxy jsProxy) => js.instanceof(jsProxy, maps.Polygon);

  Polygon([PolygonOptions opts]) : super.newInstance(maps.Polygon, [opts]);
  Polygon.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  bool get editable => $.getEditable().value;
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  MVCArray<LatLng> get path => $.getPath().map((js.Proxy jsProxy) => new MVCArray.fromJsProxy(jsProxy, (js.Proxy jsProxy) => new LatLng.fromJsProxy(jsProxy))).value;
  MVCArray<MVCArray<LatLng>> get paths => $.getPaths().map((js.Proxy jsProxy) => new MVCArray.fromJsProxy(jsProxy, (js.Proxy jsProxy) => new MVCArray.fromJsProxy(jsProxy, (js.Proxy jsProxy) => new LatLng.fromJsProxy(jsProxy)))).value;
  bool get visible => $.getVisible().value;
  set editable(bool editable) => $.setEditable(editable);
  set map(GMap map) => $.setMap(map);
  set options(PolylineOptions options) => $.setOptions(options);
  set path(Object path) {
    if (path is MVCArray<LatLng> || path is List<LatLng>) {
      $.setPath(path);
    } else {
      throw new UnsupportedError("Parameter must be of type MVCArray<LatLng> or List<LatLng>");
    }
  }
  set paths(Object paths) {
    if (paths is MVCArray<MVCArray<LatLng>> || paths is MVCArray<LatLng> || paths is List<List<LatLng>> || paths is List<LatLng>) {
      $.setPaths(paths);
    } else {
      throw new UnsupportedError("Parameter must be of type MVCArray<MVCArray<LatLng>>, MVCArray<LatLng>, List<List<LatLng>> or List<LatLng>");
    }
  }
  set visible(bool visible) => $.setVisible(visible);

  PolygonEvents get on => new PolygonEvents._(this);
}

class PolygonEvents {
  static final CLICK = "click";
  static final DBLCLICK = "dblclick";
  static final MOUSEDOWN = "mousedown";
  static final MOUSEMOVE = "mousemove";
  static final MOUSEOUT = "mouseout";
  static final MOUSEOVER = "mouseover";
  static final MOUSEUP = "mouseup";
  static final RIGHTCLICK = "rightclick";
  
  final Polygon _polygon;

  PolygonEvents._(this._polygon);

  PolyMouseEventListenerAdder get click => new PolyMouseEventListenerAdder(_polygon, CLICK);
  PolyMouseEventListenerAdder get dblclick => new PolyMouseEventListenerAdder(_polygon, DBLCLICK);
  PolyMouseEventListenerAdder get mousedown => new PolyMouseEventListenerAdder(_polygon, MOUSEDOWN);
  PolyMouseEventListenerAdder get mousemove => new PolyMouseEventListenerAdder(_polygon, MOUSEMOVE);
  PolyMouseEventListenerAdder get mouseout => new PolyMouseEventListenerAdder(_polygon, MOUSEOUT);
  PolyMouseEventListenerAdder get mouseover => new PolyMouseEventListenerAdder(_polygon, MOUSEOVER);
  PolyMouseEventListenerAdder get mouseup => new PolyMouseEventListenerAdder(_polygon, MOUSEUP);
  PolyMouseEventListenerAdder get rightclick => new PolyMouseEventListenerAdder(_polygon, RIGHTCLICK);
}

class PolygonOptions extends jsw.IsJsProxy {
  set clickable(bool clickable) => $.clickable = clickable;
  set editable(bool editable) => $.editable = editable;
  set fillColor(String fillColor) => $.fillColor = fillColor;
  set fillOpacity(num fillOpacity) => $.fillOpacity = fillOpacity;
  set geodesic(bool geodesic) => $.geodesic = geodesic;
  set map(GMap map) => $.map = map;
  set paths(Object paths) {
    if (paths is MVCArray<MVCArray<LatLng>> || paths is MVCArray<LatLng> || paths is List<List<LatLng>> || paths is List<LatLng>) {
      $.paths = paths;
    } else {
      throw new UnsupportedError("Parameter must be of type MVCArray<MVCArray<LatLng>>, MVCArray<LatLng>, List<List<LatLng>> or List<LatLng>");
    }
  }
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
  set visible(bool visible) => $.visible = visible;
  set zIndex(num zIndex) => $.zIndex = zIndex;
}

class PolyMouseEvent extends MouseEvent {
  PolyMouseEvent.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  num get edge => $.edge.value;
  num get path => $.path.value;
  num get vertex => $.vertex.value;
}

class Rectangle extends MVCObject {
  static bool isInstance(js.Proxy jsProxy) => js.instanceof(jsProxy, maps.Rectangle);

  Rectangle([RectangleOptions opts]) : super.newInstance(maps.Rectangle, [opts]);
  Rectangle.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLngBounds get bounds => $.getBounds().map(LatLngBounds.INSTANCIATOR).value;
  bool get editable => $.getEditable().value;
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  bool get visible => $.getVisible().value;
  set bounds(LatLngBounds bounds) => $.setBounds(bounds);
  set editable(bool editable) => $.setEditable(editable);
  set map(GMap map) => $.setMap(map);
  set options(RectangleOptions options) => $.setOptions(options);
  set visible(bool visible) => $.setVisible(visible);

  RectangleEvents get on => new RectangleEvents._(this);
}

class RectangleEvents {
  static final BOUNDS_CHANGED = "bounds_changed";
  static final CLICK = "click";
  static final DBLCLICK = "dblclick";
  static final MOUSEDOWN = "mousedown";
  static final MOUSEMOVE = "mousemove";
  static final MOUSEOUT = "mouseout";
  static final MOUSEOVER = "mouseover";
  static final MOUSEUP = "mouseup";
  static final RIGHTCLICK = "rightclick";
  
  final Rectangle _rectangle;

  RectangleEvents._(this._rectangle);

  NoArgsEventListenerAdder get boundsChanged => new NoArgsEventListenerAdder(_rectangle, BOUNDS_CHANGED);
  MouseEventListenerAdder get click => new MouseEventListenerAdder(_rectangle, CLICK);
  MouseEventListenerAdder get dblclick => new MouseEventListenerAdder(_rectangle, DBLCLICK);
  MouseEventListenerAdder get mousedown => new MouseEventListenerAdder(_rectangle, MOUSEDOWN);
  MouseEventListenerAdder get mousemove => new MouseEventListenerAdder(_rectangle, MOUSEMOVE);
  MouseEventListenerAdder get mouseout => new MouseEventListenerAdder(_rectangle, MOUSEOUT);
  MouseEventListenerAdder get mouseover => new MouseEventListenerAdder(_rectangle, MOUSEOVER);
  MouseEventListenerAdder get mouseup => new MouseEventListenerAdder(_rectangle, MOUSEUP);
  MouseEventListenerAdder get rightclick => new MouseEventListenerAdder(_rectangle, RIGHTCLICK);
}

class RectangleOptions extends jsw.IsJsProxy {
  set bounds(LatLngBounds bounds) => $.bounds = bounds;
  set clickable(bool clickable) => $.clickable = clickable;
  set editable(bool editable) => $.editable = editable;
  set fillColor(String fillColor) => $.fillColor = fillColor;
  set fillOpacity(num fillOpacity) => $.fillOpacity = fillOpacity;
  set map(GMap map) => $.map = map;
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
  set visible(bool visible) => $.visible = visible;
  set zIndex(num zIndex) => $.zIndex = zIndex;
}

class Circle extends MVCObject {
  static bool isInstance(js.Proxy jsProxy) => js.instanceof(jsProxy, maps.Circle);

  Circle([CircleOptions opts]) : super.newInstance(maps.Circle, [opts]);
  Circle.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLngBounds get bounds => $.getBounds().map(LatLngBounds.INSTANCIATOR).value;
  LatLng get center => $.getCenter().map(LatLng.INSTANCIATOR).value;
  bool get editable => $.getEditable().value;
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  num get radius => $.getRadius().value;
  bool get visible => $.getVisible().value;
  set center(LatLng center) => $.setCenter(center);
  set editable(bool editable) => $.setEditable(editable);
  set map(GMap map) => $.setMap(map);
  set options(CircleOptions options) => $.setOptions(options);
  set radius(num radius) => $.setRadius(radius);
  set visible(bool visible) => $.setVisible(visible);

  CircleEvents get on => new CircleEvents._(this);
}

class CircleEvents {
  static final CENTER_CHANGED = "center_changed";
  static final CLICK = "click";
  static final DBLCLICK = "dblclick";
  static final MOUSEDOWN = "mousedown";
  static final MOUSEMOVE = "mousemove";
  static final MOUSEOUT = "mouseout";
  static final MOUSEOVER = "mouseover";
  static final MOUSEUP = "mouseup";
  static final RADIUS_CHANGED = "radius_changed";
  static final RIGHTCLICK = "rightclick";
  
  final Circle _circle;

  CircleEvents._(this._circle);

  NoArgsEventListenerAdder get centerChanged => new NoArgsEventListenerAdder(_circle, CENTER_CHANGED);
  MouseEventListenerAdder get click => new MouseEventListenerAdder(_circle, CLICK);
  MouseEventListenerAdder get dblclick => new MouseEventListenerAdder(_circle, DBLCLICK);
  MouseEventListenerAdder get mousedown => new MouseEventListenerAdder(_circle, MOUSEDOWN);
  MouseEventListenerAdder get mousemove => new MouseEventListenerAdder(_circle, MOUSEMOVE);
  MouseEventListenerAdder get mouseout => new MouseEventListenerAdder(_circle, MOUSEOUT);
  MouseEventListenerAdder get mouseover => new MouseEventListenerAdder(_circle, MOUSEOVER);
  MouseEventListenerAdder get mouseup => new MouseEventListenerAdder(_circle, MOUSEUP);
  NoArgsEventListenerAdder get radiusChanged => new NoArgsEventListenerAdder(_circle, RADIUS_CHANGED);
  MouseEventListenerAdder get rightclick => new MouseEventListenerAdder(_circle, RIGHTCLICK);
}

class CircleOptions extends jsw.IsJsProxy {
  set center(LatLng center) => $.center = center;
  set clickable(bool clickable) => $.clickable = clickable;
  set editable(bool editable) => $.editable = editable;
  set fillColor(String fillColor) => $.fillColor = fillColor;
  set fillOpacity(num fillOpacity) => $.fillOpacity = fillOpacity;
  set map(GMap map) => $.map = map;
  set radius(num radius) => $.radius = radius;
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
  set visible(bool visible) => $.visible = visible;
  set zIndex(num zIndex) => $.zIndex = zIndex;
}

class GroundOverlay extends MVCObject {
  GroundOverlay(String url, LatLngBounds bounds, [GroundOverlayOptions opts]) : super.newInstance(maps.GroundOverlay, [url, bounds, opts]);
  GroundOverlay.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLngBounds get bounds => $.getBounds().map(LatLngBounds.INSTANCIATOR).value;
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  num get opacity => $.getOpacity().value;
  String get url => $.getUrl().value;
  set map(GMap map) => $.setMap(map);
  set opacity(num opacity) => $.setOpacity(opacity);

  GroundOverlayEvents get on => new GroundOverlayEvents._(this);
}

class GroundOverlayEvents {
  static final CLICK = "click";
  static final DBLCLICK = "dblclick";
  
  final GroundOverlay _groundOverlay;

  GroundOverlayEvents._(this._groundOverlay);

  MouseEventListenerAdder get click => new MouseEventListenerAdder(_groundOverlay, CLICK);
  MouseEventListenerAdder get dblclick => new MouseEventListenerAdder(_groundOverlay, DBLCLICK);
}

class GroundOverlayOptions extends jsw.IsJsProxy {
  set clickable(bool clickable) => $.clickable = clickable;
  set map(GMap map) => $.map = map;
  set opacity(num opacity) => $.opacity = opacity;
}

class OverlayView extends MVCObject {
  OverlayView() : super.newInstance(maps.OverlayView);
  OverlayView.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  void draw() { $.draw(); }
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  MapPanes get panes => $.getPanes().map(MapPanes.INSTANCIATOR).value;
  MapCanvasProjection get projection => $.getProjection().map(MapCanvasProjection.INSTANCIATOR).value;
  void onAdd() { $.onAdd(); }
  void onRemove() { $.onRemove(); }
  set map(Object map) {
    if (map == null || map is GMap || map is StreetViewPanorama) {
      $.setMap(map);
    } else {
      throw new UnsupportedError("Parameter must be of type GMap or StreetViewPanorama");
    }
  }

  void set_onAdd(onAdd()) { $.onAdd = new jsw.Callback.many(onAdd); }
  void set_onRemove(onRemove()) { $.onRemove = new jsw.Callback.many(onRemove); }
  void set_draw(draw()) { $.draw = new jsw.Callback.many(draw); }
}

class MapPanes extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new MapPanes.fromJsProxy(jsProxy);

  MapPanes.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  html.Node get floatPane => $.floatPane.value;
  set floatPane(html.Node floatPane) => $.floatPane = floatPane;
  html.Node get floatShadow => $.floatShadow.value;
  set floatShadow(html.Node floatShadow) => $.floatShadow = floatShadow;
  html.Node get mapPane => $.mapPane.value;
  set mapPane(html.Node mapPane) => $.mapPane = mapPane;
  html.Node get overlayImage => $.overlayImage.value;
  set overlayImage(html.Node overlayImage) => $.overlayImage = overlayImage;
  html.Node get overlayLayer => $.overlayLayer.value;
  set overlayLayer(html.Node overlayLayer) => $.overlayLayer = overlayLayer;
  html.Node get overlayMouseTarget => $.overlayMouseTarget.value;
  set overlayMouseTarget(html.Node overlayMouseTarget) => $.overlayMouseTarget = overlayMouseTarget;
  html.Node get overlayShadow => $.overlayShadow.value;
  set overlayShadow(html.Node overlayShadow) => $.overlayShadow = overlayShadow;
}

class MapCanvasProjection extends MVCObject {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new MapCanvasProjection.fromJsProxy(jsProxy);

  MapCanvasProjection.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLng fromContainerPixelToLatLng(Point pixel, [bool nowrap]) => $.fromContainerPixelToLatLng(pixel, nowrap).map(LatLng.INSTANCIATOR).value;
  LatLng fromDivPixelToLatLng(Point pixel, [bool nowrap]) => $.fromDivPixelToLatLng(pixel, nowrap).map(LatLng.INSTANCIATOR).value;
  Point fromLatLngToContainerPixel(LatLng latLng) => $.fromLatLngToContainerPixel(latLng).map(Point.INSTANCIATOR).value;
  Point fromLatLngToDivPixel(LatLng latLng) => $.fromLatLngToDivPixel(latLng).map(Point.INSTANCIATOR).value;
  num get worldWidth => $.getWorldWidth().value;
}

class Geocoder extends jsw.IsJsProxy {
  Geocoder() : super.newInstance(maps.Geocoder);

  void geocode(GeocoderRequest request, void callback(List<GeocoderResult> results, GeocoderStatus status)) {
    $.geocode(request, new jsw.Callback.once((Option<js.Proxy> results, Option<js.Proxy> status) => callback(results.map((e) => new jsw.JsList<GeocoderResult>.fromJsProxy(e, (e) => new GeocoderResult.fromJsProxy(e))).value, status.map(GeocoderStatus.find).value)));
  }
}

class GeocoderRequest extends jsw.IsJsProxy {
  set address(String address) => $.address = address;
  set bounds(LatLngBounds bounds) => $.bounds = bounds;
  set location(LatLng location) => $.location = location;
  set region(String region) => $.region = region;
}

class GeocoderStatus extends jsw.IsEnum<String> {
  static final ERROR = new GeocoderStatus._(maps.GeocoderStatus.ERROR);
  static final INVALID_REQUEST = new GeocoderStatus._(maps.GeocoderStatus.INVALID_REQUEST);
  static final OK = new GeocoderStatus._(maps.GeocoderStatus.OK);
  static final OVER_QUERY_LIMIT = new GeocoderStatus._(maps.GeocoderStatus.OVER_QUERY_LIMIT);
  static final REQUEST_DENIED = new GeocoderStatus._(maps.GeocoderStatus.REQUEST_DENIED);
  static final UNKNOWN_ERROR = new GeocoderStatus._(maps.GeocoderStatus.UNKNOWN_ERROR);
  static final ZERO_RESULTS = new GeocoderStatus._(maps.GeocoderStatus.ZERO_RESULTS);

  static final _INSTANCES = [ERROR, INVALID_REQUEST, OK, OVER_QUERY_LIMIT, REQUEST_DENIED, UNKNOWN_ERROR, ZERO_RESULTS];

  static GeocoderStatus find(Object o) => findIn(_INSTANCES, o);

  GeocoderStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is GeocoderStatus ? (other as GeocoderStatus).value : other);
}

class GeocoderResult extends jsw.IsJsProxy {
  GeocoderResult() : super();
  GeocoderResult.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  List<GeocoderAddressComponent> get address_components => $.address_components.map((js.Proxy jsProxy) => new jsw.JsList<GeocoderAddressComponent>.fromJsProxy(jsProxy, GeocoderAddressComponent.INSTANCIATOR)).value;
  String get formatted_address => $.formatted_address.value;
  GeocoderGeometry get geometry => $.geometry.map(GeocoderGeometry.INSTANCIATOR).value;
  List<String> get types => $.types.map((js.Proxy jsProxy) => new jsw.JsList<String>.fromJsProxy(jsProxy, null)).value;
}

class GeocoderAddressComponent extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new GeocoderAddressComponent.fromJsProxy(jsProxy);

  GeocoderAddressComponent() : super();
  GeocoderAddressComponent.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get long_name => $.long_name.value;
  String get short_name => $.short_name.value;
  List<String> get types => $.types.map((js.Proxy jsProxy) => new jsw.JsList<String>.fromJsProxy(jsProxy, null)).value;
}

class GeocoderGeometry extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new GeocoderGeometry.fromJsProxy(jsProxy);

  GeocoderGeometry() : super();
  GeocoderGeometry.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLngBounds get bounds => $.bounds.map(LatLngBounds.INSTANCIATOR).value;
  LatLng get location => $.location.map(LatLng.INSTANCIATOR).value;
  GeocoderLocationType get location_type => $.location_type.map(GeocoderLocationType.find).value;
  LatLngBounds get viewport => $.viewport.map(LatLngBounds.INSTANCIATOR).value;
}

class GeocoderLocationType extends jsw.IsEnum<String> {
  static final APPROXIMATE = new GeocoderLocationType._(maps.GeocoderLocationType.APPROXIMATE);
  static final GEOMETRIC_CENTER = new GeocoderLocationType._(maps.GeocoderLocationType.GEOMETRIC_CENTER);
  static final RANGE_INTERPOLATED = new GeocoderLocationType._(maps.GeocoderLocationType.RANGE_INTERPOLATED);
  static final ROOFTOP = new GeocoderLocationType._(maps.GeocoderLocationType.ROOFTOP);

  static final _INSTANCES = [APPROXIMATE, GEOMETRIC_CENTER, RANGE_INTERPOLATED, ROOFTOP];

  static GeocoderLocationType find(Object o) => findIn(_INSTANCES, o);

  GeocoderLocationType._(String value) : super(value);

  bool operator ==(Object other) => value == (other is GeocoderLocationType ? (other as GeocoderLocationType).value : other);
}

class DirectionsRenderer extends MVCObject {
  DirectionsRenderer([DirectionsRendererOptions opts]) : super.newInstance(maps.DirectionsRenderer, [opts]);
  DirectionsRenderer.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  DirectionsResult get directions => $.getDirections().map(DirectionsResult.INSTANCIATOR).value;
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  html.Node get panel => $.getPanel().value;
  num get routeIndex => $.getRouteIndex().value;
  set directions(DirectionsResult directions) => $.setDirections(directions);
  set map(GMap map) => $.setMap(map);
  set options(DirectionsRendererOptions options) => $.setOptions(options);
  set panel(html.Node panel) => $.setPanel(panel);
  set routeIndex(num routeIndex) => $.setRouteIndex(routeIndex);

  DirectionsRendererEvents get on => new DirectionsRendererEvents._(this);
}

class DirectionsRendererEvents {
  static final DIRECTIONS_CHANGED = "directions_changed";
  
  final DirectionsRenderer _directionsRenderer;

  DirectionsRendererEvents._(this._directionsRenderer);

  NoArgsEventListenerAdder get directionsChanged => new NoArgsEventListenerAdder(_directionsRenderer, DIRECTIONS_CHANGED);
}

class DirectionsRendererOptions extends jsw.IsJsProxy {
  set directions(DirectionsResult directions) => $.directions = directions;
  set draggable(bool draggable) => $.draggable = draggable;
  set hideRouteList(bool hideRouteList) => $.hideRouteList = hideRouteList;
  set infoWindow(InfoWindow infoWindow) => $.infoWindow = infoWindow;
  set map(GMap map) => $.map = map;
  set markerOptions(MarkerOptions markerOptions) => $.markerOptions = markerOptions;
  set panel(html.Node panel) => $.panel = panel;
  set polylineOptions(PolylineOptions polylineOptions) => $.polylineOptions = polylineOptions;
  set preserveViewport(bool preserveViewport) => $.preserveViewport = preserveViewport;
  set routeIndex(num routeIndex) => $.routeIndex = routeIndex;
  set suppressBicyclingLayer(bool suppressBicyclingLayer) => $.suppressBicyclingLayer = suppressBicyclingLayer;
  set suppressInfoWindows(bool suppressInfoWindows) => $.suppressInfoWindows = suppressInfoWindows;
  set suppressMarkers(bool suppressMarkers) => $.suppressMarkers = suppressMarkers;
  set suppressPolylines(bool suppressPolylines) => $.suppressPolylines = suppressPolylines;
}

class DirectionsService extends jsw.IsJsProxy {
  DirectionsService() : super.newInstance(maps.DirectionsService);

  void route(DirectionsRequest request, void callback(DirectionsResult results, DirectionsStatus status)) {
    $.route(request, new jsw.Callback.once((Option<js.Proxy> results, Option<js.Proxy> status) => callback(results.map(DirectionsResult.INSTANCIATOR).value, status.map(DirectionsStatus.find).value)));
  }
}

class DirectionsRequest extends jsw.IsJsProxy {
  set avoidHighways(bool avoidHighways) => $.avoidHighways = avoidHighways;
  set avoidTolls(bool avoidTolls) => $.avoidTolls = avoidTolls;
  set destination(Object destination) {
    if (destination is String || destination is LatLng) {
      $.destination = destination;
    } else {
      throw new UnsupportedError("Parameter must be of type String or LatLng");
    }
  }
  set optimizeWaypoints(bool optimizeWaypoints) => $.optimizeWaypoints = optimizeWaypoints;
  set origin(Object origin) {
    if (origin is String || origin is LatLng) {
      $.origin = origin;
    } else {
      throw new UnsupportedError("Parameter must be of type String or LatLng");
    }
  }
  set provideRouteAlternatives(bool provideRouteAlternatives) => $.provideRouteAlternatives = provideRouteAlternatives;
  set region(String region) => $.region = region;
  set transitOptions(TransitOptions transitOptions) => $.transitOptions = transitOptions;
  set travelMode(TravelMode travelMode) => $.travelMode = travelMode;
  set unitSystem(UnitSystem unitSystem) => $.unitSystem = unitSystem;
  set waypoints(List<DirectionsWaypoint> waypoints) => $.waypoints = waypoints;
}

class TravelMode extends jsw.IsEnum<String> {
  static final BICYCLING = new TravelMode._(maps.TravelMode.BICYCLING);
  static final DRIVING = new TravelMode._(maps.TravelMode.DRIVING);
  static final TRANSIT = new TravelMode._(maps.TravelMode.TRANSIT);
  static final WALKING = new TravelMode._(maps.TravelMode.WALKING);

  static final _INSTANCES = [BICYCLING, DRIVING, TRANSIT, WALKING];

  static TravelMode find(Object o) => findIn(_INSTANCES, o);

  TravelMode._(String value) : super(value);

  bool operator ==(Object other) => value == (other is TravelMode ? (other as TravelMode).value : other);
}

class UnitSystem extends jsw.IsEnum<int> {
  static final IMPERIAL = new UnitSystem._(maps.UnitSystem.IMPERIAL);
  static final METRIC = new UnitSystem._(maps.UnitSystem.METRIC);

  static final _INSTANCES = [IMPERIAL, METRIC];

  static UnitSystem find(Object o) => findIn(_INSTANCES, o);

  UnitSystem._(int value) : super(value);

  bool operator ==(Object other) => value == (other is UnitSystem ? (other as UnitSystem).value : other);
}

class TransitOptions extends jsw.IsJsProxy {
  set arrivalTime(Date arrivalTime) => $.arrivalTime = arrivalTime;
  set departureTime(Date departureTime) => $.departureTime = departureTime;
}

class DirectionsWaypoint extends jsw.IsJsProxy {
  set location(Object location) {
    if (location is String || location is LatLng) {
      $.location = location;
    } else {
      throw new UnsupportedError("Parameter must be of type String or LatLng");
    }
  }
  set stopover(bool stopover) => $.stopover = stopover;
}

class DirectionsStatus extends jsw.IsEnum<String> {
  static final INVALID_REQUEST = new DirectionsStatus._(maps.DirectionsStatus.INVALID_REQUEST);
  static final MAX_WAYPOINTS_EXCEEDED = new DirectionsStatus._(maps.DirectionsStatus.MAX_WAYPOINTS_EXCEEDED);
  static final NOT_FOUND = new DirectionsStatus._(maps.DirectionsStatus.NOT_FOUND);
  static final OK = new DirectionsStatus._(maps.DirectionsStatus.OK);
  static final OVER_QUERY_LIMIT = new DirectionsStatus._(maps.DirectionsStatus.OVER_QUERY_LIMIT);
  static final REQUEST_DENIED = new DirectionsStatus._(maps.DirectionsStatus.REQUEST_DENIED);
  static final UNKNOWN_ERROR = new DirectionsStatus._(maps.DirectionsStatus.UNKNOWN_ERROR);
  static final ZERO_RESULTS = new DirectionsStatus._(maps.DirectionsStatus.ZERO_RESULTS);

  static final _INSTANCES = [INVALID_REQUEST, MAX_WAYPOINTS_EXCEEDED, NOT_FOUND, OK, OVER_QUERY_LIMIT, REQUEST_DENIED, UNKNOWN_ERROR, ZERO_RESULTS];

  static DirectionsStatus find(Object o) => findIn(_INSTANCES, o);

  DirectionsStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is DirectionsStatus ? (other as DirectionsStatus).value : other);
}

class DirectionsResult extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new DirectionsResult.fromJsProxy(jsProxy);

  DirectionsResult() : super();
  DirectionsResult.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  List<DirectionsRoute> get routes => $.routes.map((js.Proxy jsProxy) => new jsw.JsList<DirectionsRoute>.fromJsProxy(jsProxy, DirectionsRoute.INSTANCIATOR)).value;
}

class DirectionsRoute extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new DirectionsRoute.fromJsProxy(jsProxy);

  DirectionsRoute() : super();
  DirectionsRoute.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLngBounds get bounds => new LatLngBounds.fromJsProxy($.bounds.value);
  String get copyrights => $.copyrights.value;
  List<DirectionsLeg> get legs => $.legs.map((js.Proxy jsProxy) => new jsw.JsList<DirectionsLeg>.fromJsProxy(jsProxy, DirectionsLeg.INSTANCIATOR)).value;
  List<LatLng> get overview_path => $.overview_path.map((js.Proxy jsProxy) => new jsw.JsList<LatLng>.fromJsProxy(jsProxy, LatLng.INSTANCIATOR)).value;
  List<String> get warnings => $.warnings.map((js.Proxy jsProxy) => new jsw.JsList<String>.fromJsProxy(jsProxy, null)).value;
  List<num> get waypoint_order => $.waypoint_order.map((js.Proxy jsProxy) => new jsw.JsList<num>.fromJsProxy(jsProxy, null)).value;
}

class DirectionsLeg extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new DirectionsLeg.fromJsProxy(jsProxy);

  DirectionsLeg() : super();
  DirectionsLeg.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  Time get arrival_time => $.arrival_time.map(Time.INSTANCIATOR).value;
  Time get departure_time => $.departure_time.map(Time.INSTANCIATOR).value;
  Distance get distance => $.distance.map(Distance.INSTANCIATOR).value;
  GDuration get duration => $.duration.map(GDuration.INSTANCIATOR).value;
  String get end_address => $.end_address.value;
  LatLng get end_location => $.end_location.map(LatLng.INSTANCIATOR).value;
  String get start_address => $.start_address.value;
  LatLng get start_location => $.start_location.map(LatLng.INSTANCIATOR).value;
  List<DirectionsStep> get steps => $.steps.map((js.Proxy jsProxy) => new jsw.JsList<DirectionsStep>.fromJsProxy(jsProxy, DirectionsStep.INSTANCIATOR)).value;
  List<LatLng> get via_waypoints => $.via_waypoints.map((js.Proxy jsProxy) => new jsw.JsList<LatLng>.fromJsProxy(jsProxy, LatLng.INSTANCIATOR)).value;
}

class DirectionsStep extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new DirectionsStep.fromJsProxy(jsProxy);

  DirectionsStep() : super();
  DirectionsStep.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  Distance get distance => $.distance.map(Distance.INSTANCIATOR).value;
  GDuration get duration => $.duration.map(GDuration.INSTANCIATOR).value;
  LatLng get end_location => $.end_location.map(LatLng.INSTANCIATOR).value;
  String get instructions => $.instructions.value;
  List<LatLng> get path => $.path.map((js.Proxy jsProxy) => new jsw.JsList<LatLng>.fromJsProxy(jsProxy, LatLng.INSTANCIATOR)).value;
  LatLng get start_location => $.start_location.map(LatLng.INSTANCIATOR).value;
  List<DirectionsStep> get steps => $.steps.map((js.Proxy jsProxy) => new jsw.JsList<DirectionsStep>.fromJsProxy(jsProxy, DirectionsStep.INSTANCIATOR)).value;
  TransitDetails get transit => $.transit.map(TransitDetails.INSTANCIATOR).value;
  TravelMode get travel_mode => $.travel_mode.map(TravelMode.find).value;
}

class Distance extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new Distance.fromJsProxy(jsProxy);

  Distance() : super();
  Distance.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get text => $.text.value;
  num get value => $.value.value;
}

class GDuration extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new GDuration.fromJsProxy(jsProxy);

  GDuration() : super();
  GDuration.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get text => $.text.value;
  num get value => $.value.value;
}

class Time extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new Time.fromJsProxy(jsProxy);

  Time() : super();
  Time.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get text => $.text.value;
  String get time_zone => $.time_zone.value;
  Date get value => $.value.map(jsw.JsDate.INSTANCIATOR).value;
}

class TransitDetails extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new TransitDetails.fromJsProxy(jsProxy);

  TransitDetails() : super();
  TransitDetails.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  TransitStop get arrival_stop => $.arrival_stop.map(TransitStop.INSTANCIATOR).value;
  Time get arrival_time => $.arrival_time.map(Time.INSTANCIATOR).value;
  TransitStop get departure_stop => $.departure_stop.map(TransitStop.INSTANCIATOR).value;
  Time get departure_time => $.departure_time.map(Time.INSTANCIATOR).value;
  String get headsign => $.headsign.value;
  num get headway => $.headway.value;
  TransitLine get line => $.line.map(TransitLine.INSTANCIATOR).value;
  num get num_stops => $.num_stops.value;
}

class TransitStop extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new TransitStop.fromJsProxy(jsProxy);

  TransitStop() : super();
  TransitStop.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLng get location => $.location.map(LatLng.INSTANCIATOR).value;
  String get name => $.name.value;
}

class TransitLine extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new TransitLine.fromJsProxy(jsProxy);

  TransitLine() : super();
  TransitLine.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  List<TransitAgency> get agencies => $.agencies.map((js.Proxy jsProxy) => new jsw.JsList<TransitAgency>.fromJsProxy(jsProxy, TransitAgency.INSTANCIATOR)).value;
  String get color => $.color.value;
  String get icon => $.icon.value;
  String get name => $.name.value;
  String get short_name => $.short_name.value;
  String get text_color => $.text_color.value;
  String get url => $.url.value;
  TransitVehicle get vehicle => $.vehicle.map(TransitVehicle.INSTANCIATOR).value;
}

class TransitAgency extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new TransitAgency.fromJsProxy(jsProxy);

  TransitAgency() : super();
  TransitAgency.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get name => $.name.value;
  String get phone => $.phone.value;
  String get url => $.url.value;
}

class TransitVehicle extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new TransitVehicle.fromJsProxy(jsProxy);

  TransitVehicle() : super();
  TransitVehicle.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get icon => $.icon.value;
  String get local_icon => $.local_icon.value;
  String get name => $.name.value;
  String get type => $.type.value;
}

class ElevationService extends jsw.IsJsProxy {
  ElevationService() : super.newInstance(maps.ElevationService);

  void getElevationAlongPath(PathElevationRequest request, void callback(List<ElevationResult> results, ElevationStatus status)) {
    $.getElevationAlongPath(request, new jsw.Callback.once((Option<js.Proxy> results, Option<js.Proxy> status) => callback(results.map((e) => new jsw.JsList<ElevationResult>.fromJsProxy(e, (e) => new ElevationResult.fromJsProxy(e))).value, status.map(ElevationStatus.find).value)));
  }
  void getElevationForLocations(LocationElevationRequest request, void callback(List<ElevationResult> results, ElevationStatus status)) {
    $.getElevationForLocations(request, new jsw.Callback.once((Option<js.Proxy> results, Option<js.Proxy> status) => callback(results.map((e) => new jsw.JsList<ElevationResult>.fromJsProxy(e, (e) => new ElevationResult.fromJsProxy(e))).value, status.map(ElevationStatus.find).value)));
  }
}

class LocationElevationRequest extends jsw.IsJsProxy {
  set locations(List<LatLng> locations) => $.locations = locations;
}

class PathElevationRequest extends jsw.IsJsProxy {
  set path(List<LatLng> path) => $.path = path;
  set samples(num samples) => $.samples = samples;
}

class ElevationResult extends jsw.IsJsProxy {
  ElevationResult() : super();
  ElevationResult.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  num get elevation => $.elevation.value;
  LatLng get location => $.location.map(LatLng.INSTANCIATOR).value;
  num get resolution => $.resolution.value;
}

class ElevationStatus extends jsw.IsEnum<String> {
  static final INVALID_REQUEST = new ElevationStatus._(maps.ElevationStatus.INVALID_REQUEST);
  static final OK = new ElevationStatus._(maps.ElevationStatus.OK);
  static final OVER_QUERY_LIMIT = new ElevationStatus._(maps.ElevationStatus.OVER_QUERY_LIMIT);
  static final REQUEST_DENIED = new ElevationStatus._(maps.ElevationStatus.REQUEST_DENIED);
  static final UNKNOWN_ERROR = new ElevationStatus._(maps.ElevationStatus.UNKNOWN_ERROR);

  static final _INSTANCES = [INVALID_REQUEST, OK, OVER_QUERY_LIMIT, REQUEST_DENIED, UNKNOWN_ERROR];

  static ElevationStatus find(Object o) => findIn(_INSTANCES, o);

  ElevationStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is ElevationStatus ? (other as ElevationStatus).value : other);
}

class MaxZoomService extends jsw.IsJsProxy {
  MaxZoomService() : super.newInstance(maps.MaxZoomService);

  void getMaxZoomAtLatLng(LatLng latlng, void callback(MaxZoomResult result)) {
    $.getMaxZoomAtLatLng(latlng, new jsw.Callback.once((Option<js.Proxy> result) => callback(result.map(MaxZoomResult.INSTANCIATOR).value)));
  }
}

class MaxZoomResult extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new MaxZoomResult.fromJsProxy(jsProxy);

  MaxZoomResult() : super();
  MaxZoomResult.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  MaxZoomStatus get status => $.status.map(MaxZoomStatus.find).value;
  num get zoom => $.zoom.value;
}

class MaxZoomStatus extends jsw.IsEnum<String> {
  static final ERROR = new MaxZoomStatus._(maps.MaxZoomStatus.ERROR);
  static final OK = new MaxZoomStatus._(maps.MaxZoomStatus.OK);

  static final _INSTANCES = [ERROR, OK];

  static MaxZoomStatus find(Object o) => findIn(_INSTANCES, o);

  MaxZoomStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is MaxZoomStatus ? (other as MaxZoomStatus).value : other);
}

class DistanceMatrixService extends jsw.IsJsProxy {
  DistanceMatrixService() : super.newInstance(maps.DistanceMatrixService);

  void getDistanceMatrix(DistanceMatrixRequest request, void callback(DistanceMatrixResponse response, DistanceMatrixStatus status)) {
    $.getDistanceMatrix(request, new jsw.Callback.once((Option<js.Proxy> response, Option<js.Proxy> status) => callback(response.map(DistanceMatrixResponse.INSTANCIATOR).value, status.map(DistanceMatrixStatus.find).value)));
  }
}

class DistanceMatrixRequest extends jsw.IsJsProxy {
  set avoidHighways(bool avoidHighways) => $.avoidHighways = avoidHighways;
  set avoidTolls(bool avoidTolls) => $.avoidTolls = avoidTolls;
  set destinations(Object destinations) {
    if (destinations is List<String> || destinations is List<LatLng>) {
      $.destinations = destinations;
    } else {
      throw new UnsupportedError("Parameter must be of type List<String> or List<LatLng>");
    }
  }
  set origins(Object origins) {
    if (origins is List<String> || origins is List<LatLng>) {
      $.origins = origins;
    } else {
      throw new UnsupportedError("Parameter must be of type List<String> or List<LatLng>");
    }
  }
  set region(String region) => $.region = region;
  set travelMode(TravelMode travelMode) => $.travelMode = travelMode;
  set unitSystem(UnitSystem unitSystem) => $.unitSystem = unitSystem;
}

class DistanceMatrixResponse extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new DistanceMatrixResponse.fromJsProxy(jsProxy);

  DistanceMatrixResponse() : super();
  DistanceMatrixResponse.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  List<String> get destinationAddresses => $.destinationAddresses.map((js.Proxy jsProxy) => new jsw.JsList<String>.fromJsProxy(jsProxy, null)).value;
  List<String> get originAddresses => $.originAddresses.map((js.Proxy jsProxy) => new jsw.JsList<String>.fromJsProxy(jsProxy, null)).value;
  List<DistanceMatrixResponseRow> get rows => $.rows.map((js.Proxy jsProxy) => new jsw.JsList<DistanceMatrixResponseRow>.fromJsProxy(jsProxy, DistanceMatrixResponseRow.INSTANCIATOR)).value;
}

class DistanceMatrixResponseRow extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new DistanceMatrixResponseRow.fromJsProxy(jsProxy);

  DistanceMatrixResponseRow() : super();
  DistanceMatrixResponseRow.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  List<DistanceMatrixResponseElement> get elements => $.elements.map((js.Proxy jsProxy) => new jsw.JsList<DistanceMatrixResponseElement>.fromJsProxy(jsProxy, DistanceMatrixResponseElement.INSTANCIATOR)).value;
}

class DistanceMatrixResponseElement extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new DistanceMatrixResponseElement.fromJsProxy(jsProxy);

  DistanceMatrixResponseElement() : super();
  DistanceMatrixResponseElement.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  Distance get distance => $.distance.map(Distance.INSTANCIATOR).value;
  GDuration get duration => $.duration.map(GDuration.INSTANCIATOR).value;
  DistanceMatrixElementStatus get status => $.status.map(DistanceMatrixElementStatus.find).value;
}

class DistanceMatrixStatus extends jsw.IsEnum<String> {
  static final INVALID_REQUEST = new DistanceMatrixStatus._(maps.DistanceMatrixStatus.INVALID_REQUEST);
  static final MAX_DIMENSIONS_EXCEEDED = new DistanceMatrixStatus._(maps.DistanceMatrixStatus.MAX_DIMENSIONS_EXCEEDED);
  static final MAX_ELEMENTS_EXCEEDED = new DistanceMatrixStatus._(maps.DistanceMatrixStatus.MAX_ELEMENTS_EXCEEDED);
  static final OK = new DistanceMatrixStatus._(maps.DistanceMatrixStatus.OK);
  static final OVER_QUERY_LIMIT = new DistanceMatrixStatus._(maps.DistanceMatrixStatus.OVER_QUERY_LIMIT);
  static final REQUEST_DENIED = new DistanceMatrixStatus._(maps.DistanceMatrixStatus.REQUEST_DENIED);
  static final UNKNOWN_ERROR = new DistanceMatrixStatus._(maps.DistanceMatrixStatus.UNKNOWN_ERROR);

  static final _INSTANCES = [INVALID_REQUEST, MAX_DIMENSIONS_EXCEEDED, MAX_ELEMENTS_EXCEEDED, OK, OVER_QUERY_LIMIT, REQUEST_DENIED, UNKNOWN_ERROR];

  static DistanceMatrixStatus find(Object o) => findIn(_INSTANCES, o);

  DistanceMatrixStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is DistanceMatrixStatus ? (other as DistanceMatrixStatus).value : other);
}

class DistanceMatrixElementStatus extends jsw.IsEnum<String> {
  static final NOT_FOUND = new DistanceMatrixElementStatus._(maps.DistanceMatrixElementStatus.NOT_FOUND);
  static final OK = new DistanceMatrixElementStatus._(maps.DistanceMatrixElementStatus.OK);
  static final ZERO_RESULTS = new DistanceMatrixElementStatus._(maps.DistanceMatrixElementStatus.ZERO_RESULTS);

  static final _INSTANCES = [NOT_FOUND, OK, ZERO_RESULTS];

  static DistanceMatrixElementStatus find(Object o) => findIn(_INSTANCES, o);

  DistanceMatrixElementStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is DistanceMatrixElementStatus ? (other as DistanceMatrixElementStatus).value : other);
}

class MapType extends jsw.IsJsProxy {
  MapType() : super();
  MapType.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);
  MapType.newInstance(objectName, [List args]) : super.newInstance(objectName, args);

  html.Node getTile(Point tileCoord, num zoom, html.Document ownerDocument) => $.getTile(tileCoord, zoom, ownerDocument).value;
  html.Node releaseTile(html.Node tile) => $.releaseTile(tile).value;

  String get alt => $.alt.value;
  set alt(String alt) => $.alt = alt;
  num get maxZoom => $.maxZoom.value;
  set maxZoom(num maxZoom) => $.maxZoom = maxZoom;
  num get minZoom => $.minZoom.value;
  set minZoom(num minZoom) => $.minZoom = minZoom;
  String get name => $.name.value;
  set name(String name) => $.name = name;
  Projection get projection => $.projection.map(Projection.INSTANCIATOR).value;
  set projection(Projection projection) => $.projection = projection;
  num get radius => $.radius.value;
  set radius(num radius) => $.radius = radius;
  Size get tileSize => $.tileSize.map(Size.INSTANCIATOR).value;
  set tileSize(Size tileSize) => $.tileSize = tileSize;
}

class MapTypeRegistry extends MVCObject {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new MapTypeRegistry.fromJsProxy(jsProxy);

  MapTypeRegistry() : super.newInstance(maps.MapTypeRegistry);
  MapTypeRegistry.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  void set(String id, MapType mapType) { $.set(id, mapType); }
}

class Projection extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new Projection.fromJsProxy(jsProxy);

  Projection() : super();
  Projection.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  void set_fromLatLngToPoint(Point fromLatLngToPoint(LatLng latLng, [Point point])) {
    $.fromLatLngToPoint = new jsw.Callback.many((Option<js.Proxy> latLng, [Option<js.Proxy> point]) {
      if (?point) {
        return fromLatLngToPoint(latLng.map((e) => new LatLng.fromJsProxy(e)).value, point.map((e) => new Point.fromJsProxy(e)).value);
      } else {
        return fromLatLngToPoint(latLng.map((e) => new LatLng.fromJsProxy(e)).value);
      }
    });
  }
  void set_fromPointToLatLng(LatLng fromPointToLatLng(Point pixel, [bool nowrap])) {
    $.fromPointToLatLng = new jsw.Callback.many((Option<js.Proxy> pixel, [Option<bool> nowrap]) {
      if (?nowrap) {
        return fromPointToLatLng(pixel.map((e) => new Point.fromJsProxy(e)).value, nowrap.value);
      } else {
        return fromPointToLatLng(pixel.map((e) => new Point.fromJsProxy(e)).value);
      }
    });
  }

  Point fromLatLngToPoint(LatLng latLng, [Point point]) => $.fromLatLngToPoint(latLng, point).map(Point.INSTANCIATOR).value;
  LatLng fromPointToLatLng(Point pixel, [bool nowrap]) => $.fromPointToLatLng(pixel, nowrap).map(LatLng.INSTANCIATOR).value;
}

class ImageMapType extends MapType {
  ImageMapType(ImageMapTypeOptions opts) : super.newInstance(maps.ImageMapType, [opts]);
  ImageMapType.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  num get opacity => $.getOpacity().value;
  set opacity(num opacity) => $.setOpacity(opacity);

  ImageMapTypeEvents get on => new ImageMapTypeEvents._(this);
}

class ImageMapTypeEvents {
  static final TILESLOADED = "tilesloaded";
  
  final ImageMapType _imageMapType;

  ImageMapTypeEvents._(this._imageMapType);

  NoArgsEventListenerAdder get tilesloaded => new NoArgsEventListenerAdder(_imageMapType, TILESLOADED);
}

class ImageMapTypeOptions extends jsw.IsJsProxy {
  set alt(String alt) => $.alt = alt;
  // REPORTED report wtf arg : http://code.google.com/p/gmaps-api-issues/issues/detail?id=4573
  set getTileUrl(String callback(Point point, num zoomLevel)) => $.getTileUrl = new jsw.Callback.many((Option<js.Proxy> point, Option<num> zoomLevel, [Option<Object> wtf]) => callback(point.map(Point.INSTANCIATOR).value, zoomLevel.value));
  set maxZoom(num maxZoom) => $.maxZoom = maxZoom;
  set minZoom(num minZoom) => $.minZoom = minZoom;
  set name(String name) => $.name = name;
  set opacity(num opacity) => $.opacity = opacity;
  set tileSize(Size tileSize) => $.tileSize = tileSize;
}

class StyledMapType extends MapType {
  StyledMapType(List<MapTypeStyle> styles, [StyledMapTypeOptions options]) : super.newInstance(maps.StyledMapType, [styles, options]);
}

class StyledMapTypeOptions extends jsw.IsJsProxy {
  set alt(String alt) => $.alt = alt;
  set maxZoom(num maxZoom) => $.maxZoom = maxZoom;
  set minZoom(num minZoom) => $.minZoom = minZoom;
  set name(String name) => $.name = name;
}

class MapTypeStyle extends jsw.IsJsProxy {
  set elementType(MapTypeStyleElementType elementType) => $.elementType = elementType.value;
  set featureType(MapTypeStyleFeatureType featureType) => $.featureType = featureType.value;
  set stylers(List<MapTypeStyler> stylers) => $.stylers = stylers;
}

class MapTypeStyleFeatureType extends jsw.IsEnum<String> {
  static final ADMINISTRATIVE = new MapTypeStyleFeatureType._("administrative");
  static final ADMINISTRATIVE_COUNTRY = new MapTypeStyleFeatureType._("administrative.country");
  static final ADMINISTRATIVE_LAND_PARCEL = new MapTypeStyleFeatureType._("administrative.land_parcel");
  static final ADMINISTRATIVE_LOCALITY = new MapTypeStyleFeatureType._("administrative.locality");
  static final ADMINISTRATIVE_NEIGHBORHOOD = new MapTypeStyleFeatureType._("administrative.neighborhood");
  static final ADMINISTRATIVE_PROVINCE = new MapTypeStyleFeatureType._("administrative.province");
  static final ALL = new MapTypeStyleFeatureType._("all");
  static final LANDSCAPE = new MapTypeStyleFeatureType._("landscape");
  static final LANDSCAPE_MAN_MADE = new MapTypeStyleFeatureType._("landscape.man_made");
  static final LANDSCAPE_NATURAL = new MapTypeStyleFeatureType._("landscape.natural");
  static final POI = new MapTypeStyleFeatureType._("poi");
  static final POI_ATTRACTION = new MapTypeStyleFeatureType._("poi.attraction");
  static final POI_BUSINESS = new MapTypeStyleFeatureType._("poi.business");
  static final POI_GOVERNMENT = new MapTypeStyleFeatureType._("poi.government");
  static final POI_MEDICAL = new MapTypeStyleFeatureType._("poi.medical");
  static final POI_PARK = new MapTypeStyleFeatureType._("poi.park");
  static final POI_PLACE_OF_WORSHIP = new MapTypeStyleFeatureType._("poi.place_of_worship");
  static final POI_SCHOOL = new MapTypeStyleFeatureType._("poi.school");
  static final POI_SPORTS_COMPLEX = new MapTypeStyleFeatureType._("poi.sports_complex");
  static final ROAD = new MapTypeStyleFeatureType._("road");
  static final ROAD_ARTERIAL = new MapTypeStyleFeatureType._("road.arterial");
  static final ROAD_HIGHWAY = new MapTypeStyleFeatureType._("road.highway");
  static final ROAD_HIGHWAY_CONTROLLED_ACCESS = new MapTypeStyleFeatureType._("road.highway.controlled_access");
  static final ROAD_LOCAL = new MapTypeStyleFeatureType._("road.local");
  static final TRANSIT = new MapTypeStyleFeatureType._("transit");
  static final TRANSIT_LINE = new MapTypeStyleFeatureType._("transit.line");
  static final TRANSIT_STATION = new MapTypeStyleFeatureType._("transit.station");
  static final TRANSIT_STATION_AIRPORT = new MapTypeStyleFeatureType._("transit.station.airport");
  static final TRANSIT_STATION_BUS = new MapTypeStyleFeatureType._("transit.station.bus");
  static final TRANSIT_STATION_RAIL = new MapTypeStyleFeatureType._("transit.station.rail");
  static final WATER = new MapTypeStyleFeatureType._("water");

  static final _INSTANCES = [ADMINISTRATIVE, ADMINISTRATIVE_COUNTRY, ADMINISTRATIVE_LAND_PARCEL, ADMINISTRATIVE_LOCALITY, ADMINISTRATIVE_NEIGHBORHOOD, ADMINISTRATIVE_PROVINCE, ALL, LANDSCAPE, LANDSCAPE_MAN_MADE, LANDSCAPE_NATURAL, POI, POI_ATTRACTION, POI_BUSINESS, POI_GOVERNMENT, POI_MEDICAL, POI_PARK, POI_PLACE_OF_WORSHIP, POI_SCHOOL, POI_SPORTS_COMPLEX, ROAD, ROAD_ARTERIAL, ROAD_HIGHWAY, ROAD_HIGHWAY_CONTROLLED_ACCESS, ROAD_LOCAL, TRANSIT, TRANSIT_LINE, TRANSIT_STATION, TRANSIT_STATION_AIRPORT, TRANSIT_STATION_BUS, TRANSIT_STATION_RAIL, WATER];

  static MapTypeStyleFeatureType find(Object o) => findIn(_INSTANCES, o);

  MapTypeStyleFeatureType._(String value) : super(value);

  bool operator ==(Object other) => value == (other is MapTypeStyleFeatureType ? (other as MapTypeStyleFeatureType).value : other);
}

class MapTypeStyleElementType extends jsw.IsEnum<String> {
  static final ALL = new MapTypeStyleElementType._("all");
  static final GEOMETRY = new MapTypeStyleElementType._("geometry");
  static final LABELS = new MapTypeStyleElementType._("labels");

  static final _INSTANCES = [ALL, GEOMETRY, LABELS];

  static MapTypeStyleElementType find(Object o) => findIn(_INSTANCES, o);

  MapTypeStyleElementType._(String value) : super(value);

  bool operator ==(Object other) => value == (other is MapTypeStyleElementType ? (other as MapTypeStyleElementType).value : other);
}

class MapTypeStyler extends jsw.IsJsProxy {
  set gamma(num gamma) => $.gamma = gamma;
  set hue(String hue) => $.hue = hue;
  set invert_lightness(bool invert_lightness) => $.invert_lightness = invert_lightness;
  set lightness(num lightness) => $.lightness = lightness;
  set saturation(num saturation) => $.saturation = saturation;
  set visibility(MapTypeStylerVisibility visibility) => $.visibility = visibility.value;
}

class MapTypeStylerVisibility extends jsw.IsEnum<String> {
  static final ON = new MapTypeStylerVisibility._("on");
  static final OFF = new MapTypeStylerVisibility._("off");
  static final SIMPLIFIED = new MapTypeStylerVisibility._("simplified");

  static final _INSTANCES = [ON, OFF, SIMPLIFIED];

  static MapTypeStylerVisibility find(Object o) => findIn(_INSTANCES, o);

  MapTypeStylerVisibility._(String value) : super(value);

  bool operator ==(Object other) => value == (other is MapTypeStylerVisibility ? (other as MapTypeStylerVisibility).value : other);
}

class BicyclingLayer extends MVCObject {
  BicyclingLayer() : super.newInstance(maps.BicyclingLayer);
  BicyclingLayer.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  set map(GMap map) => $.setMap(map);
}

class FusionTablesLayer extends MVCObject {
  FusionTablesLayer(FusionTablesLayerOptions options) : super.newInstance(maps.FusionTablesLayer, [options]);
  FusionTablesLayer.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  set map(GMap map) => $.setMap(map);
  set options(FusionTablesLayerOptions options) => $.setOptions(options);

  FusionTablesLayerEvents get on => new FusionTablesLayerEvents._(this);
}

class FusionTablesLayerEvents {
  static final CLICK = "click";
  
  final FusionTablesLayer _fusionTablesLayer;

  FusionTablesLayerEvents._(this._fusionTablesLayer);

  FusionTablesMouseEventListenerAdder get click => new FusionTablesMouseEventListenerAdder(_fusionTablesLayer, CLICK);
}

class FusionTablesLayerOptions extends jsw.IsJsProxy {
  set clickable(bool clickable) => $.clickable = clickable;
  set heatmap(FusionTablesHeatmap heatmap) => $.heatmap = heatmap;
  set map(GMap map) => $.map = map;
  set query(FusionTablesQuery query) => $.query = query;
  set styles(List<FusionTablesStyle> styles) => $.styles = styles;
  set suppressInfoWindows(bool suppressInfoWindows) => $.suppressInfoWindows = suppressInfoWindows;
}

class FusionTablesQuery extends jsw.IsJsProxy {
  set from(String from) => $.from = from;
  set limit(num limit) => $.limit = limit;
  set offset(num offset) => $.offset = offset;
  set orderBy(String orderBy) => $.orderBy = orderBy;
  set select(String select) => $.select = select;
  set where(String where) => $.where = where;
}

class FusionTablesStyle extends jsw.IsJsProxy {
  set markerOptions(FusionTablesMarkerOptions markerOptions) => $.markerOptions = markerOptions;
  set polygonOptions(FusionTablesPolygonOptions polygonOptions) => $.polygonOptions = polygonOptions;
  set polylineOptions(FusionTablesPolylineOptions polylineOptions) => $.polylineOptions = polylineOptions;
  set where(String where) => $.where = where;
}

class FusionTablesHeatmap extends jsw.IsJsProxy {
  set enabled(bool enabled) => $.enabled = enabled;
}

class FusionTablesMarkerOptions extends jsw.IsJsProxy {
  set iconName(String iconName) => $.iconName = iconName;
}

class FusionTablesPolygonOptions extends jsw.IsJsProxy {
  set fillColor(String fillColor) => $.fillColor = fillColor;
  set fillOpacity(num fillOpacity) => $.fillOpacity = fillOpacity;
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
}

class FusionTablesPolylineOptions extends jsw.IsJsProxy {
  set strokeColor(String strokeColor) => $.strokeColor = strokeColor;
  set strokeOpacity(num strokeOpacity) => $.strokeOpacity = strokeOpacity;
  set strokeWeight(num strokeWeight) => $.strokeWeight = strokeWeight;
}

class FusionTablesMouseEvent extends jsw.IsJsProxy {
  FusionTablesMouseEvent();
  FusionTablesMouseEvent.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get infoWindowHtml => $.infoWindowHtml.value;
  LatLng get latLng => $.latLng.map(LatLng.INSTANCIATOR).value;
  Size get pixelOffset => $.pixelOffset.map(Size.INSTANCIATOR).value;
  // TODO improve return type ( should be Map<String, FusionTablesCell> )
  js.Proxy get row => $.row.value;
}

class FusionTablesCell extends jsw.IsJsProxy {
  String get columnName => $.columnName.value;
  set columnName(String columnName) => $.columnName = columnName;
  String get value => $.value.value;
  set value(String value) => $.value = value;
}

class KmlLayer extends MVCObject {
  KmlLayer(String url, [KmlLayerOptions options]) : super.newInstance(maps.KmlLayer, [url, options]);
  KmlLayer.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLngBounds get defaultViewport => $.getDefaultViewport().map(LatLngBounds.INSTANCIATOR).value;
  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  KmlLayerMetadata get metadata => $.getMetadata().map(KmlLayerMetadata.INSTANCIATOR).value;
  KmlLayerStatus get status => $.getStatus().map(KmlLayerStatus.find).value;
  String get url => $.getUrl().value;
  set map(GMap map) => $.setMap(map);

  KmlLayerEvents get on => new KmlLayerEvents._(this);
}

class KmlLayerEvents {
  static final CLICK = "click";
  static final DEFAULTVIEWPORT_CHANGED = "defaultviewport_changed";
  static final STATUS_CHANGED = "status_changed";
  
  final KmlLayer _kmlLayer;

  KmlLayerEvents._(this._kmlLayer);

  KmlMouseEventListenerAdder get click => new KmlMouseEventListenerAdder(_kmlLayer, CLICK);
  NoArgsEventListenerAdder get defaultviewportChanged => new NoArgsEventListenerAdder(_kmlLayer, DEFAULTVIEWPORT_CHANGED);
  NoArgsEventListenerAdder get statusChanged => new NoArgsEventListenerAdder(_kmlLayer, STATUS_CHANGED);
}

class KmlLayerOptions extends jsw.IsJsProxy {
  set clickable(bool clickable) => $.clickable = clickable;
  set map(GMap map) => $.map = map;
  set preserveViewport(bool preserveViewport) => $.preserveViewport = preserveViewport;
  set suppressInfoWindows(bool suppressInfoWindows) => $.suppressInfoWindows = suppressInfoWindows;
}

class KmlLayerMetadata extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new KmlLayerMetadata.fromJsProxy(jsProxy);

  KmlLayerMetadata.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  KmlAuthor get author => $.author.map(KmlAuthor.INSTANCIATOR).value;
  String get description => $.description.value;
  String get name => $.name.value;
  String get snippet => $.snippet.value;
}

class KmlLayerStatus extends jsw.IsEnum<String> {
  static final DOCUMENT_NOT_FOUND = new KmlLayerStatus._(maps.KmlLayerStatus.DOCUMENT_NOT_FOUND);
  static final DOCUMENT_TOO_LARGE = new KmlLayerStatus._(maps.KmlLayerStatus.DOCUMENT_TOO_LARGE);
  static final FETCH_ERROR = new KmlLayerStatus._(maps.KmlLayerStatus.FETCH_ERROR);
  static final INVALID_DOCUMENT = new KmlLayerStatus._(maps.KmlLayerStatus.INVALID_DOCUMENT);
  static final INVALID_REQUEST = new KmlLayerStatus._(maps.KmlLayerStatus.INVALID_REQUEST);
  static final LIMITS_EXCEEDED = new KmlLayerStatus._(maps.KmlLayerStatus.LIMITS_EXCEEDED);
  static final OK = new KmlLayerStatus._(maps.KmlLayerStatus.OK);
  static final TIMED_OUT = new KmlLayerStatus._(maps.KmlLayerStatus.TIMED_OUT);
  static final UNKNOWN = new KmlLayerStatus._(maps.KmlLayerStatus.UNKNOWN);

  static final _INSTANCES = [DOCUMENT_NOT_FOUND, DOCUMENT_TOO_LARGE, FETCH_ERROR, INVALID_DOCUMENT, INVALID_REQUEST, LIMITS_EXCEEDED, OK, TIMED_OUT, UNKNOWN];

  static KmlLayerStatus find(Object o) => findIn(_INSTANCES, o);

  KmlLayerStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is KmlLayerStatus ? (other as KmlLayerStatus).value : other);
}

class KmlMouseEvent extends jsw.IsJsProxy {
  KmlMouseEvent();
  KmlMouseEvent.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  KmlFeatureData get featureData => $.featureData.map(KmlFeatureData.INSTANCIATOR).value;
  LatLng get latLng => $.latLng.map(LatLng.INSTANCIATOR).value;
  Size get pixelOffset => $.pixelOffset.map(Size.INSTANCIATOR).value;
}

class KmlFeatureData extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new KmlFeatureData.fromJsProxy(jsProxy);

  KmlFeatureData.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  KmlAuthor get author => $.author.map(KmlAuthor.INSTANCIATOR).value;
  String get description => $.description.value;
  String get id => $.id.value;
  String get infoWindowHtml => $.infoWindowHtml.value;
  String get name => $.name.value;
  String get snippet => $.snippet.value;
}

class KmlAuthor extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new KmlAuthor.fromJsProxy(jsProxy);

  KmlAuthor.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get email => $.email.value;
  String get name => $.name.value;
  String get uri => $.uri.value;
}

class TrafficLayer extends MVCObject {
  TrafficLayer() : super.newInstance(maps.TrafficLayer);
  TrafficLayer.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  set map(GMap map) => $.setMap(map);
}

class TransitLayer extends MVCObject {
  TransitLayer() : super.newInstance(maps.TransitLayer);
  TransitLayer.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  GMap get map => $.getMap().map(GMap.INSTANCIATOR).value;
  set map(GMap map) => $.setMap(map);
}

class StreetViewPanorama extends MVCObject {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new StreetViewPanorama.fromJsProxy(jsProxy);
  static bool isInstance(js.Proxy jsProxy) => js.instanceof(jsProxy, maps.StreetViewPanorama);

  StreetViewPanorama(html.Node container, [StreetViewPanoramaOptions opts]) : super.newInstance(maps.StreetViewPanorama, [container, opts]);
  StreetViewPanorama.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  List<StreetViewLink> get links => $.getLinks().map((js.Proxy jsProxy) => new jsw.JsList<StreetViewLink>.fromJsProxy(jsProxy, StreetViewLink.INSTANCIATOR)).value;
  String get pano => $.getPano().value;
  LatLng get position => $.getPosition().map(LatLng.INSTANCIATOR).value;
  StreetViewPov get pov => $.getPov().map(StreetViewPov.INSTANCIATOR).value;
  bool get visible => $.getVisible().value;
  void registerPanoProvider(StreetViewPanoramaData provider(String pano)) {
    $.registerPanoProvider(new jsw.Callback.many((Option<String> pano) => provider(pano.value)));
  }
  set pano(String pano) => $.setPano(pano);
  set position(LatLng latLng) => $.setPosition(latLng);
  set pov(StreetViewPov pov) => $.setPov(pov);
  set visible(bool flag) => $.setVisible(flag);

  Controls get controls => $.controls.map(Controls.INSTANCIATOR).value;
  set controls(Controls controls) => $.controls = controls;

  StreetViewPanoramaEvents get on => new StreetViewPanoramaEvents._(this);
}

class StreetViewPanoramaEvents {
  static final CLOSECLICK = "closeclick";
  static final LINKS_CHANGED = "links_changed";
  static final PANO_CHANGED = "pano_changed";
  static final POSITION_CHANGED = "position_changed";
  static final POV_CHANGED = "pov_changed";
  static final RESIZE = "resize";
  static final VISIBLE_CHANGED = "visible_changed";
  
  final StreetViewPanorama _streetViewPanorama;

  StreetViewPanoramaEvents._(this._streetViewPanorama);

  NativeEventListenerAdder get closeclick => new NativeEventListenerAdder(_streetViewPanorama, CLOSECLICK);
  NoArgsEventListenerAdder get linksChanged => new NoArgsEventListenerAdder(_streetViewPanorama, LINKS_CHANGED);
  NoArgsEventListenerAdder get panoChanged => new NoArgsEventListenerAdder(_streetViewPanorama, PANO_CHANGED);
  NoArgsEventListenerAdder get positionChanged => new NoArgsEventListenerAdder(_streetViewPanorama, POSITION_CHANGED);
  NoArgsEventListenerAdder get povChanged => new NoArgsEventListenerAdder(_streetViewPanorama, POV_CHANGED);
  NoArgsEventListenerAdder get resize => new NoArgsEventListenerAdder(_streetViewPanorama, RESIZE);
  NoArgsEventListenerAdder get visibleChanged => new NoArgsEventListenerAdder(_streetViewPanorama, VISIBLE_CHANGED);
}

class StreetViewPanoramaOptions extends jsw.IsJsProxy {
  set addressControl(bool addressControl) => $.addressControl = addressControl;
  set addressControlOptions(StreetViewAddressControlOptions addressControlOptions) => $.addressControlOptions = addressControlOptions;
  set clickToGo(bool clickToGo) => $.clickToGo = clickToGo;
  set disableDoubleClickZoom(bool disableDoubleClickZoom) => $.disableDoubleClickZoom = disableDoubleClickZoom;
  set enableCloseButton(bool enableCloseButton) => $.enableCloseButton = enableCloseButton;
  set imageDateControl(bool imageDateControl) => $.imageDateControl = imageDateControl;
  set linksControl(bool linksControl) => $.linksControl = linksControl;
  set panControl(bool panControl) => $.panControl = panControl;
  set panControlOptions(PanControlOptions panControlOptions) => $.panControlOptions = panControlOptions;
  set pano(String pano) => $.pano = pano;
  set panoProvider(StreetViewPanoramaData provider(String pano)) => $.panoProvider = new jsw.Callback.many((Option<String> pano) => provider(pano.value));
  set position(LatLng position) => $.position = position;
  set pov(StreetViewPov pov) => $.pov = pov;
  set scrollwheel(bool scrollwheel) => $.scrollwheel = scrollwheel;
  set visible(bool visible) => $.visible = visible;
  set zoomControl(bool zoomControl) => $.zoomControl = zoomControl;
  set zoomControlOptions(ZoomControlOptions zoomControlOptions) => $.zoomControlOptions = zoomControlOptions;
}

class StreetViewAddressControlOptions extends jsw.IsJsProxy {
  set position(ControlPosition position) => $.position = position;
}

class StreetViewLink extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new StreetViewLink.fromJsProxy(jsProxy);

  StreetViewLink() : super();
  StreetViewLink.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get description => $.description.value;
  set description(String description) => $.description = description;
  num get heading => $.heading.value;
  set heading(num heading) => $.heading = heading;
  String get pano => $.pano.value;
  set pano(String pano) => $.pano = pano;
}

class StreetViewPov extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new StreetViewPov.fromJsProxy(jsProxy);

  StreetViewPov() : super();
  StreetViewPov.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  num get heading => $.heading.value;
  set heading(num heading) => $.heading = heading;
  num get pitch => $.pitch.value;
  set pitch(num pitch) => $.pitch = pitch;
  num get zoom => $.zoom.value;
  set zoom(num zoom) => $.zoom = zoom;
}

class StreetViewPanoramaData extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new StreetViewPanoramaData.fromJsProxy(jsProxy);

  StreetViewPanoramaData() : super();
  StreetViewPanoramaData.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get copyright => $.copyright.value;
  set copyright(String copyright) => $.copyright = copyright;
  String get imageDate => $.imageDate.value;
  set imageDate(String imageDate) => $.imageDate = imageDate;
  List<StreetViewLink> get links => $.links.map((js.Proxy jsProxy) => new jsw.JsList<StreetViewLink>.fromJsProxy(jsProxy, StreetViewLink.INSTANCIATOR)).value;
  set links(List<StreetViewLink> links) => $.links = links;
  StreetViewLocation get location => $.location.map(StreetViewLocation.INSTANCIATOR).value;
  set location(StreetViewLocation location) => $.location = location;
  StreetViewTileData get tiles => $.tiles.map(StreetViewTileData.INSTANCIATOR).value;
  set tiles(StreetViewTileData tiles) => $.tiles = tiles;
}

class StreetViewLocation extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new StreetViewLocation.fromJsProxy(jsProxy);

  StreetViewLocation() : super();
  StreetViewLocation.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  String get description => $.description.value;
  set description(String description) => $.description = description;
  LatLng get latLng => $.latLng.map(LatLng.INSTANCIATOR).value;
  set latLng(LatLng latLng) => $.latLng = latLng;
  String get pano => $.pano.value;
  set pano(String pano) => $.pano = pano;
}

class StreetViewTileData extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new StreetViewTileData.fromJsProxy(jsProxy);

  StreetViewTileData() : super();
  StreetViewTileData.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  void set_getTileUrl(String getTileUrl(String pano, num tileZoom, num tileX, num tileY)) {
    $.getTileUrl = new jsw.Callback.many((Option<String> pano, Option<num> tileZoom, Option<num> tileX, Option<num> tileY) => getTileUrl(pano.value, tileZoom.value, tileX.value, tileY.value));
  }
  String getTileUrl(String pano, num tileZoom, num tileX, num tileY) => $.getTileUrl(pano, tileZoom, tileX, tileY).value;

  set centerHeading(num centerHeading) => $.centerHeading = centerHeading;
  set tileSize(Size tileSize) => $.tileSize = tileSize;
  set worldSize(Size worldSize) => $.worldSize = worldSize;
}

class StreetViewService extends jsw.IsJsProxy {
  StreetViewService() : super.newInstance(maps.StreetViewService);

  void getPanoramaById(String pano, void callback(StreetViewPanoramaData streetViewPanoramaData, StreetViewStatus streetViewStatus)) {
    $.getPanoramaById(pano, new jsw.Callback.once((Option<StreetViewPanoramaData> streetViewPanoramaData, Option<StreetViewStatus> streetViewStatus) => callback(streetViewPanoramaData.map(StreetViewPanoramaData.INSTANCIATOR).value, streetViewStatus.map(StreetViewStatus.find).value)));
  }
  void getPanoramaByLocation(LatLng latlng, num radius, void callback(StreetViewPanoramaData streetViewPanoramaData, StreetViewStatus streetViewStatus)) {
    $.getPanoramaByLocation(latlng, radius, new jsw.Callback.once((Option<StreetViewPanoramaData> streetViewPanoramaData, Option<StreetViewStatus> streetViewStatus) => callback(streetViewPanoramaData.map(StreetViewPanoramaData.INSTANCIATOR).value, streetViewStatus.map(StreetViewStatus.find).value)));
  }
}

class StreetViewStatus extends jsw.IsEnum<String> {
  static final OK = new StreetViewStatus._(maps.StreetViewStatus.OK);
  static final UNKNOWN_ERROR = new StreetViewStatus._(maps.StreetViewStatus.UNKNOWN_ERROR);
  static final ZERO_RESULTS = new StreetViewStatus._(maps.StreetViewStatus.ZERO_RESULTS);

  static final _INSTANCES = [OK, UNKNOWN_ERROR, ZERO_RESULTS];

  static StreetViewStatus find(Object o) => findIn(_INSTANCES, o);

  StreetViewStatus._(String value) : super(value);

  bool operator ==(Object other) => value == (other is StreetViewStatus ? (other as StreetViewStatus).value : other);
}

typedef void OnRelease();
class MapsEventListener extends jsw.IsJsProxy {
  final OnRelease onRelease;
  MapsEventListener.fromJsProxy(js.Proxy jsProxy, [this.onRelease]) : super.fromJsProxy(jsProxy);
}

class NativeEvent extends jsw.IsJsProxy {
  NativeEvent() : super();
  NativeEvent.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);
}

class Events {
  static MapsEventListener addDomListener(Object instance, String eventName, Function handler, [bool capture]) {
    final callback = new jsw.Callback.many(handler);
    final instanciator = (js.Proxy jsProxy) => new MapsEventListener.fromJsProxy(jsProxy, () => callback.dispose());
    return new jsw.IsJsProxy.fromJsProxy(maps.event).$.addDomListener(instance, eventName, callback, capture).map(instanciator).value;
  }
  static MapsEventListener addDomListenerOnce(Object instance, String eventName, Function handler, [bool capture]) {
    final callback = new jsw.Callback.once(handler);
    final instanciator = (js.Proxy jsProxy) => new MapsEventListener.fromJsProxy(jsProxy);
    return new jsw.IsJsProxy.fromJsProxy(maps.event).$.addDomListenerOnce(instance, eventName, callback, capture).map(instanciator).value;
  }
  static MapsEventListener addListener(jsw.IsJsProxy instance, String eventName, Function handler) {
    final callback = new jsw.Callback.many(handler);
    final instanciator = (js.Proxy jsProxy) => new MapsEventListener.fromJsProxy(jsProxy, () => callback.dispose());
    return new jsw.IsJsProxy.fromJsProxy(maps.event).$.addListener(instance, eventName, callback).map(instanciator).value;
  }
  static MapsEventListener addListenerOnce(jsw.IsJsProxy instance, String eventName, Function handler) {
    final callback = new jsw.Callback.once(handler);
    final instanciator = (js.Proxy jsProxy) => new MapsEventListener.fromJsProxy(jsProxy);
    return new jsw.IsJsProxy.fromJsProxy(maps.event).$.addListenerOnce(instance, eventName, callback).map(instanciator).value;
  }
  static void clearInstanceListeners(jsw.IsJsProxy instance) { new jsw.IsJsProxy.fromJsProxy(maps.event).$.clearInstanceListeners(instance); }
  static void clearListeners(jsw.IsJsProxy instance, String eventName) { new jsw.IsJsProxy.fromJsProxy(maps.event).$.clearListeners(instance, eventName); }
  static void removeListener(MapsEventListener listener) {
    if (listener.onRelease != null) {
      listener.onRelease();
    }
    new jsw.IsJsProxy.fromJsProxy(maps.event).$.removeListener(listener);
  }
  static void trigger(jsw.IsJsProxy instance, String eventName, List<Object> args) {
    final parameters = new List<Object>();
    parameters.add(instance);
    parameters.add(eventName);
    parameters.addAll(args);
    new jsw.IsJsProxy.fromJsProxy(maps.event).$.trigger(parameters);
  }
}

class MouseEvent extends jsw.IsJsProxy {
  MouseEvent() : super();
  MouseEvent.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  LatLng get latLng => $.latLng.map(LatLng.INSTANCIATOR).value;
}

class LatLng extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new LatLng.fromJsProxy(jsProxy);

  LatLng(num lat, num lng, [bool noWrap]) : super.newInstance(maps.LatLng, [lat, lng, noWrap]);
  LatLng.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  bool equals(LatLng other) => $.equals(other).value;
  num get lat => $.lat().value;
  num get lng => $.lng().value;
  String toString() => $.noSuchMethod(new jsw.ProxyInvocationMirror.method("toString", [])).value;
  String toUrlValue([num precision]) => $.toUrlValue(precision).value;
}

class LatLngBounds extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new LatLngBounds.fromJsProxy(jsProxy);

  LatLngBounds([LatLng sw, LatLng ne]) : super.newInstance(maps.LatLngBounds, [sw, ne]);
  LatLngBounds.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  bool contains(LatLng latLng) => $.contains(latLng).value;
  bool equals(LatLngBounds other) => $.equals(other).value;
  LatLngBounds extend(LatLng point) => $.extend(point).map(LatLngBounds.INSTANCIATOR).value;
  LatLng get center => $.getCenter().map(LatLng.INSTANCIATOR).value;
  LatLng get northEast => $.getNorthEast().map(LatLng.INSTANCIATOR).value;
  LatLng get southWest => $.getSouthWest().map(LatLng.INSTANCIATOR).value;
  bool intersects(LatLngBounds other) => $.intersects(other).value;
  bool isEmpty() => $.isEmpty().value;
  LatLng toSpan() => $.toSpan().map(LatLng.INSTANCIATOR).value;
  String toString() => $.noSuchMethod(new jsw.ProxyInvocationMirror.method("toString", [])).value;
  String toUrlValue([num precision]) => $.toUrlValue(precision).value;
  bool union(LatLngBounds other) => $.union(other).value;
}

class Point extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new Point.fromJsProxy(jsProxy);

  Point(num x, num y) : super.newInstance(maps.Point, [x, y]);
  Point.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  bool equals(Point other) => $.equals(other).value;
  String toString() => $.noSuchMethod(new jsw.ProxyInvocationMirror.method("toString", [])).value;

  num get x => $.x.value;
  set x(num x) => $.x = x;
  num get y => $.y.value;
  set y(num y) => $.y = y;
}

class Size extends jsw.IsJsProxy {
  static final INSTANCIATOR = (js.Proxy jsProxy) => new Size.fromJsProxy(jsProxy);

  Size(num width, num height, [String widthUnit, String heightUnit]) : super.newInstance(maps.Size, [width, height, widthUnit, heightUnit]);
  Size.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);

  bool equals(Size other) => $.equals(other).value;
  String toString() => $.noSuchMethod(new jsw.ProxyInvocationMirror.method("toString", [])).value;

  num get height => $.height.value;
  set height(num height) => $.height = height;
  num get width => $.width.value;
  set width(num width) => $.width = width;
}

class MVCObject extends jsw.IsJsProxy {
  MVCObject() : super.newInstance(maps.MVCObject);
  MVCObject.fromJsProxy(js.Proxy jsProxy) : super.fromJsProxy(jsProxy);
  MVCObject.newInstance(objectName, [List args]) : super.newInstance(objectName, args);

  void bindTo(String key, MVCObject target, [String targetKey, bool noNotify]) { $.bindTo(key, target, targetKey, noNotify); }
  void changed(String key) { $.changed(key); }
  Object get(String key) => $.get(key).value;
  void notify(String key) { $.notify(key); }
  void set(String key, Object value) { $.set(key, value); }
  set values(Map<String, Object> values) {
    final valuesJs = new jsw.IsJsProxy();
    values.forEach((String key, Object value) {
      $[key] = value;
    });
    $.setValues(valuesJs);
  }
  void unbind(String key) { $.unbind(key); }
  void unbindAll() { $.unbindAll(); }
}

class MVCArray<E> extends MVCObject {
  jsw.Transformater _transform;

  MVCArray([List<E> array, jsw.Transformater transform]) : super.newInstance(maps.MVCArray, [array]) {
    _transform = ?transform ? transform : ((e) => e);
  }
  MVCArray.fromJsProxy(js.Proxy jsProxy, [jsw.Transformater transform]) : super.fromJsProxy(jsProxy) {
    _transform = ?transform ? transform : ((e) => e);
  }

  void clear() { $.clear(); }
  void forEach(void callback(E o, num index)) {
    $.forEach(new jsw.Callback.once((Option<Object> o, Option<num> index) => callback(o.map(_transform).value, index.value)));
  }
  List<E> getArray() => $.getArray().map((js.Proxy jsProxy) => new jsw.JsList<E>.fromJsProxy(jsProxy, _transform)).value;
  E getAt(num i) => $.getAt(i).map(_transform).value;
  num get length => $.getLength().value;
  void insertAt(num i, E elem) { $.insertAt(i, elem); }
  E pop() => $.pop().map(_transform).value;
  num push(E elem) => $.push(elem).value;
  E removeAt(num i) => $.removeAt(i).map(_transform).value;
  void setAt(num i, E elem) { $.setAt(i, elem); }

  MVCArrayEvents<E> get on => new MVCArrayEvents<E>._(this);
}

class MVCArrayEvents<E> {
  static final INSERT_AT = "insert_at";
  static final REMOVE_AT = "remove_at";
  static final SET_AT = "set_at";
  
  final MVCArray<E> _mvcArray;

  MVCArrayEvents._(this._mvcArray);

  NumEventListenerAdder get insertAt => new NumEventListenerAdder(_mvcArray, INSERT_AT);
  NumAndElementEventListenerAdder<E> get removeAt => new NumAndElementEventListenerAdder<E>(_mvcArray, REMOVE_AT, _mvcArray._transform);
  NumAndElementEventListenerAdder<E> get setAt => new NumAndElementEventListenerAdder<E>(_mvcArray, SET_AT, _mvcArray._transform);
}

class EventListenerAdder {
  final jsw.IsJsProxy _instance;
  final String _eventName;

  EventListenerAdder(this._instance, this._eventName);

  void add(Function handler) { Events.addListener(_instance, _eventName, handler); }
  MapsEventListenerRegistration addTemporary(Function handler) => new MapsEventListenerRegistration._(jsw.retain(Events.addListener(_instance, _eventName, handler)));
}

class MapsEventListenerRegistration {
  final MapsEventListener _mapsEventListener;
  MapsEventListenerRegistration._(this._mapsEventListener);

  void removeListener() {
    js.scoped(() {
      Events.removeListener(_mapsEventListener);
      jsw.release(_mapsEventListener);
    });
  }
}

class NoArgsEventListenerAdder extends EventListenerAdder {
  NoArgsEventListenerAdder(jsw.IsJsProxy _instance, String _eventName) : super(_instance, _eventName);

  void add(void handler()) => super.add(() => handler());
  MapsEventListenerRegistration addTemporary(void handler()) => super.addTemporary(() => handler());
}

class NativeEventListenerAdder extends EventListenerAdder {
  NativeEventListenerAdder(jsw.IsJsProxy _instance, String _eventName) : super(_instance, _eventName);

  void add(void handler(MouseEvent e)) { super.add((e) => handler(e.map((e) => new NativeEvent.fromJsProxy(e)).value)); }
  MapsEventListenerRegistration addTemporary(void handler(NativeEvent e)) => super.addTemporary((e) => handler(e.map((e) => new NativeEvent.fromJsProxy(e)).value));
}

class MouseEventListenerAdder extends EventListenerAdder {
  MouseEventListenerAdder(jsw.IsJsProxy _instance, String _eventName) : super(_instance, _eventName);

  void add(void handler(MouseEvent e)) { super.add((e) => handler(e.map((e) => new MouseEvent.fromJsProxy(e)).value)); }
  MapsEventListenerRegistration addTemporary(void handler(MouseEvent e)) => super.addTemporary((e) => handler(e.map((e) => new MouseEvent.fromJsProxy(e)).value));
}

class PolyMouseEventListenerAdder extends EventListenerAdder {
  PolyMouseEventListenerAdder(jsw.IsJsProxy _instance, String _eventName) : super(_instance, _eventName);

  void add(void handler(PolyMouseEvent e)) { super.add((e) => handler(e.map((e) => new PolyMouseEvent.fromJsProxy(e)).value)); }
  MapsEventListenerRegistration addTemporary(void handler(PolyMouseEvent e)) => super.addTemporary((e) => handler(e.map((e) => new PolyMouseEvent.fromJsProxy(e)).value));
}

class FusionTablesMouseEventListenerAdder extends EventListenerAdder {
  FusionTablesMouseEventListenerAdder(jsw.IsJsProxy _instance, String _eventName) : super(_instance, _eventName);

  void add(void handler(FusionTablesMouseEvent e)) { super.add((e) => handler(e.map((e) => new FusionTablesMouseEvent.fromJsProxy(e)).value)); }
  MapsEventListenerRegistration addTemporary(void handler(FusionTablesMouseEvent e)) => super.addTemporary((e) => handler(e.map((e) => new FusionTablesMouseEvent.fromJsProxy(e)).value));
}

class KmlMouseEventListenerAdder extends EventListenerAdder {
  KmlMouseEventListenerAdder(jsw.IsJsProxy _instance, String _eventName) : super(_instance, _eventName);

  void add(void handler(KmlMouseEvent e)) { super.add((e) => handler(e.map((e) => new KmlMouseEvent.fromJsProxy(e)).value)); }
  MapsEventListenerRegistration addTemporary(void handler(KmlMouseEvent e)) => super.addTemporary((e) => handler(e.map((e) => new KmlMouseEvent.fromJsProxy(e)).value));
}

class NumEventListenerAdder extends EventListenerAdder {
  NumEventListenerAdder(jsw.IsJsProxy _instance, String _eventName) : super(_instance, _eventName);

  void add(void handler(num number)) { super.add((e) => handler(e.value)); }
  MapsEventListenerRegistration addTemporary(void handler(num number)) => super.addTemporary((e) => handler(e.value));
}

class NumAndElementEventListenerAdder<E> extends EventListenerAdder {
  jsw.Transformater _transform;

  NumAndElementEventListenerAdder(jsw.IsJsProxy _instance, String _eventName, this._transform) : super(_instance, _eventName);

  void add(void handler(num number, E e)) { super.add((number, e) => handler(number.value, e.map(_transform).value)); }
  MapsEventListenerRegistration addTemporary(void handler(num number, E e)) => super.addTemporary((number, e) => handler(number.value, e.map(_transform).value));
}

