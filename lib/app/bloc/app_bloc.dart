import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:task_builder/task_builder.dart';

part 'app_event.dart';

part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required PreferencesRepository preferencesRepository,
  })  : _preferencesRepository = preferencesRepository,
        super(const AppState()) {
    on<OnUpdateDeviceId>(_onUpdateDeviceId);
    on<OnRefreshDevices>(_onRefreshDevices);
  }

  final PreferencesRepository _preferencesRepository;

  void _onUpdateDeviceId(
    OnUpdateDeviceId event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(selectedDeviceId: event.deviceId));
  }

  Future<void> _onRefreshDevices(
    OnRefreshDevices event,
    Emitter<AppState> emit,
  ) async {
    try {
      final deviceIds = await _getDeviceIds();

      emit(
        state.copyWith(
          deviceIds: deviceIds,
          selectedDeviceId: deviceIds.firstOrNull,
        ),
      );
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<List<String>> _getDeviceIds() async {
    final preferences = await _preferencesRepository.getPreferences();
    final adb = await AdbService.createAsync(
      androidHome: preferences.androidHome,
    );
    return adb.getDevices();
  }
}
