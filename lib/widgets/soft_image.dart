import 'package:flutter/material.dart';

/// Zeminde serbest duran kare görsel: kenarları dairesel olarak zemine erir,
/// böylece görselin sınırı çizgi gibi görünmez.
class SoftImage extends StatelessWidget {
  const SoftImage(this.asset, {required this.size, super.key});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => const RadialGradient(
        colors: [Colors.black, Colors.black, Colors.transparent],
        stops: [0, 0.62, 1],
      ).createShader(rect),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        excludeFromSemantics: true,
        errorBuilder: (_, _, _) => SizedBox(width: size, height: size),
      ),
    );
  }
}
