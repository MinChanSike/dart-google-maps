// Copyright (c) 2013, Alexandre Ardhuin
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

part of google_maps_visualization;

class DemographicsLayerOptions extends jsw.TypedProxy {
  static DemographicsLayerOptions cast(js.Proxy proxy) => proxy == null ? null : new DemographicsLayerOptions.fromProxy(proxy);

  DemographicsLayerOptions() : super();
  DemographicsLayerOptions.fromProxy(js.Proxy proxy) : super.fromProxy(proxy);

  bool get clickable => $unsafe['clickable'];
  GMap get map => GMap.cast($unsafe['map']);
  DemographicsQuery get query => DemographicsQuery.cast($unsafe['query']);
  List<DemographicsStyle> get style => jsw.JsArrayToListAdapter.castListOfSerializables($unsafe['style'], DemographicsStyle.cast);
  bool get suppressInfoWindows => $unsafe['suppressInfoWindows'];
  set clickable(bool clickable) => $unsafe['clickable'] = clickable;
  set map(GMap map) => $unsafe['map'] = map;
  set query(DemographicsQuery query) => $unsafe['query'] = query;
  set style(List<DemographicsStyle> style) => $unsafe['style'] = jsifyList(style);
  // TODO bad type in doc
  set suppressInfoWindows(bool suppressInfoWindows) => $unsafe['suppressInfoWindows'] = suppressInfoWindows;
}