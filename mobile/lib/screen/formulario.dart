import 'package:flutter/material.dart';
import 'package:mobile/service/transacao.dart';

class FormularioTransacaoScreen extends StatefulWidget {
  final Transacao? transacao;

  FormularioTransacaoScreen({this.transacao});

  @override
  _FormularioTransacaoScreenState createState() => _FormularioTransacaoScreenState();
}

class _FormularioTransacaoScreenState extends State<FormularioTransacaoScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

  final ServicoTransacao servicoTransacao = ServicoTransacao();

  @override
  void initState() {
    super.initState();
    if (widget.transacao != null) {
      _nomeController.text = widget.transacao!.nome;
      _valorController.text = widget.transacao!.valor.toString();
    }
  }

  void _salvarTransacao() async {
    final String nome = _nomeController.text;
    final double valor = double.tryParse(_valorController.text) ?? 0;

    if (nome.isNotEmpty && valor > 0) {
      if (widget.transacao != null) {
        final transacaoAtualizada = Transacao(
          id: widget.transacao!.id,
          nome: nome,
          valor: valor,
        );
        await servicoTransacao.atualizar(transacaoAtualizada);
      } else {
        final novaTransacao = Transacao(id: "", nome: nome, valor: valor);
        await servicoTransacao.criar(novaTransacao);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transacao != null ? 'Editar Transação' : 'Nova Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _valorController,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarTransacao,
              child: Text(widget.transacao != null ? 'Atualizar' : 'Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
