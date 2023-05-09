import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../models/app_user.dart';

class Constants {
  
  static final Constants _singleton = Constants._internal();
  static String appName = "Health Manager";
  static bool isUserSignedIn = false;
  static bool isFirstTimeAppLaunched = true;
  static AppUser appUser = AppUser();
  static Color appThemeColor = const Color(0xffff6b6b);
  static String oneSignalId = "a62b45b3-a49d-456a-bc53-b7ce4454a3da";
  static String oneSignalRestKey = "ZDY2NTE5NzEtNDYyOC00NzdmLTk3YTUtNTYwOTZlNGZiNzM5";
  static String iosAppLink = "https://apps.apple.com/us/app/kv-health-manager/id6444716222";
  static String androidAppLink = "https://play.google.com/store/apps/details?id=com.kv.health.manager.app";
  //FOR NAVGATON
  static Function? callBackFunction;
  static String topViewName = "";
  static List favoritesList = [];


  factory Constants() {
    return _singleton;
  }

  Constants._internal();

  static void showDialog(String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(appName),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK')
          )
        ],
      )
    );
  }  

  static void showDialogWithTitle(String title ,String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK')
          )
        ],
      )
    );
  }   

  static void showTitleAndMessageDialog(String title, String message) {
    Get.generalDialog(
      pageBuilder: (context, __, ___) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: Text('$title', style: TextStyle(fontWeight: FontWeight.w700),),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text('OK')
          )
        ],
      )
    );
  }

  static Future<File> resizePhotoIfBiggerThen1mb(File image) async{
    try{
      List<int> imageBytes = image.readAsBytesSync();
      double kbSize = imageBytes.length/1024;
      if(kbSize >300)
      {
        double quantity = (100 * 300000)/imageBytes.length;
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String savedPath = appDocDir.path + "/" + DateTime.now().microsecondsSinceEpoch.toString() + ".jpg";
        var result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path, savedPath,
          quality: quantity.toInt(),
        );
        return result!;
      }
      else
      {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String savedPath = appDocDir.path + "" + DateTime.now().microsecondsSinceEpoch.toString() + ".jpg";
        var result = await FlutterImageCompress.compressAndGetFile(
          image.absolute.path, savedPath,
          quality: 100,
        );
        return result!;
      }
    }
    catch(e){
      return File('');
    }
  }
}