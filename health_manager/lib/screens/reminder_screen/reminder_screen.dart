import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../controllers/app_controller.dart';
import '../../utils/constants.dart';
import '../../utils/size_config.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {

  List reminders = [];
  TextEditingController reminderText = TextEditingController();
  TextEditingController reminderTime = TextEditingController();
  final format = DateFormat("dd-MM-yyyy HH:mm");
  
  @override
  void initState() {
    super.initState();
    getAllReminders();
  }

  void getAllReminders() async {
    reminders.clear();
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().getAllReminders(reminders);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        reminders = result['Reminders'];
      });
    } 
    else {
      //Fail Cases Show String
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  void addReminderPressed() async {
    if (reminderText.text.isEmpty)
      Constants.showDialog("Please enter reminder description");
    else if (reminderTime.text.isEmpty)
      Constants.showDialog("Please enter reminder time");
    else
    {
      EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
      dynamic result = await AppController().addReminder(reminderText.text, reminderTime.text);
      EasyLoading.dismiss();     
      if (result['Status'] == "Success")
      {
        Constants.showDialog('Reminder added successfully');
        getAllReminders();
      }
      else 
      {
        Constants.showDialog(result['ErrorMessage']);
      }
    }
  }

   void deleteReminder(Map reminderData, int index) async {
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black,);
    dynamic result = await AppController().deleteReminder(reminderData);
    EasyLoading.dismiss();     
    
    if (result['Status'] == "Success") 
    {
      setState(() {
        reminders.removeAt(index);        
      });
    } 
    else {
      //Fail Cases Show String
      Constants.showDialog(result['ErrorMessage'],);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.appThemeColor,
        title: Text(
          'My Reminders',
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
            //TOP VIEW
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7),  
              child: Column(
                children: [
                  Container(
                    height: SizeConfig.blockSizeVertical *6,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.white,
                        width: 1
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: TextField(
                        style: TextStyle(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                        controller: reminderText,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter reminder',
                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: SizeConfig.fontSize * 1.8),
                          //contentPadding: EdgeInsets.symmetric(horizontal: 20)
                        ),
                      ),
                    ),
                  ),

                  Container(
                    height: SizeConfig.blockSizeVertical *6,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.white,
                        width: 1
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(-1, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Theme(
                        data: ThemeData(
                          primarySwatch: Colors.pink,
                        ),
                        child: DateTimeField(
                          format: format,
                          controller: reminderTime,
                          resetIcon: Icon(Icons.close, color: Colors.transparent,),
                          style: GoogleFonts.poppins(color: Colors.black, fontSize: SizeConfig.fontSize * 1.8),
                          decoration: InputDecoration(
                            hintStyle: GoogleFonts.poppins(fontSize: SizeConfig.fontSize * 1.8, color: Colors.grey[400],),
                            border: InputBorder.none,
                            hintText: 'Enter reminder time',
                            //contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                          ),
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100)
                            );
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime:TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                      ),
                    ),
                  ),

                  GestureDetector(
                    onTap: addReminderPressed,
                    child: Container(
                      margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 2, bottom: SizeConfig.blockSizeVertical * 3,),
                      height: SizeConfig.blockSizeVertical *6,
                      decoration: BoxDecoration(
                        color: Constants.appThemeColor,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text(
                          '+ Add',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.fontSize * 2.1,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.5),
              padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7),  
              child: Text(
                'Total Reminders (${reminders.length})',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: SizeConfig.fontSize*1.8,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),

            Expanded(
              child: (reminders.isEmpty) ? Container(
                margin: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical*1.5),
                child: Center(
                  child: Text(
                    'No reminders added',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: SizeConfig.fontSize*1.7,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ) : Container(
                margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*1.5),
                padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockSizeHorizontal*7),  
                child: ListView.builder(
                  itemCount: reminders.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index){
                    return reminderCell(reminders[index], index);
                  }
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget reminderCell(Map reminder, int index){
    return Container(
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
          // Container(
          //   margin: EdgeInsets.only(right: SizeConfig.blockSizeHorizontal*2, top: 3),
          //   child: Icon(Icons.alarm, color: Colors.grey[400], size: SizeConfig.blockSizeVertical*2.5,)
          // ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2,),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '${reminder['reminder']}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.fontSize*1.6,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical*0.3),
                    child: Text(
                      '${reminder['reminderTime']}',
                      style: TextStyle(
                        color: Constants.appThemeColor,
                        fontSize: SizeConfig.fontSize*1.4,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){
                  deleteReminder(reminder, index);
                },
                child: Container(
                  margin: EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*2,),
                  child: Center(child: Icon(Icons.delete_outline, color: Colors.grey[400], size: SizeConfig.blockSizeVertical*2.5,))
                ),
              )
            ],
          ),
        ],
      )
    );
  }
}