import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:speeder/controllers/controller.dart';
import 'package:speeder/utils/dialogs.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  final Controller controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text('settings'.tr),
      ),
      body: Obx(
        () => ListView(
          children: [
            ListTile(
              title: Row(
                children: [
                  FaIcon(
                    FontAwesomeIcons.globe,
                    size: 16,
                  ),
                  Padding(
                    padding: .only(left: 5),
                    child: Text('language'.tr),
                  ),
                ],
              ),
              subtitle: Text(
                controller.lang.value.name,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              onTap: (){
                languageDialog(context);
              },
            ),
            ListTile(
              title: Row(
                children: [
                  FaIcon(
                    controller.darkMode.value ? FontAwesomeIcons.moon : FontAwesomeIcons.sun,
                    size: 16,
                  ),
                  Padding(
                    padding: .only(left: 5),
                    child: Text('darkMode'.tr),
                  ),
                ],
              ),
              subtitle: Text(
                controller.autoDark.value ? "auto".tr : controller.darkMode.value ? 'enabled'.tr : 'disabled'.tr,
                style: TextStyle(
                  color: Colors.grey
                ),
              ),
              onTap: (){
                darkModeDialog(context);
              },
            )
          ],
        ),
      ),
    );
  }
}