import 'package:flutter/material.dart';

class ControlButton extends StatefulWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? color;
  final double size;
  final bool isCircular;

  const ControlButton({
    super.key,
    required this.icon,
    this.label,
    required this.onPressed,
    this.color,
    this.size = 60.0,
    this.isCircular = true,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    widget.onPressed();
  }

  @override
  Widget build(BuildContext context) {
    final buttonWidget = AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _handleTap,
            borderRadius: BorderRadius.circular(widget.isCircular ? widget.size / 2 : 8),
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color ?? Theme.of(context).colorScheme.primary.withOpacity(0.2),
                shape: widget.isCircular ? BoxShape.circle : BoxShape.rectangle,
                borderRadius: widget.isCircular ? null : BorderRadius.circular(8),
              ),
              child: Icon(
                widget.icon,
                color: widget.color != null
                    ? Colors.white
                    : Theme.of(context).colorScheme.primary,
                size: widget.size * 0.5,
              ),
            ),
          ),
        ),
      ),
    );

    if (widget.label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buttonWidget,
          const SizedBox(height: 4),
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      );
    }

    return buttonWidget;
  }
}
