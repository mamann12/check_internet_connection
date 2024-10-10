import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Check internet Connection',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Check Internet Connection'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late bool isConnected;

  final Connectivity _connectivity = Connectivity();

  StreamSubscription<ConnectivityResult>? _connctivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //set nilai awal status konesi internet sebagai (Terhubung)
    isConnected = true;

// memanggil fungsi pengecekan koneksi internet dan mendengarkan perubahan koneksi setelah selesai
    _initConnectionStatus().then((_) {
      _connctivitySubscription =
          _connectivity.onConnectivityChanged.listen((result) {
        setState(() {
          isConnected = result != ConnectivityResult.none;
        });
      }) as StreamSubscription<ConnectivityResult>?;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // batalkan langganan saat widget dihancurkan untuk menghilangkan kebocoran memori
    _connctivitySubscription?.cancel();
  }

  // fungsi untuk memeriksa status koneksi internet saat pertama kali saat aplikasi dijalankan
  Future<void> _initConnectionStatus() async {
    final result = await _connectivity.checkConnectivity();
    setState(() {
      //perbarui status koneksi berdasarkan hasil pengecekan
      isConnected = result != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: Image.asset(
            isConnected ? 'assets/connected.png' : 'assets/disconnected.png',
            key: ValueKey<bool>(isConnected),
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
