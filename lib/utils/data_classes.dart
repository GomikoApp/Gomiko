/*
  This file is here to provide consistency between functions about what types
  they are using for different data-types that aren't defined yet.
  
  EX: 
  A global UserData class that outlines the types defined in the Database Diagram
  and reflected by the users collection on Firestore so we can create type-safe
  document CRUD requests to the Firestore Database.
  
  - Authored by Anthony 05/18/24
*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_mappable/dart_mappable.dart';

part 'data_classes.mapper.dart';

// Hook that automatically turns each key in the map from snake case to camel case.
class CamelCaseHook extends MappingHook {
  const CamelCaseHook();

  Map<String, dynamic> convertMapKeysToCamelCase(Map<String, dynamic> map) {
    final Map<String, dynamic> result = {};

    map.forEach((key, value) {
      String newKey = _convertToCamelCase(key);

      if (value is Map<String, dynamic>) {
        result[newKey] = convertMapKeysToCamelCase(value);
      } else {
        result[newKey] = value;
      }
    });

    return result;
  }

  String _convertToCamelCase(String text) {
    if (text.isEmpty) {
      return text;
    }

    List<String> parts = text.split('_');
    String firstPart = parts.first.toLowerCase();
    List<String> otherParts = parts.skip(1).map((part) => part[0].toUpperCase() + part.substring(1).toLowerCase()).toList();

    return firstPart + otherParts.join('');
  }

  @override
  Object? beforeDecode(Object? value) {
    return convertMapKeysToCamelCase(value as Map<String, dynamic>);
  }
}

/// UserData class: Used for type-safety in the "users" document in Firestore
/// From this documentation: https://pub.dev/packages/dart_mappable
@MappableClass(hook: CamelCaseHook(), caseStyle: CaseStyle.snakeCase)
class UserData with UserDataMappable {
  @MappableConstructor()
  UserData(
    {
      this.uid,
      this.email,
      this.location = "Earth", 
      this.name = "Anonymous", 
      this.points = 0,
      this.oauthProvider,
      this.profileBio = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
      this.profilePictureUrl = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
      this.profileUsername = "Anonymous",
      List<DocumentReference>? savedItems,
      List<DocumentReference>? savedPosts
    }
  ) {
    this.savedItems = savedItems ?? [];
    this.savedPosts = savedItems ?? [];
  }

  final String? uid;
  final String? email;
  final String? location;
  final String? name;
  final String? oauthProvider;
  final int? points;
  final String? profileBio;
  final String? profilePictureUrl;
  final String? profileUsername;
  late List<DocumentReference> savedItems;
  late List<DocumentReference> savedPosts;
}