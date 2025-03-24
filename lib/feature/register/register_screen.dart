import 'package:amary_story/feature/register/register_provider.dart';
import 'package:amary_story/feature/register/register_state.dart';
import 'package:amary_story/widget/button/button_widget.dart';
import 'package:amary_story/widget/toast/toast_enum.dart';
import 'package:amary_story/widget/toast/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onLogin;

  const RegisterScreen({super.key, required this.onLogin});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  void initState() {
    final RegisterProvider provider = context.read<RegisterProvider>();
    Future.microtask(() {
      provider.resetText();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RegisterProvider>(
        builder: (context, provider, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (provider.state) {
              case RegisterErrorState(message: var error):
                showToast(context, ToastEnum.error, error);
                break;
              case RegisterLoadedState(message: var message):
                showToast(context, ToastEnum.success, message);
                widget.onLogin();
                break;
              case _:
                break;
            }

            provider.resetToast();
          });

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'AmaryStory',
                  style: TextStyle(fontFamily: 'Billabong', fontSize: 48),
                ),
                SizedBox(height: 16),
                Text(
                  'Sign Up to see story from your friends',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Billabong', fontSize: 20),
                ),
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('Register'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (text) {
                    provider.name = text;
                  },
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
                  isLoading: provider.state is RegisterLoadingState,
                  isEnable: provider.isEnableButton,
                  textButton: "Sign Up",
                  onTap: () async {
                    await provider.register();
                  },
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Have an account?  "),
                    GestureDetector(
                      onTap: widget.onLogin,
                      child: Text(
                        'Log In',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
