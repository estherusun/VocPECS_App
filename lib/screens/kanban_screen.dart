import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:confetti/confetti.dart';
import '../providers/pecs_provider.dart';
import '../models/pecs_model.dart';

class KanbanScreen extends StatefulWidget {
  const KanbanScreen({super.key});
  @override
  State<KanbanScreen> createState() => _KanbanScreenState();
}

class _KanbanScreenState extends State<KanbanScreen> {
  late ConfettiController _ctrl;
  
  @override
  void initState() { 
    super.initState(); 
    _ctrl = ConfettiController(duration: const Duration(seconds: 3)); 
  }
  
  @override
  void dispose() { 
    _ctrl.dispose(); 
    super.dispose(); 
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PecsProvider>(context);
    
    if (p.items.isNotEmpty && p.items.every((i) => i.status == 'reward')) {
      _ctrl.play();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D2),
      appBar: AppBar(
        title: const Text("Work Table", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown)), 
        backgroundColor: const Color(0xFFF1E6D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _col(context, "TOOLS", "material", p),
                _col(context, "TO DO", "todo", p),
                _col(context, "DOING", "doing", p),
                _col(context, "DONE", "done", p),
                _col(context, "REWARD", "reward", p, isR: true),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter, 
            child: ConfettiWidget(
              confettiController: _ctrl, 
              blastDirectionality: BlastDirectionality.explosive,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.amber],
            )
          ),
        ],
      ),
    );
  }

  // UPDATED: Added statusKey and Provider to the column
  Widget _col(BuildContext context, String t, String statusKey, PecsProvider p, {bool isR = false}) {
    List<PecsItem> items = p.items.where((i) => i.status == statusKey).toList();

    return DragTarget<PecsItem>(
      // Logic to accept the dropped card
      onAcceptWithDetails: (details) {
        p.updatePecsStatus(details.data.id, statusKey);
        // If dropped in DOING, show popup immediately
        if (statusKey == 'doing') {
          _showDoingPopup(context, details.data);
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: 180, 
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            // Highlights the column slightly when dragging over it
            color: candidateData.isNotEmpty ? Colors.green.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.3), 
            borderRadius: BorderRadius.circular(15), 
            border: Border.all(color: Colors.black12)
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(15), 
                decoration: const BoxDecoration(
                  color: Color(0xFFA8C686), 
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15))
                ), 
                child: Center(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)))
              ),
              
              if (isR) 
                Expanded(
                  child: items.isEmpty 
                    ? const SizedBox() 
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("assets/images/reward/cake.png", height: 100),
                          const SizedBox(height: 10),
                          const Text("SYABAS!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.brown)),
                          const Text("MODUL SELESAI", style: TextStyle(fontSize: 12, color: Colors.brown)),
                        ],
                      ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(10), 
                    itemCount: items.length, 
                    itemBuilder: (context, i) => _card(context, items[i]),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _card(BuildContext context, PecsItem item) {
    // We define the UI once so we can use it for 'child' and 'feedback'
    Widget cardUI = Card(
      color: Colors.white, 
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: item.isAsset 
                ? Image.asset(item.imagePath, height: 80, width: double.infinity, fit: BoxFit.cover) 
                : Image.file(File(item.imagePath), height: 80, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(
              item.label, 
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)
            ),
          ],
        ),
      ),
    );

    // NEW: Wrapped in Draggable
    return LongPressDraggable<PecsItem>(
      data: item,
      // What it looks like while being dragged
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 160, child: Opacity(opacity: 0.8, child: cardUI)),
      ),
      // What is left behind in the column
      childWhenDragging: Opacity(opacity: 0.3, child: cardUI),
      // Normal state: If tapped, still show popup if in DOING
      child: GestureDetector(
        onTap: () {
          if (item.status == 'doing') {
            _showDoingPopup(context, item);
          }
        },
        child: cardUI,
      ),
    );
  }

  void _showDoingPopup(BuildContext context, PecsItem item) {
    showDialog(
      context: context, 
      barrierDismissible: false, 
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF1E6D2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(item.label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min, 
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: item.isAsset 
                ? Image.asset(item.imagePath, height: 180, fit: BoxFit.cover) 
                : Image.file(File(item.imagePath), height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 15),
            Text(
              item.instruction, 
              textAlign: TextAlign.center, 
              style: const TextStyle(fontSize: 18)
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () { 
              Provider.of<PecsProvider>(context, listen: false).updatePecsStatus(item.id, 'done'); 
              Navigator.pop(context); 
            }, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green, 
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ), 
            child: const Text("FINISHED ✅", style: TextStyle(color: Colors.white, fontSize: 18))
          )
        ],
      ),
    );
  }
}