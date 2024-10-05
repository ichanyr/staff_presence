import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_framework/responsive_framework.dart';

class ScrollDenganResponsive extends StatefulWidget {
  final Widget child;
  final Function()? onBack;

  const ScrollDenganResponsive({Key? key, required this.child, this.onBack})
      : super(key: key);

  @override
  State<ScrollDenganResponsive> createState() => _ScrollDenganResponsiveState();
}

class _ScrollDenganResponsiveState extends State<ScrollDenganResponsive> {
  late Widget bodyIsi;

  late Function onBack;

  @override
  Widget build(BuildContext context) {
    bodyIsi = widget.child;
    onBack = widget.onBack ?? () {};

    return WillPopScope(
      onWillPop: () async {
        if (onBack == () {}) {
          return false;
        } else {
          return true;
        }
      },
      child: SingleChildScrollView(
        child: bodyIsi,
      ),
    );
  }
}

class ScrollDenganReload extends StatefulWidget {
  final Widget child;
  final Function()? onRefresh;
  final Function()? onLoading;
  final RefreshController refreshController;

  const ScrollDenganReload(
      {Key? key,
        required this.child,
        this.onRefresh,
        this.onLoading,
        required this.refreshController})
      : super(key: key);

  @override
  State<ScrollDenganReload> createState() => _ScrollDenganReloadState();
}

class _ScrollDenganReloadState extends State<ScrollDenganReload> {
  late Widget bodyIsi;
  // RefreshController refreshController =
  //     RefreshController(initialRefresh: false);
  Function()? onRefresh;

  fnRefresh(Function()? whileRefresh) {
    whileRefresh;
  }

  @override
  Widget build(BuildContext context) {
    bodyIsi = widget.child;
    onRefresh = widget.onRefresh ?? () {};
    // onRefresh = () => Future.delayed(
    //       Duration(seconds: 0),
    //       () {
    //         widget.onRefresh;
    //       },
    //     ).then((value) => refreshController.refreshCompleted());

    return SmartRefresher(
      onRefresh: onRefresh,
      controller: widget.refreshController,
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: bodyIsi
      ),
    );
  }
}
