import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../All Widgets/progress_dialog.dart';
import '../main.dart';
import 'Dashboard__screen.dart';
import 'reset_password.dart';
import 'signup_screen.dart';

// ignore: must_be_immutable
class LoginScreen extends StatefulWidget {
  // route for teh login screen
  static const String idScreen = "login";

  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  String validateBeforeSending() {
    if (emailTextEditingController.text.isEmpty ||
        passwordTextEditingController.text.isEmpty) {
      return "empty";
    } else {
      return "not empty";
    }
  }

  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 50,
        shadowColor: Colors.grey,
        backgroundColor: Colors.grey[800],
        leading: GestureDetector(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, MyApp.idScreen, (route) => false);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        // color: Colors.yellow[400],
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 35,
                  ),
                  GradientText(
                    "School Link",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lexendMega(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                    colors: [
                      Colors.blueAccent,
                      Colors.redAccent,
                      Colors.greenAccent,
                    ],
                  ),
                  SizedBox(
                    height: 65,
                  ),
                  Text(
                    "Parent Login Screen",
                    style: GoogleFonts.robotoMono(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextField(
                          autofillHints: [AutofillHints.email],
                          controller: emailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                            ),
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                            hintStyle: GoogleFonts.lexendMega(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          style: GoogleFonts.lexendMega(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        TextField(
                            autofillHints: [AutofillHints.password],
                            controller: passwordTextEditingController,
                            obscureText: _isObscure,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1,
                                ),
                              ),
                              labelText: "password",
                              labelStyle: TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                              hintStyle: GoogleFonts.lexendMega(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                            style: GoogleFonts.lexendMega(
                              fontSize: 12,
                              color: Colors.white,
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String validator = validateBeforeSending();
                            if (validator != "empty") {
                              loginUser(context);
                            } else {
                              Fluttertoast.showToast(
                                msg:
                                    "Please Fill all the required fields above.",
                                gravity: ToastGravity.CENTER,
                                backgroundColor: Colors.black,
                                timeInSecForIosWeb: 4,
                              );
                            }
                          },
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.lexendMega(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.tealAccent[400],
                            primary: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context,
                                ResetPasswordScreen.idScreen, (route) => false);
                          },
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.lexendMega(
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, SignUpScreen.idScreen, (route) => false);
                      },
                      child: Text(
                        "Don't have an account? Click to Sign Up.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lexendMega(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.yellow[300]!.withOpacity(0.1),
                        primary: Colors.redAccent,
                        onSurface: Colors.cyanAccent,
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void loginUser(BuildContext context) async {
    showDialog(
      // this displays the message shown below under the circular progress bar.
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          elevation: 10,
          child: ProgressDialog(
            message: "Signing you in",
          ),
        );
      },
    );

    final User? user = (await _firebaseAuth
            .signInWithEmailAndPassword(
      // this will attempt to sign in the user using the given cridentials.
      email: emailTextEditingController.text,
      password: passwordTextEditingController.text,
    )
            .catchError((e) {
      // if there is an error, catch it
      Navigator.pop(context);
      displayToastMessage(
          "Error: " + e.toString(), context); // diplay the error to the user
    }))
        .user;

    if (user!.emailVerified) {
      // if user login successful
      userReference.child("Parents").child(user.uid).once().then(
        (DataSnapshot snap) {
          // variable "snap" is of type DataSnapshot. Everytime you read data from database, you recieve data as Datasnapshot.
          if (snap.value != null) {
            //  if snap value not equal to  null, login user and procceed to "MainScreen". Show toast meessage below.
            Navigator.pushNamedAndRemoveUntil(
                context, DashboardScreen.idScreen, (route) => false);
            displayToastMessage("Login Successful", context);
          } else {
            // if snap value is equal to null, dont sign in and display toast mesage
            Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("Account does NOT exist", context);
          }
        },
      );
    } else {
      // if login in not successful display toast message
      Navigator.pop(context);
      // displayToastMessage("Login Not Successful", context);
      Fluttertoast.showToast(
        msg:
            "Login Not Successful. Either Provided credentials are wrong or Email has not been verified.",
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 3,
      );
    }
  }

  displayToastMessage(String message, BuildContext context) {
    // create the displayToastMessage method.
    // giveit a parameter that will be a message.

    Fluttertoast.showToast(msg: (message));
  }
}
