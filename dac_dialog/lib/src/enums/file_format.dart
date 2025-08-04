enum FileFormat { csv, png, jpg }

extension FileFormatExt on FileFormat {
  String format() {
    switch (this) {
      case FileFormat.csv:
        return 'csv';
      case FileFormat.png:
        return 'png';
      case FileFormat.jpg:
        return 'jpg';
    }
  }
}
