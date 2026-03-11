import 'package:dogapi/services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:dogapi/models/dog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  Dog? dog;
  bool isLoading = true;

  Future<void> _loadDog() async {
    setState(() {
      isLoading = true;
    });

    final data = await _apiService.getRandomDogs();

    setState(() {
      dog = data;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadDog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Random Dog Image'), centerTitle: true),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (dog != null)
                    Image.network(
                      dog!.message,
                      height: 300,
                      width: 300,
                      fit: BoxFit.cover,
                    ),
                  SizedBox(height: 20),

                  Text(
                    'Status : ${dog?.status ?? ''}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blue),
                      elevation: MaterialStateProperty.all(4),
                    ),
                    onPressed: _loadDog,
                    child: const Text(
                      'Relode Image?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
