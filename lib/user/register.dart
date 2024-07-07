import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // values that appear has a placeholder
  String _selectedCountry = 'Portugal';
  String _selectedSpecialty = 'Operador';
  String _selectDistrito = "Castelo Branco";
  String _selectMunicipio = "Covilhã";
  String _selectFreguesia = "Covilhã";

  // input controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _distritoController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _freguesiaController = TextEditingController();

  // values for dropdown
  final List<String> _countries = ['Portugal', 'Spain', 'France', 'UK', 'USA'];
  final List<String> _specialties = ['Operador', 'Controlador', 'Inspetor'];
  final List<String> _distrito = ['Castelo Branco', 'Lisboa', 'Porto'];
  final List<String> _municipio = ['Covilhã', 'Fundão', 'Belmonte'];
  final List<String> _freguesia = ['Dominguiso', 'Covilhã', 'Boidobra'];

  // function registo
  Future<void> _register() async {
    if (_validateInputs()) {
      final name = _nameController.text;
      final phone = _phoneController.text;
      final email = _emailController.text;
      final password = _passwordController.text;
      final rua = _ruaController.text;
      final codigo_postal = _codigoController.text;

      final url = Uri.parse('http://10.0.2.2:3000/user/register');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'nome': name,
          'telefone': phone,
          'email': email,
          'password': password,
          'pais_nome': _selectedCountry,
          'especialidade': _selectedSpecialty,
          'distrito_nome': _selectDistrito,
          'municipio_nome': _selectMunicipio,
          'freguesia_nome': _selectFreguesia,
          'rua': rua,
          'codigo_postal': codigo_postal
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Utilizador Registado com sucesso"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        print('registado com sucesso');
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Este email já está em uso"),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Erro ao Registar"),
            backgroundColor: Colors.red,
          ),
        );
        print('falhou ao registar: ${response.body}');
      }
    }
  }

  // Validate Inputs
  bool _validateInputs() {
    return _formKey.currentState?.validate() ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Registo',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nome',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Telefone',
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      // You can add email validation logic here if needed
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedSpecialty,
                    decoration: InputDecoration(
                      labelText: 'Especialidade',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _specialties.map((String specialty) {
                      return DropdownMenuItem<String>(
                        value: specialty,
                        child: Text(specialty),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedSpecialty = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedCountry,
                    decoration: InputDecoration(
                      labelText: 'País',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _countries.map((String country) {
                      return DropdownMenuItem<String>(
                        value: country,
                        child: Text(country),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCountry = newValue!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectDistrito,
                    decoration: InputDecoration(
                      labelText: 'Distrito',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _distrito.map((String distrito) {
                      return DropdownMenuItem<String>(
                        value: distrito,
                        child: Text(distrito),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectDistrito = newValue!;
                      });
                      // Update the selected district in the controller
                      _distritoController.text = newValue!;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectMunicipio,
                    decoration: InputDecoration(
                      labelText: 'Municipio',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _municipio.map((String municipio) {
                      return DropdownMenuItem<String>(
                        value: municipio,
                        child: Text(municipio),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectMunicipio = newValue!;
                      });
                      // Update the selected municipality in the controller
                      _municipioController.text = newValue!;
                    },
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectFreguesia,
                    decoration: InputDecoration(
                      labelText: 'Freguesia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: _freguesia.map((String freguesia) {
                      return DropdownMenuItem<String>(
                        value: freguesia,
                        child: Text(freguesia),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectFreguesia = newValue!;
                      });
                      _freguesiaController.text = newValue!;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _ruaController,
                    decoration: InputDecoration(
                      labelText: 'Rua',
                      prefixIcon: const Icon(Icons.location_city),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _codigoController,
                    decoration: InputDecoration(
                      labelText: 'Código Postal',
                      prefixIcon: const Icon(Icons.markunread_mailbox),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo Obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    child: const Text('Registar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
