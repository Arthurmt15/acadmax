import 'package:flutter/material.dart';

class SetInputRow extends StatelessWidget {
  final int setNumber;
  final Function(double weight, int reps) onCompleted;

  SetInputRow({Key? key, required this.setNumber, required this.onCompleted}) : super(key: key);

  final TextEditingController weightController = TextEditingController();
  final TextEditingController repsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade200,
              child: Text('$setNumber', style: const TextStyle(color: Colors.black87)),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: weightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF27272A),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF27272A),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: IconButton(
              icon: const Icon(Icons.check_circle_outline, color: Colors.grey, size: 32),
              onPressed: () {
                final weight = double.tryParse(weightController.text) ?? 0.0;
                final reps = int.tryParse(repsController.text) ?? 0;
                if (weight > 0 && reps > 0) {
                  onCompleted(weight, reps);
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
