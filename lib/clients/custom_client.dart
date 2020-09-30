import 'package:http/http.dart' as http;

class CustomClient extends http.BaseClient {

  final http.Client _client;

  CustomClient(this._client);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    request.followRedirects = true;
    request.headers['user-agent'] = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36';
    return _client.send(request);
  }
}