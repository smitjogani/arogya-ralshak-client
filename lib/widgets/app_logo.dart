import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../theme/app_colors.dart';

class AppLogo extends StatefulWidget {
  final double size;
  final bool animate;
  final Color? shieldColor;
  final Color? crossColor;
  final Color? nodeColor;
  final bool useLottie;
  final bool useImage;
  final String lottiePath;
  final String imagePath;

  const AppLogo({
    super.key,
    this.size = 80,
    this.animate = true,
    this.shieldColor,
    this.crossColor,
    this.nodeColor,
    this.useLottie = false,
    this.useImage = true,
    this.lottiePath = 'assets/animations/aarogya_logo.json',
    this.imagePath = 'assets/logo/logo.jpg',
  });

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    if (widget.animate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size;

    if (widget.useImage) {
      final Widget imageWidget = Image.asset(
        widget.imagePath,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return CustomPaint(
            size: Size(size, size),
            painter: _LogoPainter(
              pulseProgress: 0.5,
              shieldColor: widget.shieldColor ?? AppColors.primaryTeal,
              crossColor: widget.crossColor ?? Colors.white,
              nodeColor: widget.nodeColor ?? AppColors.accentGold,
            ),
          );
        },
      );

      if (widget.animate) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.96 + (_controller.value * 0.08),
              child: imageWidget,
            );
          },
        );
      }

      return imageWidget;
    } else if (widget.useLottie) {
      return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final double glowProgress = widget.animate ? _controller.value : 0.5;

          return Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (widget.shieldColor ?? AppColors.primaryTeal).withValues(alpha: 0.35 + glowProgress * 0.2),
                  blurRadius: 18 + (glowProgress * 8),
                  spreadRadius: 2 + (glowProgress * 2),
                ),
                BoxShadow(
                  color: (widget.nodeColor ?? AppColors.accentGold).withValues(alpha: 0.25),
                  blurRadius: 22,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Container(
              padding: EdgeInsets.all(size * 0.03),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    widget.nodeColor ?? AppColors.accentGold,
                    widget.shieldColor ?? AppColors.primaryTeal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ClipOval(
                child: Lottie.asset(
                  widget.lottiePath,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  animate: widget.animate,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      widget.imagePath,
                      width: size,
                      height: size,
                      fit: BoxFit.contain,
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _LogoPainter(
            pulseProgress: widget.animate ? _controller.value : 0.5,
            shieldColor: widget.shieldColor ?? AppColors.primaryTeal,
            crossColor: widget.crossColor ?? Colors.white,
            nodeColor: widget.nodeColor ?? AppColors.accentGold,
          ),
        );
      },
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double pulseProgress;
  final Color shieldColor;
  final Color crossColor;
  final Color nodeColor;

  _LogoPainter({
    required this.pulseProgress,
    required this.shieldColor,
    required this.crossColor,
    required this.nodeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;
    final Offset center = Offset(width / 2, height / 2);

    // 1. Draw Outer Glowing Ring / AI Circuit Nodes
    final Paint nodePaint = Paint()
      ..color = nodeColor.withValues(alpha: 0.7 + (pulseProgress * 0.3))
      ..style = PaintingStyle.fill;

    final Paint circuitLinePaint = Paint()
      ..color = nodeColor.withValues(alpha: 0.4 + (pulseProgress * 0.3))
      ..strokeWidth = width * 0.025
      ..style = PaintingStyle.stroke;

    final double outerRadius = width * 0.46;
    const int numNodes = 6;
    for (int i = 0; i < numNodes; i++) {
      final double angle = (i * (2 * math.pi / numNodes)) + (pulseProgress * 0.2);
      final double nodeX = center.dx + outerRadius * math.cos(angle);
      final double nodeY = center.dy + outerRadius * math.sin(angle);
      
      // Draw circuit line connecting node to shield border
      canvas.drawLine(center, Offset(nodeX, nodeY), circuitLinePaint);
      
      // Draw node circle
      final double nodeSize = width * (0.04 + (i % 2 == 0 ? 0.015 : 0.005));
      canvas.drawCircle(Offset(nodeX, nodeY), nodeSize, nodePaint);
      
      // Node glow
      final Paint glowPaint = Paint()
        ..color = nodeColor.withValues(alpha: 0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(Offset(nodeX, nodeY), nodeSize * 1.8, glowPaint);
    }

    // 2. Draw Shield Path
    final Path shieldPath = Path();
    shieldPath.moveTo(width * 0.5, height * 0.12);
    shieldPath.quadraticBezierTo(width * 0.85, height * 0.12, width * 0.82, height * 0.45);
    shieldPath.quadraticBezierTo(width * 0.78, height * 0.78, width * 0.5, height * 0.88);
    shieldPath.quadraticBezierTo(width * 0.22, height * 0.78, width * 0.18, height * 0.45);
    shieldPath.quadraticBezierTo(width * 0.15, height * 0.12, width * 0.5, height * 0.12);
    shieldPath.close();

    // Shield Shadow & Gradient Fill
    final Rect shieldRect = Rect.fromLTWH(0, 0, width, height);
    final Gradient shieldGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        shieldColor,
        Color.lerp(shieldColor, Colors.black, 0.25)!,
      ],
    );

    final Paint shieldPaint = Paint()
      ..shader = shieldGradient.createShader(shieldRect)
      ..style = PaintingStyle.fill;

    // Shield Soft Shadow
    canvas.drawShadow(shieldPath, Colors.black.withValues(alpha: 0.3), 8.0, true);
    
    // Draw Shield Body
    canvas.drawPath(shieldPath, shieldPaint);

    // Shield Gold Border Accent
    final Paint borderPaint = Paint()
      ..color = nodeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = width * 0.035;
    canvas.drawPath(shieldPath, borderPaint);

    // 3. Draw Medical Cross in Center
    final double crossWidth = width * 0.12;
    final double crossHeight = height * 0.36;

    final Path crossPath = Path();
    // Vertical bar
    crossPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy * 0.98), width: crossWidth, height: crossHeight),
        Radius.circular(crossWidth * 0.3),
      ),
    );
    // Horizontal bar
    crossPath.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset(center.dx, center.dy * 0.98), width: crossHeight, height: crossWidth),
        Radius.circular(crossWidth * 0.3),
      ),
    );

    final Paint crossPaint = Paint()
      ..color = crossColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(crossPath, crossPaint);
  }

  @override
  bool shouldRepaint(covariant _LogoPainter oldDelegate) {
    return oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.shieldColor != shieldColor ||
        oldDelegate.crossColor != crossColor ||
        oldDelegate.nodeColor != nodeColor;
  }
}
