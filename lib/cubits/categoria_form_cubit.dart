import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_financeiro/cubits/categoria_cubit.dart' show CategoriaCubit;
import 'package:sistema_financeiro/cubits/categoria_form_state.dart';
import 'package:sistema_financeiro/models/categoria.dart';

class CategoriaFormCubit extends Cubit<CategoriaFormState> {

  final CategoriaCubit categoriaCubit;

  // Correção da sintaxe com ":" antes de super
  CategoriaFormCubit({ 
    required this.categoriaCubit}) : super(CategoriaFormInitial());

  Future<void> salvarCategoria({
    String? id,
    required String nomeCategoria,
    required String descricaoCategoria
  }) async {
    if (nomeCategoria.trim().isEmpty) {
      emit(CategoriaFormError('A categoria não pode ser vazia.'));
      return;
    }

    emit(CategoriaFormLoading());

    try {
      final dataHoraAtual = DateTime.now();
      
      final novaCategoria = Categoria(
        // Correção: millisecondsSinceEpoch gera um ID único
        id: id ?? dataHoraAtual.millisecondsSinceEpoch.toString(),
        nome: nomeCategoria,
        descricao: descricaoCategoria,
        created_at: dataHoraAtual,
      );

      await categoriaCubit.adicionarCategoria(novaCategoria);
      emit(CategoriaFormSuccess('Categoria salva com sucesso!'));
    } catch (e) {
      emit(CategoriaFormError('Falha ao salvar a categoria. $e'));
    }
  }

  void resetarEstado() {
    emit(CategoriaFormInitial());
  }
}