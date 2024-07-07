import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'login.dart';

// Access the User class
User user = User.userInstance;

class EditUserPage extends StatefulWidget {
  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  // Form fields
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _specialtyController = TextEditingController();

  // urls for the endpoints, first one edit user, second one to check a user profile (it's info)
  final String apiUrl = 'http://10.0.2.2:3000/user/edit/${user.id}';
  final String fetchUrl = 'http://10.0.2.2:3000/user/profile/';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  // http GET to obtain user info
  void _fetchUserData() async {
    var response = await http.get(Uri.parse('$fetchUrl${user.id}'));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body)['user'];
      setState(() {
        _nameController.text = data['nome'];
        _phoneController.text = data['telefone'].toString();
        _emailController.text = data['email'];
        _specialtyController.text = data['especialidade'];
      });
    } else {
      // Handle errors
      print("Error fetching user data: ${response.statusCode}");
    }
  }

  // form submition function, it sends the new info for the server and updates the db
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      var data = {
        'id': user.id,
        'nome': _nameController.text,
        'telefone': _phoneController.text,
        'email': _emailController.text,
        'especialidade': _specialtyController.text,
      };

      var response = await http.patch(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        print("User updated successfully");
      } else {
        print("Error updating user: ${response.statusCode}");
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Editar Utilizador'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration:  InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduza um nome';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Telemóvel',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduza um telemóvel';
                  }
                  if (!_isNumeric(value)) {
                    return 'Numeros de telemovel devem ser númericos';
                  }
                  if (value.length != 9) {
                    return 'Deve conter 9 digitos';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _emailController,
                decoration:  InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduza o Email';
                  }
                  // Validate email format
                  if (!_isValidEmail(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _specialtyController,
                decoration: InputDecoration(
                  labelText: 'Especialidade',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Introduza uma especialidade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  function to validate if a string is numeric
  bool _isNumeric(String value) {
    return double.tryParse(value) != null;
  }

  // function to validate email format
  bool _isValidEmail(String value) {
    if (value.isEmpty) {
      return false;
    }
    final regex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(value);
  }
}
