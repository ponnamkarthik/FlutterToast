import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

class FluttertoastWebPlugin {
  FluttertoastWebPlugin() {
    injectCssAndJSLibraries();
  }

  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel('PonnamKarthik/fluttertoast', const StandardMethodCodec(), registrar.messenger);
    final FluttertoastWebPlugin instance = FluttertoastWebPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'showToast':
        showToast(call.arguments);
        return true;
      default:
        throw PlatformException(
            code: 'Unimplemented',
            details: "The fluttertoast plugin for web doesn't implement "
                "the method '${call.method}'");
    }
  }

  showToast(args) {
    String msg = args['msg'];
    String gravity = "top";
    if (args['gravity'] == "top" || args['gravity'] == "bottom") {
      gravity = args["gravity"];
    }

    String position = args['webPosition'] ?? 'right';

    String bgColor = args['webBgColor'] ?? "linear-gradient(to right, #00b09b, #96c93d)";

    int textColor = args['textcolor'];

    int time = args['time'] == null ? 3000 : (int.parse(args['time'].toString()) * 1000);

    bool showClose = args['webShowClose'] ?? false;

    addHtmlToast(msg: msg, gravity: gravity, position: position, bgcolor: bgColor, showClose: showClose, time: time, textColor: textColor);
  }

  Future<void> injectCssAndJSLibraries() async {
    final List<Future<void>> loading = <Future<void>>[];
    final List<html.HtmlElement> tags = <html.HtmlElement>[];

    final html.LinkElement css = html.LinkElement()
      ..id = 'toast-css'
      ..attributes = {
        "rel": "stylesheet"
      }
      ..href = 'assets/packages/fluttertoast/assets/toastify.css';
    tags.add(css);

    final html.ScriptElement script = html.ScriptElement()
      ..async = true
      // ..defer = true
      ..src = "assets/packages/fluttertoast/assets/toastify.js";
    loading.add(script.onLoad.first);
    tags.add(script);
    html.querySelector('head').children.addAll(tags);

    await Future.wait(loading);
  }

  addHtmlToast(
      {String msg = "",
      String gravity = "top",
      String position = "right",
      String bgcolor = "linear-gradient(to right, #00b09b, #96c93d)",
      int time = 3000,
      bool showClose = false,
      int textColor}) {
    String m = msg.replaceAll("'", "\\'").replaceAll("\n", "<br />");
    html.Element ele = html.querySelector("#toast-content");
    String content = """
          var toastElement = Toastify({
            text: '$m',
            gravity: '$gravity',
            position: '$position',
            duration: $time,
            close: $showClose,
            backgroundColor: "$bgcolor",
          });
          toastElement.showToast();
        """;
    if (html.querySelector("#toast-content") != null) {
      ele.remove();
    }
    final html.ScriptElement scriptText = html.ScriptElement()
      ..id = "toast-content"
      ..innerHtml = content;
    html.querySelector('head').children.add(scriptText);
    if (textColor != null) {
      html.Element toast = html.querySelector('.toastify');
      String tcRadix = textColor.toRadixString(16);
      final String tC = "${tcRadix.substring(2)}${tcRadix.substring(0, 2)}";
      toast.style.setProperty('color', "#$tC");
    }
  }
}
