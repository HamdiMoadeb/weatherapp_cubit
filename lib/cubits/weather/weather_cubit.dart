import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_app/models/custom_error.dart';
import 'package:weather_app/repositories/location_repository.dart';

import '../../models/weather.dart';
import '../../repositories/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository weatherRepository;
  final LocationRepository locationRepository;

  WeatherCubit({
    required this.weatherRepository,
    required this.locationRepository,
  }) : super(WeatherState.initial());

  Future<void> fetchWeather(String city) async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final Weather weather = await weatherRepository.fetchWeather(city);

      emit(state.copyWith(
        status: WeatherStatus.loaded,
        weather: weather,
      ));
      print(state);
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        error: e,
      ));
      print(state);
    }
  }

  Future<void> fetchWeatherUsingLocation() async {
    emit(state.copyWith(status: WeatherStatus.loading));

    try {
      final Weather weather =
          await locationRepository.fetchWeatherWithLocation();

      emit(state.copyWith(status: WeatherStatus.loaded, weather: weather));
      print(state);
    } on CustomError catch (e) {
      emit(state.copyWith(
        status: WeatherStatus.error,
        error: e,
      ));
      print(state);
    }
  }
}
