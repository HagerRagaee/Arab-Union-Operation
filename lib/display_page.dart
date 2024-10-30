import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarsFlow',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      // Navigate to the main app
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => DisplayPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundColor: Color(0xFFFFFFFF),
              child: CircleAvatar(
                backgroundImage: AssetImage("images/logo.jpg"),
                radius: 78,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'CarsFlow',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayPage extends StatelessWidget {
  DisplayPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> getAllDriversData() async {
    // Query Firestore for all documents in the 'drivers' collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('drivers') // Replace with your collection name
        .get();

    // Return a list of documents' data
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Drivers Data'),
        backgroundColor: Colors.purple[100],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllDriversData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data found.'));
          } else {
            List<Map<String, dynamic>> dataList = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = dataList[index];

                  // Retrieve the signature and convert from Base64
                  String? signatureBase64 = data['signatureText'];
                  Uint8List? signatureImage;
                  if (signatureBase64 != null) {
                    signatureImage = base64Decode(signatureBase64);
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Management Name: ${data['mangementName'] ?? 'N/A'}'),
                            Text('User Name: ${data['userName'] ?? 'N/A'}'),
                            Text(
                                'Job Number: ${data['numberJobNumber'] ?? 'N/A'}'),
                            Text(
                                'Vehicle Type: ${data['vehicleType'] ?? 'N/A'}'),
                            Text(
                                'Vehicle Number: ${data['vehicleNumber'] ?? 'N/A'}'),
                            Text('Start Date: ${data['startDate'] ?? 'N/A'}'),
                            Text('End Date: ${data['endDate'] ?? 'N/A'}'),
                            Text('Leave Time: ${data['leaveTime'] ?? 'N/A'}'),
                            Text('Return Time: ${data['returnTime'] ?? 'N/A'}'),
                            Text('Driver Name: ${data['driverName'] ?? 'N/A'}'),
                            Text('Route: ${data['route'] ?? 'N/A'}'),
                            Text(
                                'Escorts Names: ${data['escortsNames']?.join(', ') ?? 'N/A'}'),
                            Text('Notes: ${data['notes'] ?? 'N/A'}'),
                            Text(
                                'Company Name: ${data['companyName'] ?? 'N/A'}'),

                            // Display the signature if available
                            const SizedBox(height: 20),
                            const Text('Signature:'),
                            if (signatureImage != null)
                              Image.memory(signatureImage,
                                  height: 90), // Display the image
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
