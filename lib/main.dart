import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:speeder/controllers/controller.dart';
import 'package:speeder/lang/zh_cn.dart';
import 'package:speeder/views/main_view.dart';

void main() {
  Get.put(Controller());
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
    // 'en_US': enUS,
    'zh_CN': zhCN,
    // 'zh_TW': zhTW,
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
          fontFamily: 'PuHui', 
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.yellow,
            brightness: controller.darkMode.value ? Brightness.dark : Brightness.light,
          ),
          textTheme: controller.darkMode.value ? ThemeData.dark().textTheme.apply(
            fontFamily: 'PuHui',
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ) : ThemeData.light().textTheme,
        ),
        home: MainView()
      ),
    );
  }
}
