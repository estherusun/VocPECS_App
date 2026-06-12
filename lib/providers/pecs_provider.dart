import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pecs_model.dart';
import '../models/initial_data.dart';

class PecsProvider with ChangeNotifier {
  PecsProvider() {
    _initPersistence();
  }

  // --- 1. STATE VARIABLES ---
  List<UserProfile> _profiles = [];
  String? _currentUser;
  List<PecsItem> _library = [];
  List<PecsTask> _taskAlbums = [];
  String? _activeModuleId;

  final Map<String, List<PecsItem>> _userBoards = {};
  final Map<String, List<String>> _userFinishedMedals = {};

  final List<Color> _availableColors = [
    Colors.blue, Colors.red, Colors.green, Colors.orange, Colors.purple, Colors.pink
  ];

  // --- 2. GETTERS ---
  List<UserProfile> get profiles => _profiles;
  String? get currentUser => _currentUser;
  List<PecsTask> get taskAlbums => _taskAlbums;
  List<PecsItem> get library => _library;

  List<PecsItem> get items => _userBoards[_currentUser] ?? [];
  int get completedModulesCount => _userFinishedMedals[_currentUser]?.length ?? 0;
  int get totalActivePecs => items.length;
  int get finishedPecsCount => items.where((i) => i.status == 'done' || i.status == 'reward').length;

  double get currentStudentProgress {
    if (_currentUser == null || totalActivePecs == 0) {
      return 0.0;
    }
    return finishedPecsCount / totalActivePecs;
  }

  // --- 3. SAVE & LOAD LOGIC ---
  Future<void> _initPersistence() async {
    final prefs = await SharedPreferences.getInstance();

    final String? profStr = prefs.getString('saved_profiles');
    if (profStr != null) {
      _profiles = (jsonDecode(profStr) as List).map((i) => UserProfile.fromJson(i)).toList();
    }

    final String? libStr = prefs.getString('saved_library');
    if (libStr != null) {
      _library = (jsonDecode(libStr) as List).map((i) => PecsItem.fromJson(i)).toList();
    }

    final String? albStr = prefs.getString('saved_albums');
    if (albStr != null) {
      _taskAlbums = (jsonDecode(albStr) as List).map((i) => PecsTask.fromJson(i)).toList();
    }

    _syncDefaultLibraryAndModules();

    final String? finishedStr = prefs.getString('user_finished_medals');
    if (finishedStr != null) {
      Map<String, dynamic> decoded = jsonDecode(finishedStr);
      decoded.forEach((key, value) {
        _userFinishedMedals[key] = List<String>.from(value);
      });
    }
    notifyListeners();
  }

  Future<void> _saveAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('saved_profiles', jsonEncode(_profiles.map((p) => p.toJson()).toList()));
    await prefs.setString('saved_library', jsonEncode(_library.map((l) => l.toJson()).toList()));
    await prefs.setString('saved_albums', jsonEncode(_taskAlbums.map((a) => a.toJson()).toList()));
    await prefs.setString('user_finished_medals', jsonEncode(_userFinishedMedals));
  }

  void _syncDefaultLibraryAndModules() {
    var seeds = InitialData.getSeedTasks();
    for (var seedTask in seeds) {
      if (!_taskAlbums.any((a) => a.taskName == seedTask.taskName)) {
        _taskAlbums.add(seedTask);
      }
      for (var item in seedTask.items) {
        if (!_library.any((l) => l.label == item.label)) {
          _library.add(item);
        }
      }
    }
    _saveAll();
  }

  // --- 4. LOGIC FUNCTIONS ---

  void addProfile(String name, File? img) {
    Color nextColor = _availableColors[_profiles.length % _availableColors.length];
    _profiles.add(UserProfile(id: DateTime.now().toString(), name: name, image: img, color: nextColor));
    _saveAll();
    notifyListeners();
  }

  void updateProfile(String id, String name, File? img) {
    int idx = _profiles.indexWhere((p) => p.id == id);
    if (idx != -1) {
      _profiles[idx].name = name;
      _profiles[idx].image = img;
      _saveAll();
      notifyListeners();
    }
  }

  // NEW: Delete profile logic moved inside class
  void deleteProfile(String id) {
    int idx = _profiles.indexWhere((p) => p.id == id);
    if (idx != -1) {
      final profileName = _profiles[idx].name;
      _userBoards.remove(profileName);
      _userFinishedMedals.remove(profileName);
      _profiles.removeAt(idx);
      _saveAll();
      notifyListeners();
    }
  }

  void updatePecsStatus(String id, String newStatus) {
    if (_currentUser == null) {
      return;
    }
    List<PecsItem> currentBoard = _userBoards[_currentUser!] ?? [];
    int idx = currentBoard.indexWhere((item) => item.id == id);
    if (idx != -1) {
      currentBoard[idx].status = newStatus;
      if (currentBoard.isNotEmpty && currentBoard.every((i) => i.status == 'done' || i.status == 'reward')) {
        for (var i in currentBoard) {
          i.status = 'reward';
        }
        if (_activeModuleId != null) {
          if (!(_userFinishedMedals[_currentUser!]?.contains(_activeModuleId) ?? false)) {
            _userFinishedMedals.putIfAbsent(_currentUser!, () => []).add(_activeModuleId!);
          }
        }
      }
      _saveAll();
      notifyListeners();
    }
  }

  void movePecs(String id) {
    if (_currentUser == null) {
      return;
    }
    List<PecsItem> currentBoard = _userBoards[_currentUser!] ?? [];
    int idx = currentBoard.indexWhere((item) => item.id == id);
    if (idx != -1) {
      String s = currentBoard[idx].status;
      if (s == 'material') {
        currentBoard[idx].status = 'todo';
      } else if (s == 'todo') {
        currentBoard[idx].status = 'doing';
      } else if (s == 'doing') {
        currentBoard[idx].status = 'done';
      }

      if (currentBoard.every((i) => i.status == 'done' || i.status == 'reward')) {
        for (var i in currentBoard) {
          i.status = 'reward';
        }
        if (_activeModuleId != null) {
          if (!(_userFinishedMedals[_currentUser!]?.contains(_activeModuleId) ?? false)) {
            _userFinishedMedals.putIfAbsent(_currentUser!, () => []).add(_activeModuleId!);
          }
        }
      }
      _saveAll();
      notifyListeners();
    }
  }

  void addPecs(File img, String l, String i) {
    _library.add(PecsItem(id: DateTime.now().toString(), label: l, imagePath: img.path, instruction: i, isAsset: false));
    _saveAll();
    notifyListeners();
  }

  void createTaskList(String n, List<PecsItem> s) {
    _taskAlbums.add(PecsTask(id: DateTime.now().toString(), taskName: n, items: List.from(s)));
    _saveAll();
    notifyListeners();
  }

  // NEW: Delete module logic moved inside class
  void deleteModule(String id) {
    _taskAlbums.removeWhere((album) => album.id == id);
    _saveAll();
    notifyListeners();
  }

  void selectUser(String name) {
    _currentUser = name;
    notifyListeners();
  }

  void startTask(PecsTask task) {
    if (_currentUser == null) {
      return;
    }
    _activeModuleId = task.id;
    _userBoards[_currentUser!] = task.items.map((i) => PecsItem(
      id: "${i.id}_act",
      label: i.label,
      imagePath: i.imagePath,
      isAsset: i.isAsset,
      instruction: i.instruction,
      status: 'material',
    )).toList();
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}