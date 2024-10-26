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
  int _selectedDuration = 5;
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
  String _userEmail = '';
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
      _userName = prefs.getString('userName') ?? 'John Doe';
      _userEmail = prefs.getString('userEmail') ?? 'john.doe@example.com';
      _memberSince = prefs.getString('memberSince') ?? 'January 1, 2023';
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
    await prefs.setString('userEmail', _userEmail);
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGlassCard(
                child: Text(
                  'Welcome, $_userName',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.milliseconds)
                  .slideY(begin: -0.2, end: 0),
              const SizedBox(height: 20),
              _buildGlassCard(
                child: Text(
                  _currentQuote,
                  style: textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: 600.milliseconds, delay: 200.milliseconds)
                  .slideY(begin: 0.2, end: 0),
              const SizedBox(height: 20),
              _buildBentoGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBentoGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildBentoItem('Daily Streak', '$_dailyStreak days',
            Icons.local_fire_department, Colors.orange),
        _buildBentoItem(
            'Total Sessions', '$_totalSessions', Icons.timer, Colors.blue),
        _buildBentoItem('Mindfulness Score', '$_mindfulnessScore%',
            Icons.psychology, Colors.green),
        _buildBentoItem('Favorite Technique', _favoriteTechnique,
            Icons.favorite, Colors.red),
      ],
    )
        .animate()
        .fadeIn(duration: 800.milliseconds, delay: 400.milliseconds)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildBentoItem(
      String title, String value, IconData icon, Color color) {
    final textTheme = Theme.of(context).textTheme;
    return _buildGlassCard(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(title,
              style:
                  textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: textTheme.titleMedium),
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
              const Text(
                'Meditation Techniques',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
                  .animate()
                  .fadeIn(duration: 600.milliseconds)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
              )
                  .animate()
                  .fadeIn(duration: 800.milliseconds, delay: 200.milliseconds)
                  .scale(
                      begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ],
          ),
        ),
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
              const Text(
                'Your Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              )
                  .animate()
                  .fadeIn(duration: 600.milliseconds)
                  .slideX(begin: -0.2, end: 0),
              const SizedBox(height: 20),
              _buildProfileInfo(),
              const SizedBox(height: 20),
              _buildAchievements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return _buildGlassCard(
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage('https://picsum.photos/200'),
          ),
          const SizedBox(height: 16),
          Text(_userName,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(_userEmail, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          Text('Member since: $_memberSince'),
          Text(
              'Total meditation time: ${(_totalMeditationTime / 60).round()} minutes'),
          ElevatedButton(
            onPressed: _showEditProfileDialog,
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 800.milliseconds, delay: 200.milliseconds)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempName = _userName;
        String tempEmail = _userEmail;
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => tempName = value,
                controller: TextEditingController(text: _userName),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => tempEmail = value,
                controller: TextEditingController(text: _userEmail),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _userName = tempName;
                  _userEmail = tempEmail;
                });
                _saveUserData();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAchievements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Achievements',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildAchievementBadge('7-Day Streak', Icons.emoji_events),
            _buildAchievementBadge('Zen Master', Icons.psychology),
            _buildAchievementBadge('Early Bird', Icons.wb_sunny),
            _buildAchievementBadge('Night Owl', Icons.nightlight_round),
          ],
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 800.milliseconds, delay: 400.milliseconds)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildAchievementBadge(String title, IconData icon) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(title),
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
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
              const Text(
                'Settings',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
        SwitchListTile(
          title: const Text('Notifications'),
          secondary: const Icon(Icons.notifications),
          value: _notificationsEnabled,
          onChanged: (bool value) {
            _toggleNotifications();
          },
        ),
        SwitchListTile(
          title: const Text('Dark Mode'),
          secondary: const Icon(Icons.dark_mode),
          value: _isDarkMode,
          onChanged: (bool value) {
            _toggleDarkMode();
          },
        ),
        SwitchListTile(
          title: const Text('Sound Effects'),
          secondary: const Icon(Icons.volume_up),
          value: _soundEffectsEnabled,
          onChanged: (bool value) {
            _toggleSoundEffects();
          },
        ),
        _buildSettingsItem(
          'Privacy Policy',
          Icons.privacy_tip,
          () => _openWebView('Privacy Policy', 'https://example.com/privacy'),
        ),
        _buildSettingsItem(
          'Terms of Service',
          Icons.description,
          () => _openWebView('Terms of Service', 'https://example.com/terms'),
        ),
        _buildSettingsItem('About', Icons.info, _showAboutDialog),
      ],
    )
        .animate()
        .fadeIn(duration: 800.milliseconds, delay: 200.milliseconds)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildSettingsItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
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

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: const SingleChildScrollView(
            child: Text(
              'Discover Yourself Meditation is an app designed to help you find inner peace and mindfulness through various meditation techniques. '
              'Our goal is to provide a simple, effective tool for daily meditation practice, '
              'helping users reduce stress, improve focus, and enhance overall well-being. '
              'This app is created with love and care, respecting user privacy and adhering to best practices in app development.\n\n'
              'Features:\n'
              '- Guided meditations for various purposes\n'
              '- Customizable meditation durations\n'
              '- Daily streaks and achievements\n'
              '- Mindfulness score tracking\n'
              '- Beautiful, calming user interface\n\n'
              'Version: 1.0.0\n'
              'Developed by: Asim Jaan',
            ),
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
