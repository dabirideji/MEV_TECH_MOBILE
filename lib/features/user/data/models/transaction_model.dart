import 'dart:developer';

import 'package:template/features/user/data/models/subscription_model.dart';
import 'package:template/features/user/data/models/user_model.dart';

class Transaction {
  Transaction({
    required this.userId,
    required this.amount,
    required this.currency,
    required this.paymentPlanType,
    required this.status,
    required this.providerReference,
    required this.paymentProvider,
    required this.purpose,
    required this.reference,
    required this.gateway,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      userId: (json['userId'] ?? '') as String,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      amount: (json['amount'] ?? 0) as double,
      currency: (json['currency'] ?? '') as String,
      paymentPlanType: (json['paymentPlanType'] ?? '') as String,
      status: (json['status'] ?? '') as String,
      providerReference: (json['providerReference'] ?? '') as String,
      paymentProvider: (json['paymentProvider'] ?? '') as String,
      purpose: (json['purpose'] ?? '') as String,
      reference: (json['reference'] ?? '') as String,
      gateway: (json['gateway'] ?? '') as String,
      id: (json['id'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }
  final String userId;
  final UserModel? user;
  final double amount;
  final String currency;
  final String paymentPlanType;
  final String status;
  final String providerReference;
  final String paymentProvider;
  final String purpose;
  final String reference;
  final String gateway;
  final String id;
  final String createdAt;
  final String updatedAt;
}

class Subscription {
  Subscription({
    required this.userId,
    required this.planId,
    required this.startDate,
    required this.endDate,
    required this.isActive,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.plan,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    log(json['plan'].toString());
    return Subscription(
      userId: (json['userId'] ?? '') as String,
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      planId: (json['planId'] ?? '') as String,
      plan: json['plan'] != null
          ? SubscriptionPlan.fromJson(json['plan'] as Map<String, dynamic>)
          : null,
      startDate: (json['startDate'] ?? '') as String,
      endDate: (json['endDate'] ?? '') as String,
      isActive: (json['isActive'] ?? false) as bool,
      id: (json['id'] ?? '') as String,
      createdAt: (json['createdAt'] ?? '') as String,
      updatedAt: (json['updatedAt'] ?? '') as String,
    );
  }
  final String userId;
  final UserModel? user;
  final String planId;
  final SubscriptionPlan? plan;
  final String startDate;
  final String endDate;
  final bool isActive;
  final String id;
  final String createdAt;
  final String updatedAt;
}

class SubscriptionPlan {
  SubscriptionPlan({
    required this.name,
    required this.price,
    required this.durationInDays,
    required this.description,
    required this.features,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return SubscriptionPlan(
      name: json['name'] as String,
      price: json['price'] as double,
      durationInDays: json['durationInDays'] as int,
      description: json['description'] as String,
      features: (json['features'] ?? <dynamic>[]) as List<dynamic>,
      id: json['id'] as String,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }
  final String name;
  final double price;
  final int durationInDays;
  final String description;
  final List<dynamic> features;
  final String id;
  final String createdAt;
  final String updatedAt;
}
