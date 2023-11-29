import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/cubits/weather/weather_cubit.dart';
import 'package:weather_app/pages/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? city;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Weather App',
          style: TextStyle(color: Colors.white),
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
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: showWeather(),
    );
  }

  Widget showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        if (state.status == WeatherStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == WeatherStatus.error && state.weather.name.isEmpty) {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        return Center(
          child: Text(
            state.weather.name,
            style: TextStyle(fontSize: 18.0),
          ),
        );
      },
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(state.error.errMsg),
                );
              });
        }
      },
    );
  }
}
