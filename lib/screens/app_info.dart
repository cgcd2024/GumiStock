import 'package:flutter/material.dart';

void showAppInfo(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("정보"),
        content: const Text("구미강동병원 재고관리 시스템"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("닫기"),
          ),
        ],
      );
    },
  );
}