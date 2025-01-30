import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  final String imagePath;
  final int count;
  final Function(int) onUpdate;
  final String label;
  final Color color;

  const ImageCard({
    super.key,
    required this.imagePath,
    required this.count,
    required this.onUpdate,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.max, // 최대 크기로 확장
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.center, // 텍스트 중앙 정렬
                child: Text(
                  label,
                  textAlign: TextAlign.center, // 여러 줄일 경우에도 중앙 정렬
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                // 이미지가 최대한 커지도록 확장
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // 버튼과 숫자 중앙 정렬
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, color: Colors.red, size: 28),
                    onPressed: () => onUpdate(-1),
                  ),
                  const SizedBox(width: 10), // 간격 조정
                  Text(
                    "$count",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.add, color: Colors.green, size: 28),
                    onPressed: () => onUpdate(1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
