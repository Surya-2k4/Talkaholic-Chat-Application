import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:talkaholic/const.dart';
import 'package:talkaholic/models/user_profile.dart';
import 'package:talkaholic/pages/login_page.dart';
import 'package:talkaholic/services/auth_service.dart';
import 'package:talkaholic/services/media_service.dart';
import 'package:talkaholic/widgets/custom_form.dart';
import 'package:talkaholic/services/navigation_service.dart';
import 'package:talkaholic/services/alert_service.dart';
import 'package:talkaholic/services/database_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;

  final GlobalKey<FormState> _registerFormKey = GlobalKey();

  late AuthService _authService;
  late MediaService _mediaService;
  late NavigationService _navigationService;
  late AlertService _alertService;
  late DatabaseServices _databaseService;

  String? name, email, password;

  File? selectedImage;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mediaService = _getIt.get<MediaService>();
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _alertService = _getIt.get<AlertService>();
    _databaseService = _getIt.get<DatabaseServices>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                _headerText(),
                if (!isLoading) _registerForm(),
                if (!isLoading) _loginAccountLink(),
                if (isLoading)
                  const Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  )),
              ],
            )));
  }

  Widget _headerText() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: const Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Let's get going!",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text("Register an account using the form below",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ))
        ],
      ),
    );
  }

  Widget _registerForm() {
    return Container(
        height: MediaQuery.sizeOf(context).height * 0.60,
        margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.05,
        ),
        child: Form(
            key: _registerFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _pfpSelectionField(),
                CustomFormField(
                    hintText: "Name",
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    validationRegExp: NAME_VALIDATION_REGEX,
                    onSaved: (value) {
                      setState(() {
                        name = value;
                      });
                    }),
                CustomFormField(
                    hintText: "Email",
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    validationRegExp: EMAIL_VALIDATION_REGEX,
                    onSaved: (value) {
                      setState(() {
                        email = value;
                      });
                    }),
                CustomFormField(
                    hintText: "Password",
                    height: MediaQuery.sizeOf(context).height * 0.1,
                    validationRegExp: PASSWORD_VALIDATION_REGEX,
                    obscureText: true,
                    onSaved: (value) {
                      setState(() {
                        password = value;
                      });
                    }),
                _registerButton(),
              ],
            )));
  }

  Widget _pfpSelectionField() {
    return GestureDetector(
      onTap: () async {
        File? file = await _mediaService.getImageFromGallery();
        if (file != null) {
          setState(() {
            selectedImage = file;
          });
        }
      },
      child: CircleAvatar(
        radius: MediaQuery.of(context).size.width * 0.15,
        backgroundImage: selectedImage != null
            ? FileImage(selectedImage!)
            : NetworkImage(PLACEHOLDER_PFP) as ImageProvider,
      ),
    );
  }

  Widget _registerButton() {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: MaterialButton(
        color: Theme.of(context).colorScheme.primary,
        onPressed: () async {
          setState(() {
            isLoading = true;
          });

          try {
            if (_registerFormKey.currentState?.validate() ??
                false) {
              _registerFormKey.currentState?.save();

              bool result = await _authService.signup(email!, password!);

              if (result) {
                 _alertService.showToast(
                  text: "User registered successfully",
                  icon: Icons.check,
                );
                _navigationService.goback();
                _navigationService.pushReplacementNamed("/login");

               await _databaseService.createUserProfile(
                    userProfile: UserProfile(
                  uid: _authService.user!.uid,
                  name: name,
                ));
              }
              else{
                 _alertService.showToast(
              text: "Failed to register, please try again",
              icon: Icons.error,
            );
              }

              print(result);
            }
            setState(() {
            isLoading = false;
          });
          } catch (e) {
            print(e);
          }
          
        },
        child: const Text(
          "Register",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLink() {
    return Expanded(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const Text("Already have an account? "),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => LoginPage(),
  ),);
          },
          child: const Text(
            "Sign In",
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        )
      ],
    ));
  }
}