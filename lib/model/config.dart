import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'config.g.dart';

@JsonSerializable()
class Config extends Equatable {
  const Config({
    this.javaHome,
    this.androidHome,
    this.gradleTask,
    this.stashChanges = true,
    this.installBuild = true,
  });

  factory Config.fromJson(Map<String, dynamic> json) => _$ConfigFromJson(json);

  @JsonKey(name: 'java_home')
  final String? javaHome;

  @JsonKey(name: 'android_home')
  final String? androidHome;

  @JsonKey(name: 'gradle_task')
  final String? gradleTask;

  @JsonKey(name: 'stash_changes')
  final bool stashChanges;

  @JsonKey(name: 'install_build')
  final bool installBuild;

  Map<String, dynamic> toJson() => _$ConfigToJson(this);

  Config copyWith({
    String? javaHome,
    String? androidHome,
    String? gradleTask,
    bool? stashChanges,
    bool? installBuild,
  }) {
    return Config(
      javaHome: javaHome ?? this.javaHome,
      androidHome: androidHome ?? this.androidHome,
      gradleTask: gradleTask ?? this.gradleTask,
      stashChanges: stashChanges ?? this.stashChanges,
      installBuild: installBuild ?? this.installBuild,
    );
  }

  @override
  List<Object?> get props => [
        javaHome,
        androidHome,
        gradleTask,
        stashChanges,
        installBuild,
      ];
}
