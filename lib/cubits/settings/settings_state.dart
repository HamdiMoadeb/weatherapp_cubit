part of 'settings_cubit.dart';

enum TempUnit {
  celsius,
  fahrenheit,
}

class SettingsState extends Equatable{
  final TempUnit tempUnit;

  SettingsState({
    required this.tempUnit,
  });

  factory SettingsState.initial(){
    return SettingsState(tempUnit: TempUnit.celsius);
  }

  @override
  String toString() {
    return 'SettingsState{tempUnit: $tempUnit}';
  }

  @override
  List<Object> get props => [tempUnit];

  SettingsState copyWith({
    TempUnit? tempUnit,
  }) {
    return SettingsState(
      tempUnit: tempUnit ?? this.tempUnit,
    );
  }
}