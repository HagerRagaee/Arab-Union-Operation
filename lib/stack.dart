// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class StackData extends StatefulWidget {
  StackData(
      {super.key,
      required this.label,
      this.showTime = false,
      this.showDate = false,
      required this.controller,
      this.size = 0.0,
      this.numberType = false,
      required this.validator});
  String? label;
  final bool showTime;
  final bool showDate;
  final double? size;
  final numberType;
  TextEditingController? controller = TextEditingController();
  String? Function(String?)? validator;

  @override
  State<StackData> createState() => _StackDataState();
}

class _StackDataState extends State<StackData> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Stack(
            children: [
              const Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '..........................................................................................................................................................................................................................................................',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              TextFormField(
                validator: widget.validator,
                controller: widget.controller,
                maxLines: 4,
                minLines: 1,
                keyboardType: widget.numberType
                    ? TextInputType.datetime
                    : TextInputType.multiline,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Align(
          alignment: Alignment.topRight,
          child: Text(
            widget.label!,
            style: TextStyle(
                fontSize: widget.size == 0.0 ? 15 : widget.size!,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
