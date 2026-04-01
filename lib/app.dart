import 'package:flutter/material.dart';
import 'package:flutter_application_1/bindings/general_bindings.dart';
import 'package:flutter_application_1/features/routes/app_routes.dart';
import 'package:flutter_application_1/utils/constants/colors.dart';
import 'package:get/get.dart';

import 'package:flutter_application_1/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(), // ¡Excelente, esto carga tus repositorios!
      initialRoute: '/', // Definimos la ruta inicial
      getPages: AppRoutes.pages, // Asegúrate que aquí esté definido '/'
    );
  }
}
