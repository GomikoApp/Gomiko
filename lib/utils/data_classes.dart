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

// Hook that automatically turns each key in the map from snake case to camel case.
// AS OF NOW THIS IS UNUSED, although the function to turn keys from snake case to camel case might prove useful at some point.
class CamelCaseHook {
  // const CamelCaseHook();

  static Map<String, dynamic> convertMapKeysToCamelCase(
      Map<String, dynamic> map) {
    final Map<String, dynamic> result = {};

    map.forEach((key, value) {
      String convertToCamelCase(String text) {
        if (text.isEmpty) {
          return text;
        }

        List<String> parts = text.split('_');
        String firstPart = parts.first.toLowerCase();
        List<String> otherParts = parts
            .skip(1)
            .map((part) =>
                part[0].toUpperCase() + part.substring(1).toLowerCase())
            .toList();

        return firstPart + otherParts.join('');
      }

      String newKey = convertToCamelCase(key);

      if (value is Map<String, dynamic>) {
        result[newKey] = convertMapKeysToCamelCase(value);
      } else {
        result[newKey] = value;
      }
    });

    return result;
  }

  // @override
  // Object? beforeDecode(Object? value) {
  //   final result = convertMapKeysToCamelCase(value as Map<String, dynamic>);

  //   print("BEFORE DECODE RESULT: $result");

  //   return result;
  // }
}

/// UserData class: Used for type-safety in the "users" document in Firestore.
/// It holds static keys for the properties in the users documents.
/// This is currently not null-safe (as in the case of the key not existing is possible and would probably
/// throw an error), however, we'll fix this when we can.
///
/// There is also a method UserData.asMap() that works as the old constructor.toMap did, allowing
/// you to pass arguments to automatically parse it as a map that can be sent to Firestore.
///
/// OLD: from this documentation: https://pub.dev/packages/dart_mappable
class UserData {
  static String keyUid = "uid";
  static String keyEmail = "email";
  static String keyLocation = "location";
  static String keyName = "name";
  static String keyOauthProvider = "oauth_provider";
  static String keyPoints = "points";
  static String keyProfileBio = "profile_bio";
  static String keyProfilePictureUrl = "profile_picture_url";
  static String keyProfileUsername = "profile_username";

  /// Type is List\<DocumentReference>
  static String keySavedItems = "saved_items";

  /// Type is List\<DocumentReference>
  static String keySavedPosts = "saved_posts";

  static Map<String, dynamic> asMap(
      {String? uid,
      String? email,
      String? location = "Kanto, Tokyo",
      String? name = "Anonymous",
      int? points = 0,
      String? oauthProvider,
      String? profileBio = "Hello!",
      String? profilePictureUrl =
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
      String? profileUsername = "Anonymous",
      List<DocumentReference>? savedItems,
      List<DocumentReference>? savedPosts}) {
    savedItems = <DocumentReference>[];
    savedPosts = <DocumentReference>[];
    return <String, dynamic>{
      "uid": uid,
      "email": email,
      "location": location,
      "name": name,
      "oauth_provider": oauthProvider,
      "points": points,
      "profile_bio": profileBio,
      "profile_picture_url": profilePictureUrl,
      "profile_username": profileUsername,
      "saved_items": savedItems,
      "saved_posts": savedPosts,
    };
  }

  /// OLD IMPLEMENTATION: MIGHT FIX LATER
  // UserData(
  //   {
  //     this.uid,
  //     this.email,
  //     this.location = "Earth",
  //     this.name = "Anonymous",
  //     this.points = 0,
  //     this.oauthProvider,
  //     this.profileBio = "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
  //     this.profilePictureUrl = "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
  //     this.profileUsername = "Anonymous",
  //     List<DocumentReference>? savedItems,
  //     List<DocumentReference>? savedPosts
  //   }
  // ) {
  //   this.savedItems = savedItems ?? [];
  //   this.savedPosts = savedItems ?? [];
  // }

  // UserData.fromMap(Map<String, dynamic> map) :
  //   uid = map["uid"],
  //   email = map.containsKey("email") ? map["email"] : "",
  //   location = map.containsKey("location") ? map["location"] : "",
  //   name = map.containsKey("name") ? map["name"] : "",
  //   oauthProvider = map.containsKey("oauth_provider") ? map["oauth_provider"] : "",
  //   points = map.containsKey("points") ? map["points"] : 0,
  //   profileBio = map.containsKey("profile_bio") ? map["profile_bio"] : "",
  //   profilePictureUrl = map.containsKey("profile_picture_url") ? map["profile_picture_url"] : "",
  //   profileUsername = map.containsKey("profile_username") ? map["profile_username"] : "",
  //   savedItems = map.containsKey("saved_items") ? map["saved_items"] : <DocumentReference>[],
  //   savedPosts = map.containsKey("saved_posts") ? map["saved_posts"] : <DocumentReference>[] {

  //   print("Map: $map");
  //   print("TEST: ${map["profile_username"]}");
  // }

  // String? uid;
  // String? email;
  // String? location;
  // String? name;
  // String? oauthProvider;
  // int? points;
  // String? profileBio;
  // String? profilePictureUrl;
  // String? profileUsername;
  // List<DocumentReference>? savedItems;
  // List<DocumentReference>? savedPosts;
}
