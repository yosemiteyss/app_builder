import 'dart:async';

import 'package:app_builder/module/common/model/config.dart';
import 'package:app_builder/module/preference/preference_service.dart';
import 'package:app_builder/module/settings/settings_event.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsBloc extends Bloc<SettingsEvent, Config> {
  SettingsBloc(this._preferenceService) : super(const Config()) {
    on<OnSettingsInit>(_onSettingsInit);
    on<OnUpdateJavaHome>(_onUpdateJavaHome);
    on<OnUpdateAndroidHome>(_onUpdateAndroidHome);
    on<OnUpdateGradleTask>(_onUpdateGradleTask);
    on<OnUpdateStashChanges>(_onUpdateStashChanges);
    on<OnUpdateInstallBuild>(_onUpdateInstallBuild);
  }

  final PreferenceService _preferenceService;

  Future<void> _onSettingsInit(OnSettingsInit event, Emitter<Config> emit) async {
    final config = await _preferenceService.getConfig();
    if (config != null) {
      emit(config);
      await _preferenceService.saveConfig(state);
    }
  }

  Future<void> _onUpdateJavaHome(
      OnUpdateJavaHome event, Emitter<Config> emit) async {
    final directory = await getDirectoryPath();
    if (directory != null) {
      emit(state.copyWith(javaHome: directory));
      await _preferenceService.saveConfig(state);
    }
  }

  Future<void> _onUpdateAndroidHome(
      OnUpdateAndroidHome event, Emitter<Config> emit) async {
    final directory = await getDirectoryPath();
    if (directory != null) {
      emit(state.copyWith(androidHome: directory));
      await _preferenceService.saveConfig(state);
    }
  }

  Future<void> _onUpdateGradleTask(
      OnUpdateGradleTask event, Emitter<Config> emit) async {
    emit(state.copyWith(gradleTask: event.gradleTask));
    await _preferenceService.saveConfig(state);
  }

  Future<void> _onUpdateStashChanges(
      OnUpdateStashChanges event, Emitter<Config> emit) async {
    emit(state.copyWith(isStashChanges: event.isStashChanges));
    await _preferenceService.saveConfig(state);
  }

  Future<void> _onUpdateInstallBuild(
      OnUpdateInstallBuild event, Emitter<Config> emit) async {
    emit(state.copyWith(isInstallBuild: event.installBuild));
    await _preferenceService.saveConfig(state);
  }
}
