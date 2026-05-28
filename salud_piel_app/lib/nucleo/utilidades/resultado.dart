sealed class Resultado<T> {
  const Resultado();
}

final class Exito<T> extends Resultado<T> {
  final T data;
  const Exito(this.data);
}

final class Fracaso<T> extends Resultado<T> {
  final String mensaje;
  final Exception? excepcion;
  const Fracaso(this.mensaje, [this.excepcion]);
}
