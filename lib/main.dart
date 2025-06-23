// NAMA : MUHAMMAD ROBBI FIRMANSYAH
// NIM : 230441100163
// KELAS : PEMBER A
// ASPRAK : MUHAMMAD ROSYID MAULANA


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keungan/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Keuangan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(), 
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
