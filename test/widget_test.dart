import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/login_bloc/login_bloc.dart';
import 'package:recipe_app/ui/screens/login_and_register/login_form.dart';
import 'package:recipe_app/ui/screens/login_and_register/login_page.dart';

void main() {
  testWidgets('LoginPage renders correctly and handles interactions',
      (tester) async {
    final authenticationRepository = AuthenticationRepository();

    await tester.pumpWidget(
      MaterialApp(
        home: MultiProvider(
          providers: [
            Provider<AuthenticationRepository>.value(
                value: authenticationRepository),
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(
                  authenticationRepository:
                      context.read<AuthenticationRepository>()),
            ),
          ],
          child: const LoginPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // LoginPage to'g'ri yuklanganligini tekshirish
    expect(find.byType(LoginForm), findsOneWidget);

    // ElevatedButton topilganligini tekshirish
    expect(find.byType(ElevatedButton), findsOneWidget);

    // ElevatedButtonni bosish
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

  });

}
