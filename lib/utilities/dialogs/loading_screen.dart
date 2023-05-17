import 'package:feedmedia/utilities/dialogs/loading_screen_controller.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  LoadingScreen._sharedInstance();

  void hide() {
    controller?.close();
    controller = null;
  }

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(context: context, text: text);
    }
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    OverlayEntry? overlay = OverlayEntry(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.black.withAlpha(150),
          body: const Center(
            child: CircularProgressIndicator(
              color: blue,
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingScreenController(
      close: () {
        overlay?.remove();
        overlay = null;
        return true;
      },
      update: (text) {},
    );
  }
}
