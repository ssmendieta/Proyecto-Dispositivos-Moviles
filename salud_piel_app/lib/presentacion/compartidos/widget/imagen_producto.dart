import 'package:flutter/material.dart';

class ImagenProducto extends StatelessWidget {
  final String? imagenPath;
  final double? size;
  final double borderRadius;
  final BoxFit fit;

  const ImagenProducto({
    super.key,
    this.imagenPath,
    this.size,
    this.borderRadius = 14,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = size ?? constraints.maxWidth;
        final h = size ?? constraints.maxHeight;
        return Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildContent(w, h),
        );
      },
    );
  }

  Widget _buildContent(double w, double h) {
    if (imagenPath == null || imagenPath!.isEmpty) {
      return _placeholder();
    }

    return Image.network(
      imagenPath!,
      fit: fit,
      width: w,
      height: h,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        final total = loadingProgress.expectedTotalBytes;
        final progress = total != null
            ? loadingProgress.cumulativeBytesLoaded / total
            : null;
        return Center(
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 2,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) => _placeholder(),
    );
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(
        Icons.spa_outlined,
        size: 42,
        color: Color(0xFFB0BEC5),
      ),
    );
  }
}
