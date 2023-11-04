import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: 'lib/env/.env', obfuscate: true)
abstract class Env {
  @EnviedField(varName: 'FOREX_API_KEY', obfuscate: true)
  static final String forexApiKey = _Env.forexApiKey;

  @EnviedField(varName: 'FOREX_API_URL', obfuscate: true)
  static final String forexApiUrl = _Env.forexApiUrl;

  @EnviedField(varName: 'FOREX_API_ENDPOINT', obfuscate: true)
  static final String forexApiEndpoint = _Env.forexApiEndpoint;

  @EnviedField(varName: 'NEWS_API_KEY', obfuscate: true)
  static final String newsApiKey = _Env.newsApiKey;

  @EnviedField(varName: 'NEWS_API_URL', obfuscate: true)
  static final String newsApiUrl = _Env.newsApiUrl;

  @EnviedField(varName: 'NEWS_API_ENDPOINT', obfuscate: true)
  static final String newsApiEndpoint = _Env.newsApiEndpoint;
}
