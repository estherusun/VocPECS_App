import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pecs_provider.dart';
import '../models/pecs_model.dart';

class AlbumLibraryScreen extends StatelessWidget {
  const AlbumLibraryScreen({super.key});

  // --- HELPER: CONFIRM DELETE DIALOG ---
  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF1E6D2),
        title: const Text("Delete Module?"),
        content: const Text("This will permanently remove this module."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            child: const Text("DELETE", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PecsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D2), // Cream
      appBar: AppBar(
        title: const Text("MODULE LIBRARY", 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 20)), 
        backgroundColor: const Color(0xFFF1E6D2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // 1. CREATE MODULE BUTTON
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: _createButton(context, p),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("SAVED MODULES:", 
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 14)),
            ),
          ),

          // 2. LIST OF MODULES
          Expanded(
            child: p.taskAlbums.isEmpty 
              ? const Center(child: Text("No modules yet. Build one!", style: TextStyle(color: Colors.brown)))
              : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: p.taskAlbums.length,
                itemBuilder: (context, i) {
                  final album = p.taskAlbums[i];
                  return _moduleCard(context, album, p);
                },
              ),
          ),
        ],
      ),
    );
  }

  Widget _createButton(BuildContext context, PecsProvider p) {
    return GestureDetector(
      onTap: () => _showCreateSheet(context, p),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 5)],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text("CREATE NEW MODULE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _moduleCard(BuildContext context, PecsTask album, PecsProvider p) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.brown.withValues(alpha: 0.1), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.folder_rounded, color: Colors.amber, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: GestureDetector(
              onTap: () {
                p.startTask(album);
                Navigator.pushNamed(context, '/kanban');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(album.taskName, 
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text("${album.items.length} steps • Tap to start", 
                    style: const TextStyle(fontSize: 11, color: Colors.black54)),
                ],
              ),
            ),
          ),
          // DELETE BUTTON
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, () => p.deleteModule(album.id)),
          ),
          const Icon(Icons.chevron_right, color: Colors.brown, size: 20),
        ],
      ),
    );
  }

  void _showCreateSheet(BuildContext context, PecsProvider p) {
    final ctrl = TextEditingController();
    List<PecsItem> selected = [];

    showModalBottomSheet(
      context: context, 
      isScrollControlled: true, 
      backgroundColor: const Color(0xFFF1E6D2),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setS) => Container(
          padding: const EdgeInsets.all(25), 
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              const Text("New Module", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 15),
              TextField(
                controller: ctrl, 
                decoration: InputDecoration(
                  labelText: "Module Name",
                  filled: true, fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 15),
              const Text("Select items in order (min 2):", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8), 
                  itemCount: p.library.length, 
                  itemBuilder: (context, i) {
                    final item = p.library[i];
                    bool isS = selected.contains(item);
                    return GestureDetector(
                      onTap: () => setS(() { if (isS) {
                        selected.remove(item);
                      } else {
                        selected.add(item);
                      } }),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: isS ? Colors.blue[50] : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: isS ? Colors.blue : Colors.black12),
                            ),
                            child: Column(
                              children: [
                                Expanded(child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(9)),
                                  child: item.isAsset 
                                    ? Image.asset(item.imagePath, fit: BoxFit.cover, width: double.infinity) 
                                    : Image.file(File(item.imagePath), fit: BoxFit.cover, width: double.infinity)
                                )),
                                Text(item.label, style: const TextStyle(fontSize: 9), maxLines: 1),
                              ],
                            ),
                          ),
                          // SHOW SEQUENCE NUMBER
                          if (isS)
                            Positioned(
                              top: 5, right: 5,
                              child: CircleAvatar(
                                radius: 10, backgroundColor: Colors.blue,
                                child: Text("${selected.indexOf(item) + 1}", 
                                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () { 
                  if (ctrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please name your module!")));
                  } else if (selected.length < 2) {
                    // SV FEEDBACK FIX: Clear response when button clicked
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Pick at least 2 items to build a workflow."))
                    );
                  } else {
                    p.createTaskList(ctrl.text, selected); 
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New Module Saved!")));
                  } 
                }, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown, 
                  foregroundColor: Colors.white, 
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text("SAVE MODULE")
              )
            ],
          ),
        ),
      ),
    );
  }
}