import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'preferences.g.dart';

/// {@template preferences}
/// User preferences data.
/// {@endtemplate}
@JsonSerializable()
class Preferences extends Equatable {
  /// {@macro preferences}
  const Preferences({
    this.javaHome,
    this.androidHome,
    this.gradleTask,
    this.isStashChanges = true,
    this.isInstallBuild = true,
  });

  /// Convert JSON to [Preferences].
  factory Preferences.fromJson(Map<String, dynamic> json) =>
      _$PreferencesFromJson(json);

  /// Directory of JAVA_HOME.
  @JsonKey(name: 'java_home')
  final String? javaHome;

  /// Directory of ANDROID_HOME.
  @JsonKey(name: 'android_home')
  final String? androidHome;

  /// The default gradle task name.
  @JsonKey(name: 'gradle_task')
  final String? gradleTask;

  /// Whether to stash existing changes before task build.
  @JsonKey(name: 'stash_changes')
  final bool isStashChanges;

  /// Whether to install build after task build.
  @JsonKey(name: 'install_build')
  final bool isInstallBuild;

  /// Convert [Preferences] to JSON.
  Map<String, dynamic> toJson() => _$PreferencesToJson(this);

  /// Create a copy of [Preferences].
  Preferences copyWith({
    String? javaHome,
    String? androidHome,
    String? gradleTask,
    bool? isStashChanges,
    bool? isInstallBuild,
  }) {
    return Preferences(
      javaHome: javaHome ?? this.javaHome,
      androidHome: androidHome ?? this.androidHome,
      gradleTask: gradleTask ?? this.gradleTask,
      isStashChanges: isStashChanges ?? this.isStashChanges,
      isInstallBuild: isInstallBuild ?? this.isInstallBuild,
    );
  }

  @override
  List<Object?> get props => [
        javaHome,
        androidHome,
        gradleTask,
        isStashChanges,
        isInstallBuild,
      ];
}
