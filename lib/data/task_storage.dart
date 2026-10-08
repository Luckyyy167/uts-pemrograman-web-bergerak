import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

/// Titik akses data tugas.
///
/// Starter memakai memori agar aplikasi dapat langsung dijalankan. Lengkapi
/// TODO 2 dengan SharedPreferences dan JSON; jangan memindahkan akses storage
/// ke widget.
class TaskStorage {
  TaskStorage({this.loadDelay = const Duration(milliseconds: 450)});

  static List<Task> _memory = <Task>[];

  final Duration loadDelay;

  Future<List<Task>> load({bool simulateError = false}) async {
    await Future<void>.delayed(loadDelay);
    if (simulateError) {
      throw const FormatException('Simulasi data tersimpan yang rusak.');
    }

    // TODO 2a: baca String JSON dari SharedPreferences lalu ubah menjadi
    // List<Task> dengan Task.fromJson. JSON rusak dapat menghasilkan
    // FormatException agar UI menampilkan state error.
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString('task');

    if (jsonString != null && jsonString.isNotEmpty) {
      final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
      _memory = decodedList
          .map((item) => Task.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      _memory = [];
    }

    return List<Task>.of(_memory);
  }

  Future<void> save(List<Task> tasks) async {
    // TODO 2b: encode seluruh daftar sebagai JSON String dan tulis melalui
    // SharedPreferences. Periksa nilai bool yang dikembalikan setString.
    _memory = List<Task>.of(tasks);
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(
      tasks.map((task) => task.toJson()).toList(),
    );

    final bool success = await prefs.setString('task', jsonString);
    if (!success) {
      throw const FormatException('Gagal menyimpan data tugas.');
    }
  }

  Future<void> clear() async {
    // TODO 2c: hapus key daftar tugas dari SharedPreferences.
    _memory = <Task>[];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('task');
  }

  /// Hanya untuk mengisolasi pengujian lokal.
  static void resetMemoryForTest() => _memory = <Task>[];
}
