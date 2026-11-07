import 'package:flutter/material.dart';

/// Sabit üst çubuğun altındaki kenardan kenara kil diorama sahnesi.
/// Üst ve alt kenarı zemine erir; SliverAppBar'ın flexibleSpace arka planı olarak kullanılır.
class HeroImage extends StatelessWidget {
  const HeroImage(
    this.asset, {
    this.topFade = 0.2,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.bottomCenter,
    super.key,
  });

  final String asset;

  /// Geniş sahneler dar ekranda kırpılmasın diye contain verilebilir.
  final BoxFit fit;

  /// Kırpma penceresinin konumu (ör. sahnenin önemli kısmı sağdaysa sağa kaydır).
  final Alignment alignment;

  /// Görselin üst kısmında saydam başlayıp görünür olduğu oran (0–1).
  final double topFade;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.dstIn,
      shaderCallback: (rect) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: const [Colors.transparent, Colors.transparent, Colors.black, Colors.black, Colors.transparent],
        stops: [0, topFade, topFade + 0.3, 0.9, 1],
      ).createShader(rect),
      child: Image.asset(asset, fit: fit, alignment: alignment, excludeFromSemantics: true),
    );
  }
}
