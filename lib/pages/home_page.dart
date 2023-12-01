import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:weather_app/constants/constants.dart';
import 'package:weather_app/cubits/settings/settings_cubit.dart';
import 'package:weather_app/cubits/theme/theme_cubit.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/pages/search_page.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/widgets/error_dialog.dart';
import 'package:weather_app/widgets/weather_placeholder.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? city;

  @override
  void initState() {
    super.initState();

    context.read<WeatherCubit>().fetchWeatherUsingLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            getBackgroundImagePath(),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  context.read<WeatherCubit>().fetchWeatherUsingLocation();
                },
                icon: Icon(
                  Icons.location_on_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () async {
                    city = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(),
                      ),
                    );
                    print('city: $city');
                    if (city != null) {
                      context.read<WeatherCubit>().fetchWeather(city!);
                    }
                  },
                  icon: Icon(
                    Icons.search,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: showWeather(),
          ),
        ),
      ],
    );
  }

  String getBackgroundImagePath() {
    final AppTheme appTheme = context.watch<ThemeCubit>().state.appTheme;

    switch (appTheme) {
      case AppTheme.cool:
        return 'assets/images/cool.jpg';
      case AppTheme.sun:
        return 'assets/images/sun.jpg';
      case AppTheme.snow:
        return 'assets/images/snow.jpg';
      default:
        return 'assets/images/cool.jpg';
    }
  }

  String showTemperature(double temp) {
    final tempUnit = context.watch<SettingsCubit>().state.tempUnit;
    if (tempUnit == TempUnit.fahrenheit) {
      return ((temp * 9 / 5) + 32).toStringAsFixed(2) + ' ℉';
    }
    return temp.toStringAsFixed(2) + ' ℃';
  }

  Widget showIcon(String icon) {
    return FadeInImage.assetNetwork(
      placeholder: 'assets/images/loading.gif',
      image: 'http://$kIconHost/img/wn/$icon@4x.png',
      width: 96,
      height: 96,
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(
          fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.w500),
      textAlign: TextAlign.center,
    );
  }

  Widget showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return weatherPlaceholder();
        }
        if (state.status == WeatherStatus.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          ));
        }
        if (state.status == WeatherStatus.error && state.weather.name.isEmpty) {
          return weatherPlaceholder();
        }
        return ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 6,
            ),
            Text(
              state.weather.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10.0),
                Text(
                  '(${state.weather.country})',
                  style: const TextStyle(
                    fontSize: 22.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  showTemperature(state.weather.temp),
                  style: const TextStyle(
                    fontSize: 38.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 25.0),
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.tempMax),
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      showTemperature(state.weather.tempMin),
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Spacer(),
                showIcon(state.weather.icon),
                Expanded(
                  flex: 4,
                  child: formatText(state.weather.description),
                ),
                Spacer(),
              ],
            )
          ],
        );
      },
    );
  }
}
