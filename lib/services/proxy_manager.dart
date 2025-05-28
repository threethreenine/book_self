import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'global_proxy.dart';


class ProxyManager extends ChangeNotifier {
  static const _proxyEnabledKey = 'proxy_enabled';
  static const _proxyHostKey = 'proxy_host';
  static const _proxyPortKey = 'proxy_port';
  static const _proxyUserKey = 'proxy_username';
  static const _proxyPassKey = 'proxy_password';

  final SharedPreferences _prefs;

  ProxyManager(this._prefs);

  ProxyConfig get currentConfig => ProxyConfig(
    enabled: _prefs.getBool(_proxyEnabledKey) ?? false,
    host: _prefs.getString(_proxyHostKey),
    port: _prefs.getInt(_proxyPortKey),
    username: _prefs.getString(_proxyUserKey),
    password: _prefs.getString(_proxyPassKey),
  );

  static Future<ProxyManager> create(SharedPreferences prefs) async {
    final instance = ProxyManager(prefs);
    instance._applyGlobalProxy(instance.currentConfig);
    return instance;
  }

  Future<void> updateConfig(ProxyConfig config) async {
    await _prefs.setBool(_proxyEnabledKey, config.enabled);

    if (config.host != null) {
      await _prefs.setString(_proxyHostKey, config.host!);
    }

    if (config.port != null) {
      await _prefs.setInt(_proxyPortKey, config.port!);
    }

    // 可选保存认证信息
    await _prefs.setString(_proxyUserKey, config.username ?? '');
    await _prefs.setString(_proxyPassKey, config.password ?? '');

    _applyGlobalProxy(config);
    notifyListeners();
  }

  void _applyGlobalProxy(ProxyConfig config) {
    if (config.enabled && config.isValid && !kIsWeb) {
      HttpOverrides.global = GlobalProxyHttpOverrides(
        proxyConfig: config,
      );
    } else {
      HttpOverrides.global = null;
    }
  }

  HttpClient createProxiedClient() {
    final config = currentConfig;
    if (!config.isValid) return HttpClient();

    final client = HttpClient()
      ..findProxy = (uri) => 'PROXY ${config.host}:${config.port}';
    client.badCertificateCallback = (cert, host, port) => true;

    if (config.hasCredentials) {
      client.addProxyCredentials(
        config.host!,
        config.port!,
        'Proxy Realm',
        HttpClientBasicCredentials(config.username!, config.password!),
      );
    }

    return client;
  }

  Future<bool> testConnection() async {
    final client = createProxiedClient();
    try {
      final request = await client.getUrl(Uri.parse('https://www.google.com'));
      final response = await request.close();
      debugPrint('Response status code: ${response.statusCode}');
      return true;
    } on HandshakeException catch (e) {
      debugPrint('SSL handshake failed: ${e.message}');
      return false;
    } on SocketException catch (e) {
      debugPrint('Network connection failed: ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Unknown error: $e');
      return false;
    } finally {
      client.close(force: true);
    }
  }
}