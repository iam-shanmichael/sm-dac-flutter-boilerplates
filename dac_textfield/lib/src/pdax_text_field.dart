import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PdaxTextField extends StatefulWidget {
  const PdaxTextField({
    Key? key,
    required this.initialValue,
    this.controller,
    this.width = 200,
    this.height = 40,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.textStyle,
    this.hintText,
    this.hintStyle,
    this.contentPadding,
    this.enabled = true,
    this.obscureText = false,
    this.isCurrency = false,
    this.prefixText = 'PHP',
    this.prefixTextStyle,
    this.keyboardType,
    this.maxLength,
  }) : super(key: key);

  /// TextField Controller
  final String? initialValue;

  /// TextField Controller
  final TextEditingController? controller;

  /// Total Width of the  Text Field
  final double width;

  /// Total Height of the  Text Field
  final double height;

  /// The background color of the Text field
  final Color? backgroundColor;

  /// If null, the corners of this box are rounded by this
  final BorderRadius? borderRadius;

  /// A border to draw above the background
  final Border? border;

  /// The style of the text input
  final TextStyle? textStyle;

  final String? hintText;

  /// The style of the hint text
  final TextStyle? hintStyle;

  /// The padding for the input.
  final EdgeInsets? contentPadding;

  /// If false helperText,errorText, and counterText are not displayed, and the opacity of the remaining visual elements is reduced.
  final bool enabled;

  /// Whether to hide the text being edited (e.g., for passwords).
  final bool obscureText;

  final bool isCurrency;

  /// The prefix text when the [isCurrency] is true
  final String prefixText;

  /// The style of the prefix text
  final TextStyle? prefixTextStyle;

  final TextInputType? keyboardType;

  /// Max length of the inputs
  final int? maxLength;

  @override
  State<PdaxTextField> createState() => _PdaxTextFieldState();
}

class _PdaxTextFieldState extends State<PdaxTextField> {
  TextStyle? defaultTextStyle;

  TextStyle? defaultHintStyle;

  @override
  void initState() {
    super.initState();

    defaultTextStyle = const TextStyle(
      fontSize: 12.0,
      color: Colors.black,
    );

    defaultHintStyle = TextStyle(
      fontSize: 12.0,
      color: Colors.grey[400],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.enabled ? widget.backgroundColor ?? Colors.white : Colors.grey[500],
        borderRadius:
            widget.borderRadius ?? (widget.isCurrency == true ? BorderRadius.circular(0) : BorderRadius.circular(16)),
        border: widget.border ?? Border.all(width: 1, color: const Color(0xFFdae9fc)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
          ),
        ],
      ),
      child: TextFormField(
        initialValue: 'Hello',
        controller: widget.controller,
        maxLength: widget.isCurrency ? 5 : widget.maxLength,
        inputFormatters: widget.isCurrency
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ]
            : null,
        keyboardType: widget.keyboardType ?? (widget.isCurrency ? TextInputType.number : TextInputType.text),
        style: widget.textStyle ?? defaultTextStyle,
        enabled: widget.enabled,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          hintText: widget.hintText ?? '',
          hintStyle: widget.hintStyle ?? defaultHintStyle,
          counterText: '',
          prefixIcon: widget.isCurrency
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.prefixText,
                        style: defaultHintStyle,
                      ),
                    )
                  ],
                )
              : null,
          contentPadding:
              widget.contentPadding ?? (widget.isCurrency ? null : const EdgeInsets.only(left: 10, bottom: 10)),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          disabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
          ),
        ),
      ),
    );
  }
}
