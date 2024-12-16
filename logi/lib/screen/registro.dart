import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Regis extends StatefulWidget {
  @override
  _RegisState createState() => _RegisState();
}

class _RegisState extends State<Regis> {
  final _formKey = GlobalKey<FormBuilderState>();
  String? _mensaje;
  String? _tipoMensaje;

  Future<void> _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final url = Uri.parse('http://localhost:7700/api/register');
      final headers = {'Content-Type': 'application/json'};
      final body = {
        'nombre': _formKey.currentState?.fields['nombre']?.value,
        'apellido': _formKey.currentState?.fields['apellido']?.value,
        'correo': _formKey.currentState?.fields['correo']?.value,
        'contraseña': _formKey.currentState?.fields['contraseña']?.value,
      };

      try {
        final response = await http.post(url, headers: headers, body: jsonEncode(body));
        if (response.statusCode == 201) {
          setState(() {
            _tipoMensaje = 'success';
            _mensaje = 'Usuario registrado con éxito.';
          });
        } else {
          final error = jsonDecode(response.body)['message'];
          setState(() {
            _tipoMensaje = 'error';
            _mensaje = error ?? 'Error al registrar el usuario.';
          });
        }
      } catch (e) {
        setState(() {
          _tipoMensaje = 'error';
          _mensaje = 'Error de conexión: $e';
        });
      }
    } else {
      setState(() {
        _tipoMensaje = 'error';
        _mensaje = 'Por favor, complete todos los campos correctamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Contenedor con borde alrededor del formulario
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green[600]!),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Column(
                    children: [
                      // Ícono de Persona dentro del recuadro
                      Icon(
                        Icons.person_outline,
                        size: 100,
                        color: Colors.green[600],
                      ),
                      SizedBox(height: 16),

                      // Título
                      Text(
                        'Registrate',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[600],
                        ),
                      ),
                      SizedBox(height: 24),

                      // Formulario de Registro
                      FormBuilder(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Campo Nombre
                            FormBuilderTextField(
                              name: 'nombre',
                              decoration: InputDecoration(
                                labelText: 'Nombre',
                                hintText: 'Ingrese su nombre',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 235, 232, 232),
                              ),
                              validator: Validatorless.required('Nombre es requerido'),
                            ),
                            SizedBox(height: 16),

                            // Campo Apellido
                            FormBuilderTextField(
                              name: 'apellido',
                              decoration: InputDecoration(
                                labelText: 'Apellido',
                                hintText: 'Ingrese su apellido',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 235, 232, 232),
                              ),
                              validator: Validatorless.required('Apellido es requerido'),
                            ),
                            SizedBox(height: 16),

                            // Campo Correo
                            FormBuilderTextField(
                              name: 'correo',
                              decoration: InputDecoration(
                                labelText: 'Correo',
                                hintText: 'example@mail.com',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 235, 232, 232),
                              ),
                              validator: Validatorless.multiple([
                                Validatorless.required('Correo es requerido'),
                                Validatorless.email('Correo no es válido')
                              ]),
                            ),
                            SizedBox(height: 16),

                            // Campo Contraseña
                            FormBuilderTextField(
                              name: 'contraseña',
                              decoration: InputDecoration(
                                labelText: 'Contraseña',
                                hintText: 'Ingrese su contraseña',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 235, 232, 232),
                              ),
                              obscureText: true,
                              validator: Validatorless.multiple([
                                Validatorless.required('Contraseña es requerida'),
                                Validatorless.min(5, 'La contraseña debe tener al menos 5 caracteres'),
                                Validatorless.max(20, 'La contraseña solo puede tener máximo 20 caracteres'),
                              ]),
                            ),
                            SizedBox(height: 16),

                            // Campo Confirmar Contraseña
                            FormBuilderTextField(
                              name: 'confirmarcontraseña',
                              decoration: InputDecoration(
                                labelText: 'Confirmar Contraseña',
                                hintText: 'Repita su contraseña',
                                filled: true,
                                fillColor: const Color.fromARGB(255, 235, 232, 232),
                              ),
                              obscureText: true,
                              validator: (val) {
                                if (val != _formKey.currentState?.fields['contraseña']?.value) {
                                  return 'Las contraseñas no coinciden';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 24),

                            // Botón de Registro
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _onSubmit,
                                child: Text('Registrarme'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[600],
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),

                            // Mensajes de éxito o error
                            if (_mensaje != null) ...[
                              SizedBox(height: 16),
                              Text(
                                _mensaje!,
                                style: TextStyle(
                                  color: _tipoMensaje == 'success' ? Colors.green : Colors.red,
                                  fontSize: 16,
                                ),
                              ),
                            ],

                            // Enlace para volver al inicio
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Volver al Inicio',
                                  style: TextStyle(
                                    color: Colors.blue[400],
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
