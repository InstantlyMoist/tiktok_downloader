import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:tiktokdownloader/clients/custom_client.dart';
import 'package:tiktokdownloader/widgets/download_popup.dart';

class DownloadService {

  static Future<String> getMediaUrl(String shareURL) async {
    var response = await CustomClient(http.Client()).get(shareURL);
    int linkBegin = response.body.indexOf('{"urls":["');
    int linkEnd = response.body.indexOf("]", linkBegin);
    String link = response.body.substring(linkBegin + 10, linkEnd - 1);
    print(link);
    return link;
  }

  //static int _percentage = 0;
  static StreamController<int> controller = StreamController<int>();
  static Stream stream = controller.stream;

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  static Random _rnd = Random();

  static String getRandomString(int length) =>
      String.fromCharCodes(Iterable.generate(
          length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  static void download(String mediaLink, BuildContext context) async {
    showDialog(context: context, child: DownloadPopup(stream));
    print("downloading with link $mediaLink");
    await new Directory("/storage/emulated/0/DCIM/TikTokDownloader").create();
    String randomString = getRandomString(20);
    String finalPath =
        "/storage/emulated/0/DCIM/TikTokDownloader/${randomString}.mp4";
    await Dio().download(mediaLink, finalPath,
        onReceiveProgress: (received, total) {
          controller.add(((received / total) * 100).floor());
          //onProgressChange(((received / total) * 100).floor());
        },
        options: Options(headers: {
          "Host": mediaLink.contains("v16")
              ? "v16-web-newkey.tiktokcdn.com"
              : "v19-web-newkey.tiktokcdn.com",
          "Connection": "keep-alive",
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.121 Safari/537.36",
          "Accept-Encoding": "identity;q=1, *;q=0",
          "Accept": "*/*",
          "Sec-Fetch-Site": "cross-site",
          "Sec-Fetch-Mode": "no-cors",
          "Sec-Fetch-Dest": "video",
          "Referer": "https://www.tiktok.com/foryou/$getRandomString(5)",
          "Accept-Language": "en-US,en;q=0.9",
          "Range": "bytes=0-"
        }));
    await GallerySaver.saveVideo(finalPath);
  }
}
