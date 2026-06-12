import 'dart:io';
import 'package:flutter/material.dart';

class PecsItem {
  final String id;
  final String label;
  final String imagePath;
  final bool isAsset;
  final String instruction;
  String status; 

  PecsItem({
    required this.id, required this.label, required this.imagePath, 
    this.isAsset = false, this.instruction = "Follow the picture.", this.status = 'material',
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'label': label, 'imagePath': imagePath,
    'isAsset': isAsset, 'instruction': instruction, 'status': status,
  };

  factory PecsItem.fromJson(Map<String, dynamic> json) => PecsItem(
    id: json['id'], label: json['label'], imagePath: json['imagePath'],
    isAsset: json['isAsset'] ?? false, instruction: json['instruction'] ?? "", status: json['status'] ?? 'material',
  );
}

class UserProfile {
  final String id;
  String name;
  File? image;
  final Color color;
  UserProfile({required this.id, required this.name, this.image, required this.color});

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'imagePath': image?.path, 
    'color': color.toARGB32(), // FIXED: New way to save colors
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: json['id'], name: json['name'],
    image: json['imagePath'] != null ? File(json['imagePath']) : null,
    color: Color(json['color']),
  );
}

class PecsTask {
  final String id;
  final String taskName;
  final List<PecsItem> items;
  PecsTask({required this.id, required this.taskName, required this.items});

  Map<String, dynamic> toJson() => {
    'id': id, 'taskName': taskName, 'items': items.map((i) => i.toJson()).toList(),
  };

  factory PecsTask.fromJson(Map<String, dynamic> json) => PecsTask(
    id: json['id'], taskName: json['taskName'],
    items: (json['items'] as List).map((i) => PecsItem.fromJson(i)).toList(),
  );
}