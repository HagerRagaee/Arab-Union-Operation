import 'package:flutter/material.dart';

import 'package:omar_company/logic.dart';
import 'package:omar_company/stack.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import 'dart:convert';

class WorkOrder extends StatefulWidget {
  WorkOrder({super.key});

  @override
  State<WorkOrder> createState() => _WorkOrderState();
}

class _WorkOrderState extends State<WorkOrder> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
  );

  TextEditingController controllerManagment = TextEditingController();
  TextEditingController controllerUserName = TextEditingController();
  TextEditingController controllerNumber = TextEditingController();
  TextEditingController controllerCarNumber = TextEditingController();
  TextEditingController controllerCarType = TextEditingController();
  TextEditingController controllerDriverName = TextEditingController();
  TextEditingController controllerEscorts = TextEditingController();
  TextEditingController controllerNote = TextEditingController();
  TextEditingController controllerCompanyName = TextEditingController();
  TextEditingController controllerAddress =
      TextEditingController(); // Added this line
  TextEditingController controllerStartDate =
      TextEditingController(); // Updated to TextEditingController
  TextEditingController controllerEndDate =
      TextEditingController(); // Updated to TextEditingController
  TextEditingController controllerLeaveTime = TextEditingController();
  TextEditingController controllerReturnTime = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void saveUserData() async {
    if (_formKey.currentState!.validate()) {
      String? signatureText = await _getSignatureAsBase64();

      try {
        await SaveDriverData.saveData(
          context: context,
          mangementName: controllerManagment.text,
          userName: controllerUserName.text,
          numberJobNumber: controllerNumber.text,
          vehicleType: controllerCarType.text,
          vehicleNumber: controllerCarNumber.text,
          startDate: controllerStartDate.text,
          endDate: controllerEndDate.text,
          leaveTime: controllerLeaveTime.text,
          returnTime: controllerReturnTime.text,
          driverName: controllerDriverName.text,
          route: controllerAddress.text,
          escortsNames: [controllerEscorts.text],
          notes: controllerNote.text.isNotEmpty ? controllerNote.text : null,
          companyName: controllerCompanyName.text,
          signatureText: signatureText,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data Saved Successfully")),
        );

        _clearFields();
      } catch (e) {
        print("Error saving data: $e");
      }
    }
  }

  void _clearFields() {
    controllerManagment.clear();
    controllerUserName.clear();
    controllerNumber.clear();
    controllerCarNumber.clear();
    controllerCarType.clear();
    controllerDriverName.clear();
    controllerEscorts.clear();
    controllerNote.clear();
    controllerCompanyName.clear();
    controllerAddress.clear();
    controllerStartDate.clear();
    controllerEndDate.clear();
    controllerLeaveTime.clear();
    controllerReturnTime.clear();
    _controller.clear();
  }

  Future<String?> _getSignatureAsBase64() async {
    if (_controller.isNotEmpty) {
      final Uint8List? data = await _controller.toPngBytes();
      if (data != null) {
        return base64Encode(data);
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        title: const Center(
          child: Text(
            "Work Order",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  trailing: const Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: "المصرية",
                        style: TextStyle(
                            color: Color.fromARGB(255, 123, 30, 139),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: "للاتصالات",
                        style: TextStyle(
                            fontSize: 19,
                            color: Color.fromARGB(255, 123, 30, 139)),
                      )
                    ]),
                    style: TextStyle(fontSize: 14),
                  ),
                  leading: Image.asset(
                    "images/we.jpg",
                  ),
                ),
                const SizedBox(height: 10),
                const Column(
                  children: [
                    Text(
                      " الشركه المصرية للاتصالات وشركاتها التابعة ",
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 20),
                    ),
                    Text(
                      "امر شغل تحركات السيارات المؤجرة",
                      style: TextStyle(
                          decoration: TextDecoration.underline, fontSize: 20),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StackData(
                        label: ":  الأدارة الطالبة ",
                        controller: controllerManagment,
                        validator: (value) => value == null || value.isEmpty
                            ? 'هذاالحقل مطلوب '
                            : null,
                      ),
                      const SizedBox(height: 10),
                      StackData(
                        label: ": اسم مستخدم المركبة",
                        controller: controllerUserName,
                        validator: (value) => value == null || value.isEmpty
                            ? 'هذاالحقل مطلوب '
                            : null,
                      ),
                      const SizedBox(height: 10),
                      StackData(
                        label: ": الرقم الوظيفي",
                        controller: controllerNumber,
                        numberType: true,
                        validator: (value) => value == null || value.isEmpty
                            ? 'هذاالحقل مطلوب '
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Table(
                        border: TableBorder.all(),
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": نوعها",
                                controller: controllerCarType,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'هذاالحقل مطلوب '
                                        : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": رقم المركبة",
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'هذاالحقل مطلوب '
                                        : null,
                                controller: controllerCarNumber,
                                numberType: true,
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: StackData(
                                label: ":تاريخ انتهاء المأمورية",
                                controller: controllerEndDate,
                                showDate: true,
                                size: 12,
                                numberType: true,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'هذاالحقل مطلوب '
                                        : null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: StackData(
                                label: ":تاريخ بدء المأمورية",
                                controller: controllerStartDate,
                                showDate: true,
                                size: 12,
                                numberType: true,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'هذاالحقل مطلوب '
                                        : null,
                              ),
                            ),
                          ]),
                        ],
                      ),
                      Table(
                        border: TableBorder.all(),
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                readOnly: true,
                                label: ": توقيت العودة",
                                controller: controllerReturnTime,
                                validator: null,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                readOnly: true,
                                label: ": توقيت الخروج",
                                controller: controllerLeaveTime,
                                validator: null,
                              ),
                            ),
                          ])
                        ],
                      ),
                      Table(
                        border: TableBorder.all(),
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": اسم السائق",
                                controller: controllerDriverName,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'هذاالحقل مطلوب '
                                        : null,
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": خط السير بالتفصيل",
                                controller: controllerAddress,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'هذاالحقل مطلوب '
                                        : null,
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                  label: ": اسم المرافقين",
                                  controller: controllerEscorts,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'هذاالحقل مطلوب ';
                                    }
                                    return null;
                                  }),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                  label: ": ملاحظات",
                                  controller: controllerNote,
                                  validator: (value) {
                                    return null;
                                  }),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Stack(
                                      children: [
                                        Signature(
                                          controller: _controller,
                                          width: double.infinity,
                                          height: 90,
                                          backgroundColor: Colors.white,
                                        ),
                                        Positioned(
                                          top: -5,
                                          right: 0,
                                          child: IconButton(
                                            icon: Icon(Icons.clear_rounded),
                                            color: Colors.black,
                                            onPressed: () {
                                              _controller.clear();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "توقيع مستخدم المركبة",
                                    style: TextStyle(
                                        fontSize: 15,
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: StackData(
                                label: ": اسم الشركة المنفذة",
                                controller: controllerCompanyName,
                                validator: (value) =>
                                    value == null || value.isEmpty
                                        ? 'هذاالحقل مطلوب '
                                        : null,
                              ),
                            ),
                          ]),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              saveUserData();
                            }
                          },
                          child: const Text(
                            "ارسال",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
