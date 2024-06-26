import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider, GoogleAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart' as gua;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ubuntu_system/Provider/authentication_provider.dart';
import 'package:ubuntu_system/View/Screens/Intial/account_creation.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            try {
              if (!snapshot.hasData) {
                return RegisterScreen(
                  headerBuilder: (context, constraints, _) {
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.network(
                          "https://th.bing.com/th/id/OIP.ep0z0M7rJpK14WuGshv3EwHaEK?rs=1&pid=ImgDetMain",
                        ),
                      ),
                    );
                  },
                  providers: [
                    EmailAuthProvider(),
                    PhoneAuthProvider(),
                    gua.GoogleProvider(clientId: "")
                  ],
                  subtitleBuilder: (context, action) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        action == AuthAction.signIn
                            ? 'Welcome to Ubuntu! Please sign in to continue.'
                            : 'Welcome to Ubuntu, Please create an account to continue',
                      ),
                    );
                  },
                );
              }
              context.read<AuthenticationProvider>().assignUser(snapshot.data!);
              return const AccountCreation();
            } catch (e) {
              debugPrint("User Authentication Error $e");
              return const Placeholder();
            }
          },
        ));
  }
}
