import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:health_manager/helpers/photo_list_screen.dart';
import 'package:health_manager/utils/constants.dart';
import 'package:health_manager/utils/size_config.dart';
import '../../controllers/app_controller.dart';
import '../add_post/add_post.dart';
import '../search_screen/search_screen.dart';
import 'post_comments.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List posts = [];

  @override
  void initState() {
    super.initState();
    getAllPosts();
  }

  void getAllPosts() async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllPosts(posts);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        posts = result['Posts'];
      });
    } 
    else {
      //Fail Cases Show String
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  void addPostFavorite(Map postDetail, int index) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().addPostFavorite(postDetail);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {});
    } 
    else {
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  void removePostFavorite(Map postDetail, int index) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().removeProductFavorite(postDetail);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {});
    } 
    else {
      Constants.showDialog(result['ErrorMessage'],);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      //backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Home',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Get.to(SearchScreen(posts :posts));
              setState(() {});
            },
            icon: Icon(Icons.search, color: Colors.white,)
          )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5, vertical: SizeConfig.blockSizeVertical*2),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text(
              //   'Upcoming Reminder',
              //   style: TextStyle(
              //     color: Colors.black,
              //     fontSize: SizeConfig.fontSize*1.9,
              //     fontWeight: FontWeight.bold
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
              //   height: SizeConfig.blockSizeVertical*8,
              //   child: ListView.builder(
              //     itemCount: 2,
              //     scrollDirection: Axis.horizontal,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index){
              //       return reminderCell(index);
              //     }
              //   ),
              // ),
        
              Container(
                //margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1),
                child: MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index){
                      return feedCell(posts[index], index);
                    }
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Get.to(AddPostScreen());
        },
        backgroundColor: Constants.appThemeColor,
        child: Icon(Icons.add),
      ),
    );
  }

  Widget reminderCell(int index){
    return Container(
      height: SizeConfig.blockSizeVertical*8,
      width: SizeConfig.blockSizeHorizontal*70,
      margin: EdgeInsets.only(left: (index == 0) ? 0 : SizeConfig.blockSizeHorizontal*3),
      padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.grey[400]!,
          width: 0.7
        )
      ),
      child: Center(child: Text('Have to take my medication at 6pm')),
    );
  }

  Widget feedCell(Map postData, int index){
    bool isFavorite = Constants.favoritesList.contains(postData['postId']);
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
                    if(!isFavorite)
                      addPostFavorite(postData, index);
                    else
                      removePostFavorite(postData, index);
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 5,),
                    child: Icon((isFavorite) ? Icons.favorite : Icons.favorite_border, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
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
                  // GestureDetector(
                  //   onTap: (){
                  //     //Share.share(postData['description']);
                  //   },
                  //   child: Container(
                  //     child: Icon(Icons.share, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: (){
                  //     //showReportView(postData);
                  //   },
                  //   child: Container(
                  //     child: Icon(Icons.report_gmailerrorred_outlined, color: Constants.appThemeColor, size : SizeConfig.blockSizeVertical*3),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}