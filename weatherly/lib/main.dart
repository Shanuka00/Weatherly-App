import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:weatherly/features/weather/weather_app.dart';
import 'package:weatherly/services/weather_api_services.dart';
import 'features/temp_settings/temp_settings_app.dart';
import 'pages/splash_screen.dart';
import 'repositories/weather_repository.dart';
import 'package:http/http.dart' as http;

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => WeatherRepository(
        weatherApiServices: WeatherApiServices(httpClient: http.Client()),
      ),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<WeatherCubit>(
            create: (context) => WeatherCubit(
              weatherRepository: context.read<WeatherRepository>(),
            ),
          ),
          BlocProvider<TempSettingsCubit>(
            create: (context) => TempSettingsCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'weatherly',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue, // Default shades colour
          ),
          home: const Splash(), // Call to splash page
        ),
      ),
    );
  }
}
