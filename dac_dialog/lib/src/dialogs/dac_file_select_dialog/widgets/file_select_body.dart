import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:pdax_dialog/src/dialogs/pdax_file_select_dialog/widgets/empty_selection_placeholder.dart';
import 'package:pdax_dialog/src/dialogs/pdax_file_select_dialog/widgets/file_item_container.dart';
import 'package:pdax_dialog/src/dialogs/pdax_file_select_dialog/widgets/file_selection_menu.dart';
import 'package:pdax_dialog/src/enums/file_format.dart';
import 'package:pdax_dialog/src/helpers/file_picker_service.dart';
import 'package:pdax_dialog/src/models/selected_file.dart';
import 'package:pdax_dialog/src/shared_widgets/custom_button.dart';

class FileSelectBody extends StatefulWidget {
  const FileSelectBody({
    Key? key,
    this.supportedFormats,
    required this.withData,
    required this.allowMultiple,
    this.title,
    required this.positiveActionText,
    required this.negativeActionText,
    required this.fileSelectText,
    required this.clearSelectionText,
    required this.browsePlaceholderText,
    required this.actionButtonsHeight,
    required this.actionButtonBorderRadius,
    this.titleTextStyle,
    this.fileSelectTextStyle,
    this.clearSelectionTextStyle,
    this.browsePlaceholderTextStyle,
    this.positiveActionTextStyle,
    this.negativeActionTextStyle,
    required this.positiveActionColor,
    required this.negativeActionBorderColor,
    required this.browsePlaceholderBorderColor,
    required this.onUpload,
    this.onCancel,
    required this.onClose,
  }) : super(key: key);

  final List<FileFormat>? supportedFormats;
  final bool withData;

  final bool allowMultiple;
  final String? title;
  final String positiveActionText;
  final String negativeActionText;
  final String fileSelectText;
  final String clearSelectionText;
  final String browsePlaceholderText;
  final double actionButtonsHeight;
  final double actionButtonBorderRadius;
  final TextStyle? titleTextStyle;
  final TextStyle? browsePlaceholderTextStyle;
  final TextStyle? fileSelectTextStyle;
  final TextStyle? clearSelectionTextStyle;
  final TextStyle? positiveActionTextStyle;
  final TextStyle? negativeActionTextStyle;
  final Color positiveActionColor;
  final Color negativeActionBorderColor;
  final Color browsePlaceholderBorderColor;
  final ValueChanged<List<SelectedFile>> onUpload;
  final VoidCallback? onCancel;
  final VoidCallback onClose;

  @override
  State<FileSelectBody> createState() => _FileSelectBodyState();
}

class _FileSelectBodyState extends State<FileSelectBody> {
  late final FilePickerService _filePickerService;

  late List<SelectedFile> _selectedFiles;

  Future<void> _selectFiles() async {
    List<SelectedFile>? files = await _filePickerService.pickFiles();

    if (files != null) {
      setState(() {
        if (widget.allowMultiple) {
          _selectedFiles.addAll(files);
        } else {
          _selectedFiles.clear();
          _selectedFiles.add(files.first);
        }
      });
    }
  }

  void _clearSelection() {
    setState(() {
      _selectedFiles.clear();
    });
  }

  void _unselectFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  void initState() {
    _filePickerService = FilePickerService(
      withData: widget.withData,
      allowMultiple: widget.allowMultiple,
      allowedExtensions: widget.supportedFormats,
    );

    _selectedFiles = <SelectedFile>[];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        (widget.title != null)
            ? Padding(
                padding: const EdgeInsets.all(25.0),
                child: Text(
                  widget.title!,
                  textAlign: TextAlign.center,
                  style: (widget.titleTextStyle != null)
                      ? widget.titleTextStyle
                      : const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                ),
              )
            : const SizedBox.shrink(),
        FileSelectionMenu(
          fileSelectText: widget.fileSelectText,
          onSelect: _selectFiles,
          clearSelectionText: widget.clearSelectionText,
          onClear: _clearSelection,
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          height: 200.0,
          child: DottedBorder(
            borderType: BorderType.RRect,
            dashPattern: const [5, 2],
            radius: const Radius.circular(8.0),
            color: widget.browsePlaceholderBorderColor,
            child: (_selectedFiles.isNotEmpty)
                ? ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _selectedFiles.length,
                    itemBuilder: (context, index) {
                      return FileItemContainer(
                        name: _selectedFiles[index].name,
                        borderColor: widget.browsePlaceholderBorderColor,
                        onUnselect: () => _unselectFile(index),
                      );
                    },
                  )
                : EmptySelectionPlaceholder(
                    text: widget.browsePlaceholderText,
                    textStyle: widget.browsePlaceholderTextStyle,
                  ),
          ),
        ),
        const SizedBox(height: 25.0),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                key: const Key('negativeAction'),
                text: widget.negativeActionText,
                textStyle: widget.negativeActionTextStyle,
                minHeight: widget.actionButtonsHeight,
                borderRadius: widget.actionButtonBorderRadius,
                isOutlined: true,
                isFilled: false,
                fillColor: Colors.transparent,
                borderColor: widget.negativeActionBorderColor,
                onPressed: () {
                  widget.onClose();

                  if (widget.onCancel != null) widget.onCancel!();
                },
              ),
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: CustomButton(
                key: const Key('positiveAction'),
                text: widget.positiveActionText,
                textStyle: widget.positiveActionTextStyle,
                minHeight: widget.actionButtonsHeight,
                isOutlined: false,
                borderRadius: widget.actionButtonBorderRadius,
                fillColor: widget.positiveActionColor,
                borderColor: Colors.transparent,
                onPressed: (_selectedFiles.isNotEmpty)
                    ? () => widget.onUpload(_selectedFiles)
                    : null,
              ),
            ),
          ],
        )
      ],
    );
  }
}
