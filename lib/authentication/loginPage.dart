import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  var auth=FirebaseAuth.instance;
  var key=GlobalKey<FormState>();
  var emailcontroller=TextEditingController();
  var passwordcontroller=TextEditingController();
  var done=false;
  var clicked=false;

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              // Image(image: AssetImage('assets/images/loginpagelogo.png'),height: size*0.25,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Welcome!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 50),),
                  done?SpinKitChasingDots(
                    size: 45,
                    color:  Colors.black87,
                  ):SpinKitThreeBounce(
                    size: 40,
                    color:  Colors.black87,
                  ),
                ],
              ),
              SizedBox(height: 4,),
              Text("Please provide your login details below.",style: TextStyle(color: Colors.black,fontSize: 15),textAlign: TextAlign.start,),
              SizedBox(height: 5,),
              Form(
                  key : key,
                  child:Container(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey), // Border color
                          ),
                          child:  TextFormField(
                            controller: emailcontroller,
                            validator: (value){
                              if(value!.isEmpty || !RegExp(r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$').hasMatch(value.trim())){
                                return "Enter Correct email";
                              }
                              else return null;
                            },
                            decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.account_circle,color: Colors.grey,),
                                labelText: "E-mail",
                                labelStyle: TextStyle(color: Colors.grey),
                                hintText: "E-mail",
                                border: InputBorder.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey), // Border color
                          ),
                          child:  TextFormField(
                            controller: passwordcontroller,
                            validator: (value){
                              value=value!.trim();
                              if(value!.isEmpty || value!.length<6){
                                return "Password length must be atleast 6.";
                              }
                              else return null;
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.fingerprint,color: Colors.grey,),
                                labelText: "Password",
                                labelStyle: TextStyle(color: Colors.grey),
                                hintText: "Password",
                                border: InputBorder.none
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: (){
                      showModalBottomSheet(context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          ),
                          builder: (context)=>Container(
                            padding: EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Make Selection!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 30),),
                                SizedBox(height: 4,),
                                Text("Select one of the options below to reset your password!",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15),textAlign: TextAlign.start,),
                                SizedBox(height: 25,),
                                GestureDetector(
                                  onTap: (){},
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color.fromARGB(100, 200, 200, 200)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.email_outlined,color: Colors.black,size: 60,),
                                        SizedBox(width: 20,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("E-mail",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
                                            SizedBox(height: 5,),
                                            Text("Reset password via E-mail",style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30,),
                                GestureDetector(
                                  onTap: ()=>{},
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: const Color.fromARGB(100, 200, 200, 200)
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.phone_android_outlined,color: Colors.black,size: 60,),
                                        SizedBox(width: 20,),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Phone",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18)),
                                            SizedBox(height: 5,),
                                            Text("Reset password via OTP",
                                                style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontSize: 15)),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                      );
                    },
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                    child: Text("Forget Password ?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                ),
              ),
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: ElevatedButton(
                      onPressed: (){
                        if((key.currentState!.validate())) {
                          signinuserwithemailandpass(emailcontroller.text, passwordcontroller.text);
                        }
                      },
                      child: Text("Continue",style:TextStyle(color: Colors.white),),
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
              SizedBox(height: 5,),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: (){
                      Navigator.pushReplacementNamed(context, 'signupPage');
                    },
                    style: ElevatedButton.styleFrom(foregroundColor: Colors.grey),
                    child: Text("Don't have and Account? SignUp",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future signinuserwithemailandpass(String email,String pass) async{
    setState(() {
      done=true;
    });
    try{
      await auth.signInWithEmailAndPassword(email:email.trim(), password: pass.trim()).then((value) async {
        await Future.delayed(Duration(milliseconds: 1000));
        setState(() {
          done=false;
        });
        Navigator.pushNamedAndRemoveUntil(
            (context), 'loghomePage', (route) => false);
      });
    } on FirebaseAuthException catch(e){
      setState(() {
        done=false;
      });
    }
    catch(_){
      setState(() {
        done=false;
      });
    }
  }
}
