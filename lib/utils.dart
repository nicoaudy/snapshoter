import 'package:flutter/material.dart';
import 'package:flutter_hot_toast/flutter_hot_toast.dart';

errorToast(BuildContext context, String title, double width) {
  context.loaderOverlay.show(
    widget: FlutterHotToast.error(
      context,
      height: 60,
      width: width,
      alignment: Alignment.topRight,
      label: Text(title, style: const TextStyle(fontSize: 20)),
    ),
  );
}
