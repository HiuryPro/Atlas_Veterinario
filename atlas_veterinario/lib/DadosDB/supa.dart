import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase/supabase.dart';

class SupaDB {
  static SupaDB instance = SupaDB();
  late SupabaseClient clienteSupaBase;

  iniciaSupabase() async {
    clienteSupaBase = SupabaseClient(
        dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_KEY']!);
  }

  select(
      String tabela, String select, Map where, String order, bool asc) async {
    return await clienteSupaBase
        .from(tabela)
        .select(select)
        .match(where)
        .order(order, ascending: asc);
  }

  insert(String tabela, Map insert) async {
    try {
      return await clienteSupaBase.from(tabela).insert(insert).select();
    } on PostgrestException catch (e) {
      print(e);
      return null;
    }
  }
}
