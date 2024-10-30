import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart'; // Make sure to import material.dart for TimeOfDay

class SaveDriverData {
  static Future<void> saveData({
    required BuildContext context, // Add BuildContext parameter
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
    // Add the data to Firestore
    await FirebaseFirestore.instance.collection('drivers').add({
      'mangementName': mangementName,
      'userName': userName,
      'jobNumber': numberJobNumber,
      'vehicleType': vehicleType,
      'vehicleNumber': vehicleNumber,
      'startDate': startDate,
      'endDate': endDate,
      'leaveTime': leaveTime, // Now context is available
      'returnTime': returnTime, // Now context is available
      'driverName': driverName,
      'route': route,
      'escortsNames': escortsNames,
      'notes': notes,
      'companyName': companyName,
      'signatureText': signatureText,
    });
  }
}
