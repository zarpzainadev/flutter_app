import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:provider/provider.dart';
import 'user_register_viewmodel.dart';
import 'widgets/register_form.dart';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({Key? key}) : super(key: key);

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRegisterViewModel(),
      child: Scaffold(
        body: Stack(
          children: [
            const RegisterForm(),
            if (_isLoading)
              Container(
                color: Colors.white.withOpacity(0.8),
                child: const CustomLoading(),
              ),
          ],
        ),
      ),
    );
  }
}
