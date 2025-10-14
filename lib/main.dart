//lib/main.dart:

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Archivo generado por FlutterFire CLI
import 'firebase-service.dart'; // Importamos nuestro servicio

void main() async {
  // Asegura que los widgets de Flutter estén inicializados.
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase en la aplicación.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRUD Firebase',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios con Firebase 🔥'),
        backgroundColor: Colors.deepPurple[100],
      ),
      // Usamos StreamBuilder para escuchar los datos de Firebase en tiempo real.
      body: StreamBuilder(
        stream: obtenerUsuarios(),
        builder: (context, snapshot) {
          // Si hay datos, los mostramos en una lista.
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                // Obtenemos los datos de cada documento.
                final userDoc = snapshot.data!.docs[index];
                final userId = userDoc.id; // UID del documento
                final userData = userDoc.data() as Map<String, dynamic>;
                final userName = userData['nombre'] ?? 'Sin nombre';
                final userDni = userData['dni'] ?? 'Sin DNI';

                return ListTile(
                  title: Text(userName),
                  subtitle: Text('DNI: $userDni'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón para editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _mostrarDialogoEditar(context, userId, userName),
                      ),
                      // Botón para eliminar
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => eliminarUsuario(userId),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          // Si no hay datos, mostramos un indicador de carga.
          return const Center(child: CircularProgressIndicator());
        },
      ),
      // Botón flotante para agregar nuevos usuarios.
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoAgregar(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  // --- Diálogos para Agregar y Editar ---

  void _mostrarDialogoAgregar(BuildContext context) {
    final TextEditingController dniController = TextEditingController();
    final TextEditingController nombreController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Agregar Nuevo Usuario"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dniController,
                decoration: const InputDecoration(labelText: "DNI"),
              ),
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () {
                agregarUsuario(dniController.text, nombreController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // --- Diálogo para Editar Usuario ---
void _mostrarDialogoEditar(
  BuildContext context,
  String uid,
  String nombreActual,
  String dniActual,
) {
  final TextEditingController nombreController =
      TextEditingController(text: nombreActual);
  final TextEditingController dniController =
      TextEditingController(text: dniActual);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Editar Usuario"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: "Nuevo Nombre"),
            ),
            TextField(
              controller: dniController,
              decoration: const InputDecoration(labelText: "Nuevo DNI"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text("Actualizar"),
            onPressed: () {
              actualizarUsuario(
                uid,
                nombreController.text,
                dniController.text,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
}

