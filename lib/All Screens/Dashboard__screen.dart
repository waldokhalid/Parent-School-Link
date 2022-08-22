import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/local_push_notifications.dart';
import 'announcements_Screen.dart';
import 'grades_screen.dart';
import 'homeWork_screen.dart';
import 'schoolFeesPayment_screen.dart';
import 'start_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({key}) : super(key: key);
  static const String idScreen = "DashboardScreen";

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

final databaseReference = FirebaseDatabase.instance.reference();
final FirebaseAuth auth = FirebaseAuth.instance;

class _DashboardScreenState extends State<DashboardScreen> {
  String schoolName = "     ";
  String childName = " ";
  late String adminUID;
  String parentName = " ";
  dynamic arrived = "-";
  dynamic departed = "-";
  late String formattedDate;
  String school = " ";
  late String parentUID;
  late String token;

  String getTodaysDate() {
    var now = DateTime.now().toString();
    var date = DateTime.parse(now);
    formattedDate = "${date.day}-${date.month}-${date.year}";
    print(formattedDate);
    return formattedDate;
  }

  Future<String> getUID() async {
    // This method returns the current logged in users UID
    // ignore: unused_local_variable

    try {
      // final ref = FirebaseDatabase.instance.reference();
      setState(() {
        User? user = auth.currentUser;
        adminUID = user!.uid.toString();
      });
      await Future.delayed(
        Duration(milliseconds: 200),
      );
      getInfo(adminUID);
      return adminUID;
    } catch (e) {
      print("$e");
    }
    return adminUID;
  }

  void markChildAsAbsent() async {
    // var schoolName = await getSchoolName();
    getTodaysDate();
    print(schoolName);
    databaseReference
        .child("users")
        .child(schoolName)
        .child("Absent_Children")
        .child(formattedDate)
        .child(childName)
        .set(
      {
        "Child_Name": childName,
        "Parent_Name": parentName,
      },
    );
  }

  storeNotificationToken(schoolName) async {
    token = (await FirebaseMessaging.instance.getToken())!;
    print(token);
    print(schoolName);
    print(adminUID);

    databaseReference
        .child("users")
        .child(schoolName)
        .child("Parents")
        .child(adminUID)
        .update(
      {"token": token},
    );
  }

  Future<dynamic> getInfo(adminUID) async {
    // This method grabs Admin details
    // final x = await getParentUID();
    await databaseReference
        .child("users")
        .child("Parents")
        .child(adminUID)
        .once()
        .then(
      (snapshot) async {
        setState(() {
          schoolName = snapshot.value["school"];
          childName = snapshot.value["child"];
          parentName = snapshot.value["name"];
          print(schoolName);
        });
      },
    );
    getStudentTime(schoolName);
    storeNotificationToken(schoolName);
  }

  Future<dynamic> getStudentTime(school) async {
    print("Inside getSudentTime method");
    print(school);

    try {
      await databaseReference
          .child("users")
          .child(school)
          .child("Parents")
          .child(adminUID)
          .once()
          .then(
        (snapshot) async {
          setState(
            () {
              childName = snapshot.value["child"];
              arrived = snapshot.value["Arrived"];
              departed = snapshot.value["Departed"];
              print(arrived);
              print(departed);
            },
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  deleteNotificationToken() async {
    print("Inside Delete Notification METHOD");
    FirebaseMessaging.instance.deleteToken();
    print(schoolName);
    print(adminUID);
    try {
      print("Trying to re write databse token");
      await databaseReference
          .child("users")
          .child(schoolName)
          .child("Parents")
          .child(adminUID)
          .update(
        {"token": "No Token"},
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "$e",
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUID();
    // GetArrivalTime();
    getTodaysDate();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        shadowColor: Colors.grey,
        backgroundColor: Colors.grey[800],
        // leading: GestureDetector(
        //   onTap: () {
        //     Navigator.pushNamedAndRemoveUntil(
        //         context, MyApp.idScreen, (route) => false);
        //   },
        //   child: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //     size: 30,
        //   ),
        // ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Dashboard",
              style: GoogleFonts.lexendMega(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Column(
                  children: [
                    Text(
                      " Welcome, $parentName,\n",
                      style: GoogleFonts.lexendMega(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Parent of $childName\n",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "$schoolName",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  width: (MediaQuery.of(context).size.width) / 2.5,
                  height: (MediaQuery.of(context).size.height) / 24,
                  child: Center(
                    child: Text(
                      "Arived at: $arrived",
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                ),
                width: (MediaQuery.of(context).size.width) / 2.5,
                height: (MediaQuery.of(context).size.height) / 24,
                child: Center(
                  child: Text(
                    "Left at: $departed",
                    style: GoogleFonts.lexendMega(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              markChildAsAbsent();
              Fluttertoast.showToast(
                msg: "School Absentee list updated.",
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 4,
                backgroundColor: Colors.black,
                textColor: Colors.white,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 0), 
                    blurStyle: BlurStyle.outer// changes position of shadow
                  ),
                ],
              ),
              width: (MediaQuery.of(context).size.width) / 2.5,
              height: (MediaQuery.of(context).size.height) / 24,
              child: Center(
                child: Text(
                  "Mark Absent",
                  style: GoogleFonts.lexendMega(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, MainScreen.idScreen);
                  Null;
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.indigoAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 0), 
                    blurStyle: BlurStyle.outer// changes position of shadow
                  ),
                ],
                  ),
                  height: (MediaQuery.of(context).size.height) / 6.5,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Track School Bus",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, HomeworkScreen.idScreen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 0), 
                    blurStyle: BlurStyle.outer// changes position of shadow
                  ),
                ],
                      ),
                      height: (MediaQuery.of(context).size.height) / 15,
                      width: (MediaQuery.of(context).size.width) / 3,
                      child: Center(
                        child: Text(
                          "Homework",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendMega(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, GradesSreen.idScreen);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(15),
                        ),
                        boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 0), 
                    blurStyle: BlurStyle.outer// changes position of shadow
                  ),
                ],
                      ),
                      height: (MediaQuery.of(context).size.height) / 15,
                      width: (MediaQuery.of(context).size.width) / 3,
                      child: Center(
                        child: Text(
                          "Grades",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.lexendMega(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AnnouncementScreen.idScreen,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 0), 
                    blurStyle: BlurStyle.outer// changes position of shadow
                  ),
                ],
                  ),
                  height: (MediaQuery.of(context).size.height) / 6.5,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "Bulletin",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    SchoolFeesScreen.idScreen,
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purpleAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 6,
                    blurRadius: 6,
                    offset: Offset(0, 0), 
                    blurStyle: BlurStyle.outer// changes position of shadow
                  ),
                ],
                  ),
                  height: (MediaQuery.of(context).size.height) / 6.5,
                  width: (MediaQuery.of(context).size.width) / 3,
                  child: Center(
                    child: Text(
                      "School Fees",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.lexendMega(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              width: (MediaQuery.of(context).size.width) / 3,
              child: ElevatedButton(
                onPressed: () {
                  print("Clicked Logout");
                  // await FirebaseMessaging.instance.deleteToken();
                  deleteNotificationToken();
                  Navigator.pushNamedAndRemoveUntil(
                      context, StartScreen.idScreen, (route) => false);
                  FirebaseAuth.instance.signOut();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.arrow_back),
                    Text(
                      "LOGOUT",
                      style: GoogleFonts.lexendMega(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
