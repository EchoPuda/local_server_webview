import 'package:flutter_test/flutter_test.dart';

import 'package:local_server_for_webview/local_server_for_webview.dart';

void main() {
  test('start local server', () async {
    var server = await LocalServerService.instance.startServer('127.0.0.1', 0);
    String res = LocalServerService.instance.getLocalServerWebUrl('', '/test/index.html');
    expect(res, 'http://127.0.0.1:${server.port}/test/index.html');
  });

  test('close local server', () {
    LocalServerService.instance.closeServer();
  });
}
