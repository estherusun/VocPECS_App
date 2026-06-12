import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/pecs_provider.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});
  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  File? _image;
  final _labelCtrl = TextEditingController();
  final _instrCtrl = TextEditingController();

  Future<void> _getImage(ImageSource source) async {
    final x = await ImagePicker().pickImage(source: source, imageQuality: 70);
    if (x != null) setState(() => _image = File(x.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Make New PECS"), backgroundColor: const Color(0xFFF1E6D2)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. CLEAR PREVIEW
            Container(
              height: 250, width: double.infinity,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.brown)),
              child: _image == null 
                ? const Icon(Icons.camera_enhance, size: 80, color: Colors.grey) 
                : ClipRRect(borderRadius: BorderRadius.circular(18), child: Image.file(_image!, fit: BoxFit.cover)),
            ),
            const SizedBox(height: 20),

            // 2. INPUT SOURCE
            Row(
              children: [
                Expanded(child: ElevatedButton.icon(onPressed: () => _getImage(ImageSource.camera), icon: const Icon(Icons.camera_alt), label: const Text("CAMERA"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[800], foregroundColor: Colors.white))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton.icon(onPressed: () => _getImage(ImageSource.gallery), icon: const Icon(Icons.photo_library), label: const Text("GALLERY"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green[800], foregroundColor: Colors.white))),
              ],
            ),
            const SizedBox(height: 30),

            // 3. PECS DETAILS
            if (_image != null) ...[
              TextField(controller: _labelCtrl, decoration: const InputDecoration(labelText: "Object Name (e.g. My Shovel)", filled: true, fillColor: Colors.white)),
              const SizedBox(height: 15),
              TextField(controller: _instrCtrl, decoration: const InputDecoration(labelText: "Description (Optional)", filled: true, fillColor: Colors.white)),
              const SizedBox(height: 30),
              
              // 4. JUST SAVE (No Tray required)
              ElevatedButton(
                onPressed: () {
                  if (_labelCtrl.text.isNotEmpty) {
                    Provider.of<PecsProvider>(context, listen: false).addPecs(_image!, _labelCtrl.text, _instrCtrl.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("PECS saved to your library!")));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 60)),
                child: const Text("SAVE TO LIBRARY", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}