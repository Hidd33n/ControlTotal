class Calculos {
  final DateTime fecha;
  final double monto;
  final double impuestos;

  Calculos({required this.fecha, required this.monto, required this.impuestos});

  factory Calculos.fromJson(Map<String, dynamic> json) {
    return Calculos(
      fecha: json['fecha'],
      monto: json['monto'],
      impuestos: json['impuestos'],
    );
  }
}
