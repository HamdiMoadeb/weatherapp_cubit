import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/cubits/settings/settings_cubit.dart';
import 'package:weather_app/cubits/theme/theme_cubit.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/pages/home_page.dart';
import 'package:weather_app/repositories/weather_repository.dart';
import 'package:weather_app/services/weather_api_services.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
          weatherApiServices: WeatherApiServices(
        httpClient: http.Client(),
      )),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
                weatherRepository: context.read<WeatherRepository>()),
          ),
          BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit(),
          ),
          BlocProvider<ThemeCubit>(
            create: (context) => ThemeCubit(
              weatherCubit: context.read<WeatherCubit>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Weather App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: HomePage(),
        ),
      ),
    );
  }
}
