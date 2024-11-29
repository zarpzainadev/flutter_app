import 'package:flutter/material.dart';
import 'package:flutter_web_android/components/custom_loading.dart';
import 'package:provider/provider.dart';
import 'user_edit_viewmodel.dart';
import 'widgets/edit_form.dart';

class UserEditScreen extends StatefulWidget {
  final int userId;

  const UserEditScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  State<UserEditScreen> createState() => _UserEditScreenState();
}

class _UserEditScreenState extends State<UserEditScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserEditViewModel()..initialize(widget.userId),
      child: Consumer<UserEditViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoading) {
            return Container(
              color: Colors.white,
              child: const Center(child: CustomLoading()),
            );
          }

          if (viewModel.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(viewModel.errorMessage!),
                  ElevatedButton(
                    onPressed: () => viewModel.initialize(widget.userId),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return EditForm(
            initialData: viewModel.currentUser,
            onSave: viewModel.handleUpdateUser,
          );
        },
      ),
    );
  }
}
