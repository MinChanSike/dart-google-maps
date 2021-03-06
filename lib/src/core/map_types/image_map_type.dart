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

part of google_maps;

// TODO extends MVCObject mixin MapType
class ImageMapType extends MapType {
  static ImageMapType cast(js.Proxy proxy) => proxy == null ? null : new ImageMapType.fromProxy(proxy);

  SubscribeStreamProvider _onTilesloaded;

  ImageMapType(ImageMapTypeOptions opts) : super(maps.ImageMapType, [opts]) { _initStreams(); }
  ImageMapType.fromProxy(js.Proxy proxy) : super.fromProxy(proxy) { _initStreams(); }

  void _initStreams() {
    _onTilesloaded = event.getStreamProviderFor(this, "tilesloaded");
  }

  Stream get onTilesloaded => _onTilesloaded.stream;

  num get opacity => $unsafe.getOpacity();
  set opacity(num opacity) => $unsafe.setOpacity(opacity);

  /// deprecated : use onXxx stream.
  @deprecated ImageMapTypeEvents get on => new ImageMapTypeEvents._(this);
}

@deprecated
class ImageMapTypeEvents {
  static final TILESLOADED = "tilesloaded";

  final ImageMapType _imageMapType;

  ImageMapTypeEvents._(this._imageMapType);

  NoArgsEventListenerAdder get tilesloaded => new NoArgsEventListenerAdder(_imageMapType, TILESLOADED);
}