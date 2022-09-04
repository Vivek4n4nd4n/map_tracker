import 'package:google_maps_flutter/google_maps_flutter.dart';

class Coffee {
  String shopName;
  String address;
  String description;
  String thumbnail;
  LatLng locationCoords;
  Coffee(
      {required this.shopName,
      required this.address,
      required this.thumbnail,
      required this.description,
      required this.locationCoords});
}

final List<Coffee> coffeeShops = [
Coffee(
  shopName:'Ragam Bakes',
  address: '278 sathy road',
  thumbnail: 'https://ragamcakes.com/UnderConstruction/images/logo.png',
  description: 'specials in cake items',
  locationCoords:const LatLng(11.065242,77.000488, ),
),
Coffee(
  shopName:'KR Bakes',
  address: '1263-B, Mettupalayam Rd',
  thumbnail: 'https://cdn1.vectorstock.com/i/1000x1000/58/10/bakery-shop-front-veiw-flat-icon-vector-17255810.jpg',
  description: 'specials in tea,coffee items',
  // ignore: prefer_const_constructors   
  locationCoords:  LatLng(11.022223,76.947448
 ),),
Coffee(
  shopName:'parsely Bakes',
  address: '126-e, Avinashi Rd',
  thumbnail: 'https://image.shutterstock.com/image-photo/kuala-lumpur-malaysia-august-25-260nw-1165039456.jpg',
  description: 'specials in spicy and sweet items',
  // ignore: prefer_const_constructors   
  locationCoords:  LatLng(11.036713,77.041925
 ),

)
  
];
