import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/place.dart';
import '../helpers/db_helpers.dart';
import '../helpers/location_helpers.dart';

class GreatPlaces with ChangeNotifier {
  
  List<Place> _items=[];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id== id);
  }

  Future<void> addPlace(String pickedTitle,
   String pickedDescription,
   File pickedImage,
   PlaceLocation pickedLocation,
  ) async {
    final address= await LocationHelper.getPlaceAddress(pickedLocation.latitude,
     pickedLocation.longitude);
    final updatedLocation= PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace=Place(
      id: DateTime.now().toString(),
      image: pickedImage,
      title: pickedTitle,
      description: pickedDescription,
      location: updatedLocation,
      );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert(
      'USER_PLACES',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'description': newPlace.description,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location.latitude,
        'loc_lng': newPlace.location.longitude,
        'address': newPlace.location.address,
      });
  }

  Future<void> fetchAndSetPlaces() async {
      final dataList= await DBHelper.getData('USER_PLACES');
      _items= dataList
      .map(
        (item) => Place(
          id: item['id'],
          title: item['title'],
          description: item['description'],
          image: File(item['image']),
          location: PlaceLocation(
            latitude: item['loc_lat'],
            longitude: item['loc_lng'],
            address: item['address'],
          ),
        ),
      ).toList();
    notifyListeners();
    }

}
