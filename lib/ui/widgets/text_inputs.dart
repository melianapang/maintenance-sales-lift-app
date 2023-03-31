import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';
import 'package:rejo_jaya_sakti_apps/ui/shared/spacings.dart';

class TextInput extends StatelessWidget {
  factory TextInput.disabled({
    required String label,
    String? text,
    String hintText = '',
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color? backgroundColor = MyColors.darkBlack02,
  }) {
    final controller = TextEditingController();
    controller.text = text ?? '';
    return TextInput(
      controller: controller,
      backgroundColor: backgroundColor,
      label: label,
      enabled: false,
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
    );
  }

  factory TextInput.editable({
    String? label,
    required void Function(String text) onChangedListener,
    String? text,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isPassword = false,
    String hintText = '',
    int? maxLines,
    int? maxLength,
    String? note,
    Color? borderColor,
    Color? backgroundColor = MyColors.darkBlack02,
    String? errorText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final controller = TextEditingController();
    controller.text = text ?? '';
    return TextInput(
      controller: controller,
      onChangedListener: onChangedListener,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      label: label,
      note: note,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: true,
      hintText: hintText,
      errorText: errorText,
      isPassword: isPassword,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      keyboardType: keyboardType,
    );
  }

  factory TextInput.multiline({
    required void Function(String text) onChangedListener,
    required String label,
    String? text,
    required int minLines,
    required int maxLines,
    int? maxLength,
    String? note,
    Color backgroundColor = MyColors.darkBlack02,
    String? hintText,
  }) {
    final controller = TextEditingController();
    controller.text = text ?? '';
    return TextInput(
      controller: controller,
      onChangedListener: onChangedListener,
      backgroundColor: backgroundColor,
      minLines: minLines,
      maxLines: maxLines,
      maxLength: maxLength,
      label: label,
      note: note,
      enabled: true,
      hintText: hintText,
      keyboardType: TextInputType.multiline,
    );
  }

  factory TextInput.disabledMultiline({
    required String label,
    required String text,
    Color backgroundColor = MyColors.darkBlack02,
    String? hintText,
  }) {
    final controller = TextEditingController();
    controller.text = text;
    return TextInput(
      controller: controller,
      backgroundColor: backgroundColor,
      maxLines: null,
      label: label,
      enabled: false,
      hintText: hintText,
      keyboardType: TextInputType.multiline,
    );
  }

  const TextInput({
    this.controller,
    this.enabled = true,
    this.label,
    this.note,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.keyboardType,
    this.errorText,
    this.backgroundColor,
    this.borderColor,
    this.onChangedListener,
    this.fontColor = MyColors.white,
    super.key,
  });

  final TextEditingController? controller;
  final void Function(String)? onChangedListener;
  final bool enabled;
  final String? label;
  final String? note;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? errorText;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color fontColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label ?? "",
            style: buildTextStyle(
              fontSize: 14,
              fontColor: MyColors.lightBlack02,
            ),
          ),
          Spacings.vert(8),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          minLines: minLines,
          maxLines: maxLines,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              maxLength,
            ),
          ],
          onChanged: onChangedListener,
          style: buildTextStyle(
            fontSize: 14,
            fontColor: fontColor,
            fontWeight: 400,
          ),
          decoration: InputDecoration(
            enabled: enabled,
            hintText: hintText,
            hintStyle: buildTextStyle(
              fontSize: 14,
              fontWeight: 300,
              fontColor: MyColors.greyColor,
              isItalic: true,
            ),
            prefixIcon: prefixIcon,
            errorText: errorText,
            suffixIcon: suffixIcon,
            filled: backgroundColor != null,
            fillColor: backgroundColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: borderColor ?? MyColors.transparent,
              ),
            ),
            errorStyle: const TextStyle(color: Colors.redAccent),
            border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              borderSide: BorderSide(
                color: borderColor ?? MyColors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(20.0),
              ),
              borderSide: BorderSide(
                color: borderColor ?? MyColors.darkBlack01,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              borderSide: BorderSide(
                color: Colors.redAccent,
              ),
            ),
          ),
          obscureText: isPassword,
        ),
        if (note != null) ...[
          Text(
            note ?? "",
            style: buildTextStyle(
              fontSize: 12,
              fontColor: MyColors.lightBlack01,
            ),
          ),
        ],
      ],
    );
  }
}
