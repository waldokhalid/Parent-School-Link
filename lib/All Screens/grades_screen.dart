import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../services/local_push_notifications.dart';

class GradesSreen extends StatefulWidget {
  static const String idScreen = "GradesSreen";
  // List<String> parentNotificationTOkens;

  const GradesSreen({
    key,
    // @required this.parentNotificationTOkens,
  }) : super(key: key);

  @override
  State<GradesSreen> createState() => _GradesSreenState();
}

class _GradesSreenState extends State<GradesSreen> {
  TextEditingController announcementTitle = TextEditingController();
  TextEditingController announcementBody = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();
  final FirebaseAuth auth = FirebaseAuth.instance;

  String baseName = "-";
  var color = Colors.black;

  List<String> listOfUrls = [];
  List<Widget> listOfPics = [];

  List<Announcement> announcementList = [];

  List<dynamic> notificationsList = [];

  var schoolName;
  var adminUID;

  var getDate;

  var formattedDate;

  late String sendTOken;

  var path;

  late String completePath;

  List<Map<String, dynamic>> files = [];

  late String getPath;
  late String schlName;

  getTodaysDate() async {
    setState(
      () {
        var now = DateTime.now().toString();
        var date = DateTime.parse(now);
        formattedDate = "${date.day}-${date.month}-${date.year}";
        print(formattedDate);
      },
    );
    return formattedDate;
  }

  Future<String> getUID() async {
    // This method returns the current logged in users UID
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    adminUID = user!.uid.toString();

    await Future.delayed(
      Duration(milliseconds: 200),
    );
    getInfo(adminUID);
    return adminUID;
  }

  Future<dynamic> getInfo(adminUID) async {
    await databaseReference
        .child("users")
        .child("Parents")
        .child(adminUID)
        .once()
        .then(
      (snapshot) async {
        setState(() {
          schoolName = snapshot.value["school"];
          print(schoolName);
        });
      },
    );
    getSchoolName();
  }

  getSchoolName() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    User? user = auth.currentUser;
    String adminUID = user!.uid.toString();
    print("Getting School Name");
    // ignore: unused_local_variable
    var myRef =
        databaseReference.child("users").child("Parents").child(adminUID);
    var snapshot = await myRef.get();
    if (snapshot.exists) {
      // var value = snapshot.value;
      setState(() {
        schlName = snapshot.value["school"];
      });
      print(schlName);
    } else {
      print("No Data Exists");
    }
    return schlName;
  }

  Future<List> getAnnouncements() async {
    schoolName = await getSchoolName();

    print("Getting details!!");
    // print(notificationsList);

    try {
      var ref =
          databaseReference.child("users").child(schoolName).child("Grades");
      // .child(formattedDate);
      var snapshot = await ref.get();
      if (snapshot.exists) {
        // print(snapshot.exists);
        // print(snapshot.value);
        setState(() {
          // var value = snapshot.value;
          announcementList = Map.from(snapshot.value)
              .values
              .map(
                (e) => Announcement.fromJson(
                  Map.from(e),
                ),
              )
              .toList();
          print(announcementList.length);
        });
      } else {
        print("No Data Exists");
      }
      return announcementList;
    } catch (e) {
      print("$e");
    }

    return announcementList;
  }

  @override
  void initState() {
    super.initState();
    getTodaysDate();
    getUID();
    getAnnouncements();
    // _load_Images();

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
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.grey[800],
        title: Text(
          "Grades",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            if (announcementList.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "NO GRADES POSTED YET",
                      style: GoogleFonts.lexendMega(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  itemCount: announcementList.length,
                  itemBuilder: (context, int index) {
                    final Announcement driver = announcementList[index];
                    final String title = driver.title;
                    final String body = driver.body;
                    // final String date = driver.date;
                    // final String driverPhone = driver.phone;
                    // final driverRandomId = driver.randomId;
                    // final String driverUID = driver.uid;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: Colors.deepPurpleAccent,
                        elevation: 0.2,
                        child: ExpansionTile(
                          // collapsedBackgroundColor: Colors.grey,
                          title: Text(
                            title.toUpperCase(),
                            style: GoogleFonts.lexendMega(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          children: [
                            Column(
                              children: [
                                Text(
                                  "$title".toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendMega(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "$body",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.lexendMega(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class Announcement {
  final String title;
  final String body;
  final String date;

  Announcement({
    required this.title,
    required this.body,
    required this.date,
  });

  static Announcement fromJson(Map<String, String> json) {
    return Announcement(
      title: json['title'].toString(),
      body: json['body'].toString(),
      date: json['date'].toString(),
    );
  }
}
