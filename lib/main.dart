import 'package:flutter/material.dart';
import 'pages/menu_list_page.dart';
import 'pages/menu_detail_page.dart';
import 'pages/order_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFE86F32);
    return MaterialApp(
      title: 'Kantin Bu Sari',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: orange),
        scaffoldBackgroundColor: const Color(0xFFFFFBF7),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFFFBF7),
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE9E0D8)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE9E0D8)),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const MenuListPage(),
        '/detail': (_) => const MenuDetailPage(),
        '/pesan': (_) => const OrderPage(),
      },
    );
  }
}
