
import 'package:sistema_financeiro/models/categoria.dart';

abstract class CategoriaState {}

class CategoriaLoaded extends CategoriaState {
  final List<Categoria> categorias;
  
  CategoriaLoaded({
    required this.categorias
  });
}


class CategoriaError extends CategoriaState {
  final String message;
  CategoriaError({required this.message});
}

