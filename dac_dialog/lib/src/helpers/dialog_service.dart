// Standard class for dialog operationss
import 'package:flutter/material.dart';

abstract class DialogService {
  /// Returns the dialog to be rendered.
  Widget buildDialog();

  /// Invoked when the user wants to show the dialog.
  Future<void> show();

  /// Invoked when the user wants to close the dialog.
  void close();
}
