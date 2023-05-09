import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';
import '../webview_screen/webview_screen.dart';

class IllnessListScreen extends StatefulWidget {
  const IllnessListScreen({super.key});

  @override
  State<IllnessListScreen> createState() => _IllnessListScreenState();
}

class _IllnessListScreenState extends State<IllnessListScreen> {

  List illness = [];
  List filterIllness = [];

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadJson();
  }

  void loadJson() async {
    String data = await rootBundle.loadString('assets/illness.json');
    illness = json.decode(data);
    print(illness.length);
    filterIllness = List.from(illness);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'Illness Library',
          style: TextStyle(
            color: Colors.white,
            fontSize: SizeConfig.fontSize*2.2
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.5, bottom: SizeConfig.blockSizeVertical*1),
        padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*5),  
        child: Column(
          children: [
            Container(
              height: SizeConfig.blockSizeVertical *7,
              margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 1.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey[400]!,
                  width: 0.5
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300]!.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(-1, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Center(
                child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                  controller: search,
                  onChanged: (val){
                    setState(() {
                      filterIllness = illness.where((element) => element['name'].toString().toLowerCase().contains(val.toLowerCase())).toList();                      
                    });
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: SizeConfig.fontSize * 1.8),
                    contentPadding: EdgeInsets.symmetric(horizontal: 20)
                  ),
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: filterIllness.length,
                shrinkWrap: true,
                itemBuilder: (context, index){
                  return illnessCell(index);
                }
              ),
            ),

          ],
        )
      ),
    );
  }

  Widget illnessCell(int index){
    return GestureDetector(
      onTap: (){
        Get.to(WebViewScreen(url: filterIllness[index]['url'], name: filterIllness[index]['name'],));
      },
      child: Container(
        //height: SizeConfig.blockSizeVertical* 7,
        margin: EdgeInsets.only(top: (index == 0) ? 0 : SizeConfig.blockSizeVertical*1.5),
        padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal*2,),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300]!.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(-1, 1), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2, top: SizeConfig.blockSizeVertical*1, bottom: SizeConfig.blockSizeVertical*1),
                child: Text(
                  '${filterIllness[index]['name']}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: SizeConfig.fontSize*2,
                    fontWeight: FontWeight.w500
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2,),
              child: Center(child: Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: SizeConfig.blockSizeVertical*2,))
            )
          ],
        )
      ),
    );
  }
}