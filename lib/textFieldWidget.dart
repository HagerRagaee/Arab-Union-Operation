import 'package:flutter/material.dart';

class Textfieldwidget extends StatefulWidget {
  final String hint;
  final bool showTime;
  final bool showDate;

  Textfieldwidget({
    required this.hint,
    this.showDate = false,
    super.key,
    this.showTime = false,
  });

  @override
  State<Textfieldwidget> createState() => _TextfieldwidgetState();
}

class _TextfieldwidgetState extends State<Textfieldwidget> {
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
    return TextFormField(
      readOnly: true,
      maxLines: 4,
      minLines: 1,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 206, 147, 216), width: 2)),
          hintTextDirection: TextDirection.rtl,
          prefixIcon: widget.showDate
              ? IconButton(
                  icon: Icon(
                    Icons.date_range_outlined,
                    color: Colors.purple[200],
                  ),
                  onPressed: () {
                    _selectDate(context);
                  },
                )
              : widget.showTime
                  ? IconButton(
                      icon: Icon(
                        Icons.alarm_rounded,
                        color: Colors.purple[200],
                      ),
                      onPressed: () {
                        _selectTime(context);
                      },
                    )
                  : null // Icon button appears only if show is true
          ),
      textAlign: TextAlign.right,
    );
  }
}
