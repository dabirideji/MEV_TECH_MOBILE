class UserSubscription {
  UserSubscription({
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    this.id,
    this.userEmail,
    this.planName,
  });

  factory UserSubscription.fromJson(Map<String, dynamic> json) {
    return UserSubscription(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userEmail: json['userEmail'] as String,
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      isActive: json['isActive'] as bool,
    );
  }
  final String? id;
  final String userId;
  final String? userEmail;
  final String planId;
  final String? planName;
  final String startDate;
  final String endDate;
  final bool isActive;

  Map<String, dynamic> toJson({bool isCreate = false, bool isUpdate = false}) {
    final data = <String, dynamic>{};

    if (isCreate) {
      data['userId'] = userId;
    }

    if (isCreate || isUpdate) {
      data['planId'] = planId;
      data['startDate'] = startDate;
      data['endDate'] = endDate;
      data['isActive'] = isActive;
    }

    return data;
  }
}

class UserPayment {
  UserPayment({
    this.paymentUrl,
    this.userId,
    this.planId,
    this.currency,
    this.narration,
    this.callbackUrl,
  });

  factory UserPayment.fromJson(Map<String, dynamic> json) {
    return UserPayment(paymentUrl: json['paymentUrl'] as String);
  }

  final String? paymentUrl;
  final String? userId;
  final String? planId;
  final String? currency;
  final String? narration;
  final String? callbackUrl;

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'planId': planId,
      'currency': currency,
      'narration': narration,
      'callbackUrl': callbackUrl,
    };
  }
}
