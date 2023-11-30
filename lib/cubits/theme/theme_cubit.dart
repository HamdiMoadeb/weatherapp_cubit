import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final WeatherCubit weatherCubit;
  late final StreamSubscription weatherSubscription;

  ThemeCubit({required this.weatherCubit}) : super(ThemeState.initial()) {
    weatherSubscription =
        weatherCubit.stream.listen((WeatherState weatherState) {
      print(weatherState);

      if (weatherState.weather.temp > kWarmOrNot) {
        emit(state.copyWith(appTheme: AppTheme.sun));
      } else if (weatherState.weather.temp < kSnowOrNot) {
        emit(state.copyWith(appTheme: AppTheme.snow));
      } else {
        emit(state.copyWith(appTheme: AppTheme.cool));
      }
    });
  }

  @override
  Future<void> close() {
    weatherSubscription.cancel();
    return super.close();
  }
}
