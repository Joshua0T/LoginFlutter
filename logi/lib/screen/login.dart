import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Lista.dart';  // Asegúrate de importar el archivo Lista.dart

class IniciarSesion extends StatefulWidget {
  @override
  _IniciarSesionState createState() => _IniciarSesionState();
}

class _IniciarSesionState extends State<IniciarSesion> {
  final TextEditingController correoController = TextEditingController();
  final TextEditingController contrasenaController = TextEditingController();
  String mensaje = '';

  Future<void> handleSubmit() async {
    final correo = correoController.text;
    final contrasena = contrasenaController.text;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:7700/api/entered'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'correo': correo, 'contraseña': contrasena}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];

        // Guardamos el token en SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', token);

        setState(() {
          mensaje = 'Inicio de sesión exitoso';
        });

        // Redirigimos a la página Lista
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Lista()),
        );
      } else {
        setState(() {
          mensaje = 'Error al iniciar sesión';
        });
      }
    } catch (error) {
      setState(() {
        mensaje = 'Error al iniciar sesión';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Fondo blanco
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green), // Borde verde
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 50,
                  color: Colors.green, // Color verde para el ícono
                ),
                SizedBox(height: 20),
                Text(
                  'Inicia Sesión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green, // Color verde para el texto
                  ),
                ),
                SizedBox(height: 20),
                // Campo Correo
                TextField(
                  controller: correoController,
                  decoration: InputDecoration(
                    labelText: 'Correo',
                    filled: true,
                    fillColor: Colors.grey[200], // Fondo claro
                    border: OutlineInputBorder(),
                    hintText: 'example@gmail.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                // Campo Contraseña
                TextField(
                  controller: contrasenaController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.grey[200], // Fondo claro
                    border: OutlineInputBorder(),
                    hintText: 'Contraseña',
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 24),
                // Botón de Iniciar sesión
                ElevatedButton(
                  onPressed: handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Fondo verde
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Iniciar Sesión',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 16),
                // Mensaje de error o éxito
                if (mensaje.isNotEmpty)
                  Text(
                    mensaje,
                    style: TextStyle(
                      color: Colors.green[400],
                      fontSize: 14,
                    ),
                  ),
                SizedBox(height: 16),
                // Enlace para volver al inicio
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/'); // Redirigir al inicio
                  },
                  child: Text(
                    'Volver al Inicio',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ),
                // Enlace para recuperar contraseña
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/recover-password'); // Redirigir a recuperar contraseña
                  },
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(color: Colors.blue[400]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
