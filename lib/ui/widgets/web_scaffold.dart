import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'likebtn/like_button.dart';

class WebScaffold extends StatefulWidget {
  const WebScaffold({
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
    return new WebScaffoldState();
  }
}

class WebScaffoldState extends State<WebScaffold> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: <Widget>[
          LikeButton(
            width: 36.0,
            duration: Duration(milliseconds: 500),
          ),
        ],
      ),
      body: new WebView(
        onWebViewCreated: (WebViewController webViewController) {},
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
