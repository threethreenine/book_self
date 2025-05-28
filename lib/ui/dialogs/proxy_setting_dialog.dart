import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:book_shelf/services/global_proxy.dart';
import 'package:book_shelf/services/proxy_manager.dart';

import 'package:book_shelf/generated/i10n/app_localizations.dart';


class ProxySettingsDialog extends StatefulWidget {
  const ProxySettingsDialog({super.key});

  @override
  State<ProxySettingsDialog> createState() => _ProxySettingsDialogState();
}

class _ProxySettingsDialogState extends State<ProxySettingsDialog> {
  final _hostController = TextEditingController();
  final _portController = TextEditingController();
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _enabled = false;
  bool _testing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCurrentConfig();
  }

  void _loadCurrentConfig() {
    final proxyManager = Provider.of<ProxyManager>(context, listen: false);
    final config = proxyManager.currentConfig;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _enabled = config.enabled;
        _hostController.text = config.host ?? '';
        _portController.text = config.port?.toString() ?? '';
        _userController.text = config.username ?? '';
      });
    });
  }

  Future<void> _saveConfig() async {
    final port = int.tryParse(_portController.text);
    await context.read<ProxyManager>().updateConfig(
      ProxyConfig(
        enabled: _enabled,
        host: _hostController.text,
        port: port,
        username: _userController.text,
        password: _passController.text,
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.networkAgentSettings),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.enableProxyServer),
              value: _enabled,
              onChanged: (v) => setState(() => _enabled = v),
            ),
            if (_enabled) ...[
              _buildProxyAddressFields(),
              const SizedBox(height: 16),
              _buildAuthFields(),
              const SizedBox(height: 16),
              _buildTestButton(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        ElevatedButton(
          onPressed: _enabled && _validateForm() ? _saveConfig : null,
          child: Text(AppLocalizations.of(context)!.saveConfiguration),
        ),
      ],
    );
  }

  Widget _buildProxyAddressFields() {
    return Column(
      children: [
        TextFormField(
          controller: _hostController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.proxyAddress,
            hintText: 'proxy.example.com',
          ),
          validator: (v) => v?.isEmpty ?? true ? AppLocalizations.of(context)!.proxyAddressTip : null,
        ),
        TextFormField(
          controller: _portController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.proxyPort,
            hintText: '8080',
          ),
          keyboardType: TextInputType.number,
          validator: (v) => _validatePort(v),
        ),
      ],
    );
  }

  Widget _buildAuthFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppLocalizations.of(context)!.authenticationOptional,
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        TextFormField(
          controller: _userController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.userName,
            hintText: AppLocalizations.of(context)!.optional,
          ),
        ),
        TextFormField(
          controller: _passController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.password,
            hintText: AppLocalizations.of(context)!.optional,
          ),
        ),
      ],
    );
  }

  Widget _buildTestButton() {

    return ElevatedButton.icon(
      icon: _testing
          ? const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      )
          : const Icon(Icons.wifi_tethering),
      label: Text(AppLocalizations.of(context)!.testConnection),
      onPressed: _testing ? null : _testConnection,
    );
  }

  bool _validateForm() {
    return _hostController.text.isNotEmpty &&
        _validatePort(_portController.text) == null;
  }

  String? _validatePort(String? value) {
    if (value?.isEmpty ?? true) return AppLocalizations.of(context)!.proxyPortTip;
    if (int.tryParse(value!) == null) return AppLocalizations.of(context)!.figuresTip;
    if (int.parse(value) <= 0 || int.parse(value) > 65535) {
      return AppLocalizations.of(context)!.portInvalidTip;
    }
    return null;
  }

  Future<void> _testConnection() async {
    setState(() => _testing = true);
    final success = await context.read<ProxyManager>().testConnection();
    setState(() => _testing = false);

    if (!mounted) return;

    final snackBar = SnackBar(
      content: Text(success ? AppLocalizations.of(context)!.connectionTestSuccessful : AppLocalizations.of(context)!.connectionTestFailed),
      backgroundColor: success ? Colors.green : Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}