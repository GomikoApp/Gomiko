import 'package:flutter/material.dart';

class Waste {
  final String name;
  final WasteCategory category;
  final WasteType type;
  final Image image;

  Waste({
    required this.name,
    required this.category,
    required this.type,
    required this.image,
  });
}

///
/// List of all wastes.
///
enum WasteCategory {
  plastic, // eg. bottles
  paper, // eg. cardboard
  glass, // eg. bottles
  metal, // eg. aluminum
  organic, // eg. food
  eWaste, // eg. electronics
  hazardous, // eg. batteries
  other, // eg. diapers, clothes
}

///
/// List of all waste types.
/// This is used to determine which bin the waste should go into.
enum WasteType {
  recyclable, // eg. plastic bottles
  compostable, // eg. food, paper
  landfill, // eg. diapers
  hazardous, // eg. batteries
}
