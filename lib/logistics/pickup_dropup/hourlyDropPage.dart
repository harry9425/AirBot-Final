import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class hourlyDropPage extends StatefulWidget {
  const hourlyDropPage({super.key});

  @override
  State<hourlyDropPage> createState() => _hourlyDropPageState();
}

class _hourlyDropPageState extends State<hourlyDropPage> {

  LatLng currpos = LatLng(20.5937, 78.9629);
  Completer<GoogleMapController> controller = Completer();
  var checked=true;
  TimeOfDay stime=TimeOfDay(hour: 7, minute: 30);
  TimeOfDay etime=TimeOfDay(hour: 8, minute: 30);
  var totalmin=60;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    totalmin=calculateTotalMinutes(stime, etime);
  }

  @override
  Widget build(BuildContext context) {
    var screenheight=MediaQuery.of(context).size.height;
    var screenwidth=MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(30, 30, 30, 10),
                  height: screenheight*0.14,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(80)),
                        child: IconButton(onPressed: ()=>{Navigator.pop(context)},
                          icon: Icon(Icons.arrow_back_ios_rounded,color: Colors.black,size: 25,),
                        ),
                      ),
                      Text("Hourly Based", style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 17),),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        height: 45,
                        width: 45,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3,
                                        spreadRadius: 3,
                                        offset: Offset(0, 3)
                                    )
                                  ]
                              ),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                "Pickup Point",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                                softWrap: true, // Enable soft wrap for "Pickup Point"
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                "H.12 shani-mandir, ambegoan back, 56 Pune Madya Pradesh 458001",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                                softWrap: true, // Enable soft wrap for the address
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              100),
                                          // Adjust the circular border radius as needed
                                          child: Container(
                                            height: 65,
                                            width: 65,
                                            child: GoogleMap(
                                              initialCameraPosition: CameraPosition(
                                                zoom: 16,
                                                target: LatLng(
                                                    18.4529, 73.8652),
                                              ),
                                              zoomControlsEnabled: false,
                                              zoomGesturesEnabled: false,
                                              mapType: MapType.hybrid,
                                              compassEnabled: true,
                                              onMapCreated: (
                                                  GoogleMapController c) {
                                                controller.complete(c);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider( // Insert a grey line
                                      color: Colors.grey,
                                      thickness: 0.5,
                                      // Adjust the thickness of the line as needed
                                      height: 20, // Adjust the height of the line as needed
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceBetween,
                                      children: [
                                        Text(
                                          "change",
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                          softWrap: true, // Enable soft wrap for "Pickup Point"
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "nearby 2 ",
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                              softWrap: true, // Enable soft wrap for "Pickup Point"
                                            ),
                                            Image.asset(
                                              "assets/images/drone.png",
                                              color: Colors.grey,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                    offset: Offset(0, 3)
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Start Time",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                          softWrap: true, // Enable soft wrap for "Pickup Point"
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: (){
                                                showtimepicker1();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "choose",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(5),
                                                ),
                                                backgroundColor: Colors.black87
                                                    .withOpacity(0.8),
                                                side: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_rounded,color: Colors.green,size: 35,),
                                                SizedBox(width: 5,),
                                                Text(
                                                  stime.hour.toString()+":"+stime.minute.toString()+(stime.hour>=12?" pm":" am"),
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 35,
                                                  ),
                                                  softWrap: true, // Enable soft wrap for the address
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                         )
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                    offset: Offset(0, 3)
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Handover Time",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                          softWrap: true, // Enable soft wrap for "Pickup Point"
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                              onPressed: (){
                                                showtimepicker2();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(5.0),
                                                child: Text(
                                                  "choose",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(5),
                                                ),
                                                backgroundColor: Colors.black87
                                                    .withOpacity(0.8),
                                                side: BorderSide(
                                                    color: Colors.black),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Icon(Icons.access_time_rounded,color: Colors.redAccent,size: 35,),
                                                SizedBox(width: 5,),
                                                Text(
                                                  etime.hour.toString()+":"+etime.minute.toString()+(etime.hour>=12?" pm":" am"),
                                                  style: TextStyle(
                                                    color: Colors.redAccent,
                                                    fontWeight: FontWeight.w800,
                                                    fontSize: 35,
                                                  ),
                                                  softWrap: true, // Enable soft wrap for the address
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(child: Container(
                          padding: EdgeInsets.fromLTRB(25, 15, 25, 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 3,
                                    spreadRadius: 3,
                                    offset: Offset(0, 3)
                                )
                              ]
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Choose your carrier.", style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14),),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(right: 10),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(0,1),
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        color: Colors.black12
                                                    )
                                                  ]
                                              ),
                                              child:Column(
                                                children: [
                                                  SizedBox(height: 5,),
                                                  Text("NanoHawk", style: TextStyle(
                                                      color: Colors.black,
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
                                                  Text("₹${(99 + (totalmin - 15) * 4.6).toInt()}.99", style: TextStyle(
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
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(0,2),
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        color: Colors.black12
                                                    )
                                                  ]
                                              ),
                                              child:Column(
                                                children: [
                                                  SizedBox(height: 5,),
                                                  Text("SkySwift", style: TextStyle(
                                                      color: Colors.black,
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
                                                  Text("₹${(299 + (totalmin - 15) * 6.6).toInt()}.99", style: TextStyle(
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
                                                  color:Colors.white,
                                                  borderRadius: BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        offset: Offset(0,2),
                                                        spreadRadius: 2,
                                                        blurRadius: 2,
                                                        color: Colors.black12,
                                                    )
                                                  ]
                                              ),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 5,),
                                                  Text("PowerLifter", style: TextStyle(
                                                      color: Colors.black,
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
                                                  Text("₹${(799 + (totalmin - 15) * 9.6).toInt()}.99", style: TextStyle(
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
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Checkbox(
                                    value: checked, // You can set the initial value here
                                    activeColor: Colors.blueAccent, onChanged: (bool? value) {setState(() {
                                    checked=!checked;
                                  });}, // Set the checkbox color here
                                  ),
                                  Expanded(
                                    child: Text(
                                      "Accept Terms and Conditions of airBot regarding safety of drone and yourself.",
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          "Place Booking",
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
                              SizedBox(height: 10,),
                            ],
                          ),
                        )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )
    );
  }

  int calculateTotalMinutes(TimeOfDay startTime, TimeOfDay endTime) {
    // Calculate the total minutes for each time
    int startMinutes = startTime.hour * 60 + startTime.minute;
    int endMinutes = endTime.hour * 60 + endTime.minute;

    // Calculate the difference
    int difference = endMinutes - startMinutes;

    return difference;
  }
  void showtimepicker1() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value){
      if(value!=null){
        stime=value!;
        if(stime.hour>=etime.hour) return;
        totalmin=calculateTotalMinutes(stime,etime);
        setState(() {
        });
      }
    });
  }
  void showtimepicker2() {
    showTimePicker(context: context, initialTime: TimeOfDay.now()).then((
        value) {
      if (value != null) {
        etime = value!;
        if(stime.hour>=etime.hour) return;
        totalmin = calculateTotalMinutes(stime, value);
        setState(() {});
      }
    });
  }

}
