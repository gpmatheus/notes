
class User {

  User({
    required this.id,
    this.name,
    this.email,
    this.photoUrl,
    required this.verified,
    required this.active,
    required bool remoteSave,
  }) :
    _remoteSave = remoteSave;

  final String id;
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool verified;
  final bool active;
  final bool _remoteSave;

  bool get remoteSave => _remoteSave;
}