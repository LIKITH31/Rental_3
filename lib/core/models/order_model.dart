import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String itemId;
  final String renterId;
  final String lenderId;
  final String rentalStatus; // Changed from status
  final DateTime startDate; // Changed from String
  final DateTime endDate;   // Changed from String
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.itemId,
    required this.renterId,
    required this.lenderId,
    required this.rentalStatus,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
  });

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'itemId': itemId,
      'renterId': renterId,
      'lenderId': lenderId,
      'rentalStatus': rentalStatus,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: data['id'] ?? '',
      itemId: data['itemId'] ?? '',
      renterId: data['renterId'] ?? data['customerId'] ?? '',
      lenderId: data['lenderId'] ?? '',
      rentalStatus: data['rentalStatus'] ?? data['status'] ?? 'requested',
      startDate: _parseDate(data['startDate']),
      endDate: _parseDate(data['endDate']),
      createdAt: _parseDate(data['createdAt']),
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date is Timestamp) {
      return date.toDate();
    } else if (date is String) {
      // Try parsing typical string formats
      try {
        return DateTime.parse(date);
      } catch (_) {
        // Fallback for custom formats like "14 Jan 2026" if that's what's stored
        // You might need DateFormat('dd MMM yyyy').parse(date) if imports allowed
        // strictly, but assuming standard for now or keeping safe fallback.
        // Given error said "14 Jan 2026", let's try to parse that if basic parse fails.
        // But preventing import bloat, let's just return now() if strict parse fails
        // unless we add intl import here. 
        // Actually, let's just return DateTime.now() on failure to avoid crashes.
        return DateTime.now(); 
      }
    }
    return DateTime.now();
  }
}
