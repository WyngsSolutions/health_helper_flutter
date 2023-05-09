// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../user_detail_view/user_detail_view.dart';

class PostComments extends StatefulWidget {

  final Map postDetails;
  const PostComments({ Key? key, required this.postDetails }) : super(key: key);

  @override
  State<PostComments> createState() => _PostCommentsState();
}

class _PostCommentsState extends State<PostComments> {
 
  List allPostComments = [];
  TextEditingController commentField = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllEventComments();
  }

  void getAllEventComments()async{
    allPostComments.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    dynamic result = await AppController().getAllPostComments(allPostComments, widget.postDetails);
    EasyLoading.dismiss();
    if(result['Status'] == 'Success')
    {
     setState(() {
       print(allPostComments.length);
     });
    }
    else
    {
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  Future<void> enterCommentOnEvent() async {
    if(commentField.text.isEmpty)
      Constants.showDialog('Please enter comment');
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
      dynamic result = await AppController().addPostComment(widget.postDetails, commentField.text);
      EasyLoading.dismiss();
      if(result['Status'] == 'Success')
      {
      setState(() {
        commentField.text = "";
        getAllEventComments();
      });
      }
      else
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

  ///******* UTIL METHOD ****************///
  void userProfileView(AppUser personDetail)async
  {
    dynamic result = await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return UserDetailView(personDetail : personDetail);
      }
    );
  }

  // void showReportView(Map commentDetail)async
  // {
  //   await showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     builder: (BuildContext bc){
  //       return Container(
  //         padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*3),
  //         height: SizeConfig.blockSizeVertical*52,
  //         decoration: BoxDecoration(
  //           color: Constants.appThemeColor,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(40),
  //             topRight: Radius.circular(40)
  //           )
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.stretch,
  //           children: [
  //             Text(
  //               'Report Comment To Admin',
  //               textAlign: TextAlign.center,
  //               style: TextStyle(
  //                 fontSize: SizeConfig.fontSize * 2.3,
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.bold
  //               ),
  //             ),

  //             Container(
  //               margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
  //               child: Text(
  //                 'Let the admin know what\'s wrong with this comment. Your details will be kept anonymous for this report',
  //                 textAlign: TextAlign.left,
  //                 style: TextStyle(
  //                   fontSize: SizeConfig.fontSize * 1.8,
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.w500
  //                 ),
  //               ),
  //             ),

  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 //AppController().reportComment(commentDetail, 'Other');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Spam',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 AppController().reportComment(commentDetail, 'Harassment');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Harassment',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 AppController().reportComment(commentDetail, 'Hate Speech');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Hate Speech',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             GestureDetector(
  //               onTap: (){
  //                 Get.back();
  //                 AppController().reportComment(commentDetail, 'Other');
  //                 Constants.showDialog('You have reported the comment to admin');
  //               },
  //               child: Container(
  //                 margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
  //                 height: SizeConfig.blockSizeVertical*5.5,
  //                 width: SizeConfig.blockSizeHorizontal*80,
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(10)
  //                 ),
  //                 child: Center(
  //                   child: Text(
  //                     'Other',
  //                     style: TextStyle(
  //                       fontSize: SizeConfig.fontSize * 2,
  //                       color: Constants.appThemeColor,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             )
  //           ],
  //         ),
  //       );
  //     }
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Post Comments',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
                        
            Expanded(
              child: (allPostComments.isEmpty) ? Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*5, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: Center(
                  child: Text(
                    'No Comments',
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize*2.2,
                      color: Colors.grey[400]!
                    ),
                  ),
                ),
              ): Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.5, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    itemCount: allPostComments.length,
                    itemBuilder: (_, i) {
                      return commentCell(allPostComments[i], i);
                    },
                    shrinkWrap: true,
                  ),
                ),
              ),
            ),

            (Constants.appUser.userId == widget.postDetails['userId']) ? Container():
            Container(
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*2, left: SizeConfig.blockSizeHorizontal*4, right: SizeConfig.blockSizeHorizontal*4),
              child: Center(
                child: TextField(
                  controller: commentField,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    fillColor:  Colors.grey[100],
                    filled: true,
                    hintText: 'Add comment...',
                    contentPadding: EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 5),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(width: 1,color: Color(0XFFD4D4D4)),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFFD4D4D4)),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        IconButton(
                          icon: Icon(Icons.send, color: Constants.appThemeColor), 
                          onPressed: (){
                            enterCommentOnEvent();
                            FocusScope.of(context).requestFocus(FocusNode());
                          }
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ) 

          ],
        ),
      ),
    );
  }

  Widget commentCell(dynamic commentDetail, int index){
    return GestureDetector(
      onTap: (){
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*4, vertical: SizeConfig.blockSizeVertical*1.5),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey[300]!,
              width: 0.5
            )
          )
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2),
              height: SizeConfig.blockSizeVertical*6,
              width: SizeConfig.blockSizeVertical*6,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (commentDetail['userImage'].isEmpty) ? AssetImage('assets/user_bg.png') : CachedNetworkImageProvider(commentDetail['userImage']) as ImageProvider,
                  fit: BoxFit.cover
                )
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2, top: SizeConfig.blockSizeVertical*0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          commentDetail['userName'],
                          style: TextStyle(
                            fontSize: SizeConfig.fontSize*1.8,
                            color: Colors.black
                          ),
                        ),
                        if(Constants.appUser.userId == widget.postDetails['userId'])
                        GestureDetector(
                          onTap: () async {
                            // if(Constants.appUser.userId == commentDetail['userId'])
                            //   Constants.showDialog('You cannot report your own comment');
                            // else
                            //   showReportView(commentDetail);
                            EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
                            AppUser userData = await AppUser.getUserDetailByUserId(commentDetail['userId']);
                            EasyLoading.dismiss();
                            userProfileView(userData);
                          },
                          child: Icon(Icons.info_outline, size: SizeConfig.blockSizeVertical*3, color: Constants.appThemeColor,)
                        )
                      ],
                    ),

                    Container(
                      margin: EdgeInsets.only(top: 3),
                      child: Text(
                        commentDetail['userComment'],
                        style: TextStyle(
                          fontSize: SizeConfig.fontSize*1.7,
                          color: Colors.grey[500]!
                        ),
                      ),
                    ),
                  ],
                ),
              )
            )
          ]
        ),
      )
    );
  }
}