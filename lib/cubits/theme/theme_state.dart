part of 'theme_cubit.dart';

enum AppTheme {
  cool,
  sun,
  snow,
}

class ThemeState extends Equatable{

  final AppTheme appTheme;

  ThemeState({
    this.appTheme = AppTheme.cool,
  });

  factory ThemeState.initial(){
    return ThemeState();
  }

  @override
  String toString() {
    return 'ThemeState{appTheme: $appTheme}';
  }

  ThemeState copyWith({
    AppTheme? appTheme,
  }) {
    return ThemeState(
      appTheme: appTheme ?? this.appTheme,
    );
  }

  @override
  List<Object> get props => [appTheme];
}