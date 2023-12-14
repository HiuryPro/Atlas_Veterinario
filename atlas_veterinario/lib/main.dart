import 'package:atlas_veterinario/DadosDB/supa.dart';
import 'package:atlas_veterinario/Fala/textoprafala.dart';
import 'package:atlas_veterinario/Proxy/proxypagina.dart';
import 'package:atlas_veterinario/Utils/app_controller.dart';
import 'package:atlas_veterinario/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  try {
    await dotenv.load(fileName: 'assets/.env');
    await SupaDB.instance.iniciaSupabase();
    List paginas = await SupaDB.instance.clienteSupaBase
        .from('Pagina')
        .select(
          '*',
        )
        .order('IdPagina', ascending: false);

    await ProxyPagina.instance.findFull(false);
    print(paginas[0]['IdPagina']);

    AppController.instance.totalPaginas = paginas[0]['IdPagina'];
    runApp(const AppWidget());
    await Fala.instance.initTts();
  } catch (e) {
    print(e);
  }
}
