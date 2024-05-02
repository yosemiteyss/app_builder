import 'dart:convert';

import 'package:app_builder/model/config.dart';
import 'package:app_builder/model/task.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService {
  const PreferenceService();

  Future<Config?> getConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('env');

    if (json != null) {
      return Config.fromJson(jsonDecode(json));
    } else {
      return null;
    }
  }

  Future<void> saveConfig(Config env) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(env.toJson());
    await prefs.setString('env', json);
  }

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString('tasks');

    if (json != null) {
      final List<dynamic> jsonList = jsonDecode(json);
      // ignore: unnecessary_lambdas
      return List<Task>.from(jsonList.map((e) => Task.fromJson(e)));
    } else {
      return const [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(tasks.map((e) => e.toJson()).toList()).toString();
    await prefs.setString('tasks', json);
  }

  Future<List<String>> getUninstallPackages() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('uninstall_pkgs') ?? const [];
  }

  Future<void> saveUninstallPackages(List<String> packages) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('uninstall_pkgs', packages);
  }
}
