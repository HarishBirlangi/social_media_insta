import 'package:flutter/material.dart';
import 'package:social_media_insta/widgets/header_widget.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late String userName;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  submitUserName() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      // Timer(const Duration(seconds: 4), () {
      Navigator.pop(context, userName);
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: headerWidget(
        context,
        strTitle: 'Create Account',
        disappearedBackButton: true,
      ),
      body: ListView(
        children: [
          Container(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 26),
                  child: Center(
                    child: Text(
                      'Setup a user name',
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value != null) {
                            if (value.isEmpty || value.trim().length < 5) {
                              return "User name is very short";
                            } else if (value.trim().length > 15) {
                              return "User name is very long";
                            } else {
                              return null;
                            }
                          }
                        },
                        onSaved: (newValue) => userName = newValue!,
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                          labelText: "User name",
                          labelStyle: TextStyle(fontSize: 16),
                          hintText: "Must be at least 5 characters",
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: submitUserName,
                  child: Container(
                    height: 55,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.lightGreenAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Proceed",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
