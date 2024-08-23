import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MeditationApp());
}

class MeditationApp extends StatelessWidget {
  const MeditationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Discover Yourself Meditation',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _selectedDuration = 5;
  Timer? _timer;
  int _remainingTime = 0;
  String _activeMeditation = '';
  late String _currentQuote;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _currentQuote = quotes[Random().nextInt(quotes.length)];
  }

  void _startMeditation(String type, int duration) {
    setState(() {
      _activeMeditation = type;
      _remainingTime = duration * 60;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer?.cancel();
          _activeMeditation = '';
        }
      });
    });
  }

  final List<String> quotes = [
    '"The quieter you become, the more you can hear." - Ram Dass',
    '"Meditation is not evasion; it is a serene encounter with reality." - Thich Nhat Hanh',
    '"Your goal is not to battle with the mind, but to witness the mind." - Swami Muktananda',
    '"The thing about meditation is: You become more and more you." - David Lynch',
    '"Meditation is the dissolution of thoughts in eternal awareness or pure consciousness." - Sivananda',
    '"Meditation is the secret of all growth in spiritual life and knowledge." - James Allen',
    '"The mind is everything. What you think you become." - Buddha',
    '"To understand the immeasurable, the mind must be extraordinarily quiet, still." - Jiddu Krishnamurti',
    '"Meditation is the ultimate mobile device; you can use it anywhere, anytime, unobtrusively." - Sharon Salzberg',
    '"Your calm mind is the ultimate weapon against your challenges." - Bryant McGill',
  ];

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          _buildGlassmorphicContent(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(_animation.value),
          child: Container(),
        );
      },
    );
  }

  Widget _buildGlassmorphicContent() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildGlassCard(
                  child: const Text(
                    'Discover Yourself',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: _showSettingsDialog,
                ),
              ],
            ),
            const SizedBox(height: 100),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildMeditationOption('Breathe', Icons.air, Colors.blue),
                  _buildMeditationOption(
                      'Focus', Icons.center_focus_strong, Colors.green),
                  _buildMeditationOption('Relax', Icons.spa, Colors.orange),
                  _buildMeditationOption(
                      'Sleep', Icons.nightlight_round, Colors.indigo),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildGlassCard(
              child: Text(
                _currentQuote,
                style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassCard({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildMeditationOption(String title, IconData icon, Color color) {
    bool isActive = _activeMeditation == title;
    return _buildGlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48, color: Colors.white),
          const SizedBox(height: 8),
          Text(title,
              style: const TextStyle(fontSize: 18, color: Colors.white)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => isActive ? null : _showDurationPicker(title),
            child: Text(isActive ? '${_remainingTime}s' : 'Start Timer'),
          ),
        ],
      ),
    );
  }

  void _showDurationPicker(String meditationType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set $meditationType Duration'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: _selectedDuration.toDouble(),
                    min: 1,
                    max: 60,
                    divisions: 59,
                    label: _selectedDuration.toString(),
                    onChanged: (double value) {
                      setState(() {
                        _selectedDuration = value.round();
                      });
                    },
                  ),
                  Text('$_selectedDuration minutes'),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startMeditation(meditationType, _selectedDuration);
              },
              child: const Text('Start'),
            ),
          ],
        );
      },
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Privacy Policy'),
                onTap: () {
                  Navigator.of(context).pop();
                  _openWebView('Privacy Policy', 'https://google.com/');
                },
              ),
              // ListTile(
              //   title: const Text('Terms and Conditions'),
              //   onTap: () {
              //     Navigator.of(context).pop();
              //     _openWebView(
              //         'Terms and Conditions', 'https://example.com/terms');
              //   },
              // ),
              ListTile(
                title: const Text('About'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showAboutDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text(
            'Discover Yourself Meditation is an app designed to help you find inner peace and mindfulness through various meditation techniques. '
            'Our goal is to provide a simple, effective tool for daily meditation practice, '
            'helping users reduce stress, improve focus, and enhance overall well-being. '
            'This app is created with love and care, respecting user privacy and adhering to best practices in app development.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _openWebView(String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewPage(title: title, url: url),
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: WebViewWidget(
          controller: WebViewController()
            ..loadRequest(Uri.parse(url))
            ..setJavaScriptMode(JavaScriptMode.unrestricted),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;

  BackgroundPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF1a237e),
          Color(0xFF3949ab),
          Color(0xFF3f51b5),
        ],
        stops: [0.0, 0.5, 1.0],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPaint(paint);

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < 5; i++) {
      final radius = 50.0 + i * 30.0;
      final offset = 10.0 * (i + 1);
      final x = centerX + offset * cos(animationValue * 2 * pi + i);
      final y = centerY + offset * sin(animationValue * 2 * pi + i);

      canvas.drawCircle(
        Offset(x, y),
        radius,
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
