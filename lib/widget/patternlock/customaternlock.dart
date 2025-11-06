import 'package:flutter/material.dart';
import 'dart:math';

class CustomPatternLock extends StatefulWidget {
  final void Function(String) onPatternCompleted;
  final bool allowReset;
  final String? savedPattern; // optional: use for verifying

  const CustomPatternLock({
    super.key,
    required this.onPatternCompleted,
    this.allowReset = false,
    this.savedPattern,
  });

  @override
  State<CustomPatternLock> createState() => _CustomPatternLockState();
}

class _CustomPatternLockState extends State<CustomPatternLock> {
  final int gridCount = 3;
  final double dotSize = 60;
  List<int> selectedDots = [];
  bool patternDone = false;

  Offset? currentPoint;
  final List<Offset> dotPositions = [];

  @override
  Widget build(BuildContext context) {
    final double gridSize = MediaQuery.of(context).size.width * 0.8;
    final double spacing = (gridSize - (dotSize * gridCount)) / (gridCount - 1);

    return GestureDetector(
      onPanStart: (details) => _handleTouch(details.localPosition, gridSize, spacing),
      onPanUpdate: (details) => _handleTouch(details.localPosition, gridSize, spacing),
      onPanEnd: (details) {
        widget.onPatternCompleted(selectedDots.join());
        setState(() {
          patternDone = true;
          currentPoint = null;
        });
      },
      child: Center(
        child: CustomPaint(
          painter: _PatternPainter(
            dotPositions: dotPositions,
            selectedDots: selectedDots,
            currentPoint: currentPoint,
          ),
          child: SizedBox(
            width: gridSize,
            height: gridSize,
            child: Stack(
              children: List.generate(gridCount * gridCount, (index) {
                final row = index ~/ gridCount;
                final col = index % gridCount;
                final double x = col * (dotSize + spacing);
                final double y = row * (dotSize + spacing);
                final Offset pos = Offset(x + dotSize / 2, y + dotSize / 2);
                if (dotPositions.length < gridCount * gridCount) {
                  dotPositions.add(pos);
                }

                final bool isSelected = selectedDots.contains(index);
                return Positioned(
                  left: x,
                  top: y,
                  child: Container(
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey,
                        width: 2,
                      ),
                      boxShadow: [
                        if (isSelected)
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.4),
                            blurRadius: 8,
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTouch(Offset localPosition, double gridSize, double spacing) {
    for (int i = 0; i < dotPositions.length; i++) {
      final double dx = dotPositions[i].dx - localPosition.dx;
      final double dy = dotPositions[i].dy - localPosition.dy;
      final double distance = sqrt(dx * dx + dy * dy);
      if (distance < dotSize / 2) {
        if (!selectedDots.contains(i)) {
          setState(() {
            selectedDots.add(i);
          });
        }
      }
    }

    setState(() {
      currentPoint = localPosition;
    });
  }
}

class _PatternPainter extends CustomPainter {
  final List<Offset> dotPositions;
  final List<int> selectedDots;
  final Offset? currentPoint;

  _PatternPainter({
    required this.dotPositions,
    required this.selectedDots,
    required this.currentPoint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < selectedDots.length - 1; i++) {
      final p1 = dotPositions[selectedDots[i]];
      final p2 = dotPositions[selectedDots[i + 1]];
      canvas.drawLine(p1, p2, paintLine);
    }

    if (selectedDots.isNotEmpty && currentPoint != null) {
      final lastDot = dotPositions[selectedDots.last];
      canvas.drawLine(lastDot, currentPoint!, paintLine);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
