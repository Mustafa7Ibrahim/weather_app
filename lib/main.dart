import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/config/routes/routes_config.dart';
import 'core/config/theme/theme.dart';
import 'core/interceptors/bloc_observer.dart';

import 'core/dependency_injection/get_it.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  widgetsBinding.deferFirstFrame();

  widgetsBinding.addPostFrameCallback((_) async {
    // Run any function you want to wait for before showing app layout.
    // final BuildContext context = widgetsBinding.rootElement!;

    // When the native splash screen is full screen, iOS will not automatically show the notification
    // bar when the app loads. To show it, setEnabledSystemUIMode has to be explicitly set:
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode
          .edgeToEdge, // https://github.com/flutter/flutter/issues/105714
    );

    // Closes splash screen, and show the app layout.
    widgetsBinding.allowFirstFrame();
  });

  Bloc.observer = MyBlocObserver();
  await dotenv.load();
  await initGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WeatherApp',
      theme: AppTheme.appTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: RoutesConfig.router,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(1),
          ),
          child: child!,
        );
      },
    );
  }
}
