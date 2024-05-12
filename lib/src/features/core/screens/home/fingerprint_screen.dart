import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FingerprintScreen extends StatefulWidget {
  const FingerprintScreen({super.key});

  @override
  State<FingerprintScreen> createState() => _FingerprintScreenState();
}

class _FingerprintScreenState extends State<FingerprintScreen> {

  late SharedPreferences _prefs;
  bool _passcodeEnabled = false;
  Future<void> _loadPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _passcodeEnabled = _prefs.getBool('passcodeEnabled') ?? true;
    });
  }
  Future<void> _togglePasscode(bool value) async {
    setState(() {
      _passcodeEnabled = value;
    });

    await _prefs.setBool('passcodeEnabled', value);

    if (value) {
      print('Passcode turned ON');
      /// is passcode on perform operation here
      String result = await _authenticate();
      print("Result: $result");
      if(result == "true"){
        await _prefs.setBool('passcodeEnabled', true);
      } else {
        await _prefs.setBool('passcodeEnabled', false);
        setState(() {
          _passcodeEnabled = false;
        });
      }
    } else {
      print('Passcode turned OFF');
      /// passcode turn of operations here
      await _prefs.setBool('passcodeEnabled', false);
    }
  }

  late final LocalAuthentication auth;
  bool _supportState = false;

  Future<void> currentState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool passcodeEnabled = prefs.getBool('passcodeEnabled') ?? false;
    print('Passcode Enabled: $passcodeEnabled');
  }

  @override
  void initState() {
    super.initState();
    currentState();

    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
          (bool isSupported) => setState(() {
            _supportState = isSupported;
          }),
        );
    _loadPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Passcode".toUpperCase()),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Passcode or Fingerprint',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Switch(
                    value: _passcodeEnabled,
                    onChanged: _togglePasscode,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.green,
                  ),
                ],
              ),
              // if (_supportState)
              //   const Text("Device is supported")
              // else
              //   const Text("This device is not supported"),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _getAvailableBiometrics,
              //   child: const Text("Get Available Biometrics"),
              // ),
              // const SizedBox(height: 20),
              // ElevatedButton(
              //   onPressed: _authenticate,
              //   child: const Text("Authenticate"),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> _getAvailableBiometrics() async {
  //   List<BiometricType> availableBiometrics =
  //       await auth.getAvailableBiometrics();
  //   print("List of available biometrics: $availableBiometrics");
  //
  //   if (!mounted) {
  //     return;
  //   }
  // }

  Future<String> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
        localizedReason: "Subscribe or you will never find any stack overflow error",
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      print("Authenticated: $authenticated");
      return authenticated.toString();
    } on PlatformException catch (e) {
      print(e);
    }

    return "false";
  }
}
