import 'package:toastification/toastification.dart';

class FlushbarNotificationModel {
  final String title;
  final String subtitle;
  final ToastificationType type;

  FlushbarNotificationModel({
    required this.title,
    required this.subtitle,
    required this.type,
  });
}

class FlushbarSuccessModel extends FlushbarNotificationModel {
  FlushbarSuccessModel({
    required super.title,
    required super.subtitle,
  }) : super(
          type: ToastificationType.success,
        );
}

class FlushbarErrorModel extends FlushbarNotificationModel {
  FlushbarErrorModel({
    required super.title,
    required super.subtitle,
  }) : super(
          type: ToastificationType.error,
        );
}

class FlushbarInfoModel extends FlushbarNotificationModel {
  FlushbarInfoModel({
    required super.title,
    required super.subtitle,
  }) : super(
          type: ToastificationType.warning,
        );
}
