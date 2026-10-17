import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_financeiro/cubits/categoria_cubit.dart';
import 'package:sistema_financeiro/cubits/categoria_form_cubit.dart';
import 'package:sistema_financeiro/cubits/categoria_form_state.dart';
import 'package:sistema_financeiro/cubits/categoria_state.dart';

import '../models/categoria.dart';
import 'package:flutter/material.dart';


class CadastroCategoriaPage extends StatefulWidget {
  final Categoria? categoriaParaEdicao;

  const CadastroCategoriaPage({super.key, this.categoriaParaEdicao});

  @override
  State<CadastroCategoriaPage> createState() => _CadastroCategoriaPageState();
}


class _CadastroCategoriaPageState extends State<CadastroCategoriaPage>{
  late final TextEditingController _categoriaNomeController;

  late final TextEditingController _categoriaDescricaoController;

  @override
  void initState() {
    super.initState();
    _categoriaNomeController = TextEditingController(
      text: widget.categoriaParaEdicao?.nome ?? ""
    );

    _categoriaDescricaoController = TextEditingController(
      text: widget.categoriaParaEdicao?.descricao ?? ""
    );
  }

  @override
  void dispose() {
    _categoriaNomeController.dispose();
    _categoriaDescricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("Nova Categoria"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: BlocListener<CategoriaFormCubit, CategoriaFormState>(
          listener: (context, state) {
            if( state is CategoriaFormError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.erro),
                  backgroundColor: Colors.red,
                )
              );
            }

            if(state is CategoriaFormSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.mensagem),
                  backgroundColor: Colors.green,
                )
              );

              _categoriaNomeController.clear();
              _categoriaDescricaoController.clear();
              context.read<CategoriaFormCubit>().resetarEstado();
            }
          },

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _categoriaNomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                    border: OutlineInputBorder()
                  ),
                ),
                const SizedBox(height:20),

                TextField(
                  controller: _categoriaDescricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder()
                  ),
                ),

                const SizedBox(height: 20),

                BlocBuilder<CategoriaFormCubit, CategoriaFormState>(
                  builder: (context, state){
                    final isLoading = state is CategoriaFormLoading;

                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.green,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        )
                      ),
                      onPressed: isLoading ? null : () {
                        context.read<CategoriaFormCubit>().salvarCategoria(
                          id: widget.categoriaParaEdicao?.id,
                          nomeCategoria: _categoriaNomeController.text,
                          descricaoCategoria: _categoriaDescricaoController.text
                        );
                      },
                      child: isLoading ?
                        const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2
                          ),
                        ): Text(
                          'Salvar Categoria',
                          style: TextStyle(fontSize: 16, color: Colors.white)
                        )
                    );
                  }
                ),

                const SizedBox(height: 20),

                //Lista das categorias já cadastradas
                const Text(
                  "Categorias Cadastradas",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                ),
                const SizedBox(height: 8),

                BlocBuilder<CategoriaCubit, CategoriaState>(
                  builder: (context, state) {
                    if (state is CategoriaError) {
                      return Text(
                        state.message,
                        style: const TextStyle(color: Colors.red)
                      );
                    }

                    final categorias = (state as CategoriaLoaded).categorias;

                    if (categorias.isEmpty) {
                      return const Text(
                        "Nenhuma categoria cadastrada.",
                        style: TextStyle(color: Colors.grey)
                      );
                    }

                    return Column(
                      children: categorias.map((categoria) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(Icons.label_outline, color: Colors.teal),
                          title: Text(
                            categoria.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold)
                          ),
                          subtitle: categoria.descricao.isEmpty ? null : Text(categoria.descricao),
                        ),
                      )).toList()
                    );
                  }
                )
              ],

            )
          ),
        ),
      ),
    );
  }
}
