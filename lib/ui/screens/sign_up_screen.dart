import 'package:flutter/material.dart';

import 'package:book_shelf/generated/i10n/app_localizations.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context)!.registerImplemented),
      ),
    );
  }
}
