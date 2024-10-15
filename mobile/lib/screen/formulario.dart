import 'package:flutter/material.dart';
import 'package:mobile/service/transacao.dart';

class FormularioScreen extends StatefulWidget {
  final Transacao? transacao;

  FormularioScreen({this.transacao});

  @override
  _FormularioScreenState createState() => _FormularioScreenState();
}

class _FormularioScreenState extends State<FormularioScreen> {
  final _nomeController = TextEditingController();
  final _valorController = TextEditingController();

  final TransacaoService transacaoService = TransacaoService();

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
        await transacaoService.update(transacaoAtualizada);
      } else {
        final transacao = Transacao(id: "", nome: nome, valor: valor);
        await transacaoService.create(transacao);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.transacao != null ? 'Editar Transação' : 'Adicionar Transação')),
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
