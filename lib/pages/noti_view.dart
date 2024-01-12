import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../assets/functions/notify_service.dart';

class NotifyView extends StatefulWidget {
  const NotifyView({Key? key}) : super(key: key);

  @override
  State<NotifyView> createState() => _NotifyViewState();
}

class _NotifyViewState extends State<NotifyView> {
  List<Notificacion> notificaciones = []; // Agrega la lista de notificaciones
  final NotificacionesService _notificacionesService = NotificacionesService();

  @override
  void initState() {
    super.initState();
    cargarNotificaciones();
  }

  Future<void> cargarNotificaciones() async {
    try {
      // Llama al método cargarNotificaciones de NotificacionesService
      List<Notificacion> loadedNotificaciones =
          await _notificacionesService.cargarNotificaciones();

      setState(() {
        notificaciones = loadedNotificaciones;
      });
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: notificaciones.isEmpty
          ? Center(
              child: Text(
                'No tienes notificaciones',
                style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                        fontFamily: 'poppins', fontWeight: FontWeight.w400),
                    color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: notificaciones.length,
              itemBuilder: (context, index) {
                Notificacion notificacion = notificaciones[index];

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            notificacion.titulo,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${notificacion.descripcion}\n${DateFormat('dd-MM-yyyy HH:mm').format(notificacion.fecha)}",
                            style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w400),
                                color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _notificacionesService
                                      .aceptarInvitacion(notificacion);
                                },
                                child: Text(
                                  'Aceptar',
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w400),
                                      color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 16),
                              TextButton(
                                onPressed: () {
                                  _notificacionesService
                                      .rechazarInvitacion(notificacion);
                                },
                                child: Text(
                                  'Rechazar',
                                  style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                          fontFamily: 'poppins',
                                          fontWeight: FontWeight.w400),
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
