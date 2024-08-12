import 'package:app_builder/module/builder/cli/adb_service.dart';
import 'package:app_builder/module/common/model/package.dart';
import 'package:app_builder/module/preference/preference_service.dart';
import 'package:app_builder/module/task/model/task_state.dart';
import 'package:app_builder/module/tools/bloc/tools_event.dart';
import 'package:app_builder/module/tools/model/tools_state.dart';
import 'package:app_builder/utils/string_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ToolsBloc extends Bloc<ToolsEvent, ToolsState> {
  ToolsBloc(this._preferenceService) : super(const ToolsState()) {
    on<OnToolsInit>(_onToolsInit);
    on<OnAddUninstallPackage>(_onAddUninstallPackage);
    on<OnRemoveUninstallPackage>(_onRemoveUninstallPackage);
    on<OnUninstallPackages>(_onUninstallPackages);
    on<OnSetDeviceId>(_onSetDeviceId);
    on<OnRefreshDevices>(_onRefreshDevices);
  }

  final PreferenceService _preferenceService;

  Future<void> _onToolsInit(OnToolsInit event, Emitter<ToolsState> emit) async {
    final packages = await _getUninstallPackages();
    final deviceIds = await _getDeviceIds();

    emit(
      state.copyWith(
        packages: packages,
        deviceIds: deviceIds,
        selectedDeviceId: deviceIds.firstOrNull,
      ),
    );
  }

  Future<void> _onAddUninstallPackage(
    OnAddUninstallPackage event,
    Emitter<ToolsState> emit,
  ) async {
    final packageName = event.packageName;
    if (!packageName.isBlank) {
      final package = Package(name: packageName, state: TaskState.idle());
      final packages = [...state.packages, package];

      emit(state.copyWith(packages: packages));

      await _preferenceService.saveUninstallPackages(
        packages.map((e) => e.name).whereNotNull().toList(),
      );
    }
  }

  Future<void> _onRemoveUninstallPackage(
    OnRemoveUninstallPackage event,
    Emitter<ToolsState> emit,
  ) async {
    final packages = state.packages.toList()..remove(event.package);

    emit(state.copyWith(packages: packages));

    await _preferenceService.saveUninstallPackages(
      packages.map((e) => e.name).whereNotNull().toList(),
    );
  }

  Future<void> _onUninstallPackages(
    OnUninstallPackages event,
    Emitter<ToolsState> emit,
  ) async {
    final deviceId = state.selectedDeviceId;
    if (deviceId == null) {
      return;
    }

    final adb = await AdbService.createAsync(_preferenceService);
    final packages = state.packages
        .map((e) => e.copyWith(state: TaskState.ongoing(null)))
        .toList();

    emit(state.copyWith(packages: packages));

    final futures = state.packages.map((package) async {
      final success = await adb.uninstall(package.name, deviceId);
      return package.copyWith(
        state: success ? TaskState.success(null) : TaskState.error(null),
      );
    });

    emit(state.copyWith(packages: await Future.wait(futures)));
  }

  void _onSetDeviceId(OnSetDeviceId event, Emitter<ToolsState> emit) {
    emit(state.copyWith(selectedDeviceId: event.deviceId));
  }

  Future<void> _onRefreshDevices(
    OnRefreshDevices event,
    Emitter<ToolsState> emit,
  ) async {
    final deviceIds = await _getDeviceIds();

    emit(
      state.copyWith(
        deviceIds: deviceIds,
        selectedDeviceId: deviceIds.firstOrNull,
      ),
    );
  }

  Future<List<Package>> _getUninstallPackages() async {
    final packages = await _preferenceService.getUninstallPackages();
    return packages
        .map((e) => Package(name: e, state: TaskState.idle()))
        .toList();
  }

  Future<List<String>> _getDeviceIds() async {
    final adb = await AdbService.createAsync(_preferenceService);
    return adb.getDevices();
  }
}
