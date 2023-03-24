import 'package:flutter/material.dart';
import 'package:rejo_jaya_sakti_apps/core/app_constants/colors.dart';
import 'package:rejo_jaya_sakti_apps/core/utilities/text_styles.dart';

enum ButtonType { primary, secondary, negative, canceled, filterButton }

enum ButtonSize { large, medium, small }

extension ButtonTypeExt on ButtonType {
  static Map<ButtonType, Color> backgroundColors = <ButtonType, Color>{
    ButtonType.primary: MyColors.yellow01,
    ButtonType.secondary: MyColors.secondaryLightBlack,
    ButtonType.negative: MyColors.red001,
    ButtonType.canceled: MyColors.lightGrey,
    ButtonType.filterButton: MyColors.lightGrey,
  };
  Color get backgroundColor => backgroundColors[this] ?? Colors.transparent;

  static const Map<ButtonType, Color> backgroundDisabledColors =
      <ButtonType, Color>{
    ButtonType.primary: MyColors.lightBlack01,
    ButtonType.secondary: MyColors.lightGrey,
    ButtonType.negative: MyColors.lightBlack002,
    ButtonType.filterButton: MyColors.lightGrey,
  };
  Color get backgroundDisabled => backgroundDisabledColors[this]!;

  static const Map<ButtonType, Color> backgroundPressedColors =
      <ButtonType, Color>{
    ButtonType.primary: MyColors.yellow02,
    ButtonType.secondary: MyColors.lightBlack02,
    ButtonType.negative: MyColors.negativeColor,
    ButtonType.filterButton: MyColors.lightBlue01,
  };
  Color get backgroundPressedColor => backgroundPressedColors[this]!;

  static const Map<ButtonType, Color> foregroundColors = <ButtonType, Color>{
    ButtonType.primary: MyColors.white,
    ButtonType.secondary: MyColors.white,
    ButtonType.negative: MyColors.white,
    ButtonType.filterButton: MyColors.lightBlue01,
  };
  Color get foregroundColor => foregroundColors[this]!;

  static const Map<ButtonType, Color> foregroundPressedColors =
      <ButtonType, Color>{
    ButtonType.primary: MyColors.white,
    ButtonType.secondary: MyColors.white,
    ButtonType.negative: MyColors.white,
    ButtonType.filterButton: MyColors.darkBlue02,
  };
  Color get foregroundPressedColor => foregroundPressedColors[this]!;

  static const Map<ButtonType, Color> textColors = <ButtonType, Color>{
    ButtonType.primary: MyColors.darkBlack01,
    ButtonType.secondary: MyColors.yellow01,
    ButtonType.negative: MyColors.white,
    ButtonType.filterButton: MyColors.white,
  };
  Color? get textColor => textColors[this];

  static const Map<ButtonType, Color> disabledTextColors = <ButtonType, Color>{
    ButtonType.primary: MyColors.lightBlack02,
    ButtonType.secondary: MyColors.secondaryLightBlack,
    ButtonType.negative: MyColors.white,
    ButtonType.filterButton: MyColors.black,
  };
  Color? get disabledTextColor => disabledTextColors[this];

  static const Map<ButtonType, Color> borderColors = <ButtonType, Color>{
    ButtonType.negative: MyColors.lightBlack002,
    ButtonType.filterButton: MyColors.yellow
  };
  Color? get borderColor => borderColors[this];

  static const Map<ButtonType, FontWeight> fontWeights =
      <ButtonType, FontWeight>{
    ButtonType.primary: FontWeight.w600,
    ButtonType.secondary: FontWeight.w400,
    ButtonType.filterButton: FontWeight.w500,
  };
  FontWeight? get fontWeight => fontWeights[this];

  static const Map<ButtonType, Color> borderPressedColors = <ButtonType, Color>{
    ButtonType.primary: MyColors.darkBlack02,
    ButtonType.secondary: MyColors.secondaryLightBlack,
    ButtonType.filterButton: MyColors.transparent
  };
  Color? get borderPressedColor => borderPressedColors[this];
}

extension ButtonSizeExt on ButtonSize {
  static const Map<ButtonSize, double> linkButtonHeights = <ButtonSize, double>{
    ButtonSize.small: 21,
    ButtonSize.large: 24,
  };

  double get linkButtonHeight => linkButtonHeights[this]!;

  static const Map<ButtonSize, double> fontSizes = <ButtonSize, double>{
    ButtonSize.small: 10,
    ButtonSize.medium: 12,
    ButtonSize.large: 16,
  };

  double get fontSize => fontSizes[this]!;

  static const Map<ButtonSize, double> iconSizes = <ButtonSize, double>{
    ButtonSize.small: 14,
    ButtonSize.medium: 18,
    ButtonSize.large: 22,
  };

  double get iconSize => iconSizes[this]!;

  static const Map<ButtonSize, EdgeInsetsGeometry> paddings =
      <ButtonSize, EdgeInsetsGeometry>{
    ButtonSize.small: EdgeInsets.symmetric(
      horizontal: 8,
      vertical: 4,
    ),
    ButtonSize.medium: EdgeInsets.symmetric(
      horizontal: 12,
      vertical: 8,
    ),
    ButtonSize.large: EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 18,
    ),
  };

  EdgeInsetsGeometry get padding => paddings[this]!;

  static const Map<ButtonSize, double> reducedHeights = <ButtonSize, double>{
    ButtonSize.small: 12,
    ButtonSize.medium: 16,
    ButtonSize.large: 24,
  };

  double get reducedHeight => reducedHeights[this]!;
}

class ButtonWidget extends StatelessWidget {
  factory ButtonWidget.bottomSingleButton(
      {required VoidCallback onTap,
      required String text,
      required ButtonType buttonType,
      required EdgeInsets padding}) {
    return ButtonWidget(
      buttonType: buttonType,
      text: text,
      padding: padding,
      onTap: onTap,
    );
  }

  const ButtonWidget({
    required this.buttonType,
    this.buttonSize = ButtonSize.large,
    required this.text,
    this.textStyle,
    this.onTap,
    this.padding,
    super.key,
  });

  final ButtonType buttonType;
  final ButtonSize buttonSize;
  final String text;
  final TextStyle? textStyle;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  ButtonStyle createStyle({
    required Color background,
    required Color backgroundDisabled,
    required Color backgroundPressed,
    required Color foreground,
    required Color foregroundDisabled,
    required Color foregroundPressed,
    required Color shadowColor,
    required Color overlayColor,
    required EdgeInsetsGeometry padding,
    required OutlinedBorder? border,
    required OutlinedBorder? borderPressed,
  }) {
    final MaterialStateProperty<Color> backgroundColor =
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return backgroundDisabled;
      } else if (states.contains(MaterialState.pressed)) {
        return backgroundPressed;
      }
      return background;
    });
    final MaterialStateProperty<Color> foregroundColor =
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      if (states.contains(MaterialState.disabled)) {
        return foregroundDisabled;
      } else if (states.contains(MaterialState.pressed)) {
        return foregroundPressed;
      }
      return foreground;
    });
    final MaterialStateProperty<OutlinedBorder?> shape =
        MaterialStateProperty.resolveWith((Set<MaterialState> states) {
      return border;
    });

    return ButtonStyle(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      overlayColor: MaterialStateProperty.all<Color>(overlayColor),
      shadowColor: ButtonStyleButton.allOrNull<Color>(shadowColor),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(padding),
      shape: shape,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      minimumSize: MaterialStateProperty.all<Size>(Size(10, 21)),
    );
  }

  RoundedRectangleBorder? get border => buttonType.borderColor != null
      ? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: buttonType.borderColor!,
            width: 1,
          ),
        )
      : RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        );

  RoundedRectangleBorder? get borderPressed =>
      buttonType.borderPressedColor != null
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: buttonType.borderPressedColor!,
                width: 2,
              ),
            )
          : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: ElevatedButton(
        onPressed: onTap,
        style: createStyle(
          padding: buttonSize.padding,
          background: buttonType.backgroundColor,
          backgroundDisabled: buttonType.backgroundDisabled,
          backgroundPressed: buttonType.backgroundPressedColor,
          foreground: buttonType.foregroundColor,
          foregroundDisabled: MyColors.lightBlack001,
          foregroundPressed: buttonType.foregroundPressedColor,
          overlayColor: Colors.transparent,
          shadowColor: Colors.transparent,
          border: border,
          borderPressed: borderPressed,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // if (icon != null) ...<Widget>[
            //   Icon(
            //     icon,
            //     size: size.iconSize,
            //   ),
            //   Spacings.horzSpace(10.5),
            // ],
            Text(
              text,
              style: TextStyle(
                fontSize: buttonSize.fontSize,
                fontWeight: buttonType.fontWeight ?? FontWeight.w600,
                height: 14.84 / buttonSize.fontSize,
                color: onTap == null
                    ? buttonType.disabledTextColor
                    : buttonType.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _textStyle {
    return textStyle ?? buildTextStyle(fontSize: 14);
  }
}
