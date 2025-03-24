import 'dart:io';

import 'package:amary_story/feature/add/add_provider.dart';
import 'package:amary_story/feature/add/add_state.dart';
import 'package:amary_story/route/nav_route.dart';
import 'package:amary_story/widget/button/button_widget.dart';
import 'package:amary_story/widget/toast/toast_enum.dart';
import 'package:amary_story/widget/toast/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("New Story")),
      body: Consumer<AddProvider>(
        builder: (contex, provider, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (provider.state) {
              case AddErrorState(message: var error):
                showToast(context, ToastEnum.error, error);
                break;
              case AddLoadedState(message: var message):
                showToast(context, ToastEnum.success, message);
                Navigator.pushNamed(context, NavRoute.homeRoute.name);
              case _:
                break;
            }

            provider.resetToast();
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      _image == null
                          ? Icon(
                            Icons.image,
                            size: 100,
                            color: Colors.grey[600],
                          )
                          : Image.file(File(_image!.path), fit: BoxFit.cover),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text("Add Image from Gallery"),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    hintText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  onChanged: (value) {
                    provider.description = value;
                  },
                ),
                SizedBox(height: 10),
                ButtonWidget(
                  isLoading: provider.state is AddLoadingState,
                  isEnable: provider.isEnableButton,
                  textButton: "Upload",
                  onTap: () async {
                    await provider.upload();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final AddProvider provider = context.read<AddProvider>();
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        provider.image = File(pickedFile.path);
      });
    }
  }
}
