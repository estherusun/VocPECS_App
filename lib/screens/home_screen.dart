import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this to pubspec.yaml
import '../providers/pecs_provider.dart';
import '../models/pecs_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showGuide = false;

  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
  }

  // Phase 2: Logic to show arrow only on first visit
  void _checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // If 'first_visit' doesn't exist, it is true
      _showGuide = prefs.getBool('first_visit') ?? true;
    });
  }

  // Disappears when they click the first button
 void _onModuleClicked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('first_visit', false);
    if (!mounted) return; 
    setState(() => _showGuide = false);
    Navigator.pushNamed(context, '/album_library');
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PecsProvider>(context);
    
    final activeProfile = p.profiles.firstWhere(
      (u) => u.name == p.currentUser,
      orElse: () => UserProfile(id: '0', name: 'User', color: Colors.grey),
    );

    int finishedCount = p.completedModulesCount; 

    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D2), // Calming Cream
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. HEADER
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: activeProfile.color,
                    backgroundImage: activeProfile.image != null ? FileImage(activeProfile.image!) : null,
                    child: activeProfile.image == null ? const Icon(Icons.person, color: Colors.white) : null,
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Hello,", style: TextStyle(fontSize: 16, color: Colors.brown)),
                      Text(activeProfile.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown)),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.help_outline, color: Colors.brown, size: 30),
                    onPressed: () => Navigator.pushNamed(context, '/intro'),
                  ),
                  const Icon(Icons.wb_sunny, color: Colors.orange, size: 30),
                ],
              ),

              const SizedBox(height: 20),

              // 2. PROGRESS CARD
              if (p.totalActivePecs > 0) _buildProgressCard(p),

              const SizedBox(height: 20),

              const Text("MY WORKSPACE:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 10),

              // 3. HUB BUTTONS
              // --- STACK ADDED HERE FOR THE BOUNCING ARROW ---
              Stack(
                clipBehavior: Clip.none,
                children: [
                  _hubButton(context, "MY MODULES", "Choose a task", Icons.menu_book, Colors.green[700]!, _onModuleClicked),
                  if (_showGuide)
                    const Positioned(
                      top: -35,
                      left: 20,
                      child: _BouncingArrow(),
                    ),
                ],
              ),
              
              _hubButton(context, "WORK BOARD", "Active table", Icons.view_column, Colors.blue[700]!, () => Navigator.pushNamed(context, '/kanban')),
              _hubButton(context, "CREATE NEW", "Scan tool", Icons.add_a_photo, Colors.orange[800]!, () => Navigator.pushNamed(context, '/scanner')),
              _hubButton(context, "HOW TO USE", "Watch the guide", Icons.play_circle_fill, Colors.purple[700]!, () => Navigator.pushNamed(context, '/intro')),

              const SizedBox(height: 20),

              // 4. LOCKED REWARDS SYSTEM
              _buildRewardRow(finishedCount),

              const SizedBox(height: 30),

              // 5. SWITCH USER
              Center(
                child: TextButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
                  icon: const Icon(Icons.logout, size: 20),
                  label: const Text("Switch Profile"),
                  style: TextButton.styleFrom(foregroundColor: Colors.brown),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(PecsProvider p) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Progress", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("${p.finishedPecsCount} / ${p.totalActivePecs} Done"),
            ],
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: p.currentStudentProgress,
            minHeight: 10,
            backgroundColor: Colors.grey[200],
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildRewardRow(int count) {
    List<String> rewards = ["cake.png", "candy.png", "cookie.png", "cake.png", "candy.png"];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("MY TREATS:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown)),
        const SizedBox(height: 10),
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.5), 
            borderRadius: BorderRadius.circular(15)
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, i) {
              bool isUnlocked = i < count;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: isUnlocked ? 1.0 : 0.1, 
                      child: Image.asset("assets/images/reward/${rewards[i]}", height: 50),
                    ),
                    const SizedBox(height: 5),
                    Icon(
                      isUnlocked ? Icons.check_circle : Icons.lock, 
                      size: 14, 
                      color: isUnlocked ? Colors.green : Colors.grey
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Modified _hubButton to accept a Function instead of a String route
  Widget _hubButton(BuildContext context, String title, String desc, IconData icon, Color col, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: col.withValues(alpha: 0.2), width: 2),
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: col),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: col)),
                Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

// Phase 2: Bouncing Arrow Widget
class _BouncingArrow extends StatefulWidget {
  const _BouncingArrow();

  @override
  State<_BouncingArrow> createState() => _BouncingArrowState();
}

class _BouncingArrowState extends State<_BouncingArrow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 600), vsync: this)..repeat(reverse: true);
    _animation = Tween<double>(begin: 0, end: 15).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Padding(
          padding: EdgeInsets.only(top: _animation.value),
          child: const Icon(Icons.arrow_downward_rounded, color: Colors.red, size: 40),
        );
      },
    );
  }
}