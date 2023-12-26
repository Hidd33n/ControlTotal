import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'calculo.g.dart';

@JsonSerializable()
class Calculo {
  final String id;
  final String montoFinal;
  final String montoResta;
  @TimestampSerializer()
  final DateTime fecha;

  Calculo({
    required this.id,
    required this.fecha,
    required this.montoFinal,
    required this.montoResta,
  });

  factory Calculo.fromJson(Map<String, dynamic> json) =>
      _$CalculoFromJson(json);

  Map<String, dynamic> toJson() => _$CalculoToJson(this);
}

class TimestampSerializer implements JsonConverter<DateTime, dynamic> {
  const TimestampSerializer();

  @override
  DateTime fromJson(dynamic timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
