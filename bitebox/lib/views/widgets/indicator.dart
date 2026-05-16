import 'package:bitebox/views/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Indicator extends StatelessWidget {
  final int current_step;

  const Indicator({super.key, required this.current_step});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      _stepbuild(1),
      _buildline(1),
      _stepbuild(2),
      _buildline(2),
      _stepbuild(3),
      _buildline(3)
      ],
    );
  }

  Widget _stepbuild(int step) {
    final isDone = current_step > step;
    final isActive = current_step == step;

    return Container(
        width:  36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDone || isActive ? BBColors.red : Colors.transparent,
        border: Border.all(
          color: isDone || isActive ? BBColors.red : BBColors.muted,
          width: 2,
        ),
      ),
      child: Center(
        child: isDone
            ? const Icon(Icons.check, color: Colors.white, size: 18)
            : Text(
                '$Step',
                style: GoogleFonts.poppins(
                  color: isActive ? Colors.white : BBColors.muted,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
  Widget _buildline(int step){
    final isCompleted = current_step >step;
    return Expanded(
      child: Container(
        height: 2,
        color: isCompleted ? BBColors.red : BBColors.muted,
      ),
    );
  }
}
