/// A sound that is installed on this device and ready for the rest alarm.
class AlarmSound {
  const AlarmSound({
    required this.assetKey,
    required this.name,
    required this.localPath,
    this.androidUri,
    this.iosFileName,
  });

  factory AlarmSound.fromJson(Map<String, dynamic> json) => AlarmSound(
    assetKey: json['assetKey'] as String,
    name: json['name'] as String,
    localPath: json['localPath'] as String,
    androidUri: json['androidUri'] as String?,
    iosFileName: json['iosFileName'] as String?,
  );

  /// Channel id suffix / file name.
  final String assetKey;
  final String name;

  /// The downloaded file (preview, existence checks).
  final String localPath;

  /// Android: `content://media/...` of the MediaStore copy.
  final String? androidUri;

  /// iOS: file name inside `Library/Sounds`.
  final String? iosFileName;

  Map<String, dynamic> toJson() => {
    'assetKey': assetKey,
    'name': name,
    'localPath': localPath,
    'androidUri': androidUri,
    'iosFileName': iosFileName,
  };
}
