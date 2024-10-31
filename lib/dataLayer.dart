import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SaveDriverData {
  static Future<String> _getNextDriverId() async {
    final counterRef =
        FirebaseFirestore.instance.collection('counters').doc('driverCount');

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      final counterSnapshot = await transaction.get(counterRef);

      int newDriverId = 1;
      if (counterSnapshot.exists) {
        final currentCount = counterSnapshot.data()?['count'] ?? 0;
        newDriverId = currentCount + 1;
      }

      transaction.set(counterRef, {'count': newDriverId});
      return newDriverId.toString(); // Convert to string
    });
  }

  // Method to save driver data with auto-incrementing ID
  static Future<void> saveData({
    required BuildContext context,
    required String mangementName,
    required String userName,
    required String numberJobNumber,
    required String vehicleType,
    required String vehicleNumber,
    required String startDate,
    required String endDate,
    required String? leaveTime,
    required String? returnTime,
    required String driverName,
    required String route,
    required List<String> escortsNames,
    String? notes,
    required String companyName,
    required String? signatureText,
  }) async {
    String driverId = await _getNextDriverId();
    await FirebaseFirestore.instance
        .collection('drivers')
        .doc(driverId.toString())
        .set({
      'id': driverId,
      'mangementName': mangementName,
      'userName': userName,
      'jobNumber': numberJobNumber,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'startDate': startDate,
      'endDate': endDate,
      'leaveTime': leaveTime,
      'returnTime': returnTime,
      'driverName': driverName,
      'route': route,
      'escortsNames': escortsNames,
      'notes': notes,
      'companyName': companyName,
      'signatureText': signatureText,
    });
  }
}
