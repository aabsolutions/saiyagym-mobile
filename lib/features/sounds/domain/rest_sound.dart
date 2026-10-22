/// Who can pick a sound (`RestSoundDto.access`).
enum SoundAccess { free, premium }

/// A rest-alarm sound of the catalog (`RestSoundDto`, `GET /sounds`).
class RestSound {
  const RestSound({
    required this.id,
    required this.slug,
    required this.name,
    required this.access,
    required this.locked,
    required this.durationSec,
    this.wavUrl,
    this.mp3Url,
  });

  factory RestSound.fromJson(Map<String, dynamic> json) => RestSound(
    id: json['id'] as String,
    slug: json['slug'] as String,
    name: json['name'] as String,
    // Lenient: a value this app doesn't know is treated as premium.
    access:
        SoundAccess.values.asNameMap()[json['access']] ?? SoundAccess.premium,
    locked: json['locked'] == true,
    durationSec: (json['durationSec'] as num?)?.toDouble() ?? 0,
    wavUrl: json['wavUrl'] as String?,
    mp3Url: json['mp3Url'] as String?,
  );

  final String id;
  final String slug;

  /// Already localized by the API (`Accept-Language`).
  final String name;
  final SoundAccess access;

  /// Premium sound and the plan lacks `premiumSounds`: no URLs either.
  final bool locked;
  final double durationSec;

  /// iOS delivery (wav).
  final String? wavUrl;

  /// Android delivery (mp3).
  final String? mp3Url;

  /// Stable per-asset key: the uuid tail of the Cloudinary public id (the
  /// file name in the URL without extension). A replaced audio gets a new
  /// one, so channels / files never serve stale audio.
  String? get assetKey {
    final url = mp3Url ?? wavUrl;
    if (url == null) return null;
    final file = Uri.tryParse(url)?.pathSegments.lastOrNull;
    if (file == null || file.isEmpty) return null;
    final dot = file.lastIndexOf('.');
    return dot <= 0 ? file : file.substring(0, dot);
  }
}
