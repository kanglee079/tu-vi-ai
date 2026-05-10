import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import 'app/main_app.dart';
import 'data/mock/prototype_dependencies.dart';
import 'firebase_options.dart';

const _kUseDebugDependencies = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (_kUseDebugDependencies || kDebugMode) {
    final dependencies = AppDependencies.prototype();
    runApp(MinhMenhAiApp(dependencies: dependencies));
    return;
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final dependencies = await AppDependencies.production();
  runApp(MinhMenhAiApp(dependencies: dependencies));
}
