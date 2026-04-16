String formatDistance(double distance) {
  if (distance < 1000) {
    return '${distance.toInt()} m';
  } else {
    return '${(distance / 1000).toStringAsFixed(2)} km';
  }
}