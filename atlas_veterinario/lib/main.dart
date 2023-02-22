import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: 'assets/.env');
  await SupaDB.instance.iniciaSupabase();
  runApp(const AppWidget());
}
