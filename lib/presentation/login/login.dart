import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testeur/presentation/login/viewmodel/login_view_model.dart';
import '../ressources/routes_manager.dart';
import '../ressources/colors_manager.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'widgets/login_widgets.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginViewModel = LoginViewModel(context.read<AuthBloc>());

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ColorManager.gradientStart,
              ColorManager.gradientEnd,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              getContentWidget(context, loginViewModel),
              const SizedBox(height: 20),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.error}')),
                    );
                  } else if (state is AuthSuccess) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
                    });
                  } else if (state is AuthClearError) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const CircularProgressIndicator();
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}