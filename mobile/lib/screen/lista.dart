import 'package:flutter/material.dart';
import 'package:mobile/service/transacao.dart';
import 'formulario.dart';

class TransacaoListaScreen extends StatefulWidget {
  @override
  _TransacaoListaScreenState createState() => _TransacaoListaScreenState();
}

class _TransacaoListaScreenState extends State<TransacaoListaScreen> {
  final TransacaoService servicoTransacao = TransacaoService();
  late Future<List<Transacao>> transacoesFuturas;

  @override
  void initState() {
    super.initState();
    transacoesFuturas = servicoTransacao.buscarTodos();
  }

  void _refreshLista() {
    setState(() {
      transacoesFuturas = servicoTransacao.buscarTodos();
    });
  }

  void _removerTransacao(String id) async {
    await servicoTransacao.deletar(id);
    _refreshLista();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transações Registradas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FormularioScreen())).then((_) {
                _refreshLista();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Transacao>>(
        future: transacoesFuturas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Falha ao carregar as transações.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Nenhuma transação encontrada.'));
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
                        ).then((_) {
                          _refreshLista();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _removerTransacao(transacao.id),
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
