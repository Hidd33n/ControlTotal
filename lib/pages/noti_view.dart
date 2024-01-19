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
      // ignore: empty_catches
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary,
      child: notificaciones.isEmpty
          ? Center(
              child: Text(
                'No tienes notificaciones',
                style: Theme.of(context).textTheme.bodyLarge,
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
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "${notificacion.descripcion}\n${DateFormat('dd-MM-yyyy HH:mm').format(notificacion.fecha)}",
                            style: GoogleFonts.poppins(
                                textStyle:
                                    Theme.of(context).textTheme.bodyLarge,
                                color: Theme.of(context).colorScheme.primary),
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
                                  style: Theme.of(context).textTheme.bodyLarge,
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
                                  style: Theme.of(context).textTheme.bodyLarge,
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
