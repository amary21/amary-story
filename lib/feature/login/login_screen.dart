import 'package:amary_story/feature/login/login_provider.dart';
import 'package:amary_story/feature/login/login_state.dart';
import 'package:amary_story/route/nav_route.dart';
import 'package:amary_story/widget/button/button_widget.dart';
import 'package:amary_story/widget/toast/toast_enum.dart';
import 'package:amary_story/widget/toast/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final LoginProvider provider = context.read<LoginProvider>();
      provider.resetText();

      bool isReadyToken = await provider.isReadyToken();
      if (isReadyToken) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, NavRoute.homeRoute.name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<LoginProvider>(
        builder: (context, provider, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (provider.state) {
              case LoginErrorState(message: var error):
                showToast(context, ToastEnum.error, error);
                break;
              case LoginLoadedState(message: var message):
                showToast(context, ToastEnum.success, message);
                Navigator.pushNamed(context, NavRoute.homeRoute.name);
              case _:
                break;
            }

            provider.resetToast();
          });

          return switch (provider.isGetReadyToken) {
            true => CircularProgressIndicator(),
            _ => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'AmaryStory',
                    style: TextStyle(fontFamily: 'Billabong', fontSize: 48),
                  ),
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Login'),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (text) {
                      provider.email = text;
                    },
                  ),
                  SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (text) {
                      provider.password = text;
                    },
                  ),
                  SizedBox(height: 32),
                  ButtonWidget(
                    isLoading: provider.state is LoginLoadedState,
                    isEnable: provider.isEnableButton,
                    textButton: "Log In",
                    onTap: () async {
                      await provider.login();
                    },
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NavRoute.registerRoute.name,
                          );
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          };
        },
      ),
    );
  }
}
