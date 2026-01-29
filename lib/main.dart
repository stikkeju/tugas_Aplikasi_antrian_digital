import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/queue_provider.dart';
import 'pages/login_page.dart';

import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  if (Platform.isWindows || Platform.isLinux) {
    // Inisialisasi FFI buat Windows/Linux
    sqfliteFfiInit();

    // Ganti factory database default
    databaseFactory = databaseFactoryFfi;
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => QueueProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red, // Tema warna merah khas Mixue
          appBarTheme: AppBarTheme(
            backgroundColor: Color(0xFFE80013),
            foregroundColor: Colors.white,
          ),
        ),
        home: LoginPage(),
      ),
    );
  }
}
