import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/temp_settings/temp_settings_app.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(13, 44, 60, 1), // Appbar background
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 9, 81, 112), // Body background
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20.0),
              const Text(
                'Temperature Unit',
                style: TextStyle(color: Colors.white, fontSize: 27.0), // Tempreture unit font size and colour
              ),
              const SizedBox(height: 40.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/fara.png',
                    width: 56.0, // Faranheit image size
                    height: 56.0,
                  ),
                  const SizedBox(width: 25.0),
                  Switch(
                    value: context.watch<TempSettingsCubit>().state.tempUnit == TempUnit.celsius,
                    onChanged: (_) {
                      context.read<TempSettingsCubit>().toggleTempUnit();
                    },
                    activeColor: const Color.fromRGBO(13, 44, 60, 1),
                  ),
                  const SizedBox(width: 22.0),
                  Image.asset(
                    'assets/cels.png',
                    width: 56.0, // Celcius image size
                    height: 56.0,
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Image.asset(
                'assets/settingsclip.png',
                width: 380.0, // Setting page main image size
                height: 380.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

