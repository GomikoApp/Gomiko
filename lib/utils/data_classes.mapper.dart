// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'data_classes.dart';

class UserDataMapper extends ClassMapperBase<UserData> {
  UserDataMapper._();

  static UserDataMapper? _instance;
  static UserDataMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserDataMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'UserData';

  static String? _$uid(UserData v) => v.uid;
  static const Field<UserData, String> _f$uid = Field('uid', _$uid, opt: true);
  static String? _$email(UserData v) => v.email;
  static const Field<UserData, String> _f$email =
      Field('email', _$email, opt: true);
  static String? _$location(UserData v) => v.location;
  static const Field<UserData, String> _f$location =
      Field('location', _$location, opt: true, def: "Earth");
  static String? _$name(UserData v) => v.name;
  static const Field<UserData, String> _f$name =
      Field('name', _$name, opt: true, def: "Anonymous");
  static int? _$points(UserData v) => v.points;
  static const Field<UserData, int> _f$points =
      Field('points', _$points, opt: true, def: 0);
  static String? _$oauthProvider(UserData v) => v.oauthProvider;
  static const Field<UserData, String> _f$oauthProvider =
      Field('oauthProvider', _$oauthProvider, key: 'oauth_provider', opt: true);
  static String? _$profileBio(UserData v) => v.profileBio;
  static const Field<UserData, String> _f$profileBio = Field(
      'profileBio', _$profileBio,
      key: 'profile_bio',
      opt: true,
      def: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.");
  static String? _$profilePictureUrl(UserData v) => v.profilePictureUrl;
  static const Field<UserData, String> _f$profilePictureUrl = Field(
      'profilePictureUrl', _$profilePictureUrl,
      key: 'profile_picture_url', opt: true);
  static String? _$profileUsername(UserData v) => v.profileUsername;
  static const Field<UserData, String> _f$profileUsername = Field(
      'profileUsername', _$profileUsername,
      key: 'profile_username', opt: true, def: "Anonymous");
  static List<DocumentReference<Object?>> _$savedItems(UserData v) =>
      v.savedItems;
  static const Field<UserData, List<DocumentReference<Object?>>> _f$savedItems =
      Field('savedItems', _$savedItems, key: 'saved_items', opt: true);
  static List<DocumentReference<Object?>> _$savedPosts(UserData v) =>
      v.savedPosts;
  static const Field<UserData, List<DocumentReference<Object?>>> _f$savedPosts =
      Field('savedPosts', _$savedPosts, key: 'saved_posts', opt: true);

  @override
  final MappableFields<UserData> fields = const {
    #uid: _f$uid,
    #email: _f$email,
    #location: _f$location,
    #name: _f$name,
    #points: _f$points,
    #oauthProvider: _f$oauthProvider,
    #profileBio: _f$profileBio,
    #profilePictureUrl: _f$profilePictureUrl,
    #profileUsername: _f$profileUsername,
    #savedItems: _f$savedItems,
    #savedPosts: _f$savedPosts,
  };

  static UserData _instantiate(DecodingData data) {
    return UserData(
        uid: data.dec(_f$uid),
        email: data.dec(_f$email),
        location: data.dec(_f$location),
        name: data.dec(_f$name),
        points: data.dec(_f$points),
        oauthProvider: data.dec(_f$oauthProvider),
        profileBio: data.dec(_f$profileBio),
        profilePictureUrl: data.dec(_f$profilePictureUrl),
        profileUsername: data.dec(_f$profileUsername),
        savedItems: data.dec(_f$savedItems),
        savedPosts: data.dec(_f$savedPosts));
  }

  @override
  final Function instantiate = _instantiate;

  static UserData fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserData>(map);
  }

  static UserData fromJson(String json) {
    return ensureInitialized().decodeJson<UserData>(json);
  }
}

mixin UserDataMappable {
  String toJson() {
    return UserDataMapper.ensureInitialized()
        .encodeJson<UserData>(this as UserData);
  }

  Map<String, dynamic> toMap() {
    return UserDataMapper.ensureInitialized()
        .encodeMap<UserData>(this as UserData);
  }

  UserDataCopyWith<UserData, UserData, UserData> get copyWith =>
      _UserDataCopyWithImpl(this as UserData, $identity, $identity);
  @override
  String toString() {
    return UserDataMapper.ensureInitialized().stringifyValue(this as UserData);
  }

  @override
  bool operator ==(Object other) {
    return UserDataMapper.ensureInitialized()
        .equalsValue(this as UserData, other);
  }

  @override
  int get hashCode {
    return UserDataMapper.ensureInitialized().hashValue(this as UserData);
  }
}

extension UserDataValueCopy<$R, $Out> on ObjectCopyWith<$R, UserData, $Out> {
  UserDataCopyWith<$R, UserData, $Out> get $asUserData =>
      $base.as((v, t, t2) => _UserDataCopyWithImpl(v, t, t2));
}

abstract class UserDataCopyWith<$R, $In extends UserData, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<
      $R,
      DocumentReference<Object?>,
      ObjectCopyWith<$R, DocumentReference<Object?>,
          DocumentReference<Object?>>> get savedItems;
  ListCopyWith<
      $R,
      DocumentReference<Object?>,
      ObjectCopyWith<$R, DocumentReference<Object?>,
          DocumentReference<Object?>>> get savedPosts;
  $R call(
      {String? uid,
      String? email,
      String? location,
      String? name,
      int? points,
      String? oauthProvider,
      String? profileBio,
      String? profilePictureUrl,
      String? profileUsername,
      List<DocumentReference<Object?>>? savedItems,
      List<DocumentReference<Object?>>? savedPosts});
  UserDataCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserDataCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserData, $Out>
    implements UserDataCopyWith<$R, UserData, $Out> {
  _UserDataCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserData> $mapper =
      UserDataMapper.ensureInitialized();
  @override
  ListCopyWith<
      $R,
      DocumentReference<Object?>,
      ObjectCopyWith<$R, DocumentReference<Object?>,
          DocumentReference<Object?>>> get savedItems => ListCopyWith(
      $value.savedItems,
      (v, t) => ObjectCopyWith(v, $identity, t),
      (v) => call(savedItems: v));
  @override
  ListCopyWith<
      $R,
      DocumentReference<Object?>,
      ObjectCopyWith<$R, DocumentReference<Object?>,
          DocumentReference<Object?>>> get savedPosts => ListCopyWith(
      $value.savedPosts,
      (v, t) => ObjectCopyWith(v, $identity, t),
      (v) => call(savedPosts: v));
  @override
  $R call(
          {Object? uid = $none,
          Object? email = $none,
          Object? location = $none,
          Object? name = $none,
          Object? points = $none,
          Object? oauthProvider = $none,
          Object? profileBio = $none,
          Object? profilePictureUrl = $none,
          Object? profileUsername = $none,
          Object? savedItems = $none,
          Object? savedPosts = $none}) =>
      $apply(FieldCopyWithData({
        if (uid != $none) #uid: uid,
        if (email != $none) #email: email,
        if (location != $none) #location: location,
        if (name != $none) #name: name,
        if (points != $none) #points: points,
        if (oauthProvider != $none) #oauthProvider: oauthProvider,
        if (profileBio != $none) #profileBio: profileBio,
        if (profilePictureUrl != $none) #profilePictureUrl: profilePictureUrl,
        if (profileUsername != $none) #profileUsername: profileUsername,
        if (savedItems != $none) #savedItems: savedItems,
        if (savedPosts != $none) #savedPosts: savedPosts
      }));
  @override
  UserData $make(CopyWithData data) => UserData(
      uid: data.get(#uid, or: $value.uid),
      email: data.get(#email, or: $value.email),
      location: data.get(#location, or: $value.location),
      name: data.get(#name, or: $value.name),
      points: data.get(#points, or: $value.points),
      oauthProvider: data.get(#oauthProvider, or: $value.oauthProvider),
      profileBio: data.get(#profileBio, or: $value.profileBio),
      profilePictureUrl:
          data.get(#profilePictureUrl, or: $value.profilePictureUrl),
      profileUsername: data.get(#profileUsername, or: $value.profileUsername),
      savedItems: data.get(#savedItems, or: $value.savedItems),
      savedPosts: data.get(#savedPosts, or: $value.savedPosts));

  @override
  UserDataCopyWith<$R2, UserData, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _UserDataCopyWithImpl($value, $cast, t);
}
