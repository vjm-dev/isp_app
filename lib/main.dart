import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:isp_app/core/di/service_locator.dart';
import 'package:isp_app/domain/usecases/login_user.dart';
import 'package:isp_app/presentation/blocs/auth/auth_bloc.dart';
import 'package:isp_app/presentation/blocs/theme/theme_bloc.dart';
import 'package:isp_app/presentation/pages/auth/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(loginUser: getIt<LoginUser>()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'ISP Connect',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const SplashPage(),
            debugShowCheckedModeBanner: kDebugMode,
          );
        },
      ),
    );
  }
}