import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'app/main_app.dart';
import 'data/mock/prototype_dependencies.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final useDebug = const bool.fromEnvironment('DEBUG_DEPENDENCIES', defaultValue: false);
  if (useDebug || kDebugMode) {
    final dependencies = AppDependencies.prototype();
    runApp(MinhMenhAiApp(dependencies: dependencies));
    return;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dependencies = await AppDependencies.production();
  runApp(MinhMenhAiApp(dependencies: dependencies));
}
