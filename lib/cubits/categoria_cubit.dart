
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sistema_financeiro/cubits/categoria_state.dart' show CategoriaState, CategoriaLoaded, CategoriaError;
import 'package:sistema_financeiro/models/categoria.dart';
import 'package:sistema_financeiro/repositories/categoria_repository.dart';

class CategoriaCubit extends Cubit<CategoriaState> {
  List<Categoria> _categorias = [];
  final CategoriaRepository repository;

  CategoriaCubit({required this.repository}) : super(CategoriaLoaded(
    categorias: []
  ));

  Future<void> carregarCategorias() async {
    try{
      _categorias = await repository.buscarCategoria();
      _emitirCategorias();
    } catch(e){
      emit(CategoriaError(message: 'Erro ao carregar dados do Supabase. $e'));
    }
  }

  Future<void> adicionarCategoria(Categoria categoria) async {
    final novaCategoria = await repository.criarCategoria(categoria);

    _categorias.insert(0, novaCategoria);
    _emitirCategorias();
  }

  void _emitirCategorias() {
    emit(CategoriaLoaded(
      categorias: List.unmodifiable(_categorias)
    ));
  }
}

