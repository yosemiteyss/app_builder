import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';

part 'settings_event.dart';

part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc({
    required PreferencesRepository preferencesRepository,
  })  : _preferencesRepository = preferencesRepository,
        super(const SettingsState()) {
    on<OnLoadPreferences>(_onLoadPreferences);
    on<OnUpdateJavaHome>(_onUpdateJavaHome);
    on<OnUpdateAndroidHome>(_onUpdateAndroidHome);
    on<OnUpdateGradleTask>(_onUpdateGradleTask);
    on<OnUpdateStashChanges>(_onUpdateStashChanges);
    on<OnUpdateInstallBuild>(_onUpdateInstallBuild);
  }

  final PreferencesRepository _preferencesRepository;

  Future<void> _onLoadPreferences(
    OnLoadPreferences event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final preferences = await _preferencesRepository.getPreferences();
      emit(state.copyWith(preferences: preferences));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateJavaHome(
    OnUpdateJavaHome event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final directory = await getDirectoryPath(
        initialDirectory: state.preferences.javaHome,
      );
      if (directory != null) {
        final updatedPrefs = state.preferences.copyWith(javaHome: directory);
        emit(state.copyWith(preferences: updatedPrefs));
        await _preferencesRepository.savePreferences(updatedPrefs);
      }
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateAndroidHome(
    OnUpdateAndroidHome event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final directory = await getDirectoryPath(
        initialDirectory: state.preferences.androidHome,
      );
      if (directory != null) {
        final updatedPrefs = state.preferences.copyWith(androidHome: directory);
        emit(state.copyWith(preferences: updatedPrefs));
        await _preferencesRepository.savePreferences(updatedPrefs);
      }
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateGradleTask(
    OnUpdateGradleTask event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final updatedPrefs = state.preferences.copyWith(
        gradleTask: event.gradleTask,
      );
      emit(state.copyWith(preferences: updatedPrefs));
      await _preferencesRepository.savePreferences(updatedPrefs);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateStashChanges(
    OnUpdateStashChanges event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final updatedPrefs = state.preferences.copyWith(
        isStashChanges: event.isStashChanges,
      );
      emit(state.copyWith(preferences: updatedPrefs));
      await _preferencesRepository.savePreferences(updatedPrefs);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUpdateInstallBuild(
    OnUpdateInstallBuild event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      final updatedPrefs = state.preferences.copyWith(
        isInstallBuild: event.isInstallBuild,
      );
      emit(state.copyWith(preferences: updatedPrefs));
      await _preferencesRepository.savePreferences(updatedPrefs);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }
}
