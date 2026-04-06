import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/files_helper.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/file_type_extension.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionsHelper {
  PermissionsHelper._private();

  static final PermissionsHelper instance = PermissionsHelper._private();

  // Permission states
  PermissionStatus cameraPermissionState = PermissionStatus.denied;
  PermissionStatus microphonePermissionState = PermissionStatus.denied;
  PermissionStatus storagePermissionState = PermissionStatus.denied;
  PermissionStatus locationPermissionState = PermissionStatus.denied;
  PermissionStatus photosPermissionState = PermissionStatus.denied;
  PermissionStatus notificationPermissionState = PermissionStatus.denied;

  // StreamController to notify changes
  final _controller = StreamController<PermissionsHelper>.broadcast();

  Stream<PermissionsHelper> get stream => _controller.stream;

  //=============================
  // INIT & CHECK ALL PERMISSIONS
  //=============================

  /// Call this on startup to check all permissions
  Future<void> checkAllPermissions() async {
    cameraPermissionState = await Permission.camera.status;
    microphonePermissionState = await Permission.microphone.status;
    storagePermissionState = await Permission.storage.status;
    locationPermissionState = await Permission.location.status;
    photosPermissionState = await Permission.photos.status;
    notificationPermissionState = await Permission.notification.status;

    _notify();
  }

  //=============================
  // REQUEST PERMISSIONS
  //=============================

  Future<PermissionStatus> requestCamera() async {
    cameraPermissionState = await Permission.camera.request();
    _notify();
    return cameraPermissionState;
  }

  Future<PermissionStatus> requestMicrophone() async {
    microphonePermissionState = await Permission.microphone.request();
    _notify();
    return microphonePermissionState;
  }

  Future<PermissionStatus> requestStorage() async {
    storagePermissionState = await Permission.storage.request();
    _notify();
    return storagePermissionState;
  }

  Future<PermissionStatus> requestLocation() async {
    locationPermissionState = await Permission.location.request();
    _notify();
    return locationPermissionState;
  }

  Future<PermissionStatus> requestPhotos() async {
    photosPermissionState = await Permission.photos.request();
    _notify();
    return photosPermissionState;
  }

  Future<PermissionStatus> requestNotifications() async {
    notificationPermissionState = await Permission.notification.request();
    _notify();
    return notificationPermissionState;
  }

  /// Request all at once
  Future<void> requestAll() async {
    await requestCamera();
    await requestMicrophone();
    await requestStorage();
    await requestLocation();
    await requestPhotos();
    await requestNotifications();
  }

  //=============================
  // INTERNAL
  //=============================

  void _notify() {
    if (!_controller.isClosed) {
      _controller.add(this);
    }
  }

  /// Dispose stream controller when app closes
  void dispose() {
    _controller.close();
  }
}

class MediaHelper {
  Future<List<XFile>> selectMedia(
    BuildContext context,
    ImageSource source, {
    bool video = false,
    Duration maxVideoDuration = const Duration(seconds: 10),
    int imageQuality = 25,
    double maxFileSize = (1024 * 1024) * 10,
  }) async {
     var hasPermission = false;

    switch (source) {
      case ImageSource.camera:
        hasPermission = await Permission.camera.isGranted;
      case ImageSource.gallery:
        hasPermission = await Permission.photos.isGranted;
    }
    final picker = ImagePicker();
    if (hasPermission) {
      switch (source) {
        case ImageSource.camera:
          final file = video
              ? await picker.pickVideo(
                  source: source,
                  maxDuration: maxVideoDuration,
                )
              : await picker.pickImage(
                  source: source,
                  imageQuality: imageQuality,
                );
          if (file == null) {
            return <XFile>[];
          }
          return [file];
        case ImageSource.gallery:
          final files = await picker.pickMultipleMedia(
            imageQuality: 25,
            limit: 20,
          );
          if (files.isEmpty) {
            return [];
          }
          final tasks = <XFile>[];
          for (final file in files) {
            if (FilesHelper.getFileType(file.path) == FileType.other &&
                context.mounted) {
              showWarningSnackbar(
                message:
                    '${context.t.core.file_picker.unsupported_file} ${file.path.split('/').last}',
              );
              continue;
            }
            final sizeInBytes = await file.length();

            if (sizeInBytes > maxFileSize && context.mounted) {
              showWarningSnackbar(
                message:
                    '${context.t.core.file_picker.size_warning(maxSize: 50)} ${file.path.split('/').last}',
              );

              continue;
            }

            tasks.add(file);
          }

          return tasks;
      }
    } else if (context.mounted) {
      showErrorSnackbar(message: context.t.core.file_picker.no_permission,
      action: SnackBarAction(label: context.t.core.file_picker.open_settings, onPressed: () => openAppSettings(),)
      );
      
      
    }
    return [];
  }
}
