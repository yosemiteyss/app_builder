// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Config _$ConfigFromJson(Map<String, dynamic> json) => Config(
      javaHome: json['java_home'] as String?,
      androidHome: json['android_home'] as String?,
      gradleTask: json['gradle_task'] as String?,
      isStashChanges: json['stash_changes'] as bool? ?? true,
      isInstallBuild: json['install_build'] as bool? ?? true,
    );

Map<String, dynamic> _$ConfigToJson(Config instance) => <String, dynamic>{
      'java_home': instance.javaHome,
      'android_home': instance.androidHome,
      'gradle_task': instance.gradleTask,
      'stash_changes': instance.isStashChanges,
      'install_build': instance.isInstallBuild,
    };
