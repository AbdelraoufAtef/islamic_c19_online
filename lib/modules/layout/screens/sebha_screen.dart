import 'dart:math';
import 'package:flutter/material.dart';
import 'package:islamic_c19_online/core/theme/app_colors.dart';

class DhikrItem {
  final String arabic;
  final int target;

  const DhikrItem({
    required this.arabic,
    required this.target,
  });
}

const List<DhikrItem> dhikrList = [
  DhikrItem(arabic: 'سبحان الله', target: 33),
  DhikrItem(arabic: 'الحمد لله', target: 33),
  DhikrItem(arabic: 'الله أكبر', target: 33),
];

class SebhaScreen extends StatefulWidget {
  const SebhaScreen({super.key});

  @override
  State<SebhaScreen> createState() => SebhaScreenState();
}

class SebhaScreenState extends State<SebhaScreen>
    with SingleTickerProviderStateMixin {
  int dhikrIndex = 0;
  int count = 0;
  final int totalBeads = 30;

  late AnimationController pulseController;
  late Animation<double>pulseAnimation;

  DhikrItem get currentDhikr => dhikrList[dhikrIndex];

  @override
  void initState() {
    super.initState();
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    pulseAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    pulseController.dispose();
    super.dispose();
  }

  void _onTap() {
    pulseController.forward().then((_) => pulseController.reverse());

    setState(() {
      count++;
      if (count >= currentDhikr.target) {
        if (dhikrIndex < dhikrList.length - 1) {
          dhikrIndex++;
          count = 0;
        } else {
          dhikrIndex = 0;
          count = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/sebha/sebha_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.35,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  "assets/images/quran_header.png",
                  height: 171,
                ),
              ),

              const SizedBox(height: 12),
              const Text(
                'سَبِّحِ اسْمَ رَبِّكَ الأَعْلَى',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              GestureDetector(
                onTap: _onTap,
                child: AnimatedBuilder(
                  animation: pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: pulseAnimation.value,
                      child: child,
                    );
                  },
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 320,
                          height: 320,
                          child: CustomPaint(
                            painter: SebhaRingPainter(
                              totalBeads: totalBeads,
                              litBeads:count,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              currentDhikr.arabic,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              '$count',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class SebhaRingPainter extends CustomPainter {
  final int totalBeads;
  final int litBeads;

  SebhaRingPainter({required this.totalBeads, required this.litBeads});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.40;
    final beadRadius = size.width * 0.045;

    final threadPaint = Paint()
      ..color = const Color(0xffE2BE7F).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius, threadPaint);

    for (int i = 0; i < totalBeads; i++) {
      final angle = (2 * pi * i / totalBeads) - (pi / 2);
      final beadCenter = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );

      final beadPaint = Paint()
        ..shader = RadialGradient(
          center: const Alignment(-0.3, -0.3),
          colors: const [Color(0xffFFE09A), Color(0xffC8A951)],
        ).createShader(
          Rect.fromCircle(center: beadCenter, radius: beadRadius),
        );

      canvas.drawCircle(beadCenter, beadRadius, beadPaint);
    }
  }

  @override
  bool shouldRepaint(SebhaRingPainter old) =>
      old.litBeads != litBeads || old.totalBeads != totalBeads;
}