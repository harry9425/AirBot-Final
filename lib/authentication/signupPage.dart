import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:airBot/modelClasses/userclass.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:airBot/utils/colors.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {

  var auth = FirebaseAuth.instance;
  late DatabaseReference database;
  var key = GlobalKey<FormState>();
  var namecontroller = TextEditingController();
  var phonecontroller = TextEditingController();
  var emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var done = false;
  var locationdone = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database = FirebaseDatabase.instance.ref();
    database.keepSynced(true);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 35,),
              //Image(image: AssetImage('assets/images/signuplogo.png'),height: size*0.2,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Hola!", style: TextStyle(color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 60),),
                    done ? SpinKitChasingDots(size: 40,
                      color: Colors.black,) : SpinKitFadingGrid(
                      size: 45,
                      color: Colors.black,
                    ),
                  ]),
              SizedBox(height: 4,),
              Text("Enter the details below to get started.", style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 15), textAlign: TextAlign.start,),
              Form(
                  key: key,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey), // Border color
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.account_circle, color: Colors.grey),
                              labelText: "Name",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "Name",
                              border: InputBorder.none, // Remove the default border
                            ),
                            validator: (value) {
                              value = value!.trim();
                              if (value.isEmpty || value.length > 20) {
                                return "Enter Correct Name";
                              } else {
                                return null;
                              }
                            },
                            controller: namecontroller,
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey), // Border color
                          ),
                          child: TextFormField(
                          controller: emailcontroller,
                          validator: (value) {
                            if (value!.isEmpty || !RegExp(
                                r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(value.trim())) {
                              return "Enter Correct email";
                            }
                            else
                              return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.alternate_email_outlined,
                                color: Colors.grey,),
                              labelText: "E-mail",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "E-mail",
                              border:  InputBorder.none,
                          ),
                        ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey), // Border color
                          ),
                          child: TextFormField(
                          controller: phonecontroller,
                          validator: (value) {
                            if (value!.isEmpty || !RegExp(r'([0-9]{10}$)')
                                .hasMatch(value.trim())) {
                              return "Enter correct phone number format";
                            }
                            else
                              return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.phone_android,
                                color: Colors.grey,),
                              labelText: "Phone",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "Phone",
                              border:  InputBorder.none,
                          ),
                        ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey), // Border color
                          ),
                          child:
                          TextFormField(
                          obscureText: true,
                          controller: passwordcontroller,
                          validator: (value) {
                            value = value!.trim();
                            if (value!.isEmpty || value!.length < 6) {
                              return "Password length must be atleast 6.";
                            }
                            else
                              return null;
                          },
                          decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.fingerprint,
                                color: Colors.grey,),
                              suffixIcon: Icon(Icons.remove_red_eye,
                                color: Colors.grey,),
                              labelText: "Password",
                              labelStyle: TextStyle(color: Colors.grey),
                              hintText: "Password",
                              border:InputBorder.none,
                          ),
                        ),
                        ),
                        SizedBox(height: 20,),
                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ElevatedButton(
                                onPressed: () {
                                  if ((key.currentState!.validate())) {
                                    createuserwithemailandpass(
                                        emailcontroller.text,
                                        passwordcontroller.text);
                                  }
                                },
                                child: Text(done ? "Processing..." : "Sign-Up",
                                  style: TextStyle(color: Colors.white),),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    backgroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(),
                                    foregroundColor: Colors.white,
                                    side: BorderSide(color: Colors.black
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 14)
                                ),
                              ),
                            )
                        ),
                        SizedBox(height: 10,),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, 'loginPage');
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.grey),
                              child: Text("Already have an Account? Login",
                                style: TextStyle(color: Colors.black,
                                    fontWeight: FontWeight.w500),)
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),
      ),
    );
  }

  Future createuserwithemailandpass(String email, String pass) async {
    setState(() {
      done = true;
    });
    try {
      print("andr    aagya brooo");
      await auth.createUserWithEmailAndPassword(
          email: email.trim(), password: pass.trim()).then((value) async {
        DateTime today = DateTime.now();
        String formattedDate = DateFormat('d MMM yy').format(today);
        formattedDate = formattedDate.replaceAllMapped(
            RegExp(r'(\d+)(st|nd|rd|th)'), (Match m) {
          var suffix = '';
          if (m.group(2) == '1' && m.group(1) != '11') {
            suffix = 'st';
          } else if (m.group(2) == '2' && m.group(1) != '12') {
            suffix = 'nd';
          } else if (m.group(2) == '3' && m.group(1) != '13') {
            suffix = 'rd';
          } else {
            suffix = 'th';
          }
          return '${m.group(1)}$suffix';
        });
        Map<String, dynamic> map = {
          'id': value.user!.uid.toString(),
          'phone': phonecontroller.text.trim(),
          'userdp': "https://firebasestorage.googleapis.com/v0/b/groupies-29fbd.appspot.com/o/userdp%2F508-5087236_tab-profile-f-user-icon-white-fill-hd.png?alt=media&token=ff05d49f-011b-456a-b002-880c0f7d2159",
          'email': emailcontroller.text.trim(),
          'password': passwordcontroller.text.trim(),
          'name': namecontroller.text.trim(),
          'time': formattedDate,
        };
        var database = FirebaseDatabase.instance.ref();
        database.child("Users").child(value.user!.uid.toString())
            .set(map)
            .then((v) {
              print("aagya brooo");
          setState(() {
            done = false;
          });
          if (value.user!.uid == null) {
            Navigator.pushNamedAndRemoveUntil(
                (context), 'loginPage', (route) => false);
          }
          else
            Navigator.pushNamedAndRemoveUntil(
                (context), 'loghomePage', (route) => false);
        }).onError((error, stackTrace) {
          setState(() {
            done = false;
          });
        });
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        done = true;
      });
    }
    catch (_) {
      setState(() {
        done = true;
      });
    }
  }
}
