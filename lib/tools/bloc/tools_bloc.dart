import 'package:app_builder/utils/string_ext.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:preferences_repository/preferences_repository.dart';
import 'package:task_builder/task_builder.dart';
import 'package:task_repository/task_repository.dart';

part 'tools_event.dart';

part 'tools_state.dart';

class ToolsBloc extends Bloc<ToolsEvent, ToolsState> {
  ToolsBloc({
    required PreferencesRepository preferencesRepository,
  })  : _preferencesRepository = preferencesRepository,
        super(const ToolsState()) {
    on<OnToolsInit>(_onToolsInit);
    on<OnAddUninstallPackage>(_onAddUninstallPackage);
    on<OnRemoveUninstallPackage>(_onRemoveUninstallPackage);
    on<OnUninstallPackages>(_onUninstallPackages);
  }

  final PreferencesRepository _preferencesRepository;

  Future<void> _onToolsInit(
    OnToolsInit event,
    Emitter<ToolsState> emit,
  ) async {
    try {
      final uninstallPackages = await _getUninstallPackages();
      emit(state.copyWith(uninstallPackages: uninstallPackages));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onAddUninstallPackage(
    OnAddUninstallPackage event,
    Emitter<ToolsState> emit,
  ) async {
    try {
      final packageName = event.packageName;
      if (!packageName.isBlank) {
        final package = Package(name: packageName, state: const IdleState());
        final updatedPackages = [...state.uninstallPackages, package];

        emit(state.copyWith(uninstallPackages: updatedPackages));

        final packageNames =
            updatedPackages.map((e) => e.name).nonNulls.toList();
        await _preferencesRepository.saveUninstallPackages(packageNames);
      }
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onRemoveUninstallPackage(
    OnRemoveUninstallPackage event,
    Emitter<ToolsState> emit,
  ) async {
    try {
      final updatedPackages = state.uninstallPackages.toList()
        ..remove(event.package);

      emit(state.copyWith(uninstallPackages: updatedPackages));

      final packageNames = updatedPackages.map((e) => e.name).nonNulls.toList();
      await _preferencesRepository.saveUninstallPackages(packageNames);
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<void> _onUninstallPackages(
    OnUninstallPackages event,
    Emitter<ToolsState> emit,
  ) async {
    try {
      final deviceId = event.deviceId;
      if (deviceId == null) {
        return;
      }

      final preferences = await _preferencesRepository.getPreferences();
      final adb = await AdbService.createAsync(
        androidHome: preferences.androidHome,
      );

      final uninstallPackages = state.uninstallPackages
          .map((e) => e.copyWith(state: const OngoingState(null)))
          .toList();

      emit(state.copyWith(uninstallPackages: uninstallPackages));

      final futures = state.uninstallPackages.map((package) async {
        final isSuccess = await adb.uninstall(
          package: package.name,
          deviceId: deviceId,
        );
        return package.copyWith(
          state: isSuccess ? const SuccessState(null) : const ErrorState(null),
        );
      });

      emit(state.copyWith(uninstallPackages: await Future.wait(futures)));
    } on Exception catch (error, stackTrace) {
      addError(error, stackTrace);
    }
  }

  Future<List<Package>> _getUninstallPackages() async {
    final packages = await _preferencesRepository.getUninstallPackages();
    return packages
        .map((package) => Package(name: package, state: const IdleState()))
        .toList();
  }
}
