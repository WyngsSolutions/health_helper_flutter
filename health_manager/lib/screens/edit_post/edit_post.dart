import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../home_screen/home_screen.dart';

class EditPost extends StatefulWidget {
 
  final Map postDetail;
  const EditPost({super.key, required this.postDetail});

  @override
  State<EditPost> createState() => _EditPostState();
}

class _EditPostState extends State<EditPost> {
  
  TextEditingController postText = TextEditingController();

  @override
  void initState() {
    super.initState();
    postText.text = widget.postDetail['description'];
  }

  void submitPressed() async {
    if (postText.text.isEmpty)
      Constants.showDialog("Please enter post description");
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().editPostRequest(widget.postDetail, postText.text);
      EasyLoading.dismiss();     
      if (result['Status'] == "Success")
      {
        Get.back(result: true);
        Constants.showDialog('Post edited successfully');
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
          'Edit Post',
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
            )
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
              'Edit',
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