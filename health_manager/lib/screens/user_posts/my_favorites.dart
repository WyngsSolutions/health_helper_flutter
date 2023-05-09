// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_manager/screens/edit_post/edit_post.dart';
import '../../controllers/app_controller.dart';
import '../../helpers/photo_list_screen.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../feed_screen/post_comments.dart';

class MyFavorites extends StatefulWidget {
  const MyFavorites({super.key});

  @override
  State<MyFavorites> createState() => _MyFavoritesState();
}

class _MyFavoritesState extends State<MyFavorites> {
   
  List posts = [];

  @override
  void initState() {
    super.initState();
    getAllFavPosts();
  }

  void getAllFavPosts() async {
    posts.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getMyFavoritePosts();
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        posts = result['AllPosts'];
      });
    } 
    else
    {
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  void removePostFavorite(Map postDetail, int index) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().removeProductFavorite(postDetail);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        posts.removeAt(index);
      });
    } 
    else {
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
      backgroundColor: Constants.appThemeColor,
        title: Text(
          'My Favorite Posts',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
    body: Container(
      margin: EdgeInsets.fromLTRB(SizeConfig.blockSizeHorizontal*5, SizeConfig.blockSizeVertical*0, SizeConfig.blockSizeHorizontal*5, SizeConfig.blockSizeVertical*2),
      child: (posts.isNotEmpty) ? ListView.builder(
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (context, index){
          return feedCell(posts[index], index);
        }
      ) : Center(
          child: Text(
            'No Posts Yet',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: SizeConfig.fontSize*2
            ),
          ),
        ),
      ),
    );
  }

  Widget feedCell(Map postData, int index){
    return GestureDetector(
      onTap: (){
        Get.to(PostComments(postDetails: postData,));
      },
      child: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
        padding: EdgeInsets.symmetric(horizontal:SizeConfig.blockSizeHorizontal*2, vertical: SizeConfig.blockSizeHorizontal*2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      image: (postData['userPicture'].isEmpty) ? AssetImage('assets/logo.jpg') : CachedNetworkImageProvider(postData['userPicture']) as ImageProvider,
                      fit: BoxFit.cover
                    )
                  ),
                ),
                Expanded(
                  child: Text(
                    postData['name'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: SizeConfig.fontSize * 1.8,
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    removePostFavorite(postData, index);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5,),
                    child: Icon(Icons.favorite, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  ),
                ),
              ],
            ),
    
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*2),
              child: Text(
                postData['description'],
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: SizeConfig.fontSize * 2.0,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),

            if(postData['postImage'].isNotEmpty)
            GestureDetector(
              onTap: (){
                Get.to(PhotoListScreen(galleryItems: [postData['postImage']]));
              },
              child: Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
                height: SizeConfig.blockSizeVertical*30,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(postData['postImage']),
                    fit: BoxFit.cover
                  )
                ),
              ),
            ),
    
            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
              padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1
                  )
                )
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: (){
                      //Get.to(PostComments(postDetails: postData,));
                    },
                    child: Container(
                      child: Icon(Icons.comment, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*2.5),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: SizeConfig.blockSizeVertical*1),
                    child: Text(
                      'Replies (${postData['commentsCount']})',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: SizeConfig.fontSize * 1.8,
                        color: Colors.black,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}