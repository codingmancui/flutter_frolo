import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///the most common indicator,combine with a text and a icon
///
// See also:
//
// [ClassicHeader]
class LoadMoreFooter extends LoadIndicator {
  final String loadingText = '正在加载中',
      noDataText = '没有更多数据',
      failedText = '网络异常,加载失败';

  /// a builder for re wrap child,If you need to change the boxExtent or background,padding etc.you need outerBuilder to reWrap child
  /// example:
  /// ```dart
  /// outerBuilder:(child){
  ///    return Container(
  ///       color:Colors.red,
  ///       child:child
  ///    );
  /// }
  /// ````
  /// In this example,it will help to add backgroundColor in indicator
  final OuterBuilder outerBuilder;

  /// icon and text middle margin
  final double spacing;


  final TextStyle textStyle;

  /// notice that ,this attrs only works for LoadStyle.ShowWhenLoading
  final Duration completeDuration;

  const LoadMoreFooter({
    Key key,
    VoidCallback onClick,
    LoadStyle loadStyle: LoadStyle.ShowAlways,
    double height: 60.0,
    this.outerBuilder,
    this.textStyle: const TextStyle(color: Colors.grey, fontSize: 10),
    this.spacing: 10.0,
    this.completeDuration: const Duration(milliseconds: 300),
  }) : super(
          key: key,
          loadStyle: loadStyle,
          height: height,
          onClick: onClick,
        );

  @override
  State<StatefulWidget> createState() {
    return _ClassicFooterState();
  }
}

class _ClassicFooterState extends LoadIndicatorState<LoadMoreFooter> {
  Widget _buildText(LoadStatus mode) {
    RefreshString strings =
        RefreshLocalizations.of(context)?.currentLocalization ??
            EnRefreshString();
    return Text(
        mode == LoadStatus.loading
            ? widget.loadingText ?? strings.loadingText
            : LoadStatus.noMore == mode
                ? widget.noDataText ?? strings.noMoreText
                : LoadStatus.failed == mode
                    ? widget.failedText
                    : widget.loadingText,
        style: widget.textStyle);
  }

  Widget _buildIcon(LoadStatus mode) {
    Widget icon;
    if (mode == LoadStatus.loading) {
      icon = SizedBox(
        width: 12.0,
        height: 12.0,
        child: const CircularProgressIndicator(strokeWidth: 1.0),
      );
    } else if (mode == LoadStatus.noMore) {
      icon = Container();
    } else if (mode == LoadStatus.failed) {
      icon = Icon(Icons.error, color: Colors.lightGreen);
    }
    return icon ?? Container();
  }

  @override
  Future endLoading() {
    return Future.delayed(widget.completeDuration);
  }

  @override
  Widget buildContent(BuildContext context, LoadStatus mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container = Wrap(
      spacing: widget.spacing,
      textDirection: TextDirection.ltr,
      direction:  Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    return widget.outerBuilder != null
        ? widget.outerBuilder(container)
        : Container(
            height: widget.height,
            child: Center(
              child: container,
            ),
          );
  }
}
