import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Lista extends StatefulWidget {
  @override
  _ListaState createState() => _ListaState();
}

class _ListaState extends State<Lista> {
  bool _loading = true;
  String _error = "";
  List<dynamic> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  // Función para cargar los usuarios desde el backend
  Future<void> _fetchUsers() async {
    setState(() {
      _loading = true;
      _error = "";
    });

    try {
      final response = await http.get(
        Uri.parse('http://localhost:7700/api/verusuarios'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            _users = data;
            _loading = false;
          });
        } else {
          setState(() {
            _error = "No se encontraron usuarios.";
            _loading = false;
          });
        }
      } else {
        setState(() {
          _error = "Error al cargar los usuarios: ${response.body}";
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Hubo un error al cargar los usuarios: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Usuarios'),
        centerTitle: true,
        backgroundColor: Colors.green[600],
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_error.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _error,
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        final user = _users[index];
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Bordes redondeados
                          ),
                          elevation: 5, // Sombra ligera para el card
                          color: Colors.white,
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                            title: Text(
                              user['nombre'] ?? 'Nombre no disponible',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Text(
                              user['correo'] ?? 'Correo no disponible',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            trailing: CircleAvatar(
                              backgroundColor: (user['activo'] == null || user['activo'] == false)
                                  ? Colors.red
                                  : Colors.green,
                              radius: 10,
                            ),
                            onTap: () {
                              // Navegar a la pantalla de editar usuario
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
