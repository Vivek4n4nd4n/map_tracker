import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_track/coffee_model.dart';
import 'package:widget_marker_google_map/widget_marker_google_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Drag to change map location'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late PageController _pageController;
  late GoogleMapController _controller;
  var previousPage;
  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }

  List<WidgetMarker> allMarkers = [];
  @override
  void initState() {
    super.initState();

    coffeeShops.forEach((element) {
      allMarkers.add(
        WidgetMarker(
          position: element.locationCoords,
          markerId: element.shopName,
          draggable: true,
          infoWindow: InfoWindow(
            title: element.shopName,
          ),
          widget: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 30, color: Colors.white, //width: 80,
                padding: const EdgeInsets.all(2),
                child:
                   

                    Text(element.shopName),
              ),
            ),
          ),
        ),
        // Marker(
        //     markerId: MarkerId(element.shopName),
        //     draggable: true,
        //     infoWindow:
        //         InfoWindow(title: element.shopName, snippet: element.address),
        //     position: element.locationCoords),
      );
    });
    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(() {
        _onScroll();
      });
    // ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_pageController.page?.toInt() != previousPage) {
      previousPage = _pageController.page!.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = (_pageController.page! - index);
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            child: widget,
            height: Curves.easeInOut.transform(value) * 125.0,
            width: Curves.easeInOut.transform(value) * 350.0,
          ),
        );
      },
      child: InkWell(
        // onFocusChange: (autofcus) {
        //  moveCamera();}

        onTap: () {
          //  _onScroll();
          // moveCamera();
        },
        child: Stack(children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              height: 125,
              width: 275,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(0.0, 4.0),
                      blurRadius: 10.0,
                    )
                  ]),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                        image: DecorationImage(
                            image: NetworkImage(coffeeShops[index].thumbnail),
                            fit: BoxFit.cover),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          coffeeShops[index].shopName,
                          style: TextStyle(
                              fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          coffeeShops[index].address,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          width: 150,
                          child: Text(
                            coffeeShops[index].description,
                            style: TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: coffeeShops[_pageController.page!.toInt()].locationCoords,
      zoom: 14.0,
      bearing: 45.0,
      tilt: 45.0,
    )));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.green[300],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(widget.title),
        ),
        body: Stack(
          children: <Widget>[
            // ignore: sized_box_for_whitespace
            Container(
              height: height,
              width: width,
              child: WidgetMarkerGoogleMap(
                initialCameraPosition: const CameraPosition(
                    target: LatLng(11.057786, 76.991440), zoom: 12),
                widgetMarkers: allMarkers,
                onMapCreated: mapCreated,
                mapType: MapType.normal,
              ),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                  height: 200,
                  width: width,
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: coffeeShops.length,
                      itemBuilder: (context, index) {
                        return _coffeeShopList(index);
                      })),
            )
          ],
        ));
  }
}
