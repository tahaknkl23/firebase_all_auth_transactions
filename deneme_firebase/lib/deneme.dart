import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Deneme extends StatefulWidget {
  const Deneme({super.key});

  @override
  State<Deneme> createState() => _DenemeState();
}

class _DenemeState extends State<Deneme> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deneme'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Deneme'),
            ElevatedButton(
                onPressed: () async {
                  final deneme = await Dio().get("https://jsonplaceholder.typicode.com/posts");
                  debugPrint(deneme.data.toString());
                },
                child: const Text('Deneme')),
          ],
        ),
      ),
    );
  }
}
