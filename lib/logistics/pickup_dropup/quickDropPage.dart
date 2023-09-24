import 'dart:async';
import 'dart:convert';
import 'package:airbot_final/utils/marqueewidget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../modelClasses/userclass.dart';

class quickDropPage extends StatefulWidget {
  const quickDropPage({Key? key}) : super(key: key);

  @override
  State<quickDropPage> createState() => _quickDropPageState();
}

class _quickDropPageState extends State<quickDropPage> {
  LatLng currpos = LatLng(20.5937, 78.9629);
  Completer<GoogleMapController> controller = Completer();

  // Define a custom map style with a black background
  final String blackMapStyle ='''
  [
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "on"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#212121"
      }
    ]
  },
  {
    "featureType": "administrative",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "administrative.country",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "featureType": "administrative.locality",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#181818"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#1b1b1b"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry.fill",
    "stylers": [
      {
        "color": "#2c2c2c"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#8a8a8a"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#373737"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#3c3c3c"
      }
    ]
  },
  {
    "featureType": "road.highway.controlled_access",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#4e4e4e"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#000000"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#3d3d3d"
      }
    ]
  }
]
  ''';

  var auth = FirebaseAuth.instance;
  ItemScrollController itemScrollController=ItemScrollController();
  String userid = "";
  late UserModel curruser;
  String chatuserid="";
  DatabaseReference database = FirebaseDatabase.instance.reference();
  List<List<String>> list = [];
  var laoding=true;
  var pastlocation=false;
  var currpage=0;
  var updown=0;

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    Fluttertoast.showToast(msg: userid);
    database
        .child('Users').child(userid).child("past locations")
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        list.clear();
       for (DataSnapshot snapshot in event.snapshot.children){
          list.add([snapshot.key.toString(),snapshot.value.toString()]);
       }
       laoding=false;
       pastlocation=true;
       setState(() {});
      } else {
        laoding=false;
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    super.initState();
    database.keepSynced(true);
    if (auth.currentUser == null) {
      Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
    }
    userid = auth.currentUser!.uid;
    list.clear();
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                zoom: 16,
                target: LatLng(18.4529, 73.8652),
                // Set the map tilt to 45 degrees
              ),
              zoomControlsEnabled: false,
              zoomGesturesEnabled: true,
              compassEnabled: false,
              onMapCreated: (GoogleMapController c) {
                controller.complete(c);
                c.setMapStyle(blackMapStyle);
              },
            ),
          ),
          Positioned(
            top: 30, // Adjust the top position as needed
            left: 10, // Adjust the left position as needed
            child: IconButton(
              icon: Icon(Icons.arrow_back,color: Colors.white,size: 30,),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            top: 30, // Adjust the top position as needed
            right: 2, // Adjust the left position as needed
            child: IconButton(
              icon: Icon(Icons.menu,color: Colors.white,size: 30,),
              onPressed: () {},
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          margin:EdgeInsets.only(top: 30),
                          width: screenwidth,
                          //height:screenheight*0.4,
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child:Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Where to Pick and Drop Parcel?", style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14),),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.my_location,color: Colors.blueAccent,size: 32,),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,// Adjust the font size for entered text// Set to bold
                                        color: Colors.black, // Set text color to black
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Pickup Location",
                                        hintStyle: TextStyle(fontSize: 22, color: Colors.black54), // Adjust font size
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey), // Set the bottom line color
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey), // Set the bottom line color
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 15,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_location_alt_rounded,color: Colors.blueAccent,size: 30,),
                                  SizedBox(width: 20,),
                                  Expanded(
                                    child: TextField(
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,// Adjust the font size for entered text// Set to bold
                                        color: Colors.black, // Set text color to black
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Drop-off Location",
                                        hintStyle: TextStyle(fontSize: 22, color: Colors.black54),  // Adjust font size
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey), // Set the bottom line color
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Colors.grey), // Set the bottom line color
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 15,),
                              updown==1?Column(
                                children: [
                                  if(currpage==0) Row(
                                    children: [
                                      Text("your recent locations", style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),),
                                      SizedBox(width: 4,),
                                      laoding?SpinKitThreeBounce(color: Colors.black87,size: 15,):Container()
                                    ],
                                  ),
                                  if(currpage==1) Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Choose your carrier.", style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),),
                                      if(currpage==1) GestureDetector(
                                        onTap: (){
                                          setState(() {
                                            currpage=0;
                                          });
                                        },
                                        child: Text("Go Back  ", style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14),),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  if(currpage==0)  (laoding || !pastlocation)?Container():SizedBox(
                                    width: screenwidth,
                                    height: 200,
                                    child:ListView.builder(
                                      padding: EdgeInsets.only(bottom: 20),
                                      itemCount: list.length,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (BuildContext context, int index) {
                                        List<String> ls = list[index];
                                        return Container(
                                          padding: EdgeInsets.all(10),
                                          margin: EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              border: Border.all(color: Colors.grey,width: 1)
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(100),
                                                    border: Border.all(color: Colors.black87,width: 0.5)
                                                ),
                                                child: Icon(Icons.access_time_filled_rounded,color: Colors.black87,size: 25,),
                                              ),
                                              SizedBox(width: 10,),
                                              Expanded(
                                                child: MarqueeWidget(
                                                  child: Text(ls[1], style: TextStyle(
                                                      color: Colors.black87,
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 14),),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  if(currpage==1) Row(
                                    children: [
                                      Expanded(
                                        child: SingleChildScrollView(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.only(bottom: 6),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black87
                                                          .withOpacity(0.8),
                                                      borderRadius: BorderRadius.circular(20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset: Offset(0,1),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            color: Colors.grey
                                                        )
                                                      ]
                                                  ),
                                                  child:Column(
                                                    children: [
                                                      SizedBox(height: 5,),
                                                      Text("NanoHawk", style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15),),
                                                      Image.asset(
                                                        "assets/images/dronelight.png",
                                                        height: 120,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Text("under 1Kgs", style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12),),
                                                      SizedBox(height: 5,),
                                                      Text("₹99.00", style: TextStyle(
                                                          color: Colors.blueAccent,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15),),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                      color: Colors.black87
                                                          .withOpacity(0.8),
                                                      borderRadius: BorderRadius.circular(20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset: Offset(0,2),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            color: Colors.grey
                                                        )
                                                      ]
                                                  ),
                                                  child:Column(
                                                    children: [
                                                      SizedBox(height: 5,),
                                                      Text("SkySwift", style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15),),
                                                      Image.asset(
                                                        "assets/images/dronemid.png",
                                                        height: 120,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Text("under 5Kgs", style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12),),
                                                      SizedBox(height: 5,),
                                                      Text("₹299.00", style: TextStyle(
                                                          color: Colors.blueAccent,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15),),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: 10,),
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  margin: EdgeInsets.only(right: 10),
                                                  decoration: BoxDecoration(
                                                      color:Colors.black87
                                                          .withOpacity(0.8),
                                                      borderRadius: BorderRadius.circular(20),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset: Offset(0,2),
                                                            spreadRadius: 2,
                                                            blurRadius: 2,
                                                            color: Colors.grey
                                                        )
                                                      ]
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(height: 5,),
                                                      Text("PowerLifter", style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15),),
                                                      Image.asset(
                                                        "assets/images/droneheavy.png",
                                                        height: 120,
                                                        fit: BoxFit.fill,
                                                      ),
                                                      Text("under 15Kgs", style: TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 12),),
                                                      SizedBox(height: 5,),
                                                      Text("₹799.00", style: TextStyle(
                                                          color: Colors.blueAccent,
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15),),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if(currpage==1) Column(
                                    children: [
                                      SizedBox(height: 8,),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {},
                                                child: Text("Payment",style: TextStyle(color: Colors.white,fontSize: 13),),
                                                style: OutlinedButton.styleFrom(
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    foregroundColor: Colors.black,
                                                    backgroundColor: Colors.black87
                                                ),
                                              )
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {},
                                                child: Text("UPI / Card",style: TextStyle(color: Colors.black,fontSize: 12),),
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  foregroundColor: Colors.black,
                                                  side: BorderSide(color: Colors.black),
                                                  //  padding: EdgeInsets.symmetric(vertical: 14)
                                                ),
                                              )
                                          ),
                                          SizedBox(width: 10,),
                                          Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {},
                                                child: Text("Wallet",style: TextStyle(color: Colors.black,fontSize: 12),),
                                                style: OutlinedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20)
                                                  ),
                                                  foregroundColor: Colors.black,
                                                  side: BorderSide(color: Colors.black),
                                                  //  padding: EdgeInsets.symmetric(vertical: 14)
                                                ),
                                              )
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              currpage=1;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              "Continue",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius
                                                  .circular(15),
                                            ),
                                            backgroundColor: Colors.black87
                                                .withOpacity(0.8),
                                            side: BorderSide(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ):Container(),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 25, // Adjust the right position as needed
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(color: Colors.black45),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 0,
                                  spreadRadius: 2,
                                  offset: Offset(0,3),
                                )
                              ]
                            ),
                            child: IconButton(
                              icon: Icon(updown==1?Icons.keyboard_arrow_down_rounded:Icons.keyboard_arrow_up_rounded,color: Colors.black,size: 30,),
                              onPressed: () {
                                setState(() {
                                  updown=1-updown;
                                });
                              },
                            ),
                          )
                        ),
                      ]
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

}

