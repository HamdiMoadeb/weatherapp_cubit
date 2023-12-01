import 'package:geolocator/geolocator.dart';
import '../exceptions/location_exceptions.dart';
import '../models/custom_error.dart';
import '../models/weather.dart';
import '../services/weather_api_services.dart';

class LocationRepository {
  final WeatherApiServices weatherApiServices;

  LocationRepository({required this.weatherApiServices});

  Future<Weather> fetchWeatherWithLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw LocationException('Location services are disabled. Please make sure you enable GPS and try again');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw LocationException('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw LocationException(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      Position currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      print(currentPosition);

      final Weather weather = await weatherApiServices.getWeather(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      return weather;
    } on LocationException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
