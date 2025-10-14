import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EliminarUsuario extends StatelessWidget {
  const EliminarUsuario({super.key});

  Future<void> _eliminarUsuario(String id, BuildContext context) async {
    await FirebaseFirestore.instance.collection('usuarios').doc(id).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Usuario eliminado')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Eliminar Usuario')),
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
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _eliminarUsuario(doc.id, context),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
