import 'package:flutter/material.dart';

/// A shimmer loading widget for skeleton loaders
class ShimmerLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  
  const ShimmerLoader({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });
  
  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                isDark 
                  ? const Color(0xFF2A2A3E)
                  : const Color(0xFFE5E5E5),
                isDark 
                  ? const Color(0xFF3A3A4E)
                  : const Color(0xFFF0F0F0),
                isDark 
                  ? const Color(0xFF2A2A3E)
                  : const Color(0xFFE5E5E5),
              ],
              stops: [
                _animation.value - 0.5,
                _animation.value,
                _animation.value + 0.5,
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Verse line shimmer loader
class VerseShimmerLoader extends StatelessWidget {
  final int verseNumber;
  
  const VerseShimmerLoader({super.key, this.verseNumber = 1});
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30,
            child: ShimmerLoader(width: 20, height: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerLoader(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                const ShimmerLoader(width: double.infinity, height: 12),
                const SizedBox(height: 6),
                ShimmerLoader(width: MediaQuery.of(context).size.width * 0.6, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card shimmer loader
class CardShimmerLoader extends StatelessWidget {
  const CardShimmerLoader({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerLoader(width: 150, height: 20),
            const SizedBox(height: 12),
            const ShimmerLoader(width: double.infinity, height: 14),
            const SizedBox(height: 8),
            const ShimmerLoader(width: double.infinity, height: 14),
            const SizedBox(height: 8),
            ShimmerLoader(width: MediaQuery.of(context).size.width * 0.7, height: 14),
          ],
        ),
      ),
    );
  }
}
