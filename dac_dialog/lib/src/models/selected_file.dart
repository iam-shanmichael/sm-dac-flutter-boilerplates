import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class SelectedFile {
  SelectedFile({
    String? path,
    this.bytes,
    required this.name,
  }) : _path = path;

  /// File name including its extension.
  final String name;

  /// Byte data for this file. Particurlarly useful if you want to manipulate its data
  /// or easily upload to somewhere else.
  /// [Check here in the FAQ](https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ) an example on how to use it to upload on web.
  final Uint8List? bytes;

  /// The absolute path for a cached copy of this file. It can be used to create a
  /// file instance with a descriptor for the given path.
  /// ```
  /// final File myFile = File(platformFile.path);
  /// ```
  /// On web this is always `null`. You should access `bytes` property instead.
  /// Read more about it [here](https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ)
  final String? _path;

  factory SelectedFile.fromPlatformFile(PlatformFile platformFile) {
    return SelectedFile(
      name: platformFile.name,
      path: (!kIsWeb) ? platformFile.path : null,
      bytes: platformFile.bytes,
    );
  }

  /// File extension for this file.
  String? get extension => name.split('.').last;

  String? get path {
    if (kIsWeb) {
      /// https://github.com/miguelpruivo/flutter_file_picker/issues/751
      throw '''
      On web `path` is always `null`,
      You should access `bytes` property instead,
      Read more about it [here](https://github.com/miguelpruivo/flutter_file_picker/wiki/FAQ)
      ''';
    }

    return _path;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is SelectedFile &&
        (kIsWeb || other.path == path) &&
        other.name == name &&
        other.bytes == bytes;
  }

  @override
  int get hashCode {
    return kIsWeb ? 0 : path.hashCode ^ name.hashCode ^ bytes.hashCode;
  }

  @override
  String toString() {
    return 'SelectedFile(${kIsWeb ? '' : 'path $path'}, name: $name, bytes: $bytes)';
  }
}
