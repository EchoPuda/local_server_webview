HttpServer 对于Webview预加载、拦截替换资源的Flutter实现。优化Webview的首次加载时间、白屏时间。

## Pub get
```yaml
  local_server_for_webview:
    git:
      url: https://github.com/EchoPuda/local_server_webview.git
```
## Usage

继承LocalServerClientManager, 初始化并配置载入LocalServerClientConfig，最后在合适的时机startLocalServer()
```dart
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
```

在WebView页面中，绑定LocalServerCacheBinder到Manager中。然后获取转换后的LocalServerUrl，最后由WebView加载展示。
```dart
class _WebPageState extends State<WebPage> {

  // Local server 管理
  late LocalServerCacheBinder _localServerBuilder;
  WebViewController? webViewController;
  String _innerUrl = '';
  String _title = '';

  @override
  void initState() {
    super.initState();
    log('页面开始加载：${DateTime.now()}', name: 'web-time');
    _localServerBuilder = LocalServerCacheBinder()..initBinder();
    LocalServerWebViewManager.instance.registerBuilder(_localServerBuilder);
    _innerUrl = _localServerBuilder.convertH5Url2LocalServerUrl(widget.url);
  }

  @override
  void dispose() {
    LocalServerWebViewManager.instance.resignBuilder(_localServerBuilder);
    _localServerBuilder.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _title,
        ),
      ),
      body: WebView(
        initialUrl: _innerUrl,
        debuggingEnabled: true,
        onPageStarted: (url) {
          print("onPageStarted($url) ----------------------");
          log('Web开始加载：${DateTime.now()}', name: 'web-time');
        },
        onPageFinished: (url) {
          print("onPageFinished($url) ----------------------");
          log('Web加载完成：${DateTime.now()}', name: 'web-time');
        },
        onWebViewCreated: (controller) async {
          webViewController = controller;
          webViewController!.getTitle().then((value) {
            setState(() {
              _title = value ?? '';
            });
          });
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
```

在不用的时候记得关闭LocalServer

