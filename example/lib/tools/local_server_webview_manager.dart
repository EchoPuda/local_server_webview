import 'package:local_server_for_webview/local_server_for_webview.dart';

class LocalServerWebViewManager extends LocalServerClientManager {

  factory LocalServerWebViewManager() => _getInstance();

  static LocalServerWebViewManager get instance => _getInstance();
  static LocalServerWebViewManager? _instance;

  static LocalServerWebViewManager _getInstance() {
    _instance ??= LocalServerWebViewManager._internal();
    return _instance!;
  }

  LocalServerWebViewManager._internal();

  /// 测试的配置
  void initSetting() {
    init();
    LocalServerCacheBinderSetting.instance.setBaseHost('https://jomin-web.web.app');
    Map<String, dynamic> baCache = {'common': {'compress': '/local-server/common.zip', "version": "20220503"}};
    LocalServerClientConfig localServerClientConfig = LocalServerClientConfig.fromJson({
      'option': [{'key': 'test-one', 'open': 1, 'priority': 0, "version": "20220503"}],
      'assets': {
        'test-one': {'compress': '/local-server/test-one.zip'}
      },
      'basics': baCache,
    });
    prepareManager(localServerClientConfig);
    startLocalServer();
  }

}