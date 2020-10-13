import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat/helpers/show_alert.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/widgets/blue_button.dart';
import 'package:chat/widgets/custom_input.dart';
import 'package:chat/widgets/labels.dart';
import 'package:chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Logo(title: 'Registro',),
                _Form(),
                Labels(
                  route: 'login',
                  title: '¿Ya tienes una cuenta?',
                  subtitle: '¡Ingresa ahora!'
                ),

                Text('Términos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),)
              ],
            ),
          ),
        ),
      )
    );
  }
}

class _Form extends StatefulWidget {
  _Form({Key key}) : super(key: key);

  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.person_outline,
            placeHolder: 'Nombre',
            textController: nameController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            textController: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            textController: passwordController,
            isPassword: true,
          ),
          
          BlueButton(
            text: 'Registrarse',
            onPressed: authService.waiting 
              ? null
              : () async {
                
                // Close keyboard
                FocusScope.of(context).unfocus();

                final registerError = await authService.register(
                  nameController.text.trim(),
                  emailController.text.trim(), 
                  passwordController.text.trim()
                );

                if ( registerError.isEmpty ) {
                  //TODO: Connect with socket
                  Navigator.pushReplacementNamed(context, 'users');
                } else {
                  showAlert(context, 'Registro', registerError);
                }

              }
          )
        ],
      ),
    );
  }
}
