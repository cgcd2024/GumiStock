String getFormattedTime() {
  final now = DateTime.now();
  return "${now.year}.${_twoDigits(now.month)}.${_twoDigits(now.day)} ${_twoDigits(now.hour)}:${_twoDigits(now.minute)}:${_twoDigits(now.second)}";
}

String _twoDigits(int n) {
  return n.toString().padLeft(2, '0');
}
