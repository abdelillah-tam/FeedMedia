import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = Function();
typedef UpdateLoadingScreen = Function(String);

@immutable
class LoadingScreenController {
  final CloseLoadingScreen close;
  final UpdateLoadingScreen update;

  const LoadingScreenController({
    required this.close,
    required this.update,
  });
}
