enum FileType {
  image,
  video,
  audio,
  other,
}

extension FileTypeExtension on String {
  static final videoExtensions = [
    '.mp4',
    '.mov',
    '.avi',
    '.wmv',
    '.flv',
    '.mkv',
    '.webm',
    '.m4v',
    '.3gp',
    '.mpg',
    '.mpeg',
    '.vob',
    '.ogv',
    '.ogg',
    '.drc',
    '.gifv',
    '.mng',
    '.qt',
    '.yuv',
    '.rm',
    '.rmvb',
    '.asf',
    '.amv',
    '.m4p',
    '.m4b',
    '.f4v',
    '.f4p',
    '.f4a',
    '.f4b',
    '.mxg',
    '.svi',
    '.nsv',
    '.roq',
    '.ts',
    '.m2ts',
    '.mts',
    '.dv',
    '.divx',
  ];

  static final imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.webp',
    '.tiff',
    '.bmp',
    '.svg',
    '.heif',
    '.heic',
    '.raw',
    '.ico',
    '.jfif',
    '.pjpeg',
    '.pjp',
    '.avif',
    '.apng',
  ];

  static final audioExtensions = [
    '.mp3',
    '.wav',
    '.ogg',
    '.flac',
    '.aac',
    '.m4a',
    '.wma',
    '.opus',
    '.alac',
    '.aiff',
    '.amr',
    '.au',
    '.mid',
    '.midi',
    '.ra',
    '.rm',
    '.voc',
    '.weba',
    '.8svx',
    '.cda',
  ];

  bool get isVideoUrl {
    final uri = Uri.tryParse(this);
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return videoExtensions.any(path.endsWith);
  }

  bool get isImageUrl {
    final uri = Uri.tryParse(this);
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return imageExtensions.any(path.endsWith);
  }

  bool get isAudioUrl {
    final uri = Uri.tryParse(this);
    if (uri == null) return false;
    final path = uri.path.toLowerCase();
    return audioExtensions.any(path.endsWith);
  }

  FileType get fileType {
    final uri = Uri.tryParse(this);
    if (uri == null) return FileType.other;
    final path = uri.path.toLowerCase();

    if (videoExtensions.any(path.endsWith)) {
      return FileType.video;
    }
    if (imageExtensions.any(path.endsWith)) {
      return FileType.image;
    }
    if (audioExtensions.any(path.endsWith)) {
      return FileType.audio;
    }
    return FileType.other;
  }
}
