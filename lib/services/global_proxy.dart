
import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';


class ProxyConfig {
  final bool enabled;
  final String? host;
  final int? port;
  final String? username;
  final String? password;

  const ProxyConfig({
    this.enabled = false,
    this.host,
    this.port,
    this.username,
    this.password,
  });

  bool get isValid => enabled && host != null && host!.isNotEmpty && port != null;

  bool get hasCredentials => username?.isNotEmpty == true && password?.isNotEmpty == true;
}

class GlobalProxyHttpOverrides extends HttpOverrides {
  final ProxyConfig proxyConfig;

  GlobalProxyHttpOverrides({
    required this.proxyConfig,
  });

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    if(kIsWeb){
      return newUniversalHttpClient();
    }
    final client = super.createHttpClient(context);

    if (!kIsWeb) {
      if (!proxyConfig.isValid) return client as HttpClient;

      client.findProxy = (uri) => 'PROXY ${proxyConfig.host}:${proxyConfig.port}';
      client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      if (proxyConfig.hasCredentials) {
        client.addProxyCredentials(
          proxyConfig.host!,
          proxyConfig.port!,
          'Proxy Realm',
          HttpClientBasicCredentials(proxyConfig.username!, proxyConfig.password!,),
        );
      }
    }

    return client as HttpClient;
  }
}