String formatDistance(double distance) {
  if (distance < 1000) {
    return '${distance.toInt()} m';
  } else {
    return '${(distance / 1000).toStringAsFixed(2)} km';
  }
}

String formatTime(int seconds) {
  final minutes = seconds ~/ 60;
  final remainingSeconds = seconds % 60;
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}