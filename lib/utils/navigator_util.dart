import 'package:flutter/cupertino.dart';
import 'package:frolo/data/db/data_base_singleton.dart';
import 'package:frolo/data/protocol/models.dart';
import 'package:frolo/ui/widgets/web_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'object_util.dart';

class NavigatorUtil {
  static void pushPage(
    BuildContext context,
    Widget page, {
    String pageName,
    bool needLogin = false,
  }) {
    if (context == null || page == null) return;
    Navigator.push(
        context, new CupertinoPageRoute<void>(builder: (ctx) => page));
  }

  static void pushWeb(BuildContext context,
      {String title, String titleId, String url, Article article}) {
    if (ObjectUtil.isNotEmpty(article)) {
      article.lastTime = new DateTime.now().millisecondsSinceEpoch;
      DatabaseSingleton.instance.database.articleDao.insertArticle(article);
    }
    if (context == null || ObjectUtil.isEmpty(url)) return;
    if (url.endsWith(".apk")) {
      launchInBrowser(url, title: title ?? titleId);
    } else {
      Navigator.push(
          context,
          new CupertinoPageRoute<void>(
              builder: (ctx) => new WebPage(
                    title: title,
                    titleId: titleId,
                    url: url,
                  )));
    }
  }

  static Future<Null> launchInBrowser(String url, {String title}) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }
}
