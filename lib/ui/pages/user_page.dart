import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_shelf/providers/settings/locale_provider.dart';
import 'package:book_shelf/providers/settings/theme_provider.dart';
import 'package:book_shelf/generated/i10n/app_localizations.dart';

import 'package:book_shelf/ui/dialogs/proxy_setting_dialog.dart';


class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final locale = Provider.of<LocaleProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: ListView(
        children: [
          _buildThemeSection(context, theme, localizations),
          _buildLanguageSection(context, locale, localizations),
          buildProxySettingDialog(context),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context, ThemeProvider theme, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(localizations.darkMode, style: Theme.of(context).textTheme.titleMedium),
        ),
        RadioListTile<ThemeMode>(
          title: Text(localizations.systemDefault),
          value: ThemeMode.system,
          groupValue: theme.themeMode,
          onChanged: (value) => theme.toggleTheme(value!),
        ),
        RadioListTile<ThemeMode>(
          title: Text(localizations.lightMode),
          value: ThemeMode.light,
          groupValue: theme.themeMode,
          onChanged: (value) => theme.toggleTheme(value!),
        ),
        RadioListTile<ThemeMode>(
          title: Text(localizations.darkMode),
          value: ThemeMode.dark,
          groupValue: theme.themeMode,
          onChanged: (value) => theme.toggleTheme(value!),
        ),
      ],
    );
  }

  Widget _buildLanguageSection(BuildContext context, LocaleProvider locale, AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(localizations.language, style: Theme.of(context).textTheme.titleMedium),
        ),
        RadioListTile<Locale>(
          title: Text(localizations.english),
          value: const Locale('en'),
          groupValue: locale.locale,
          onChanged: (value) => locale.setLocale(value!),
        ),
        RadioListTile<Locale>(
          title: Text(localizations.chinese),
          value: const Locale('zh'),
          groupValue: locale.locale,
          onChanged: (value) => locale.setLocale(value!),
        ),
      ],
    );
  }

  Widget buildProxySettingDialog(context){
    return ElevatedButton(
      onPressed: () => showDialog(
        context: context,
        builder: (_) => const ProxySettingsDialog(),
      ),
      child: Text(AppLocalizations.of(context)!.setProxy),
    );
  }
}