import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final formKey = GlobalKey<FormState>();
  String? city;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void submit() {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = formKey.currentState;

    if (form != null && form.validate()) {
      form.save();
      Navigator.pop(context, city!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Search', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(13, 44, 60, 1), // Appbar background colour
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 9, 81, 112), // Background colour under scroll view
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 9, 81, 112), // Background colour in scroll view
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60.0),
                Form(
                  key: formKey,
                  autovalidateMode: autovalidateMode,
                  child: TextFormField(
                    autofocus: true,
                    style: const TextStyle(fontSize: 20.0, color: Color.fromARGB(255, 255, 255, 255)),
                    decoration: InputDecoration(
                      hintText: 'Enter city name',
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white),
                      hintStyle: const TextStyle(color: Color.fromARGB(255, 133, 150, 156)), // Place hint
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white), // Border colour
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.white),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (String? input) {
                      if (input == null || input.trim().length < 2) {
                        return 'City name must be at least 2 characters long'; // Error msg
                      }
                      return null;
                    },
                    onSaved: (String? input) {
                      city = input;
                    },
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton( // Search button
                  onPressed: submit,
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(13, 44, 60, 1),
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                  ),
                  child: const Text(
                    "Weather status",
                    style: TextStyle(
                      fontSize: 19.0,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Image.asset(
                  'assets/searchclip.png',
                  width: 380.0,  // Search page image size
                  height: 380.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
