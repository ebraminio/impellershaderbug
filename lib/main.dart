import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const ShaderPage(),
    );
  }
}

class ShaderPage extends StatefulWidget {
  const ShaderPage({super.key});

  @override
  State<ShaderPage> createState() => _ShaderPageState();
}

class _ShaderPageState extends State<ShaderPage> {
  bool _initialized = false;
  FragmentProgram? _shader;

  void _initializeShader() async {
    if (_initialized == true) return;
    _initialized = true;
    final shader = await FragmentProgram.fromAsset('shaders/shader.frag');
    setState(() => _shader = shader);
  }

  @override
  Widget build(BuildContext context) {
    _initializeShader();
    final shader = _shader;
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (shader != null)
              CustomPaint(
                painter: _ScenePainter(shader),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Stack(
                    children: [
                      Container(height: 200),
                      Container(height: 200, width: 10, color: Colors.red),
                    ],
                  ),
                ),
              ),
            Container(height: 1800),
          ],
        ),
      ),
    );
  }
}

class _ScenePainter extends CustomPainter {
  final FragmentProgram program;

  _ScenePainter(this.program);

  @override
  void paint(Canvas canvas, Size size) {
    final shader = program.fragmentShader();
    shader.setFloat(0, size.width);
    shader.setFloat(1, size.height);
    canvas.drawPaint(Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
