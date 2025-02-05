import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/appointment_model.dart';
import '../../../models/notification_model.dart' as model;
import '../../../routes/app_routes.dart';
import '../controllers/notifications_controller.dart';
import 'notification_item_widget.dart';

class AppointmentNotificationItemWidget extends GetView<NotificationsController> {
  AppointmentNotificationItemWidget({Key? key, required this.notification}) : super(key: key);
  final model.Notification notification;

  @override
  Widget build(BuildContext context) {
    return NotificationItemWidget(
      notification: notification,
      onDismissed: (notification) {
        controller.removeNotification(notification);
      },
      icon: Icon(
        Icons.assignment_outlined,
        color: Get.theme.scaffoldBackgroundColor,
        size: 34,
      ),
      onTap: (notification) async {
        Get.toNamed(Routes.APPOINTMENT, arguments: new Appointment(id: notification.data['appointment_id'].toString()));
        await controller.markAsReadNotification(notification);
      },
    );
  }
}
