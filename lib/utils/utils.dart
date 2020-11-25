import 'package:flutter/material.dart';
import 'package:frolo/data/common/common.dart';
import 'package:frolo/utils/timeline_util.dart';
import 'package:sp_util/sp_util.dart';

import 'object_util.dart';

class Utils {
  static String getImgPath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }

  static Color nameToColor(String name) {
    // assert(name.length > 1);
    final int hash = name.hashCode & 0xffff;
    final double hue = (360.0 * hash / (1 << 15)) % 360.0;
    return HSVColor.fromAHSV(1.0, hue, 0.4, 0.90).toColor();
  }

  static String getTimeLine(BuildContext context, int timeMillis) {
    return TimelineUtil.format(timeMillis,
        locale: Localizations.localeOf(context).languageCode,
        dayFormat: DayFormat.Common);
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static int getLoadStatus(bool hasError, List data) {
    if (hasError) return LoadingStatus.fail;
    if (data == null) {
      return LoadingStatus.loading;
    } else if (data.isEmpty) {
      return LoadingStatus.empty;
    } else {
      return LoadingStatus.success;
    }
  }
  static bool isLogin() {
    return ObjectUtil.isNotEmpty(SpUtil.getString(Constant.keyAppToken));
  }
}
