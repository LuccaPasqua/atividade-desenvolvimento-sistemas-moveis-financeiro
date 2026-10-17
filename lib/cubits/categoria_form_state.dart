
abstract class CategoriaFormState{}

class CategoriaFormInitial extends CategoriaFormState{}

class CategoriaFormLoading extends CategoriaFormState {}

class CategoriaFormSuccess extends CategoriaFormState {
  final String mensagem;
  CategoriaFormSuccess(this.mensagem);
}

class CategoriaFormError extends CategoriaFormState {
  final String erro;
  CategoriaFormError(this.erro);
  
}