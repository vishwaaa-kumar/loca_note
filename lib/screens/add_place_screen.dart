import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';

import '../providers/great_places.dart';
import '../widgets/images_input.dart';
import '../widgets/location_input.dart';
import '../models/place.dart';

class AddPlaceScreen extends StatefulWidget {
  
  static const routeName='/add-place';
  
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  
  final _titleController=TextEditingController();
  final _descriptionController=TextEditingController();
  File _pickedImage;
  PlaceLocation _pickedLocation;

  void _selectImage(File pickedImage) {
    _pickedImage=pickedImage;
  }

  void _selectPlace(double lat, double lng) {
    _pickedLocation= PlaceLocation(latitude: lat, longitude: lng);
  }

  void _savePlace() {

    if(_titleController.text.isEmpty||_descriptionController.text.isEmpty||_pickedImage==null||_pickedLocation==null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen:false)
      .addPlace(_titleController.text, _descriptionController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a New Place'),
        ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    TextField(
                      decoration: InputDecoration(labelText: 'Title'),
                      controller: _titleController,
                    ),
                    SizedBox(height:10,),
                    TextField(
                      decoration: InputDecoration(labelText: 'Description'),
                      controller: _descriptionController,
                    ),
                    SizedBox(height:10,),
                    TextField(
                      decoration: InputDecoration(labelText: 'Address'),
                    ),
                    SizedBox(height:10,),
                    ImageInput(_selectImage),
                    SizedBox(height: 10,),
                    LocationInput(_selectPlace),
                  ],
                ),
              ),
            ),
          ),
          RaisedButton.icon(
            icon:Icon(Icons.add),
            label:Text('Add Place'),
            onPressed: _savePlace,
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
          ),
        ],
      )
    );
  }
}
