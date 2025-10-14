import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditarUsuario extends StatefulWidget {
  const EditarUsuario({super.key});

  @override
  State<EditarUsuario> createState() => _EditarUsuarioState();
}

class _EditarUsuarioState extends State<EditarUsuario> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  Future<void> _actualizarUsuario(String id) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(id).update({
      'nombre': _nombreController.text,
      'correo': _correoController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario actualizado correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Usuario')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['nombre']),
                subtitle: Text(doc['correo']),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _nombreController.text = doc['nombre'];
                    _correoController.text = doc['correo'];

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Editar Usuario'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _nombreController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre',
                              ),
                            ),
                            TextField(
                              controller: _correoController,
                              decoration: const InputDecoration(
                                labelText: 'Correo',
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _actualizarUsuario(doc.id);
                              Navigator.pop(context);
                            },
                            child: const Text('Guardar'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
