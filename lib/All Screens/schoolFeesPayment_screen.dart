import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SchoolFeesScreen extends StatefulWidget {
  const SchoolFeesScreen({key}) : super(key: key);
  static const String idScreen = "SchoolFeesScreen";

  @override
  State<SchoolFeesScreen> createState() => _SchoolFeesScreenState();
}

class _SchoolFeesScreenState extends State<SchoolFeesScreen> {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth auth = FirebaseAuth.instance;

  late String schlName;
  late String parentUID;

  int totalFees = 0;
  int paidFees = 0;
  int balanceFees = 0;

  getSchoolName() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    // User user = auth.currentUser;
    // String adminUID = user.uid.toString();
    setState(() {
      User? user = auth.currentUser;
      String adminUID = user!.uid.toString();
      parentUID = adminUID;
      print("Set UID");
      print(parentUID);
    });
    print("Getting School Name");
    // ignore: unused_local_variable
    var myRef = await databaseReference
        .child("users")
        .child("Parents")
        .child("$parentUID");
    var snapshot = await myRef.get();
    if (snapshot.exists) {
      // var value = snapshot.value;
      setState(() {
        schlName = snapshot.value["school"];
      });
      print(schlName);
    } else {
      print("No School Exists");
    }
    return schlName;
  }

  void getFeesInfo() async {
    // ignore: unused_local_variable
    // final ref = FirebaseDatabase.instance.reference();
    // setState(() {
    //   User user = auth.currentUser;
    //   String adminUID = user.uid.toString();
    //   parentUID = adminUID;
    // });
    var schoolName = await getSchoolName();

    print("Getting School Name");
    // ignore: unused_local_variable
    print("$schoolName and $parentUID");
    try {
      var myRef = await databaseReference
          .child("users")
          .child(schoolName)
          .child("Parents")
          .child("$parentUID");
      var snapshot = await myRef.get();
      if (snapshot.exists) {
        // var value = snapshot.value;
        setState(() {
          totalFees = snapshot.value["Total"];
          paidFees = snapshot.value["Paid"];
          balanceFees = snapshot.value["Balance"];
        });
        // print(schlName);
      } else {
        print("No Data Exists");
      }
    } catch (e) {
      print("$e");
    }
  }

  @override
  void initState() {
    super.initState();
    getFeesInfo();
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
          "School Fees Info",
          style: GoogleFonts.lexendMega(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Total Fees: KSH $totalFees",
                style: GoogleFonts.lexendMega(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Paid Fees: KSH $paidFees",
                style: GoogleFonts.lexendMega(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                "Balance Fees: KSH $balanceFees",
                style: GoogleFonts.lexendMega(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
