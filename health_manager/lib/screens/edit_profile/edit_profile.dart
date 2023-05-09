// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, curly_braces_in_flow_control_structures, unnecessary_null_comparison
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import 'package:path/path.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({ Key? key }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  TextEditingController name = TextEditingController(text: Constants.appUser.name);
  TextEditingController email = TextEditingController(text: Constants.appUser.email);
  
  //PHOTO
  XFile? image;
  String imagePath = "";
  final ImagePicker picker = ImagePicker();
  String userImageUrl = "";

  @override
  void initState() {
    super.initState();
    userImageUrl = Constants.appUser.userProfilePicture;
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

  Future<String> uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + basename(image!.path);
    final firebaseStorage = FirebaseStorage.instance;
    //Upload to Firebase
    var snapshot = await firebaseStorage.ref().child("user_pictures").child(fileName).putFile(File(image!.path));
    var downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void updateProfile()async{
    if(name.text.isEmpty)
      Constants.showDialog('Please enter name');
    else
    { 
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      if(image != null)
        userImageUrl = await uploadFile();

      dynamic result = await AppController().updateProfileInfo(name.text, userImageUrl);
      EasyLoading.dismiss();
      if(result['Status'] == 'Success')
      {
        Get.back(result: true);
        Constants.appUser.name = name.text;
        //Constants.appUser.phone = phone.text;
        Constants.appUser.userProfilePicture = userImageUrl;
        await Constants.appUser.saveUserDetails();
        Constants.showDialog('Profile has been updated successfully');
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
        titleSpacing: 10,
        title: Row(
          children: [
            Text(
              'Edit Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.fontSize * 2.1,
                fontWeight: FontWeight.bold
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            print('close');
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus)
              currentFocus.unfocus();
          },
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                
                Stack(
                  children: [
                    GestureDetector(
                      onTap: getImage,
                      child: Center(
                        child: Container(
                          height: SizeConfig.blockSizeVertical*17,
                          width: SizeConfig.blockSizeVertical*17,
                          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*4, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Constants.appThemeColor
                            ),
                            image: DecorationImage(
                              image: (image != null) ? FileImage(File(imagePath)) : (userImageUrl.isEmpty) ? AssetImage('assets/placeholder.png') : CachedNetworkImageProvider(userImageUrl) as ImageProvider,
                              fit: BoxFit.cover
                            )
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                               Container(
                                padding: EdgeInsets.all(SizeConfig.blockSizeVertical*1),
                                 decoration: BoxDecoration(
                                   color: Constants.appThemeColor,
                                   shape: BoxShape.circle
                                 ),
                                 child: Icon(Icons.edit, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                
                Container(
                  height: SizeConfig.blockSizeVertical*6.5,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*7, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Constants.appThemeColor
                    )
                  ),
                  child: Center(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: SizeConfig.fontSize*1.8),
                      controller: name,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize *1.8),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.person)
                      ),
                    ),
                  ),
                ),
              
                Container(
                  height: SizeConfig.blockSizeVertical*6.5,
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Constants.appThemeColor
                    )
                  ),
                  child: Center(
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(fontSize: SizeConfig.fontSize *1.8, color: Colors.grey[500]),
                      controller: email,
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(fontSize: SizeConfig.fontSize *1.8),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email)
                      ),
                    ),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: updateProfile,
        child: Container(
          margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2, left: SizeConfig.blockSizeHorizontal*6, right: SizeConfig.blockSizeHorizontal*6, bottom:  SizeConfig.blockSizeVertical*5),
          height: SizeConfig.blockSizeVertical * 6.5,
          decoration: BoxDecoration(
            color: Constants.appThemeColor,
            borderRadius: BorderRadius.circular(5)
          ),
          child : Center(
            child: Text(
              'Update',
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