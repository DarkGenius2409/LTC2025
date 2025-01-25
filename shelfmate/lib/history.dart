class History {
  History({required this.user, required this.history});

  History.fromJson(Map<String, Object?> json)
      : this(
          user: json['user']! as String,
          history: json['history']! as List<Map<String, dynamic>>,
        );

  final String user;
  final List<Map<String, dynamic>> history;

  Map<String, Object?> toJson() {
    return {
      'title': user,
      'history': history,
    };
  }
}
