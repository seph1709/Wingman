import 'package:background_downloader/background_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import '../controller/llm_controller.dart';
import 'notification_service.dart';

class DownloadService {
  static Future<void> downloadModel({
    required String url,
    bool needsToken = false,
    required String filename,
  }) async {
    LLMController controller = Get.find<LLMController>();
    final task = DownloadTask(
      url: url,
      filename: filename,
      headers:
          needsToken
              ? {'Authorization': 'Bearer ${controller.getToken()}'}
              : {},
      // directory: await getDownloadsDirectory().then((value) => value!.path),
      requiresWiFi: true,
      retries: 5,
      allowPause: true,
      metaData: 'data for me',
    );

    // Start download, and wait for result. Show progress and status changes
    // while downloading
    final result = await FileDownloader().download(
      task,
      onProgress: (progress) {
        if ((progress * 100).toInt() == 100) {
          NotificationService.pushNotificationStatus(
            filename,
            "Done downloading please wait for a moment",
          );
        } else {
          NotificationService.pushNotification(
            filename,
            (progress * 100).toInt(),
          );
        }
      },
    );

    // Act on the result
    switch (result.status) {
      case TaskStatus.complete:
        {
          NotificationService.pushNotification(filename, 100);
          final newFilePath = await FileDownloader().moveToSharedStorage(
            task,
            SharedStorage.downloads,
          );
          if (newFilePath == null) {
            NotificationService.pushNotificationStatus(
              filename,
              "Error moving file",
            );
          } else {
            NotificationService.pushNotificationStatus(
              filename,
              "Download Successful",
            );
          }
        }

      case TaskStatus.canceled:
        NotificationService.pushNotificationStatus(filename, "Canceled");

      case TaskStatus.paused:
        NotificationService.pushNotificationStatus(filename, "Paused");

      case TaskStatus.waitingToRetry:
        NotificationService.pushNotificationStatus(filename, "Waiting to retry");

      case TaskStatus.enqueued:
        NotificationService.pushNotificationStatus(filename, "Enqueued");
      default:
        NotificationService.pushNotificationStatus(filename, "Failed");
    }
  }
}
