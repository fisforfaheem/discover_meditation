import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:confetti/confetti.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

// Add these models at the top of the file, after the imports
class FAQ {
  final String question;
  final String answer;
  final IconData icon;
  final Color color;
  final String emoji;
  final List<String>? bulletPoints;
  final String? tip;

  FAQ({
    required this.question,
    required this.answer,
    required this.icon,
    required this.color,
    required this.emoji,
    this.bulletPoints,
    this.tip,
  });
}

// Add this list of FAQs before the main class
final List<FAQ> faqs = [
  FAQ(
    question: 'How do I get started with meditation?',
    answer:
        'Starting your meditation journey is easier than you might think! The key is to begin with small steps and gradually build your practice.',
    icon: Icons.play_circle_outline,
    color: Colors.blue,
    emoji: '🌱',
    bulletPoints: [
      'Find a quiet, comfortable space',
      'Start with just 5 minutes daily',
      'Use guided meditations for beginners',
      'Focus on your breath',
      'Be patient with yourself',
    ],
    tip:
        '💡 Pro Tip: Try meditating at the same time each day to build a habit.',
  ),
  FAQ(
    question: 'What are the benefits of meditation?',
    answer:
        'Meditation offers a wide range of scientifically proven benefits for both mind and body.',
    icon: Icons.favorite_outline,
    color: Colors.pink,
    emoji: '✨',
    bulletPoints: [
      'Reduced stress and anxiety 😌',
      'Improved focus and concentration 🎯',
      'Better sleep quality 😴',
      'Enhanced emotional well-being 🌈',
      'Increased self-awareness 🧘‍♀️',
      'Lower blood pressure ❤️',
      'Better stress management 🌿',
    ],
    tip:
        '💡 Pro Tip: Track your mood before and after meditation to notice the benefits.',
  ),
  FAQ(
    question: 'How often should I meditate?',
    answer:
        'Consistency is more important than duration when it comes to meditation practice.',
    icon: Icons.calendar_today,
    color: Colors.green,
    emoji: '📅',
    bulletPoints: [
      'Daily practice is ideal',
      'Start with 5-10 minutes',
      'Gradually increase duration',
      'Listen to your body',
      'Quality over quantity',
    ],
    tip: '💡 Pro Tip: Set reminders to help establish your meditation routine.',
  ),
  FAQ(
    question: 'Why do I feel sleepy during meditation?',
    answer:
        'Feeling sleepy during meditation is a common experience, especially for beginners.',
    icon: Icons.nightlight_round,
    color: Colors.indigo,
    emoji: '😴',
    bulletPoints: [
      'Your body is deeply relaxing',
      'You might be sleep-deprived',
      'Time of day matters',
      'Posture affects alertness',
      'Energy levels fluctuate',
    ],
    tip: '💡 Pro Tip: Try meditating after some light exercise to stay alert.',
  ),
  FAQ(
    question: 'How do I handle distracting thoughts?',
    answer:
        'Distracting thoughts are a normal part of meditation. The key is how you respond to them.',
    icon: Icons.psychology,
    color: Colors.orange,
    emoji: '🧠',
    bulletPoints: [
      'Observe thoughts without judgment',
      'Return focus to your breath',
      'Use visualization techniques',
      'Label your thoughts',
      'Practice self-compassion',
    ],
    tip: '💡 Pro Tip: Think of thoughts as clouds passing by in the sky.',
  ),
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  runApp(
      MeditationApp(initialDarkMode: isDarkMode, isFirstLaunch: isFirstLaunch));
}

class MeditationApp extends StatefulWidget {
  final bool initialDarkMode;
  final bool isFirstLaunch;

  const MeditationApp(
      {super.key, required this.initialDarkMode, required this.isFirstLaunch});

  @override
  State<MeditationApp> createState() => _MeditationAppState();
}

class _MeditationAppState extends State<MeditationApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.initialDarkMode;
  }

  void _toggleTheme(bool isDarkMode) async {
    setState(() {
      _isDarkMode = isDarkMode;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    final lightTheme = ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme),
      colorScheme: const ColorScheme.light(
        primary: Colors.deepPurple,
        secondary: Colors.deepPurpleAccent,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
    );

    final darkTheme = ThemeData(
      primarySwatch: Colors.deepPurple,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF121212),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      colorScheme: const ColorScheme.dark(
        primary: Colors.deepPurpleAccent,
        secondary: Colors.deepPurple,
        surface: Color(0xFF1E1E1E),
        onSurface: Colors.white70,
      ),
    );

    return MaterialApp(
      title: 'Discover Yourself Meditation',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: widget.isFirstLaunch ? '/onboarding' : '/splash',
      routes: {
        '/onboarding': (context) =>
            OnboardingScreen(onComplete: () => _completeOnboarding(context)),
        '/splash': (context) =>
            SplashScreen(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
        '/home': (context) =>
            HomePage(toggleTheme: _toggleTheme, isDarkMode: _isDarkMode),
      },
      debugShowCheckedModeBanner: false,
    );
  }

  void _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstLaunch', false);
    Navigator.of(context).pushReplacementNamed('/splash');
  }
}

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = LiquidController();
  int currentPage = 0;

  final pages = [
    Container(
      color: Colors.blue,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.spa, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Welcome to Discover Yourself',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Embark on a journey of self-discovery and inner peace through meditation.',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
    Container(
      color: Colors.green,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.self_improvement, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Guided Meditations',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Choose from a variety of guided meditations to suit your needs and mood.',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
    Container(
      color: Colors.orange,
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.track_changes, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Track Your Progress',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Monitor your meditation journey with insightful statistics and achievements.',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            pages: pages,
            enableLoop: false,
            fullTransitionValue: 300,
            enableSideReveal: true,
            liquidController: _controller,
            onPageChangeCallback: (index) {
              setState(() {
                currentPage = index;
              });
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentPage > 0)
                  ElevatedButton(
                    onPressed: () {
                      _controller.jumpToPage(page: currentPage - 1);
                    },
                    child: const Text('Previous'),
                  ),
                if (currentPage < pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      _controller.jumpToPage(page: currentPage + 1);
                    },
                    child: const Text('Next'),
                  )
                else
                  ElevatedButton(
                    onPressed: widget.onComplete,
                    child: const Text('Get Started'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const SplashScreen(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(
              toggleTheme: widget.toggleTheme, isDarkMode: widget.isDarkMode),
        ),
      );
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.self_improvement, size: 100),
                const SizedBox(height: 20),
                Text(
                  'Discover Yourself',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Text(
                  'Meditation',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2,
              maxBlastForce: 5,
              minBlastForce: 1,
              emissionFrequency: 0.05,
              numberOfParticles: 50,
              gravity: 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  const HomePage(
      {super.key, required this.toggleTheme, required this.isDarkMode});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final int _selectedDuration = 5;
  Timer? _timer;
  int _remainingTime = 0;
  String _activeMeditation = '';
  late String _currentQuote;
  int _currentIndex = 0;
  late bool _isDarkMode;
  bool _notificationsEnabled = true;
  bool _soundEffectsEnabled = true;

  // User profile data
  String _userName = '';
  String _memberSince = '';
  int _totalMeditationTime = 0;
  int _dailyStreak = 0;
  int _totalSessions = 0;
  int _mindfulnessScore = 0;
  String _favoriteTechnique = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _currentQuote = quotes[Random().nextInt(quotes.length)];
    _isDarkMode = widget.isDarkMode;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
      _memberSince = prefs.getString('memberSince') ?? 'January 1, 2024';
      _totalMeditationTime = prefs.getInt('totalMeditationTime') ?? 0;
      _dailyStreak = prefs.getInt('dailyStreak') ?? 0;
      _totalSessions = prefs.getInt('totalSessions') ?? 0;
      _mindfulnessScore = prefs.getInt('mindfulnessScore') ?? 0;
      _favoriteTechnique = prefs.getString('favoriteTechnique') ?? 'Breathe';
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
      _soundEffectsEnabled = prefs.getBool('soundEffectsEnabled') ?? true;
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _userName);
    await prefs.setString('memberSince', _memberSince);
    await prefs.setInt('totalMeditationTime', _totalMeditationTime);
    await prefs.setInt('dailyStreak', _dailyStreak);
    await prefs.setInt('totalSessions', _totalSessions);
    await prefs.setInt('mindfulnessScore', _mindfulnessScore);
    await prefs.setString('favoriteTechnique', _favoriteTechnique);
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    await prefs.setBool('soundEffectsEnabled', _soundEffectsEnabled);
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
          _totalMeditationTime++;
        } else {
          _timer?.cancel();
          _activeMeditation = '';
          _totalSessions++;
          _updateMindfulnessScore();
          _saveUserData();
        }
      });
    });
  }

  void _updateMindfulnessScore() {
    // Simple algorithm to update mindfulness score
    _mindfulnessScore =
        ((_totalMeditationTime / 60) * 0.6 + _totalSessions * 0.4).round();
    if (_mindfulnessScore > 100) _mindfulnessScore = 100;
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
          _buildContent(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: BackgroundPainter(_animation.value, _isDarkMode),
          child: Container(),
        );
      },
    );
  }

  Widget _buildContent() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildMeditationContent();
      case 2:
        return _buildProfileContent();
      case 3:
        return _buildSettingsContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final greeting = _getGreeting(now.hour);
    final emoji = _getGreetingEmoji(now.hour);

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$greeting $emoji',
                              style: textTheme.titleLarge?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _userName,
                              style: textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                          child: Text(
                            _userName.isNotEmpty
                                ? _userName[0].toUpperCase()
                                : 'U',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDailyProgress(),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
              const SizedBox(height: 24),
              _buildQuickStartSection()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 200.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              _buildDailyInsights()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 400.ms)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 24),
              _buildQuoteCard()
                  .animate()
                  .fadeIn(duration: 600.ms, delay: 600.ms)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  String _getGreetingEmoji(int hour) {
    if (hour < 12) {
      return '🌅';
    } else if (hour < 17) {
      return '☀️';
    } else {
      return '🌙';
    }
  }

  Widget _buildDailyProgress() {
    final progress = _mindfulnessScore / 100;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daily Progress',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              '${(_mindfulnessScore).round()}%',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(10),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildMiniStat('🔥 Streak', '$_dailyStreak days'),
            _buildMiniStat(
                '⏱️ Today', '${(_totalMeditationTime / 60).round()} mins'),
            _buildMiniStat('🎯 Goal', '20 mins'),
          ],
        ),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✨ Quick Start',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickStartButton(
                'Breathe',
                '5 min',
                Icons.air,
                Colors.blue,
                () => _startMeditation('Breathe', 5),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickStartButton(
                'Focus',
                '10 min',
                Icons.center_focus_strong,
                Colors.green,
                () => _startMeditation('Focus', 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStartButton(String title, String duration, IconData icon,
      Color color, VoidCallback onTap) {
    return _buildGlassCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                duration,
                style: TextStyle(
                  fontSize: 14,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailyInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '📊 Daily Insights',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _buildGlassCard(
          child: Column(
            children: [
              _buildInsightItem(
                '🎯 Focus Level',
                'Excellent',
                LinearProgressIndicator(
                  value: 0.8,
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 6,
                ),
              ),
              const Divider(),
              _buildInsightItem(
                '😌 Stress Level',
                'Low',
                LinearProgressIndicator(
                  value: 0.3,
                  backgroundColor: Colors.green.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 6,
                ),
              ),
              const Divider(),
              _buildInsightItem(
                '💪 Consistency',
                'Good',
                LinearProgressIndicator(
                  value: 0.6,
                  backgroundColor: Colors.orange.withOpacity(0.1),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.orange),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(String title, String value, Widget indicator) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          indicator,
        ],
      ),
    );
  }

  Widget _buildQuoteCard() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.format_quote, size: 24),
              SizedBox(width: 8),
              Text(
                'Daily Wisdom',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _currentQuote,
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Text(
                '🧘‍♂️ Meditation Space',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ).animate().fadeIn(duration: 600.ms).slideX(begin: -0.2, end: 0),

              const SizedBox(height: 8),
              Text(
                'Find your inner peace through mindful practice',
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

              const SizedBox(height: 24),

              // Active Session Card (if meditation is active)
              if (_activeMeditation.isNotEmpty)
                _buildActiveMeditationCard()
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(begin: const Offset(0.95, 0.95)),

              // // Featured Techniques Section
              // _buildFeaturedTechniques()
              //     .animate()
              //     .fadeIn(duration: 800.ms, delay: 200.ms),

              const SizedBox(height: 24),

              // Categories Section
              _buildMeditationCategories()
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 400.ms),

              const SizedBox(height: 24),

              // Quick Timer Section
              _buildQuickTimerSection()
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 600.ms),

              const SizedBox(height: 24),

              // Tips Section
              _buildMeditationTips()
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 800.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveMeditationCard() {
    return _buildGlassCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🎯 Active Session',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _activeMeditation,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                ],
              ),
              Text(
                '${(_remainingTime / 60).floor()}:${(_remainingTime % 60).toString().padLeft(2, '0')}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _remainingTime / (_selectedDuration * 60),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(10),
            minHeight: 8,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _timer?.cancel();
                _activeMeditation = '';
              });
            },
            icon: const Icon(Icons.stop_circle_outlined),
            label: const Text('End Session'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  // Update _buildFeaturedCard with fixed height constraints
  Widget _buildFeaturedCard(String title, String subtitle, Color color,
      IconData icon, String duration, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 300,
        height: 300, // Fixed height
        // margin: const EdgeInsets.symmetric(vertical: 4),
        child: _buildGlassCard(
          child: Padding(
            padding: const EdgeInsets.all(5), // Increased padding
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon and Duration Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10), // Increased padding
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 24, color: color), // Larger icon
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ), // Increased padding
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        duration,
                        style: TextStyle(
                          fontSize: 14, // Larger font
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Increased spacing
                // Title
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18, // Larger font
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // Allow 2 lines for title
                ),
                const SizedBox(height: 8), // Increased spacing
                // Subtitle
                Expanded(
                  // Wrap in Expanded to prevent overflow
                  child: Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15, // Larger font
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                    maxLines: 3, // Allow 3 lines for subtitle
                  ),
                ),
                const SizedBox(height: 16), // Increased spacing
                // Start Button
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12), // Increased padding
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'Start Session',
                      style: TextStyle(
                        fontSize: 14, // Larger font
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Update _buildFeaturedTechniques with adjusted height
  Widget _buildFeaturedTechniques() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '✨ Featured Techniques',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160, // Match the card height
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildFeaturedCard(
                'Mindful Breathing',
                '🫁 Perfect for beginners',
                Colors.blue,
                Icons.air,
                '5-10 min',
                () => _showDurationPicker(
                  'Mindful Breathing',
                  description: 'Focus on your breath to calm your mind',
                  minDuration: 5,
                  maxDuration: 10,
                ),
              ),
              const SizedBox(width: 12),
              _buildFeaturedCard(
                'Body Scan',
                '🧘‍♀️ Deep relaxation',
                Colors.green,
                Icons.accessibility_new,
                '15-20 min',
                () => _showDurationPicker(
                  'Body Scan',
                  description:
                      'Systematically release tension throughout your body',
                  minDuration: 15,
                  maxDuration: 20,
                ),
              ),
              const SizedBox(width: 12),
              _buildFeaturedCard(
                'Loving Kindness',
                '💝 Cultivate compassion',
                Colors.pink,
                Icons.favorite,
                '10-15 min',
                () => _showDurationPicker(
                  'Loving Kindness',
                  description: 'Develop compassion for yourself and others',
                  minDuration: 10,
                  maxDuration: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMeditationCategories() {
    final categories = [
      {
        'title': 'Breathe',
        'description': '🫁 Mindful breathing exercises',
        'icon': Icons.air,
        'color': Colors.blue,
        'minDuration': 5,
        'maxDuration': 15,
        'detail': 'Focus on your breath to find calm and clarity',
      },
      {
        'title': 'Focus',
        'description': '🎯 Enhance concentration',
        'icon': Icons.center_focus_strong,
        'color': Colors.green,
        'minDuration': 10,
        'maxDuration': 20,
        'detail': 'Improve your concentration and mental clarity',
      },
      {
        'title': 'Sleep',
        'description': '😴 Better rest & relaxation',
        'icon': Icons.nightlight_round,
        'color': Colors.indigo,
        'minDuration': 15,
        'maxDuration': 30,
        'detail': 'Prepare your mind and body for restful sleep',
      },
      {
        'title': 'Stress Relief',
        'description': '🌿 Reduce anxiety',
        'icon': Icons.spa,
        'color': Colors.orange,
        'minDuration': 10,
        'maxDuration': 25,
        'detail': 'Release tension and find inner peace',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🎯 Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.6, // Adjusted aspect ratio
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              category['title'] as String,
              category['description'] as String,
              category['icon'] as IconData,
              category['color'] as Color,
              () => _showDurationPicker(
                category['title'] as String,
                description: category['detail'] as String,
                minDuration: category['minDuration'] as int,
                maxDuration: category['maxDuration'] as int,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String title, String description, IconData icon,
      Color color, VoidCallback onTap) {
    return SizedBox(
      // Add fixed size container
      height: 100, // Fixed height
      child: _buildGlassCard(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // Organize icon and title in a row
                  children: [
                    Icon(icon, size: 20, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Expanded(
                  // Make description take remaining space
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickTimerSection() {
    return _buildGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⏱️ Quick Timer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimerChip('5 min', () => _startMeditation('Quick', 5)),
              _buildTimerChip('10 min', () => _startMeditation('Quick', 10)),
              _buildTimerChip('15 min', () => _startMeditation('Quick', 15)),
              _buildTimerChip('20 min', () => _startMeditation('Quick', 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimerChip(String label, VoidCallback onTap) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _buildMeditationTips() {
    return _buildGlassCard(
      child: Column(
        mainAxisSize: MainAxisSize.min, // Add this
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates, size: 20), // Reduced icon size
              SizedBox(width: 8),
              Text(
                'Tips for Better Meditation',
                style: TextStyle(
                  fontSize: 16, // Reduced font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12), // Reduced spacing
          _buildTipItem('Find a quiet, comfortable space'),
          _buildTipItem('Keep a consistent practice schedule'),
          _buildTipItem('Start with shorter sessions'),
          _buildTipItem('Focus on your breath'),
          _buildTipItem('Be kind to yourself'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String tip) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0), // Reduced padding
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 16, // Reduced icon size
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 6), // Reduced spacing
          Expanded(
            child: Text(
              tip,
              style: TextStyle(
                fontSize: 12, // Reduced font size
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildStatisticsSection(),
              const SizedBox(height: 24),
              _buildMeditationJourney(),
              const SizedBox(height: 24),
              _buildAchievements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return _buildGlassCard(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.1),
                child: Text(
                  _userName.isNotEmpty ? _userName[0].toUpperCase() : 'U',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                  onPressed: _showEditProfileDialog,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _userName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            'Member since: $_memberSince',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildStatisticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Journey',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            _buildStatCard(
              'Total Sessions',
              '$_totalSessions',
              Icons.self_improvement,
              Colors.blue,
            ),
            _buildStatCard(
              'Mindfulness Score',
              '$_mindfulnessScore%',
              Icons.psychology,
              Colors.green,
            ),
            _buildStatCard(
              'Daily Streak',
              '$_dailyStreak days',
              Icons.local_fire_department,
              Colors.orange,
            ),
            _buildStatCard(
              'Total Time',
              '${(_totalMeditationTime / 60).round()} mins',
              Icons.timer,
              Colors.purple,
            ),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms);
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return _buildGlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMeditationJourney() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meditation Journey',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        _buildGlassCard(
          child: Column(
            children: [
              _buildJourneyItem(
                'Favorite Technique',
                _favoriteTechnique,
                Icons.favorite,
                Colors.red,
              ),
              const Divider(),
              _buildJourneyItem(
                'Last Session',
                '2 hours ago',
                Icons.access_time,
                Colors.blue,
              ),
              const Divider(),
              _buildJourneyItem(
                'Next Goal',
                '10 day streak',
                Icons.flag,
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms);
  }

  Widget _buildJourneyItem(
      String title, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Achievements',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAchievementBadge('Early Bird', Icons.wb_sunny, true),
            _buildAchievementBadge('7-Day Streak', Icons.emoji_events, true),
            _buildAchievementBadge('Zen Master', Icons.psychology, false),
            _buildAchievementBadge('Night Owl', Icons.nightlight_round, false),
            _buildAchievementBadge('30-Day Streak', Icons.star, false),
            _buildAchievementBadge(
                'Mindful Pro', Icons.workspace_premium, false),
          ],
        ),
      ],
    ).animate().fadeIn(duration: 800.ms, delay: 600.ms);
  }

  Widget _buildAchievementBadge(String title, IconData icon, bool isUnlocked) {
    return Tooltip(
      message: isUnlocked ? 'Achieved!' : 'Keep meditating to unlock',
      child: Chip(
        avatar: Icon(
          icon,
          size: 18,
          color: isUnlocked
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
        ),
        label: Text(
          title,
          style: TextStyle(
            color: isUnlocked
                ? Theme.of(context).colorScheme.onSurface
                : Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
        backgroundColor: isUnlocked
            ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
            : Theme.of(context).colorScheme.onSurface.withOpacity(0.05),
      ),
    );
  }

  Widget _buildSettingsContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    '⚙️ Settings',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.settings,
                    size: 28,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              )
                  .animate()
                  .fadeIn(duration: 600.milliseconds)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 20),
              _buildSettingsOptions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsOptions() {
    return Column(
      children: [
        _buildSettingsSection(
          'App Preferences',
          [
            _buildEnhancedSwitchTile(
              'Notifications',
              '🔔 Stay updated with meditation reminders',
              Icons.notifications_active,
              Colors.blue,
              _notificationsEnabled,
              (bool value) =>
                  _toggleNotifications(), // Convert to correct function type
            ),
            _buildEnhancedSwitchTile(
              'Dark Mode',
              '🌙 Switch to dark theme',
              Icons.dark_mode,
              Colors.purple,
              _isDarkMode,
              (bool value) =>
                  _toggleDarkMode(), // Convert to correct function type
            ),
            _buildEnhancedSwitchTile(
              'Sound Effects',
              '🎵 Enable meditation sounds',
              Icons.music_note,
              Colors.green,
              _soundEffectsEnabled,
              (bool value) =>
                  _toggleSoundEffects(), // Convert to correct function type
            ),
          ],
        ),
        const SizedBox(height: 20),
        _buildSettingsSection(
          'Information',
          [
            _buildEnhancedSettingsItem(
              'Privacy Policy',
              '🔒 Read our privacy policy',
              Icons.privacy_tip,
              Colors.orange,
              () => _openWebView('Privacy Policy',
                  'https://sites.google.com/view/remind-to-relax/home'),
            ),
            _buildEnhancedSettingsItem(
              'FAQ',
              '❓ Get help and support',
              Icons.help_outline,
              Colors.teal,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FAQListScreen()),
              ),
            ),
            _buildEnhancedSettingsItem(
              'About',
              'ℹ️ App information and version',
              Icons.info,
              Colors.indigo,
              _showAboutDialog,
            ),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 800.ms, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildEnhancedSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    bool value,
    Function(bool) onChanged,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: color,
      ),
    );
  }

  Widget _buildEnhancedSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
      ),
      trailing: Icon(Icons.chevron_right, color: color),
      onTap: onTap,
    );
  }

  void _toggleNotifications() {
    setState(() {
      _notificationsEnabled = !_notificationsEnabled;
    });
    _saveUserData();
    // Implement actual notification logic here
  }

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    widget.toggleTheme(_isDarkMode);
  }

  void _toggleSoundEffects() {
    setState(() {
      _soundEffectsEnabled = !_soundEffectsEnabled;
    });
    _saveUserData();
    // Implement actual sound effects logic here
  }

  Widget _buildGlassCard({required Widget child}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark
                ? theme.colorScheme.surface.withOpacity(0.1)
                : theme.colorScheme.surface.withOpacity(0.7),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isDark
                  ? theme.colorScheme.onSurface.withOpacity(0.1)
                  : theme.colorScheme.onSurface.withOpacity(0.1),
            ),
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
          Icon(icon, size: 48, color: color),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => isActive ? null : _showDurationPicker(title),
            child: Text(isActive ? '${_remainingTime}s' : 'Start'),
          ),
        ],
      ),
    );
  }

  void _showDurationPicker(
    String meditationType, {
    String description = '',
    int minDuration = 1,
    int maxDuration = 60,
  }) {
    int selectedDuration = minDuration;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      meditationType,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Text(
                      'Duration: $selectedDuration minutes',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Slider(
                      value: selectedDuration.toDouble(),
                      min: minDuration.toDouble(),
                      max: maxDuration.toDouble(),
                      divisions: maxDuration - minDuration,
                      label: '$selectedDuration min',
                      onChanged: (value) {
                        setState(() {
                          selectedDuration = value.round();
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _startMeditation(meditationType, selectedDuration);
                          },
                          child: const Text('Start'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface,
                  Theme.of(context).colorScheme.surface.withOpacity(0.9),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Text(
                      '✨ About',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '🧘‍♀️ Discover Yourself Meditation',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your journey to inner peace and mindfulness starts here. We provide a simple yet powerful tool for daily meditation practice.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                _buildFeatureItem(
                    '🎯 Guided Meditations', 'For various purposes'),
                _buildFeatureItem(
                    '⏱️ Custom Durations', 'Meditate at your pace'),
                _buildFeatureItem('🔥 Daily Streaks', 'Track your progress'),
                _buildFeatureItem(
                    '📊 Mindfulness Score', 'Monitor your growth'),
                _buildFeatureItem('🎨 Beautiful UI', 'Calming experience'),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Developed with 💖 by Asim Jaan',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Got it 👍'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFeatureItem(String title, String subtitle) {
    return ListTile(
      dense: true,
      leading: Container(
        width: 4,
        height: 24,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
    );
  }

  void _openWebView(String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => WebViewPage(title: title, url: url),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Theme.of(context).colorScheme.surface,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor:
          Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.self_improvement), label: 'Meditate'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  // Add this method in the _HomePageState class
  void _showEditProfileDialog() {
    String tempName = _userName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  controller: TextEditingController(text: _userName),
                  onChanged: (value) => tempName = value,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userName = tempName;
                        });
                        _saveUserData();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String title;
  final String url;

  const WebViewPage({super.key, required this.title, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: WebViewWidget(
        controller: WebViewController()
          ..loadRequest(Uri.parse(url))
          ..setJavaScriptMode(JavaScriptMode.unrestricted),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double animationValue;
  final bool isDarkMode;

  BackgroundPainter(this.animationValue, this.isDarkMode);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: isDarkMode
            ? [
                const Color(0xFF1a1a2e),
                const Color(0xFF16213e),
                const Color(0xFF0f3460),
              ]
            : [
                const Color(0xFFE3F2FD),
                const Color(0xFFBBDEFB),
                const Color(0xFF90CAF9),
              ],
        stops: const [0.0, 0.5, 1.0],
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
          ..color = (isDarkMode ? Colors.white : Colors.black).withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Update FAQListScreen with better UI
class FAQListScreen extends StatelessWidget {
  const FAQListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ & Help Center'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return _buildFAQCard(context, faq);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            '❓ Frequently Asked Questions',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Find answers to common questions about meditation',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCard(BuildContext context, FAQ faq) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FAQDetailScreen(faq: faq),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: faq.color.withOpacity(0.3),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: faq.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(faq.icon, size: 24, color: faq.color),
                    const SizedBox(width: 8),
                    Text(
                      faq.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  faq.question,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: faq.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Update FAQDetailScreen with better UI
class FAQDetailScreen extends StatelessWidget {
  final FAQ faq;

  const FAQDetailScreen({super.key, required this.faq});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${faq.emoji} FAQ'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: faq.color.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          Icon(faq.icon, size: 48, color: faq.color),
          const SizedBox(height: 16),
          Text(
            faq.question,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            faq.answer,
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            ),
          ),
          if (faq.bulletPoints != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Key Points:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...faq.bulletPoints!.map((point) => _buildBulletPoint(point)),
          ],
          if (faq.tip != null) ...[
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: faq.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: faq.color.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: faq.color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      faq.tip!,
                      style: TextStyle(
                        color: faq.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String point) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: faq.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              point,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
