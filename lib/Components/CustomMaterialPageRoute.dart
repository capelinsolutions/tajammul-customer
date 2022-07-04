import 'package:flutter/material.dart';

class CustomMaterialPageRoute extends MaterialPageRoute {
  final VoidCallback? back;
  @override
  @protected
  bool get hasScopedWillPopCallback {
    back!() ;
    return false;
  }

  CustomMaterialPageRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    this.back,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
    builder: builder,
    settings: settings,
    maintainState: maintainState,
    fullscreenDialog: fullscreenDialog,
  );
}