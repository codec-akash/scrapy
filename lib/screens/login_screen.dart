import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scarpbook/blocs/login_bloc/login_bloc.dart';
import 'package:scarpbook/utils/extension_fucntion.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LoginBloc>().add(AppStarted());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scrapy")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoggedInWithGoogle) {
                print("Loggin google successful");
              }
              if (state is LogInFailedState &&
                  state.loginEvent is LoginWithGoogle) {
                context.showSnackBar(state.errorMsg.toString());
              }
            },
            child: Container(),
          ),
          Text(
            "Login with Google",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: () {
                context.read<LoginBloc>().add(LoginWithGoogle());
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text("Login"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
