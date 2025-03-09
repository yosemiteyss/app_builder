part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  const SettingsState({
    this.preferences = const Preferences(),
  });

  final Preferences preferences;

  SettingsState copyWith({Preferences? preferences}) {
    return SettingsState(
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [preferences];
}
