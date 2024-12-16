import 'package:flutter/material.dart';
import 'package:logi/screen/login.dart';
import 'package:logi/screen/registro.dart';

class Menuoption extends StatefulWidget {
  const Menuoption({super.key});

  @override
  State<Menuoption> createState() => _MenuoptionState();
}

class _MenuoptionState extends State<Menuoption> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        foregroundColor: Colors.white,
        title: Text('Menú'),
        leading: Icon(
          Icons.home, // Icono que va en la parte superior izquierda
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Imagen en la parte superior
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/3534/3534139.png',
              height: 100,
              width: 100,
            ),
            SizedBox(height: 30),

            // Título principal con estilo
            Center(
              child: Text(
                'Bienvenido al Menú',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: 30),

            // Opción de registrarse
            Card(
              elevation: 8, // Añadir sombra
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados
              ),
              color: Colors.blue[50], // Fondo azul claro
              child: ListTile(
                title: Text(
                  'Registrarse',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                leading: Icon(
                  Icons.person_add,
                  color: Colors.blue,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.blue,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Regis()),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Opción de iniciar sesión
            Card(
              elevation: 8, // Añadir sombra
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados
              ),
              color: Colors.green[50], // Fondo verde claro
              child: ListTile(
                title: Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                leading: Icon(
                  Icons.login,
                  color: Colors.green,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: Colors.green,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IniciarSesion()),
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
