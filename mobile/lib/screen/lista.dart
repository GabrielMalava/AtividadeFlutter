import 'package:flutter/material.dart';
import 'package:mobile/service/transacao.dart';
import 'formulario.dart';

class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  final TransacaoService transacaoService = TransacaoService();
  late Future<List<Transacao>> futureTransacoes;

  @override
  void initState() {
    super.initState();
    futureTransacoes = transacaoService.fetchAll();
  }

  void _atualizarLista() {
    setState(() {
      futureTransacoes = transacaoService.fetchAll();
    });
  }

  void _excluirTransacao(String id) async {
    await transacaoService.delete(id);
    _atualizarLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Transações'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioScreen())).then((_) {
                _atualizarLista();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Transacao>>(
        future: futureTransacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar transações'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma transação cadastrada.'));
          }

          final transacoes = snapshot.data!;

          return ListView.builder(
            itemCount: transacoes.length,
            itemBuilder: (context, index) {
              final transacao = transacoes[index];
              return ListTile(
                title: Text(transacao.nome),
                subtitle: Text('Valor: R\$${transacao.valor}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                       onPressed: () {
                        Navigator.push(
                         context,
                          MaterialPageRoute(
                            builder: (context) => FormularioScreen(transacao: transacao),
                              ),
                            )..then((_) {
                         _atualizarLista();
                       });
                     },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _excluirTransacao(transacao.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
