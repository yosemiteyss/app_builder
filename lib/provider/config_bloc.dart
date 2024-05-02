import 'dart:async';

import 'package:app_builder/model/config.dart';
import 'package:app_builder/provider/config_event.dart';
import 'package:app_builder/service/preference_service.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfigBloc extends Bloc<ConfigEvent, Config> {
  ConfigBloc(this._preferenceService) : super(const Config()) {
    on<OnConfigInit>(_onConfigInit);
    on<OnSetJavaHome>(_onSetJavaHome);
    on<OnSetAndroidHome>(_onSetAndroidHome);
    on<OnSetGradleTask>(_onSetGradleTask);
    on<OnSetStashChanges>(_onSetStashChanges);
    on<OnSetInstallBuild>(_onSetInstallBuild);
  }

  final PreferenceService _preferenceService;

  Future<void> _onConfigInit(OnConfigInit event, Emitter<Config> emit) async {
    final config = await _preferenceService.getConfig();
    if (config != null) {
      emit(config);
      await _preferenceService.saveConfig(state);
    }
  }

  Future<void> _onSetJavaHome(
      OnSetJavaHome event, Emitter<Config> emit) async {
    final directory = await getDirectoryPath();
    if (directory != null) {
      emit(state.copyWith(androidHome: directory));
      await _preferenceService.saveConfig(state);
    }
  }

  Future<void> _onSetAndroidHome(
      OnSetAndroidHome event, Emitter<Config> emit) async {
    final directory = await getDirectoryPath();
    if (directory != null) {
      emit(state.copyWith(androidHome: directory));
      await _preferenceService.saveConfig(state);
    }
  }

  Future<void> _onSetGradleTask(
      OnSetGradleTask event, Emitter<Config> emit) async {
    emit(state.copyWith(gradleTask: event.gradleTask));
    await _preferenceService.saveConfig(state);
  }

  Future<void> _onSetStashChanges(
      OnSetStashChanges event, Emitter<Config> emit) async {
    emit(state.copyWith(stashChanges: event.stashChanges));
    await _preferenceService.saveConfig(state);
  }

  Future<void> _onSetInstallBuild(
      OnSetInstallBuild event, Emitter<Config> emit) async {
    emit(state.copyWith(installBuild: event.installBuild));
    await _preferenceService.saveConfig(state);
  }
}
