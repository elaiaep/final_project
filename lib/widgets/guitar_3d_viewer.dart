import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class Guitar3DViewer extends StatelessWidget {
  final String modelUrl;
  final String guitarName;

  const Guitar3DViewer({
    super.key,
    required this.modelUrl,
    required this.guitarName,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ModelViewer(
        src: modelUrl,
        alt: 'A 3D model of $guitarName',
        ar: true,
        arModes: const ['scene-viewer', 'webxr', 'quick-look'],
        autoRotate: true,
        cameraControls: true,
        disableZoom: false,
        loading: Loading.lazy,
        autoPlay: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        exposure: 1.0,
        shadowIntensity: 1,
        shadowSoftness: 1,
      ),
    );
  }
} 