class Waste {
  final WasteCategory category;
  final String image;

  Waste({
    required this.category,
    required this.image,
  });

  get name => category.name;
}

///
/// List of all wastes.
///
enum WasteCategory {
  burnable,
  nonBurnable, // includes sharp objects that need to be wrapped
  recyclable, // includes cans, glass, paper, etc.
  paper, // but large cardboard boxes are kept separate
  hazardous, // includes batteries, light bulbs, etc.
  oversized, // Need to call local facility to pick up. Includes furniture, etc.
}

extension WasteCategoryExtension on WasteCategory {
  String get name {
    switch (this) {
      case WasteCategory.burnable:
        return "Burnable";
      case WasteCategory.nonBurnable:
        return "Non-Burnable";
      case WasteCategory.recyclable:
        return "Recyclable";
      case WasteCategory.paper:
        return "Paper";
      case WasteCategory.hazardous:
        return "Hazardous";
      case WasteCategory.oversized:
        return "Oversized";
    }
  }
}
