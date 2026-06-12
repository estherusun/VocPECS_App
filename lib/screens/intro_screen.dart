import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  bool _isAnswerRevealed = false;

  late YoutubePlayerController _kanbanController;
  late YoutubePlayerController _rewardController;

  @override
  void initState() {
    super.initState();
    
    // REPLACE WITH YOUR ACTUAL YOUTUBE IDs
     const String v1Id = 'xVdoxARjqVk'; 
     const String v2Id = '_rKK15KsR_g'; 

    _kanbanController = YoutubePlayerController(
      initialVideoId: v1Id,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );

    _rewardController = YoutubePlayerController(
      initialVideoId: v2Id,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  void dispose() {
    _kanbanController.dispose();
    _rewardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D2), 
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (i) => setState(() {
                  _currentPage = i;
                  _isAnswerRevealed = false;
                }),
                children: [
                  // SCREEN 1: Q&A
                  _buildScreen1(),

                  // SCREEN 2: SCANNER
                  _buildStepScreen(
                    "Create Custom Visuals",
                    "Snap a picture of any real-world tool.",
                    images: ["snap_tool.png", "hub_surface.jpg"],
                  ),

                  // SCREEN 3: LIBRARY
                  _buildStepScreen(
                    "Prepare the Lesson",
                    "Group your custom cards together.",
                    images: ["library_demo.jpeg"],
                  ),

                  // SCREEN 4: KANBAN (Video Only + Description)
                  _buildStepScreen(
                    "Guide the Execution",
                    "The student follows the visual board.",
                    videoDesc: "Watch how the student drags the tool into the 'Doing' column to see exactly what to do next.",
                    ytController: _kanbanController,
                  ),

                  // SCREEN 5: REWARD (Video Only + Description)
                  _buildStepScreen(
                    "Celebrate Success!",
                    "Digital wins unlock physical rewards.",
                    videoDesc: "Watch how finishing the task on the tablet leads to a real-world reward and success!",
                    ytController: _rewardController,
                  ),
                ],
              ),
            ),
            _buildNavigationRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildScreen1() {
    return GestureDetector(
      onTap: () => setState(() => _isAnswerRevealed = !_isAnswerRevealed),
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              _isAnswerRevealed 
                ? "assets/images/intro_part2.png" 
                : "assets/images/intro_part1.png",
              height: 400,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(height: 20),
            Text(
              _isAnswerRevealed ? "Tapping makes it clear!" : "Tap the bubble to find out!",
              style: const TextStyle(fontStyle: FontStyle.italic, color: Colors.brown),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepScreen(String title, String subtitle, {List<String>? images, String? videoDesc, YoutubePlayerController? ytController}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.brown)),
          const SizedBox(height: 8),
          Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: Colors.black54)),
          const SizedBox(height: 25),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // --- DISPLAY IMAGES (If any) ---
                  if (images != null)
                    for (var img in images)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset("assets/images/$img", fit: BoxFit.cover),
                        ),
                      ),
                  
                  // --- DISPLAY VIDEO DESCRIPTION CARD (For Screens 4 & 5) ---
                  if (videoDesc != null)
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.brown.withValues(alpha: 0.2)),
                      ),
                      child: Text(
                        videoDesc,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17, color: Colors.brown, height: 1.4),
                      ),
                    ),

                  // --- DISPLAY YOUTUBE PLAYER ---
                  if (ytController != null)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.brown.withValues(alpha: 0.3), width: 4),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: YoutubePlayer(
                          controller: ytController,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.brown,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(5, (index) => Container(
              margin: const EdgeInsets.all(4),
              width: _currentPage == index ? 24 : 10,
              height: 10,
              decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(5)),
            )),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            ),
            onPressed: () {
              if (_currentPage == 4) {
                Navigator.pop(context);
              } else {
                _controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
              }
            },
            child: Text(_currentPage == 4 ? "LET'S START" : "NEXT"),
          ),
        ],
      ),
    );
  }
}