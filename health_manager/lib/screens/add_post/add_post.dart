import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../home_screen/home_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  TextEditingController postText = TextEditingController();
  //PHOTO
  XFile? image;
  String imagePath = "";
  final ImagePicker picker = ImagePicker();
  String userImageUrl = "";

  @override
  void initState() {
    super.initState();
  }

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery,);
    if(pickedFile!.path != null)
    {
      setState(() {
        image = pickedFile;
        imagePath = pickedFile.path;
      });
    }
  }

  void submitPressed() async {
    if (postText.text.isEmpty)
      Constants.showDialog("Please enter post description");
    else
    {
      File? imageSelcted;
      if(image != null)
        imageSelcted = File(image!.path);
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().postRequest(postText.text, imageSelcted);
      EasyLoading.dismiss();     
      if (result['Status'] == "Success")
      {
        Get.offAll(HomeScreen(defaultPage: 0));
        Constants.showDialog('Post submitted successfully');
      }
      else 
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        centerTitle: true,
        title: Text(
          'Add Post',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            
            Container(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
              height: SizeConfig.blockSizeVertical*25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 0.7,
                  color: Colors.grey[400]!
                )
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
                        height: SizeConfig.blockSizeVertical*5,
                        width: SizeConfig.blockSizeVertical*5,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: (Constants.appUser.userProfilePicture.isEmpty) ? AssetImage('assets/logo.jpg') : CachedNetworkImageProvider(Constants.appUser.userProfilePicture) as ImageProvider,
                            fit: BoxFit.cover
                          )
                        ),
                      ),
                      Expanded(
                        child: Text(
                          Constants.appUser.name,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize * 1.8,
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin : EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white,
                        width: 1
                      )
                    ),
                    child: Center(
                      child: TextField(
                        controller: postText,
                        style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                        keyboardType: TextInputType.multiline,
                        minLines: 6,
                        maxLines: 6,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Write something...',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: SizeConfig.fontSize * 1.8),
                          contentPadding: EdgeInsets.symmetric(horizontal: 5)
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            ),

            GestureDetector(
              onTap: getImage,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                  height: SizeConfig.blockSizeVertical * 5,
                  width: SizeConfig.blockSizeHorizontal*30,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(5)
                  ),
                  child : Center(
                    child: Text(
                      'Choose file',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 1.6,
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]
        )
      ),
      bottomNavigationBar: GestureDetector(
        onTap: submitPressed,
        child: Container(
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6, bottom:  SizeConfig.blockSizeVertical*5),
          height: SizeConfig.blockSizeVertical * 6.5,
          decoration: BoxDecoration(
            color: Constants.appThemeColor,
            borderRadius: BorderRadius.circular(5)
          ),
          child : Center(
            child: Text(
              'Submit',
              style: TextStyle(
                fontSize: SizeConfig.fontSize * 2.0,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}