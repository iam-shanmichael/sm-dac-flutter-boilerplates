import 'package:file_picker/file_picker.dart';
import 'package:pdax_dialog/src/enums/file_format.dart';
import 'package:pdax_dialog/src/models/selected_file.dart';

// Helper for file picker
class FilePickerService {
  FilePickerService({
    this.withData = true,
    this.allowMultiple = true,
    this.allowedExtensions,
  });

  final bool withData;

  final bool allowMultiple;

  final List<FileFormat>? allowedExtensions;

  Future<List<SelectedFile>?> pickFiles() async {
    List<String> extensions = <String>[];
    List<SelectedFile> selectedFiles = <SelectedFile>[];

    if (allowedExtensions != null) {
      for (FileFormat ext in allowedExtensions!) {
        extensions.add(ext.format());
      }
    }

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: allowMultiple,
      withData: withData,
      allowCompression: true,
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (result != null) {
      for (PlatformFile res in result.files) {
        selectedFiles.add(SelectedFile.fromPlatformFile(res));
      }
    }

    return (selectedFiles.isNotEmpty) ? selectedFiles : null;
  }
}
