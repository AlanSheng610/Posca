import 'package:posca/models/postcard.dart';

/// Passed from the send/reply entry points through the camera to the
/// compose screen.
class ComposeArgs {
  const ComposeArgs({
    required this.type,
    this.receiverUid = '',
    this.photoPath,
  });

  final PostcardType type;
  final String receiverUid;

  /// Set by the camera once a photo is taken.
  final String? photoPath;

  ComposeArgs withPhoto(String path) =>
      ComposeArgs(type: type, receiverUid: receiverUid, photoPath: path);
}
