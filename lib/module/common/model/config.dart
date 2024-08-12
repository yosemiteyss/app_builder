import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config extends Equatable {
  const Config({
    this.javaHome,
    this.androidHome,
    this.gradleTask,
    this.isStashChanges = true,
    this.isInstallBuild = true,
  });

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  @JsonKey(name: 'java_home')
  final String? javaHome;

  @JsonKey(name: 'android_home')
  final String? androidHome;

  @JsonKey(name: 'gradle_task')
  final String? gradleTask;

  @JsonKey(name: 'stash_changes')
  final bool isStashChanges;

  @JsonKey(name: 'install_build')
  final bool isInstallBuild;

  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  Config copyWith({
    String? javaHome,
    String? androidHome,
    String? gradleTask,
    bool? isStashChanges,
    bool? isInstallBuild,
  }) {
    return Config(
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
