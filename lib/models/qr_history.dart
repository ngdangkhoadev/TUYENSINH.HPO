class QRHistory {
  final String id;
  final String content;
  final String format;
  final DateTime scannedAt;
  final String? displayValue;

  QRHistory({
    required this.id,
    required this.content,
    required this.format,
    required this.scannedAt,
    this.displayValue,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'format': format,
      'scannedAt': scannedAt.toIso8601String(),
      'displayValue': displayValue,
    };
  }

  factory QRHistory.fromJson(Map<String, dynamic> json) {
    return QRHistory(
      id: json['id'] as String,
      content: json['content'] as String,
      format: json['format'] as String,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
      displayValue: json['displayValue'] as String?,
    );
  }

  QRHistory copyWith({
    String? id,
    String? content,
    String? format,
    DateTime? scannedAt,
    String? displayValue,
  }) {
    return QRHistory(
      id: id ?? this.id,
      content: content ?? this.content,
      format: format ?? this.format,
      scannedAt: scannedAt ?? this.scannedAt,
      displayValue: displayValue ?? this.displayValue,
    );
  }
}

