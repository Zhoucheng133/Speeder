import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:gps_tracker/controllers/controller.dart';
import 'package:gps_tracker/lang/en_us.dart';
import 'package:gps_tracker/lang/zh_cn.dart';
import 'package:gps_tracker/lang/zh_tw.dart';
import 'package:gps_tracker/views/main_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final controller=Get.put(Controller());
  await controller.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
  };
}

class _MainAppState extends State<MainApp> {

  final controller = Get.find<Controller>();

  @override
  Widget build(BuildContext context) {

    final brightness = MediaQuery.of(context).platformBrightness;
    controller.darkModeHandler(brightness == Brightness.dark);

    return Obx(
      () => GetMaterialApp(
        translations: MainTranslations(), 
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        locale: controller.lang.value.locale, 
        supportedLocales: supportedLocales.map((item)=>item.locale).toList(),
        theme: ThemeData(
          brightness: controller.darkMode.value ? Brightness.dark : Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow,
            brightness: controller.darkMode.value ? Brightness.dark : Brightness.light,
          ),
          textTheme: controller.darkMode.value ? ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ) : ThemeData.light().textTheme,
        ),
        home: MainView()
      ),
    );
  }
}
