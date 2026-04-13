import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speeder/controllers/controller.dart';

void languageDialog(BuildContext context){

  final statusGet=Get.find<Controller>();

  showDialog(
    context: context, 
    builder: (context)=>AlertDialog(
      title: Text("language".tr),
      content: StatefulBuilder(
        builder: (context, setState) {
          return DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              value: statusGet.lang.value.name,
              items: supportedLocales.map((item)=>DropdownMenuItem<String>(
                value: item.name,
                child: Text(
                  item.name
                ),
              )).toList(),
              onChanged: (val){
                final index=supportedLocales.indexWhere((element) => element.name==val);
                statusGet.changeLanguage(index);
              },
            ),
          );
        }
      ),
      actions: [
        ElevatedButton(
          child: Text('ok'.tr),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}