import 'package:flutter/material.dart';
import 'package:mobile/service/transacao.dart';

class TelaFormulario extends StatefulWidget {
  final Transacao? transacao;

  TelaFormulario({this.transacao});

  @override
  _TelaFormularioState createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _controllerNome = TextEditingController();
  final _controllerValor = TextEditingController();

  final ServicoTransacao servicoTransacao = ServicoTransacao();

  @override
  void initState() {
    super.initState();
    if (widget.transacao != null) {
      _controllerNome.text = widget.transacao!.nome;
      _controllerValor.text = widget.transacao!.valor.toString();
    }
  }

  void _salvar() async {
    final String nome = _controllerNome.text;
    final double valor = double.tryParse(_controllerValor.text) ?? 0;

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
        title: Text(widget.transacao != null ? 'Editar Transação' : 'Adicionar Transação'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controllerNome,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _controllerValor,
              decoration: InputDecoration(labelText: 'Valor'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvar,
              child: Text(widget.transacao != null ? 'Atualizar' : 'Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}
