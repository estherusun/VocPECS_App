import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/pecs_provider.dart';
import '../models/pecs_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // --- NEW FEATURE: CONFIRMATION DIALOG ---
  void _confirmDeleteProfile(BuildContext context, PecsProvider p, UserProfile user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF1E6D2), // Maintain Cream Theme
        title: const Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${user.name}'s profile and all their progress? This cannot be undone."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close confirmation
            child: const Text("CANCEL"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              p.deleteProfile(user.id);
              Navigator.pop(context); // Close confirmation
              Navigator.pop(context); // Close main edit dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("${user.name} has been removed."))
              );
            },
            child: const Text("YES, DELETE EVERYTHING", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- FUNCTION: SHOW ADD/EDIT DIALOG (Maintained) ---
  void _showProfileDialog(BuildContext context, {UserProfile? existingUser}) {
    final TextEditingController nameController =
        TextEditingController(text: existingUser?.name ?? "");
    File? selectedImage = existingUser?.image;
    final ImagePicker picker = ImagePicker();
    final p = Provider.of<PecsProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: Text(existingUser == null ? "Add Child" : "Edit Profile"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: existingUser?.color ?? Colors.grey[300],
                      backgroundImage: selectedImage != null ? FileImage(selectedImage!) : null,
                      child: selectedImage == null
                          ? const Icon(Icons.person, size: 40, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.blue),
                          onPressed: () async {
                            final XFile? photo = await picker.pickImage(source: ImageSource.camera);
                            if (photo != null) setDialogState(() => selectedImage = File(photo.path));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.photo_library, color: Colors.green),
                          onPressed: () async {
                            final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
                            if (photo != null) setDialogState(() => selectedImage = File(photo.path));
                          },
                        ),
                      ],
                    ),
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration: const InputDecoration(labelText: "Child's Name"),
                    ),
                  ],
                ),
              ),
              actions: [
                // --- DELETE BUTTON TRIGGERS CONFIRMATION ---
                if (existingUser != null)
                  TextButton(
                    onPressed: () => _confirmDeleteProfile(context, p, existingUser),
                    child: const Text("DELETE", style: TextStyle(color: Colors.red)),
                  ),
                
                TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      if (existingUser == null) {
                        p.addProfile(nameController.text, selectedImage);
                      } else {
                        p.updateProfile(existingUser.id, nameController.text, selectedImage);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pecsProvider = Provider.of<PecsProvider>(context);
    final profiles = pecsProvider.profiles;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              "Who is working?",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tap to enter, Hold to edit",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 160,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                  childAspectRatio: 1.0,
                ),
                itemCount: profiles.length + 1,
                itemBuilder: (context, index) {
                  if (index == profiles.length) {
                    return _buildAddButton(context, isDarkMode);
                  }
                  return _buildProfileCard(context, profiles[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, UserProfile user) {
    return GestureDetector(
      onTap: () {
        Provider.of<PecsProvider>(context, listen: false).selectUser(user.name);
        Navigator.pushReplacementNamed(context, '/home');
      },
      onLongPress: () => _showProfileDialog(context, existingUser: user),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: user.color,
                borderRadius: BorderRadius.circular(12),
                image: user.image != null
                    ? DecorationImage(image: FileImage(user.image!), fit: BoxFit.cover)
                    : null,
              ),
              child: user.image == null
                  ? const Center(child: Icon(Icons.person, size: 60, color: Colors.white))
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton(BuildContext context, bool isDarkMode) {
    return GestureDetector(
      onTap: () => _showProfileDialog(context),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.add_circle_outline,
                size: 50,
                color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Add Child",
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}