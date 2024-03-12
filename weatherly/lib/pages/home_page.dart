import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recase/recase.dart';
import 'package:weatherly/features/weather/weather_app.dart';
import 'package:weatherly/pages/search_page.dart';
import 'package:weatherly/widgets/error_dialog.dart';
import '../features/temp_settings/temp_settings_app.dart';
import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _city = 'Colombo'; // Set the default city to Colombo

  @override
  void initState() {
    super.initState();
    // Fetch weather data for Colombo when the widget is initialized
    context.read<WeatherCubit>().fetchWeather(_city);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(13, 44, 60, 1), // Set background colour for Appbar
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white, size: 30), // Set color to white and increase size
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const SettingsPage();
                    },
                  ),
                );
              },
            ),
            const Spacer(), // Use Spacer to push the title to the center
            const Text('Weatherly', style: TextStyle(color: Colors.white)), // Set color to white
            const Spacer(), // Use Spacer to push the title to the center
            IconButton(
              onPressed: () async {
                _city = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchPage(),
                  ),
                );

                print('city->$_city');
                context.read<WeatherCubit>().fetchWeather(_city);
              },
              icon: const Icon(Icons.search, color: Colors.white, size: 32),  // Set color to white and increase size
            ),
          ],
        ),
      ),
      body: _showWeather(),
      backgroundColor: const Color.fromARGB(255, 9, 81, 112), // Set background colour
    );
  }

  String showTemperature(double temperature) {
    final tempUnit = context.watch<TempSettingsCubit>().state.tempUnit;

    if (tempUnit == TempUnit.fahrenheit) {
      return '${((temperature * 9 / 5) + 32).toStringAsFixed(2)}℉'; // Convert celcius to faranheit
    }

    return '${temperature.toStringAsFixed(2)}℃';
  }

  Widget showIcon() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        String weatherDescription = state.weather.description;

        Map<String, String> weatherIconMapping = {
          'clear sky': 'default.png',
          'few clouds': 'default.png',
          'scattered clouds': '7.png',
          'mist': '5.png',
          'fog': '5.png',
          'light rain': '2.png',
          'moderate rain': '3.png',
          'rain': '3.png',
          'heavy rain': '3.png',
          'light snow': '4.png',
          'moderate snow': '4.png',
          'heavy snow': '4.png',
          'thunderstorm': '1.png',
          'drizzle': '2.png',
          'light intensity drizzle': '2.png',
          'freezing rain': '4.png',
          'snow shower': '4.png',
          'thunderstorm with rain': '1.png',
          'thunderstorm with snow': '4.png',
          'hail': '4.png',
          'sunny': '6.png',
          'partly cloudy': 'default.png',
          'mostly clear': 'default.png',
          'blizzard': '9.png',
          'tornado': '9.png',
          'hurricane': '9.png',
          'snow flurries': '4.png',
          'overcast clouds': '7.png',
          'broken clouds': '7.png',
          'haze': '5.png',
          'snow': '4.png',
        }; // Different weather state icons (There may be some that are not here)

        String mappedIcon = weatherIconMapping[weatherDescription] ?? 'default.png';
        String iconPath = 'assets/$mappedIcon';

        return Image.asset(
          iconPath,
          width: 210, // Set weather icon size
          height: 210,
        );
      },
    );
  }

  Widget formatText(String description) {
    final formattedString = description.titleCase;
    return Text(
      formattedString,
      style: const TextStyle(fontSize: 24.0),
      textAlign: TextAlign.center,
    );
  }

  Widget _showWeather() {
    return BlocConsumer<WeatherCubit, WeatherState>(
      listener: (context, state) {
        if (state.status == WeatherStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == WeatherStatus.initial) {
          return const Center(
            child: Text(
              'Select a city', // Default text if not connected
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          );
        }

        if (state.status == WeatherStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == WeatherStatus.error && state.weather.name == '') {
          return const Center(
            child: Text(
              'Select a city',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          );
        }

        return ListView(
          children: [
            const SizedBox(height: 48),
            Text(
              textAlign: TextAlign.center,
              state.weather.name,
              style: const TextStyle(
                  fontSize: 41.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  TimeOfDay.fromDateTime(state.weather.lastUpdated)
                      .format(context),
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
                const SizedBox(width: 10.0),
                Text(
                  '(${state.weather.country})',
                  style: const TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 54.0),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      showTemperature(state.weather.temp), // Display current tempreture
                      style: const TextStyle(
                          fontSize: 56.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                      ),
                    ),
                  ],
                ),
              ],
            ), // current tempreture row
            const SizedBox(height: 40.0),

            //Start Min, Max Row

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/min.png',
                          width: 46,
                          height: 46,
                        ),
                        const SizedBox(width: 40.0),
                        const Text(
                          '           Temp Min',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            '          '+showTemperature(state.weather.tempMin), // Min tempreture
                            style: const TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),


                //start max
                const SizedBox(width: 82.0),
                Column(
                  children: [
                    Stack(
                      children: [
                        Image.asset(
                          'assets/max.png',
                          width: 46,
                          height: 46,
                        ),
                        const Text(
                          '          Temp Max',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.white),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Text(
                            '          '+showTemperature(state.weather.tempMax), // Maximum tempreture
                            style: const TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

           //End of the Min, Max Row

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showIcon(),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    state.weather.description, // Display weather state
                    style: const TextStyle( fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center),
                ),
              ],
            ),

          ],
        );
      },
    );
  }
}
