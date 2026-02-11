class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final DateTime date;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: json['fajr'] ?? '',
      sunrise: json['sunrise'] ?? '',
      dhuhr: json['dhuhr'] ?? '',
      asr: json['asr'] ?? '',
      maghrib: json['maghrib'] ?? '',
      isha: json['isha'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fajr': fajr,
      'sunrise': sunrise,
      'dhuhr': dhuhr,
      'asr': asr,
      'maghrib': maghrib,
      'isha': isha,
      'date': date.toIso8601String(),
    };
  }
}

class PrayerAlarm {
  final String prayerName;
  final String time;
  final bool isEnabled;
  final int? notificationId;

  PrayerAlarm({
    required this.prayerName,
    required this.time,
    this.isEnabled = true,
    this.notificationId,
  });

  factory PrayerAlarm.fromJson(Map<String, dynamic> json) {
    return PrayerAlarm(
      prayerName: json['prayerName'] ?? '',
      time: json['time'] ?? '',
      isEnabled: json['isEnabled'] ?? true,
      notificationId: json['notificationId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prayerName': prayerName,
      'time': time,
      'isEnabled': isEnabled,
      'notificationId': notificationId,
    };
  }

  PrayerAlarm copyWith({
    String? prayerName,
    String? time,
    bool? isEnabled,
    int? notificationId,
  }) {
    return PrayerAlarm(
      prayerName: prayerName ?? this.prayerName,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
      notificationId: notificationId ?? this.notificationId,
    );
  }
}
