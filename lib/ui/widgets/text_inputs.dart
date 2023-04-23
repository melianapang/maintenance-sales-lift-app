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
    TextEditingController? controller,
    String? label,
    void Function(String text)? onChangedListener,
    bool? isEnabled,
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
    String? Function(String?)? validator,
  }) {
    return TextInput(
      controller: controller,
      onChangedListener: onChangedListener,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      label: label,
      note: note,
      maxLength: maxLength,
      maxLines: maxLines,
      enabled: isEnabled ?? true,
      hintText: hintText,
      errorText: errorText,
      isPassword: isPassword,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      keyboardType: keyboardType,
      validator: validator,
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
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
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
  final String? Function(String?)? validator;
  final AutovalidateMode autovalidateMode;

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
            if (keyboardType == TextInputType.phone ||
                keyboardType == TextInputType.number)
              FilteringTextInputFormatter.digitsOnly,
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
          validator: validator,
          autovalidateMode: autovalidateMode,
        ),
        if (note != null) ...[
          Spacings.vert(4),
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
