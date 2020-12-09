import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'back_button.dart';
import 'dart:io';

import 'loading/square_circle.dart';

class WebPage extends StatefulWidget {
  const WebPage({
    Key key,
    this.title,
    this.titleId,
    this.url,
  }) : super(key: key);

  final String title;
  final String titleId;
  final String url;

  @override
  State<StatefulWidget> createState() {
    return new WebPageState();
  }
}

class WebPageState extends State<WebPage> {
  ValueNotifier<bool> _loading = new ValueNotifier(true);

  @override
  void initState() {
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        leading: BackButtonV2(color: Colors.white),
        title: new Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: new TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        brightness: Brightness.dark,
      ),
      body: new Stack(
        children: <Widget>[
          new WebView(
            onWebViewCreated: (WebViewController webViewController) {},
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (url) {
              _loading.value = false;
            },
          ),
          new ValueListenableBuilder<bool>(
              valueListenable: _loading,
              builder: (context, value, _) {
                return new Offstage(
                  offstage: !value,
                  child: new Container(
                    color: Colors.white,
                    child: new SpinKitSquareCircle(
                        size: 35,
                        color: Colors.lime,
                        duration: Duration(milliseconds: 600)),
                  ),
                );
              })
        ],
      ),
    );
  }
}
