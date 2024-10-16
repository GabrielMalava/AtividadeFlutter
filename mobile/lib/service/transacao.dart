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

class ServicoTransacao extends AbstractApi<Transacao> {
  final String urlBase = 'http://localhost:3000/transacoes';

  @override
  Future<List<Transacao>> obterTodas() async {
    try {
      final resposta = await http.get(Uri.parse(urlBase));
      if (resposta.statusCode == 200) {
        List<dynamic> listaJson = json.decode(resposta.body);
        return listaJson.map((json) => Transacao(
          id: json['id'],
          nome: json['nome'],
          valor: json['valor'],
        )).toList();
      } else {
        throw Exception('Erro ao carregar transações: ${resposta.statusCode}');
      }
    } catch (erro) {
      throw Exception('Falha ao buscar transações: $erro');
    }
  }

  @override
  Future<Transacao> obterPorId(String id) async {
    try {
      final resposta = await http.get(Uri.parse('$urlBase/$id'));
      if (resposta.statusCode == 200) {
        final jsonResposta = json.decode(resposta.body);
        return Transacao(
          id: jsonResposta['id'],
          nome: jsonResposta['nome'],
          valor: jsonResposta['valor'],
        );
      } else {
        throw Exception('Erro ao carregar transação: ${resposta.statusCode}');
      }
    } catch (erro) {
      throw Exception('Falha ao buscar transação: $erro');
    }
  }

  @override
  Future<Transacao> criar(Transacao transacao) async {
    final resposta = await http.post(
      Uri.parse(urlBase),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nome': transacao.nome,
        'valor': transacao.valor,
      }),
    );

    if (resposta.statusCode == 201) {
      final jsonResposta = json.decode(resposta.body);
      return Transacao(
        id: jsonResposta['id'],
        nome: jsonResposta['nome'],
        valor: jsonResposta['valor'],
      );
    } else {
      throw Exception('Erro ao criar transação: ${resposta.statusCode}');
    }
  }

  @override
  Future<Transacao> atualizar(Transacao transacao) async {
    try {
      final resposta = await http.put(
        Uri.parse('$urlBase/${transacao.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(transacao.toJson()),
      );

      if (resposta.statusCode == 200) {
        final jsonResposta = json.decode(resposta.body);
        return Transacao(
          id: jsonResposta['id'],
          nome: jsonResposta['nome'],
          valor: jsonResposta['valor'],
        );
      } else {
        throw Exception('Erro ao atualizar transação: ${resposta.statusCode}');
      }
    } catch (erro) {
      throw Exception('Falha ao atualizar transação: $erro');
    }
  }

  @override
  Future<void> excluir(String id) async {
    try {
      final resposta = await http.delete(Uri.parse('$urlBase/$id'));
      if (resposta.statusCode != 200) {
        throw Exception('Erro ao excluir transação: ${resposta.statusCode}');
      }
    } catch (erro) {
      throw Exception('Falha ao excluir transação: $erro');
    }
  }
}
