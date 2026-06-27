import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pecs_provider.dart';
import '../models/pecs_model.dart';

class AlbumLibraryScreen extends StatelessWidget {
  const AlbumLibraryScreen({super.key});

  void _confirmDelete(BuildContext context, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF1E6D2),
        title: const Text("Delete Module?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("CANCEL")),
          ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red), onPressed: () { onConfirm(); Navigator.pop(context); }, child: const Text("DELETE", style: TextStyle(color: Colors.white)))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Provider.of<PecsProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF1E6D2),
      appBar: AppBar(
        title: const Text("MODULE LIBRARY", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.brown, fontSize: 20)), 
        backgroundColor: const Color(0xFFF1E6D2),
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.brown), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: GestureDetector(
              onTap: () => _showCreateSheet(context, p),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(color: Colors.brown, borderRadius: BorderRadius.circular(15)),
                child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.add_circle_outline, color: Colors.white), SizedBox(width: 10), Text("CREATE NEW MODULE", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))]),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: p.taskAlbums.length,
              itemBuilder: (context, i) {
                final album = p.taskAlbums[i];
                // ENTIRE CARD IS GESTURE DETECTOR
                return GestureDetector(
                  onTap: () {
                    p.startTask(album);
                    Navigator.pushNamed(context, '/kanban');
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.brown.withValues(alpha: 0.1), width: 2)),
                    child: Row(
                      children: [
                        const Icon(Icons.folder_open_rounded, color: Colors.amber, size: 30),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(album.taskName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text("${album.items.length} steps • Tap to start", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                          onPressed: () => _confirmDelete(context, () => p.deleteModule(album.id)),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateSheet(BuildContext context, PecsProvider p) {
    final ctrl = TextEditingController();
    List<PecsItem> selected = [];
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: const Color(0xFFF1E6D2),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setS) => Container(
          padding: const EdgeInsets.all(25), height: MediaQuery.of(context).size.height * 0.85,
          child: Column(
            children: [
              const Text("Build New Module", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown)),
              const SizedBox(height: 15),
              TextField(controller: ctrl, decoration: InputDecoration(labelText: "Module Name", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 8, crossAxisSpacing: 8),
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
                      child: Container(
                        decoration: BoxDecoration(color: isS ? Colors.blue[50] : Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: isS ? Colors.blue : Colors.black12)),
                        child: Column(children: [
                          Expanded(child: ClipRRect(borderRadius: const BorderRadius.vertical(top: Radius.circular(9)), child: item.isAsset ? Image.asset(item.imagePath, fit: BoxFit.cover) : Image.file(File(item.imagePath), fit: BoxFit.cover))),
                          Text(item.label, style: const TextStyle(fontSize: 9), maxLines: 1),
                        ]),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  if (ctrl.text.isNotEmpty && selected.length >= 2) {
                    p.createTaskList(ctrl.text, selected);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter name and select 2+ items")));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 50)),
                child: const Text("SAVE MODULE"),
              )
            ],
          ),
        ),
      ),
    );
  }
}