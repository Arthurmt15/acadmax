import 'package:flutter/material.dart';

class SetInputRow extends StatefulWidget {
  final int setNumber;
  final bool isBodyweight;
  final Function(double? weight, int reps) onCompleted;

  const SetInputRow({
    Key? key,
    required this.setNumber,
    required this.isBodyweight,
    required this.onCompleted,
  }) : super(key: key);

  @override
  State<SetInputRow> createState() => _SetInputRowState();
}

class _SetInputRowState extends State<SetInputRow> {
  final _weightController = TextEditingController();
  final _repsController = TextEditingController();
  bool _completed = false;

  @override
  void dispose() {
    _weightController.dispose();
    _repsController.dispose();
    super.dispose();
  }

  void _markCompleted() {
    if (_repsController.text.isEmpty) return;
    
    final reps = int.tryParse(_repsController.text);
    if (reps == null) return;
    
    final weight = widget.isBodyweight ? null : double.tryParse(_weightController.text);
    
    setState(() {
      _completed = true;
    });
    
    widget.onCompleted(weight, reps);
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final rowColor = _completed ? const Color(0xFF1A1A1A) : Colors.transparent;
    final borderColor = _completed ? primary : Colors.white;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: rowColor,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Row(
        children: [
          // Set Number
          Container(
            width: 48,
            height: 56,
            decoration: BoxDecoration(
              color: _completed ? primary : Colors.transparent,
              border: Border(right: BorderSide(color: borderColor, width: 2)),
            ),
            alignment: Alignment.center,
            child: Text(
              '${widget.setNumber}',
              style: TextStyle(
                color: _completed ? Colors.white : Colors.grey.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          
          const SizedBox(width: 8),

          // Weight / Type Input
          Expanded(
            child: widget.isBodyweight
              ? Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: Colors.grey.shade600, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'BODY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : SizedBox(
                  height: 48,
                  child: TextField(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    enabled: !_completed,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'KG',
                      hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.zero,
                        borderSide: BorderSide(color: Colors.white, width: 2),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF111111),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
          ),

          const SizedBox(width: 8),

          // Reps Input
          Expanded(
            child: SizedBox(
              height: 48,
              child: TextField(
                controller: _repsController,
                keyboardType: TextInputType.number,
                enabled: !_completed,
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'REPS',
                  hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.grey.shade600, width: 2),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: Colors.white, width: 2),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF111111),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ),

          const SizedBox(width: 8),

          // Action Button
          GestureDetector(
            onTap: _completed ? null : _markCompleted,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _completed ? primary : Colors.transparent,
                border: Border(left: BorderSide(color: borderColor, width: 2)),
              ),
              alignment: Alignment.center,
              child: _completed
                  ? const Icon(Icons.check, color: Colors.white, size: 32)
                  : const Text(
                      'DO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
