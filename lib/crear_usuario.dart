import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrearUsuario extends StatefulWidget {
  const CrearUsuario({super.key});

  @override
  State<CrearUsuario> createState() => _CrearUsuarioState();
}

class _CrearUsuarioState extends State<CrearUsuario> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();

  Future<void> _crearUsuario() async {
    await FirebaseFirestore.instance.collection('usuarios').add({
      'nombre': _nombreController.text,
      'correo': _correoController.text,
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario creado exitosamente')),
    );
    _nombreController.clear();
    _correoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: _correoController,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _crearUsuario,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
