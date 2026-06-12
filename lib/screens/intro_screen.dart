import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:confetti/confetti.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  late ConfettiController _confettiController;
  int _currentPage = 0;

  // Interaction States
  bool _isAnswerRevealed = false;
  bool _practice1Done = false;
  bool _practice2Done = false;

  late YoutubePlayerController _kanbanController;
  late YoutubePlayerController _rewardController;

  // Exact path for your assets
  final String folder = "assets/images/basic_example/Module 1 Germination/";

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    
    _kanbanController = YoutubePlayerController(
      initialVideoId: 'xVdoxARjqVk', // Simulation Part 1
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
    _rewardController = YoutubePlayerController(
      initialVideoId: '_rKK15KsR_g', // Simulation Part 2 (Reward)
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _kanbanController.dispose();
    _rewardController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showPracticeReward() {
    _confettiController.play();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF1E6D2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset("assets/images/reward/cake.png", height: 120),
            const SizedBox(height: 20),
            const Text("BRILLIANT!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.brown, fontStyle: FontStyle.italic)),
            const Text("You earned a treat!", style: TextStyle(fontSize: 18, color: Colors.brown)),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
              onPressed: () => Navigator.pop(context),
              child: const Text("I UNDERSTAND ✅", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D2), 
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    children: [
                      _step1Welcome(),
                      _step2Creation(),
                      _step3Library(),
                      _step4Practice1(), // Drag Seed -> DOING
                      _step5Video1(),    // Execution Video
                      _step6Practice2(), // Drag Soil Tray -> DONE
                      _step7Video2(),    // Reward Video (Part 2)
                      _step8Final(),     // Final Ready Slide
                    ],
                  ),
                ),
                _buildFooterNav(),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
            ),
          ),
        ],
      ),
    );
  }

  // --- STEP 1: WELCOME ---
  Widget _step1Welcome() {
    return GestureDetector(
      onTap: () => setState(() => _isAnswerRevealed = true),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("WELCOME TO VocPECS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.brown)),
          Image.asset(_isAnswerRevealed ? "assets/images/intro_part2.png" : "assets/images/intro_part1.png", height: 400, fit: BoxFit.contain),
          Text(_isAnswerRevealed ? "Perfect! Press Next." : "Tap the bubble to find out", style: const TextStyle(color: Colors.brown, fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

  // --- STEP 4 & 6: DRAG PRACTICE (MAINTAIN PEC IN COLUMN) ---
  Widget _dragPractice(String title, String sub, String imgPath, String targetLabel, bool isDone, Function(bool) onDone) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.brown)),
        Text(sub),
        const SizedBox(height: 60),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Left Side: Draggable (Hidden if Done)
            if (!isDone) 
              Draggable<int>(
                data: 1,
                feedback: _buildPecsCard(imgPath, targetLabel),
                childWhenDragging: Opacity(opacity: 0.2, child: _buildPecsCard(imgPath, targetLabel)),
                child: _buildPecsCard(imgPath, "HOLD & DRAG"),
              ) 
            else const SizedBox(width: 130, height: 160),

            const Icon(Icons.arrow_forward_rounded, size: 40, color: Colors.brown),

            // Right Side: Target (Shows Card if Done)
            DragTarget<int>(
              onAcceptWithDetails: (details) => onDone(true),
              builder: (context, candidate, rejected) => Container(
                height: 190, width: 140,
                decoration: BoxDecoration(
                  color: candidate.isNotEmpty ? Colors.green.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.brown, width: 2),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity, padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(color: Color(0xFFA8C686), borderRadius: BorderRadius.vertical(top: Radius.circular(18))),
                      child: Text(targetLabel, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    Expanded(
                      child: isDone 
                        ? Padding(padding: const EdgeInsets.all(5), child: _buildPecsCard(imgPath, "SIAP!")) // MAINTAIN PEC IN COLUMN
                        : const Center(child: Icon(Icons.download_rounded, color: Colors.brown, size: 30)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // --- SLIDE BUILDERS ---
  Widget _step2Creation() => _imageStep("1. Create PECS", "Snap photos of your tools.", ["snap_tool.png", "hub_surface.jpg"]);
  Widget _step3Library() => _imageStep("2. Build Module", "Pick your cards to make a lesson.", ["library_demo.jpeg"]);
  Widget _step4Practice1() => _dragPractice("Practice: Start Work", "Drag the SEED into DOING.", "${folder}seed.png", "DOING", _practice1Done, (val) => setState(() => _practice1Done = val));
  Widget _step5Video1() => _videoStep("How to Work", "Watch the student move the cards.", _kanbanController);
  Widget _step6Practice2() => _dragPractice("Practice: Finish Task", "Move the SOIL TRAY to DONE.", "${folder}soil_tray.png", "DONE", _practice2Done, (val) { setState(() => _practice2Done = val); _showPracticeReward(); });
  Widget _step7Video2() => _videoStep("Success Reward", "Watch the real-world reward.", _rewardController);
  Widget _step8Final() => const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.check_circle, size: 100, color: Colors.green), SizedBox(height: 20), Text("YOU ARE READY!", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.brown)), Padding(padding: EdgeInsets.all(30), child: Text("You have mastered the controls.\nLet's start gardening!", textAlign: TextAlign.center, style: TextStyle(fontSize: 18)))]);

  // --- REUSABLE UI HELPERS ---
  Widget _imageStep(String title, String sub, List<String> imgs) => Padding(padding: const EdgeInsets.all(20), child: Column(children: [Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.brown)), Text(sub), const SizedBox(height: 20), Expanded(child: ListView(children: imgs.map((path) => Container(margin: const EdgeInsets.only(bottom: 15), decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white, width: 4)), child: ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.asset("assets/images/$path", fit: BoxFit.cover)))).toList()))]));
  Widget _videoStep(String title, String sub, YoutubePlayerController ctrl) => Column(mainAxisAlignment: MainAxisAlignment.center, children: [Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.brown)), Text(sub), const SizedBox(height: 20), Container(margin: const EdgeInsets.symmetric(horizontal: 20), decoration: BoxDecoration(border: Border.all(color: Colors.brown, width: 3), borderRadius: BorderRadius.circular(20)), child: ClipRRect(borderRadius: BorderRadius.circular(17), child: YoutubePlayer(controller: ctrl, showVideoProgressIndicator: true)))]);
  Widget _buildPecsCard(String path, String label) => Container(width: 110, height: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.black12), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5)]), child: Column(children: [Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(15)), child: path.startsWith('assets') ? Image.asset(path, fit: BoxFit.cover) : Image.file(File(path), fit: BoxFit.cover))), Padding(padding: const EdgeInsets.all(5.0), child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10)))],));

  Widget _buildFooterNav() {
    bool canProceed = false;
    if (_currentPage == 0) {
      canProceed = _isAnswerRevealed;
    } else if ([1, 2, 4, 6, 7].contains(_currentPage)) canProceed = true;
    else if (_currentPage == 3) canProceed = _practice1Done;
    else if (_currentPage == 5) canProceed = _practice2Done;

    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(8, (i) => Container(margin: const EdgeInsets.all(4), width: _currentPage == i ? 18 : 8, height: 8, decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(4))))),
          const SizedBox(height: 20),
          if (canProceed)
            SizedBox(
              width: double.infinity, height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                onPressed: () { if (_currentPage == 7) {
                  Navigator.pop(context);
                } else {
                  _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                } },
                child: Text(_currentPage == 7 ? "START NOW" : "NEXT STEP", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            )
          else
            const SizedBox(height: 65, child: Center(child: Text("Finish interaction to continue", style: TextStyle(color: Colors.brown, fontStyle: FontStyle.italic)))),
        ],
      ),
    );
  }
}