import 'dart:convert';
import 'dart:io';
import 'package:flutter_advanced_boilerplate/utils/methods/file_type_extension.dart';
import 'package:path_provider/path_provider.dart';

class FilesHelper {
  FilesHelper._();

  static bool isImage(String path) => getFileType(path) == FileType.image;
  static bool isVideo(String path) => getFileType(path) == FileType.video;
  static bool isAudio(String path) => getFileType(path) == FileType.audio;
  static bool isCompressed(String path) =>
      getFileType(path) == FileType.compressed;

  static FileType getFileType(String path) {
    final extension = path.split('.').last.toLowerCase();
    
    if (FileTypeExtensions.imageExtensions.contains(extension)) {
      return FileType.image;
    } else if (FileTypeExtensions.videoExtensions.contains(extension)) {
      return FileType.video;
    } else if (FileTypeExtensions.audioExtensions.contains(extension)) {
      return FileType.audio;
    } else if (FileTypeExtensions.compressedExtensions.contains(extension)) {
      return FileType.compressed;
    } else {
      return FileType.other;
    }
  }

  static Future<File> fromBase64(String base64, String path) async {
    final bytes = base64Decode(base64);
    return File(path).writeAsBytes(bytes);
  }

  static Future<String> toBase64String(String path) async {
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }

  static Future<File> copyToAppStorage(String path) async {
    final dir = await getApplicationDocumentsDirectory();
    return File(path).copy('${dir.path}/${path.split('/').last}');
  }

}
