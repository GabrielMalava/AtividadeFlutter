import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/service/abstract_api.dart';

class Transacao {
  final String id;
  final String nome;
  final double valor;

  Transacao({required this.id, required this.nome, required this.valor});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'valor': valor,
    };
  }
}

class TransacaoService extends AbstractApi<Transacao> {
  final String baseUrl = 'http://localhost:3000/transacoes';

  @override
  Future<List<Transacao>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Transacao(
          id: json['id'],
          nome: json['nome'],
          valor: json['valor'],
        )).toList();
      } else {
        throw Exception('Falha ao carregar transações: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar transações: $e');
    }
  }

  @override
  Future<Transacao> fetchById(String id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200) {
        final json1 = json.decode(response.body);
        return Transacao(
          id: json1['id'],
          nome: json1['nome'],
          valor: json1['valor'],
        );
      } else {
        throw Exception('Falha ao carregar transação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar transação: $e');
    }
  }

@override
Future<Transacao> create(Transacao item) async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'nome': item.nome,
      'valor': item.valor,
    }),
  );

  if (response.statusCode == 201) {
    final json1 = json.decode(response.body);
    return Transacao(
      id: json1['id'],
      nome: json1['nome'],
      valor: json1['valor'],
    );
  } else {
    throw Exception('Falha ao criar transação: ${response.statusCode}');
  }
}

  @override
  Future<Transacao> update(Transacao item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/${item.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(item.toJson()),
      );

      if (response.statusCode == 200) {
        final json1 = json.decode(response.body);
        return Transacao(
          id: json1['id'],
          nome: json1['nome'],
          valor: json1['valor'],
        );
      } else {
        throw Exception('Falha ao atualizar transação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao atualizar transação: $e');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Falha ao excluir transação: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao excluir transação: $e');
    }
  }
}
