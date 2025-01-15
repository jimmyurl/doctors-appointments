import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart' hide OnTap;
import 'package:get/get.dart';

import '../app/services/settings_service.dart';

class Ui {
  static GetSnackBar SuccessSnackBar({String title = 'Success', String message = ''}) {
    Get.log("[$title] $message");
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message??'', style: Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Colors.green,
      icon: Icon(Icons.check_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 5),
    );
  }

  static GetSnackBar ErrorSnackBar({String title = 'Error', String message = ''}) {
    Get.log("[$title] $message", isError: true);
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.primaryColor))),
      messageText: Text(message?.substring(0, min(message.length, 200))??'', style: Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.primaryColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Colors.redAccent,
      icon: Icon(Icons.remove_circle_outline, size: 32, color: Get.theme.primaryColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static GetSnackBar defaultSnackBar({String title = 'Alert', String message = ''}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      titleText: Text(title.tr, style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.hintColor))),
      messageText: Text(message??'', style: Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.focusColor))),
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(20),
      backgroundColor: Get.theme.primaryColor,
      borderColor: Get.theme.focusColor.withOpacity(0.1),
      icon: Icon(Icons.warning_amber_rounded, size: 32, color: Get.theme.hintColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static GetSnackBar notificationSnackBar({String title = 'Notification', String message = '', OnTap? onTap, Widget? mainButton}) {
    Get.log("[$title] $message", isError: false);
    return GetSnackBar(
      onTap: onTap,
      mainButton: mainButton,
      titleText: Text(title.tr, style: Get.textTheme.titleLarge?.merge(TextStyle(color: Get.theme.hintColor))),
      messageText: Text(message, style: Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.focusColor))),
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.all(20),
      backgroundColor: Get.theme.primaryColor,
      borderColor: Get.theme.focusColor.withOpacity(0.1),
      icon: Icon(Icons.notifications_none, size: 32, color: Get.theme.hintColor),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      borderRadius: 8,
      duration: Duration(seconds: 5),
    );
  }

  static Color parseColor(String? hexCode, {double? opacity}) {
    try {
      return Color(int.tryParse(hexCode!.replaceAll("#", "0xFF")) ?? 0).withOpacity(opacity ?? 1);
    } catch (e) {
      return Color(0xFFCCCCCC).withOpacity(opacity ?? 1);
    }
  }

  static List<Icon> getStarsList(double? rate, {double size = 18}) {
    var list = <Icon>[];
    if (rate == null) rate = 0;
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

  static Icon getStarReview(double? rate, {double size = 18}) {
    var icon;
    if (rate == null) rate = 0;
    if (rate == 5){
      icon = Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
  }
    else if (rate - rate.floor() > 0) {
      icon = Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D));
    }
    else {
      icon = Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }
    return icon;
  }

  static Widget getPrice(double? myPrice, {TextStyle? style, String zeroPlaceholder = '-', String? unit}) {
    var _setting = Get.find<SettingsService>();
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize ?? 0 + 2));
    }
    try {
      if (myPrice == 0) {
        return Text('-', style: style ?? Get.textTheme.titleSmall);
      }
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: _setting.setting.value.currencyRight != null && _setting.setting.value.currencyRight == false
            ? TextSpan(
                text: _setting.setting.value.defaultCurrency,
                style: getPriceStyle(style ?? Get.textTheme.titleSmall!),
                children: <TextSpan>[
                  TextSpan(text: myPrice?.toStringAsFixed(_setting.setting.value.defaultCurrencyDecimalDigits ?? 0), style: style ?? Get.textTheme.titleSmall!),
                  if (unit != null) TextSpan(text: " " + unit + " ", style: getPriceStyle(style ?? Get.textTheme.titleSmall)),
                ],
              )
            : TextSpan(
                text: myPrice?.toStringAsFixed(_setting.setting.value.defaultCurrencyDecimalDigits ?? 0 ),
                style: style ?? Get.textTheme.titleSmall,
                children: <TextSpan>[
                  TextSpan(text: _setting.setting.value.defaultCurrency, style: getPriceStyle(style!)),
                  if (unit != null) TextSpan(text: " " + unit + " ", style: getPriceStyle(style)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static TextStyle getPriceStyle(TextStyle? style) {
    if (style == null) {
      return Get.textTheme.titleSmall!.merge(
        TextStyle(fontWeight: FontWeight.w300, fontSize: Get.textTheme.titleSmall!.fontSize! - 4),
      );
    } else {
      return style.merge(TextStyle(fontWeight: FontWeight.w300, fontSize: style.fontSize! - 4));
    }
  }

  static BoxDecoration getBoxDecoration({Color? color, double? radius, Border? border, Gradient? gradient}) {
    return BoxDecoration(
      color: color ?? Get.theme.primaryColor,
      borderRadius: BorderRadius.all(Radius.circular(radius ?? 10)),
      boxShadow: [
        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
      ],
      border: border ?? Border.all(color: Get.theme.focusColor.withOpacity(0.05)),
      gradient: gradient,
    );
  }

  static InputDecoration getInputDecoration({String? hintText = '', String? errorText, IconData? iconData, Widget? suffixIcon, Widget? suffix}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: Get.textTheme.bodySmall,
      prefixIcon: iconData != null ? Icon(iconData, color: Get.theme.focusColor).marginOnly(right: 14) : SizedBox(),
      prefixIconConstraints: iconData != null ? BoxConstraints.expand(width: 38, height: 38) : BoxConstraints.expand(width: 0, height: 0),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      contentPadding: EdgeInsets.all(0),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
      suffixIcon: suffixIcon,
      suffix: suffix,
      errorText: errorText,
    );
  }
  static Html applyHtml(String? html, {TextStyle? style, TextAlign? textAlign, Alignment alignment = Alignment.centerLeft}) {
    return Html(
      data: html?.replaceAll('\r\n', '') ?? '',
      style: {
        "*": Style(
            textAlign: textAlign,
            alignment: alignment,
            color: style == null ? Get.theme.hintColor : style.color,
            fontSize: style == null ? FontSize(16.0) : FontSize(style.fontSize ?? 16.0),
            display: Display.inlineBlock,
            fontWeight: style == null ? FontWeight.w300 : style.fontWeight,
            width: Width.auto()
        ),
        "li": Style(
          textAlign: textAlign,
          lineHeight: LineHeight.normal,
          listStylePosition: ListStylePosition.outside,
          fontSize: style == null ? FontSize(14.0) : FontSize(style.fontSize ?? 14.0),
          display: Display.block,
        ),
        "h4,h5,h6": Style(
          textAlign: textAlign,
          fontSize: style == null ? FontSize(16.0) : FontSize(style.fontSize! + 2),
        ),
        "h1,h2,h3": Style(
          textAlign: textAlign,
          lineHeight: LineHeight.number(2),
          fontSize: style == null ? FontSize(18.0) : FontSize(style.fontSize! + 4),
        ),
        "br": Style(
          height: Height(0),
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"p"},
          builder: (context) => Text(
            context.innerHtml,
            textAlign: textAlign,
            style: style == null
                ? Get.textTheme.bodyLarge?.merge(const TextStyle(fontSize: 11))
                : style.merge(const TextStyle(fontSize: 11)),
          ),
        ),
      ],
      onCssParseError: (css, messages) {
        debugPrint("CSS parsing error in: $css");
        messages.forEach((element) {
          debugPrint(element.toString());
        });
        return '';
      },
    );
  }

  static Html removeHtml(String? html, {TextStyle? style, TextAlign? textAlign, Alignment alignment = Alignment.centerLeft}) {
    return Html(
      data: html?.replaceAll('\r\n', '') ?? '',
      style: {
        "*": Style(
            textAlign: textAlign,
            alignment: alignment,
            color: style == null ? Get.theme.hintColor : style.color,
            fontSize: style == null ? FontSize(11.0) : FontSize(style.fontSize ?? 11.0),
            display: Display.inlineBlock,
            fontWeight: style == null ? FontWeight.w300 : style.fontWeight,
            width: Width.auto()
        ),
        "br": Style(
          height: Height(0),
        ),
      },
      extensions: [
        TagExtension(
          tagsToExtend: {"p"},
          builder: (context) => Text(
            context.innerHtml,
            textAlign: textAlign,
            style: style == null
                ? Get.textTheme.bodyLarge?.merge(const TextStyle(fontSize: 11))
                : style.merge(const TextStyle(fontSize: 11)),
          ),
        ),
      ],
      onCssParseError: (css, messages) {
        debugPrint("CSS parsing error in: $css");
        messages.forEach((element) {
          debugPrint(element.toString());
        });
        return '';
      },
    );
  }

  static BoxFit getBoxFit(String boxFit) {
    switch (boxFit) {
      case 'cover':
        return BoxFit.cover;
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'fit_height':
        return BoxFit.fitHeight;
      case 'fit_width':
        return BoxFit.fitWidth;
      case 'none':
        return BoxFit.none;
      case 'scale_down':
        return BoxFit.scaleDown;
      default:
        return BoxFit.cover;
    }
  }

  static AlignmentDirectional getAlignmentDirectional(String alignmentDirectional) {
    switch (alignmentDirectional) {
      case 'top_start':
        return AlignmentDirectional.topStart;
      case 'top_center':
        return AlignmentDirectional.topCenter;
      case 'top_end':
        return AlignmentDirectional.topEnd;
      case 'center_start':
        return AlignmentDirectional.centerStart;
      case 'center':
        return AlignmentDirectional.topCenter;
      case 'center_end':
        return AlignmentDirectional.centerEnd;
      case 'bottom_start':
        return AlignmentDirectional.bottomStart;
      case 'bottom_center':
        return AlignmentDirectional.bottomCenter;
      case 'bottom_end':
        return AlignmentDirectional.bottomEnd;
      default:
        return AlignmentDirectional.bottomEnd;
    }
  }

  static CrossAxisAlignment getCrossAxisAlignment(String textPosition) {
    switch (textPosition) {
      case 'top_start':
        return CrossAxisAlignment.start;
      case 'top_center':
        return CrossAxisAlignment.center;
      case 'top_end':
        return CrossAxisAlignment.end;
      case 'center_start':
        return CrossAxisAlignment.center;
      case 'center':
        return CrossAxisAlignment.center;
      case 'center_end':
        return CrossAxisAlignment.center;
      case 'bottom_start':
        return CrossAxisAlignment.start;
      case 'bottom_center':
        return CrossAxisAlignment.center;
      case 'bottom_end':
        return CrossAxisAlignment.end;
      default:
        return CrossAxisAlignment.start;
    }
  }

  static String getDistance(double distance) {
    String _unit = Get.find<SettingsService>().setting.value.distanceUnit!;
    if (_unit == 'km') {
      distance *= 1.60934;
    }
    return distance != null ? distance.toStringAsFixed(2) + " " + _unit.tr : "";
  }

  static bool isDesktop(BoxConstraints constraint) {
    return constraint.maxWidth >= 1280;
  }

  static bool isTablet(BoxConstraints constraint) {
    return constraint.maxWidth >= 768 && constraint.maxWidth <= 1280;
  }

  static bool isMobile(BoxConstraints constraint) {
    return constraint.maxWidth < 768;
  }

  static double col12(BoxConstraints constraint, {double desktopWidth = 1280, double tabletWidth = 768, double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth;
    } else if (isTablet(constraint)) {
      return tabletWidth;
    } else {
      return desktopWidth;
    }
  }

  static double col9(BoxConstraints constraint, {double desktopWidth = 1280, double tabletWidth = 768, double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 3 / 4;
    } else if (isTablet(constraint)) {
      return tabletWidth * 3 / 4;
    } else {
      return desktopWidth * 3 / 4;
    }
  }

  static double col8(BoxConstraints constraint, {double desktopWidth = 1280, double tabletWidth = 768, double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 2 / 3;
    } else if (isTablet(constraint)) {
      return tabletWidth * 2 / 3;
    } else {
      return desktopWidth * 2 / 3;
    }
  }

  static double col6(BoxConstraints constraint, {double desktopWidth = 1280, double tabletWidth = 768, double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth / 2;
    } else if (isTablet(constraint)) {
      return tabletWidth / 2;
    } else {
      return desktopWidth / 2;
    }
  }

  static double col4(BoxConstraints constraint, {double desktopWidth = 1280, double tabletWidth = 768, double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 1 / 3;
    } else if (isTablet(constraint)) {
      return tabletWidth * 1 / 3;
    } else {
      return desktopWidth * 1 / 3;
    }
  }

  static double col3(BoxConstraints constraint, {double desktopWidth = 1280, double tabletWidth = 768, double mobileWidth = 480}) {
    if (isMobile(constraint)) {
      return mobileWidth * 1 / 4;
    } else if (isTablet(constraint)) {
      return tabletWidth * 1 / 4;
    } else {
      return desktopWidth * 1 / 4;
    }
  }
}
