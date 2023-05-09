// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/app_controller.dart';
import '../../models/app_user.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../chat_screen/chat_screen.dart';

class UserDetailView extends StatefulWidget {

  final AppUser personDetail;
  const UserDetailView({ Key? key, required this.personDetail}) : super(key: key);

  @override
  State<UserDetailView> createState() => _UserDetailViewState();
}

class _UserDetailViewState extends State<UserDetailView> {
  
  late AppUser userDetail;

  @override
  void initState() {
    super.initState();
    userDetail = AppUser();
    userDetail.userId = widget.personDetail.userId;
    userDetail.name = widget.personDetail.name;
    userDetail.userProfilePicture = widget.personDetail.userProfilePicture;
    userDetail.oneSignalUserId = '';
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical*40,
      padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*3),
              height: SizeConfig.blockSizeVertical*10,
              width: SizeConfig.blockSizeVertical*10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: (widget.personDetail.userProfilePicture.isEmpty) ? AssetImage('assets/user_bg.png') : CachedNetworkImageProvider(widget.personDetail.userProfilePicture) as ImageProvider,
                  fit: BoxFit.cover
                )
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*3),
            child: Center(
              child: Text(
                '${widget.personDetail.name}',
                textAlign: TextAlign.start,
                maxLines: 2,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 2.2,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          
          Container(
            margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                GestureDetector(
                  onTap:(){
                    Get.back();
                    Get.to(ChatScreen(chatUser: userDetail,));
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 1, left: SizeConfig.blockSizeHorizontal*10, right: SizeConfig.blockSizeHorizontal*10, bottom: SizeConfig.blockSizeVertical*1),
                    height: SizeConfig.blockSizeVertical *6,
                    width: SizeConfig.blockSizeHorizontal*70,
                    decoration: BoxDecoration(
                      color: Constants.appThemeColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                        'Send a message',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.fontSize * 2.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: showReportView,
                  child: Center(
                    child: Text(
                      'Report',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.appThemeColor,
                        fontSize: SizeConfig.fontSize * 2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: (){
                //     launchUrl(Uri.parse('tel://${widget.personDetail['phone']}'));
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(5),
                //     decoration: BoxDecoration(
                //       color: Constants.appThemeColor,
                //       shape: BoxShape.circle
                //     ),
                //     child: Icon(Icons.call, size: SizeConfig.blockSizeVertical*3, color: Colors.white,),
                //   ),
                // ),                
                // SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
                // GestureDetector(
                //   onTap: (){
                //     Get.back();
                //     Get.to(ChatScreen(chatUser: userDetail,));
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(5),
                //     decoration: BoxDecoration(
                //       color: Constants.appThemeColor,
                //       shape: BoxShape.circle
                //     ),
                //     child: Icon(Icons.mail, size: SizeConfig.blockSizeVertical*3, color: Colors.white,),
                //   ),
                // ),
                // SizedBox(width: SizeConfig.blockSizeHorizontal*4,),
                // GestureDetector(
                //   onTap: (){
                //     //Get.to(MyReviews(userId: userDetail.userId,));
                //   },
                //   child: Container(
                //     padding: EdgeInsets.all(5),
                //     decoration: BoxDecoration(
                //       color: Constants.appThemeColor,
                //       shape: BoxShape.circle
                //     ),
                //     child: Icon(Icons.star, size: SizeConfig.blockSizeVertical*3.1, color: Colors.white,),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ///******* UTIL METHOD ****************///
  void showReportView()async
  {
    await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7, vertical: SizeConfig.blockSizeVertical*3),
          height: SizeConfig.blockSizeVertical*52,
          decoration: BoxDecoration(
            color: Constants.appThemeColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40)
            )
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Report Comment To Admin',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 2.3,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),

              Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
                child: Text(
                  'Let the admin know what\'s wrong with this user. Your details will be kept anonymous for this report',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: SizeConfig.fontSize * 1.8,
                    color: Colors.white,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportUser(widget.personDetail, 'Spam');
                  Constants.showDialog('You have reported the user to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Spam',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportUser(widget.personDetail, 'Harassment');
                  Constants.showDialog('You have reported the user to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Harassment',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportUser(widget.personDetail, 'Other');
                  Constants.showDialog('You have reported the user to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Hate Speech',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Get.back();
                  AppController().reportUser(widget.personDetail, 'Other');
                  Constants.showDialog('You have reported the user to admin');
                },
                child: Container(
                  margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2.5),
                  height: SizeConfig.blockSizeVertical*5.5,
                  width: SizeConfig.blockSizeHorizontal*80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Text(
                      'Other',
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 2,
                        color: Constants.appThemeColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      }
    );
  }
}