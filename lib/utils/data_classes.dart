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

/// UserData class: Used for type-safety in the "users" document in Firestore
/// From this documentation: https://pub.dev/packages/dart_mappable
@MappableClass(caseStyle: CaseStyle.snakeCase)
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
      this.profilePictureUrl,
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