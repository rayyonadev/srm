import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class AppToast {
  static void success({
    required BuildContext context,
    String? description,
  }) {
    toastification.show(
      backgroundColor: Color(0xff001E61).withOpacity(0.9),
      context: context,
      type: ToastificationType.success,
      title: Text("Muvoffaqqiyatli", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
      description: description != null ? Text(description,style: TextStyle(color: Colors.white),) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 3),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static void error({
    required BuildContext context,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.fillColored,
      title: Text("Xatolik", style: const TextStyle(fontWeight: FontWeight.bold)),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12),
    );
  }

  static void warning({
    required BuildContext context,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.warning,
      style: ToastificationStyle.flatColored,
      title: Text("Diqqat", style: const TextStyle(fontWeight: FontWeight.bold)),
      description: description != null ? Text(description) : null,
      alignment: Alignment.topCenter,
      autoCloseDuration: const Duration(seconds: 4),
      borderRadius: BorderRadius.circular(12),
      icon: const Icon(Icons.warning_amber_rounded),
    );
  }
}