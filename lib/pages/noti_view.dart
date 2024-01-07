import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../functions/notify_service.dart';

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

  void mostrarMenuNotificaciones(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: notificaciones.isEmpty
              ? const Text('No hay notificaciones disponibles.')
              : SingleChildScrollView(
                  child: Column(
                    children: notificaciones
                        .map((notificacion) => LayoutBuilder(
                              builder: (context, constraints) {
                                return SizedBox(
                                  width: constraints
                                      .maxWidth, // Asegura que no desborde horizontalmente
                                  child: ListTile(
                                    title: Text(notificacion.titulo),
                                    subtitle: Text(notificacion.descripcion),
                                    trailing: Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            _notificacionesService
                                                .aceptarInvitacion(
                                                    notificacion);
                                          },
                                          child: const Text('Aceptar'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _notificacionesService
                                                .rechazarInvitacion(
                                                    notificacion);
                                          },
                                          child: const Text('Rechazar'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ))
                        .toList(),
                  ),
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: notificaciones.isEmpty
          ? const Center(
              child: Text(
                'No tienes notificaciones',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
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
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
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
                                child: const Text('Aceptar'),
                              ),
                              const SizedBox(width: 16),
                              TextButton(
                                onPressed: () {
                                  _notificacionesService
                                      .rechazarInvitacion(notificacion);
                                },
                                child: const Text('Rechazar'),
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
