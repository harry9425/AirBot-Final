import 'dart:async';
import 'dart:convert';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rive/rive.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../modelClasses/shopsclass.dart';
import '../modelClasses/userclass.dart';
import '../utils/marqueewidget.dart';
class loghomePage extends StatefulWidget {
  const loghomePage({super.key});

  @override
  State<loghomePage> createState() => _loghomePageState();
}

class _loghomePageState extends State<loghomePage> {

  var dronecnt=0;
  var CurrentRank="Loading..";
  var nextRidesgap="Loading..";
  Color rankcolour=Colors.grey;
  IconData ranklogo=Icons.area_chart_rounded;
  var issidemenuopen = false;
  LatLng currpos = LatLng(20.5937, 78.9629);
  Completer<GoogleMapController> controller = Completer();
  var auth = FirebaseAuth.instance;
  ItemScrollController itemScrollController = ItemScrollController();
  List<ShopModel> list = [];
  var laoding = true;
  BitmapDescriptor markericon = BitmapDescriptor.defaultMarker;
  String fetchaddress="Please update your Location..";
  double radiusofrange = 2;
  late var curruser;
  UserModel mainuser=UserModel.empty();
  final List<Marker> _markers = [];
  var database=FirebaseDatabase.instance.reference();
  var gname="Loading...";
  var totalrides="0";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    database.keepSynced(true);
    if(auth.currentUser!=null) {
      curruser = auth.currentUser?.uid;
      final ref = FirebaseDatabase.instance.ref().child("Users");
      ref.keepSynced(true);
      ref.child(curruser).get().then((value){
        if (value.exists) {
          UserModel userModel = UserModel.empty();
          userModel.name = value.child('name').value.toString() ?? '';
          userModel.id = value.child('id').value.toString() ?? '';
          userModel.uderdp = value.child('userdp').value.toString() ?? '';
          fetchaddress = value.child('coor').child('address').value.toString() ?? 'Please update your Location..';
          var lat=value.child('coor').child('latitude').value.toString() ?? '20.5937';
          var lng=value.child('coor').child("longitude").value.toString() ?? '78.9629';
          totalrides = value.child('totalRides').value.toString() ?? '0';
          double latitude = double.tryParse(lat) ?? 20.5937; // Use 0.0 as a default value if parsing fails
          double longitude = double.tryParse(lng) ?? 78.9629;
          currpos=LatLng(latitude,longitude);
          _markers.clear();
          _markers.add(
              Marker(
                markerId: MarkerId(curruser),
                position: LatLng(latitude, longitude,),
                infoWindow: InfoWindow(
                  title: "You",
                ),
                icon: markericon,
              )
          );
          updatecamera(latitude, longitude);
          mainuser=userModel;
          gname="Hello User";
          int time=TimeOfDay.now().hour;
          if(time<12) gname="Good Morning "+ mainuser.name;
          else if(time<=17) gname="Good Afternoon "+ mainuser.name;
          else gname="Good Evening "+ mainuser.name;
          Fluttertoast.showToast(msg: totalrides.toString());
          getRank(totalrides);
        }
      });
    }
    else{
      Navigator.pushNamedAndRemoveUntil(context,"welcome",(route) => false);
    }
  }

  updatecamera(var lat,var lng) async {
    GoogleMapController googleMapController = await controller.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(lat, lng), zoom: 15.5),
    ));
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    database
        .child('shops')
        .limitToLast(5)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        list.clear();
        Map<dynamic, dynamic> value = event.snapshot.value as dynamic;
        value.forEach((key, data) {
          ShopModel shopModel = ShopModel.empty();
          shopModel.name = data['name'].toString() ?? '';
          shopModel.key = data['id'].toString() ?? '';
          shopModel.location = data['location'].toString() ?? '';
          shopModel.dp = data['dp'].toString() ?? '';
          shopModel.isopen = data['isopen'].toString() ?? '';
          shopModel.coor = data['coordinates'].toString() ?? '';
          list.add(shopModel);
        });
        setState(() {
          laoding = false;
        });
      } else {
        print('No data available');
      }
    });
    int cnt=0;
    database.child('drone').onValue.listen((event) {
      cnt=0;
      if (event.snapshot.value != null) {
        for(DataSnapshot snapshot in event.snapshot.children){
          if(snapshot.child("currstatus").value.toString()=="1") cnt++;
        }
        setState(() {
          dronecnt=cnt;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenheight = MediaQuery
        .of(context)
        .size
        .height;
    var screenwidth = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: screenheight * 0.44,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 15, 15, 15),
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30,30,30,5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                issidemenuopen = !issidemenuopen;
                              });
                              Future.delayed(
                                  Duration(milliseconds: 1000), () {});
                            },
                            child: Icon(Icons.menu_rounded, color: Colors.white,
                              size: 35,)
                        ),
                        Text(gname, style: TextStyle(
                            color: Color.fromARGB(255, 240, 240, 240),
                            fontWeight: FontWeight.w600,
                            fontSize: 16),),
                        Container(
                            margin: EdgeInsets.only(right: 10),
                            child: CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 15,
                              backgroundImage: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_640.png"),
                            )
                        )
                      ],
                    ),
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Current Status", style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.area_chart_rounded, color: rankcolour, size: 20,),
                                  SizedBox(width: 7,),
                                  Text(CurrentRank, style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),),
                                ],
                              )
                            ]
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                            child: SizedBox(
                              height: 20,
                              child: Flex(
                                direction: Axis.horizontal,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(12, (index) => Text("-",style:TextStyle(color: Colors.white),)),
                              ),
                            )
                        ),
                        SizedBox(width: 10,),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Your Next Rewards", style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),),
                              SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(
                                    "assets/images/drone.png",
                                    color: Colors.white,
                                    width: 20,
                                    height: 20,
                                  ),
                                  SizedBox(width: 6,),
                                  Text(nextRidesgap, style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),),
                                ],
                              )
                            ]
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Text("choose your mode", style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18),),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "quickdroppage");
                            },
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white, //
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(0, 0),
                                  ),
                                ], // You can change the color as desired
                              ),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timelapse_sharp,
                                      color: Colors.blueAccent, size: 40,),
                                    SizedBox(height: 5,),
                                    Text("Quick Drop", style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Adjust the spacing between containers
                        Expanded(
                          child: GestureDetector(
                            onTap:(){
                              Navigator.pushNamed(context,"hourlydroppage");
                            },
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white, //
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(0, 0),
                                  ),
                                ], // You can change the color as desired
                              ),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.more_time, color: Colors.blueAccent,
                                      size: 40,),
                                    SizedBox(height: 5,),
                                    Text("Hourly Based", style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        // Adjust the spacing between containers
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pushNamed(context,"scheduledroppage");
                            },
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white, //
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(0, 0),
                                  ),
                                ], // You can change the color as desired
                              ),
                              child: Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_month_outlined,
                                      color: Colors.blueAccent, size: 40,),
                                    SizedBox(height: 5,),
                                    Text("Scheduled", style: TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12),),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
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
                                                fetchaddress,
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
                                        Expanded(
                                          flex: 1,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                100),
                                            // Adjust the circular border radius as needed
                                            child: Container(
                                              height: screenheight * 0.08,
                                              // Set the height dynamically
                                              child:GoogleMap(
                                                initialCameraPosition: CameraPosition(
                                                  zoom: 18,
                                                  target: LatLng(20.5937, 78.9629),
                                                ),
                                                markers: Set<Marker>.of(_markers),
                                                mapType: MapType.hybrid,
                                                compassEnabled: true,
                                                zoomGesturesEnabled: false,
                                                onMapCreated: (GoogleMapController c) {
                                                  controller.complete(c);
                                                },
                                                zoomControlsEnabled: false,
                                              ),
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
                                        GestureDetector(
                                          onTap: (){
                                            showSyncLocationDialog(context);
                                          },
                                          child: Text(
                                            "change",
                                            style: TextStyle(
                                              color: Colors.blueAccent,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                            softWrap: true, // Enable soft wrap for "Pickup Point"
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              "nearby "+dronecnt.toString(),
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13,
                                              ),
                                              softWrap: true, // Enable soft wrap for "Pickup Point"
                                            ),
                                            Image.asset(
                                              "assets/images/drone.png",
                                              color: (dronecnt==0)?Colors.grey:Colors.blueAccent,
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
                    SizedBox(height: 15,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Collaborated Shops", style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),),
                        Text("See More", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Expanded(
                        child:
                        laoding ? Container(child: Center(
                            child: CircularProgressIndicator(color: Colors.white,))) :
                        GridView.builder(
                          padding: EdgeInsets.only(top: 10, left: 2, right: 2),
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            bool isLastItemInRow = (index + 1) % 2 ==
                                0; // Check if it's the last item in the row

                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 200,
                                padding: EdgeInsets.only(
                                    left: 15, right: 15, top: 10, bottom: 8),
                                margin: EdgeInsets.only(bottom: 10,
                                    right: isLastItemInRow ? 0 : 10),
                                // Conditional margin
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 2,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              color: Colors.white,
                                              border: Border.all(
                                                color: Colors.grey, width: 1.0,)
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                100),
                                            child: Image.network(
                                              list[index].dp,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          height: 50,
                                          width: 50,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            children: [
                                              MarqueeWidget(
                                                child: Text(
                                                  list[index].name,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 5),
                                              Text(
                                                list[index].isopen == "true"
                                                    ? "Currently Open"
                                                    : "Closed",
                                                style: TextStyle(
                                                  color: list[index].isopen ==
                                                      "true"
                                                      ? Colors.blueAccent
                                                      : Colors.redAccent,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 10,
                                                ),
                                                softWrap: true,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/drone.png",
                                          color: Colors.grey,
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(width: 6,),
                                        Text(
                                          "5 mins away",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 10,
                                          ),
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .spaceEvenly,
                                              children: [
                                                Icon(Icons.shopping_cart,
                                                  color: Colors.white,
                                                  size: 15,),
                                                Text(
                                                  "Check Store",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius
                                                    .circular(10),
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
                                ),
                              ),
                            );
                          },
                        )
                    ),
                  ],
                ),
              ),
            ]
        )
    );
  }

  Future<bool> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return false;
    await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      GoogleMapController googleMapController = await controller.future;
      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 15.5),
      ));
      currpos=LatLng(position.latitude, position.longitude);
      _markers.clear();
      _markers.add(
          Marker(
            markerId: MarkerId(curruser),
            position: LatLng(position.latitude, position.longitude,),
            infoWindow: InfoWindow(
              title: "You",
            ),
            icon: markericon,
          )
      );
      var lat=position.latitude;
      var lng=position.longitude;
      String _host = 'https://maps.google.com/maps/api/geocode/json';
      final url = '$_host?key=AIzaSyCyTZJqntXd2VbJaw532eRiPVyBDek8Q5k&language=en&latlng=$lat,$lng';
      if(lat != null && lng != null){
        var response = await http.get(Uri.parse(url));
        if(response.statusCode == 200) {
          Map data = jsonDecode(response.body);
          String _formattedAddress = data["results"][0]["formatted_address"];
          print("response ==== $_formattedAddress");
          fetchaddress=_formattedAddress;
        } else{
            fetchaddress="Sorry Not able to get exact address of your location..";
        }
      } else {
          fetchaddress="Sorry Not able to get exact address of your location..";
      }

      Map<String, dynamic> map = {
        'latitude': position.latitude,
        'longitude': position.longitude,
        'address': fetchaddress
      };
      database.child("Users").child(curruser).child("coor").set(map);
      setState(() {});
      return true;
    }).catchError((e) {
      debugPrint(e);
      print(e);
      return false;
    });
    return true;
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: "Location services are disabled. Please enable the services");
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permissions are disabled");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg:
      'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  void showSyncLocationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            height: 350,
            child: Column(
              children: [
                SizedBox(height: 20),
                Image.asset(
                  "assets/images/location.png",
                  height: 200,
                  width: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Sync your location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState((){});
                    Fluttertoast.showToast(msg: "Fetching Location...");
                    _getCurrentPosition();
                  },
                  child: Text(
                    'Sync Now',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _signOut() {
    FirebaseAuth.instance.signOut().whenComplete((){
      Navigator.pushNamedAndRemoveUntil(context, 'welcome', (route) => false);
    }).onError((error, stackTrace){
      print(error.toString());
    });
  }
  void getRank(rides){
    int total=int.tryParse(rides)??0;
    if(total<2){
      rankcolour=Colors.white;
      CurrentRank="Bronze";
      nextRidesgap="${(2-total)} calls ways";
    }
    else if(total==2){
      rankcolour=Colors.blueAccent;
      CurrentRank="Silver";
      nextRidesgap="${(6-total)} calls ways";
    }
    else if(total<6){
      rankcolour=Colors.blueAccent;
      CurrentRank="Silver";
      nextRidesgap="${(6-total)} calls ways";
    }
    else if(total==6){
      rankcolour=Colors.greenAccent;
      CurrentRank="Gold";
      nextRidesgap="${(12-total)} calls ways";
    }
    else if(total<12){
      rankcolour=Colors.greenAccent;
      CurrentRank="Gold";
      nextRidesgap="${(12-total)} calls ways";
    }
    else if(total==12){
      rankcolour=Colors.redAccent;
      CurrentRank="Diamond";
      nextRidesgap="Coming Soon..";
    }
    else{
      rankcolour=Colors.redAccent;
      CurrentRank="Diamond";
      nextRidesgap="Coming Soon..";
    }
    setState(() {});
  }
}