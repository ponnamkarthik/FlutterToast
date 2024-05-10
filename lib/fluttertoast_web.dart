import 'dart:async';
import 'package:web/web.dart' as web;
import 'dart:ui_web' as ui;
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Plugin Class to show a toast message on screen for web
class FluttertoastWebPlugin {
  /// Constructor class
  /// which calls the metohd to inject JS and CSS in to dom
  FluttertoastWebPlugin() {
    injectCssAndJSLibraries();
  }

  /// Registers [MethodChannel] used to communicate with the platform side.
  static void registerWith(Registrar registrar) {
    final MethodChannel channel = MethodChannel(
        'PonnamKarthik/fluttertoast', const StandardMethodCodec(), registrar);
    final FluttertoastWebPlugin instance = FluttertoastWebPlugin();
    channel.setMethodCallHandler(instance.handleMethodCall);
  }

  /// Handle Method Callbacks from [MethodChannel].
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

  /// showToast which parses the required arguments and pass
  /// it to [addHtmlToast]
  showToast(args) {
    String msg = args['msg'];
    String? gravity = "top";
    if (args['gravity'] == "top" || args['gravity'] == "bottom") {
      gravity = args["gravity"];
    }

    String position = args['webPosition'] ?? 'right';

    String bgColor =
        args['webBgColor'] ?? "linear-gradient(to right, #00b09b, #96c93d)";

    int? textColor = args['textcolor'];

    int time = args['time'] == null
        ? 3000
        : (int.parse(args['time'].toString()) * 1000);

    bool showClose = args['webShowClose'] ?? false;

    addHtmlToast(
        msg: msg,
        gravity: gravity,
        position: position,
        bgcolor: bgColor,
        showClose: showClose,
        time: time,
        textColor: textColor);
  }

  /// [injectCssAndJSLibraries] which add the JS and CSS files into DOM
  Future<void> injectCssAndJSLibraries() async {
    final List<Future<void>> loading = <Future<void>>[];
    final List<web.HTMLElement> tags = <web.HTMLElement>[];

    final cssUrl = ui.assetManager.getAssetUrl(
      'packages/fluttertoast/assets/toastify.css',
    );
    final web.HTMLLinkElement css = web.HTMLLinkElement()
      ..id = 'toast-css'
      ..setAttribute("rel", "stylesheet")
      ..href = cssUrl;
    tags.add(css);

    final jsUrl = ui.assetManager.getAssetUrl(
      'packages/fluttertoast/assets/toastify.js',
    );
    final web.HTMLScriptElement script = web.HTMLScriptElement()
      ..async = true
      // ..defer = true
      ..src = jsUrl;
    loading.add(script.onLoad.first);
    tags.add(script);
    for (final web.HTMLElement tag in tags) {
      web.document.querySelector('head')!.append(tag);
    }

    await Future.wait(loading);
  }

  /// injects Final [Toastify] code with all the parameters to
  /// make toast visible on web
  addHtmlToast(
      {String msg = "",
      String? gravity = "top",
      String position = "right",
      String bgcolor = "linear-gradient(to right, #00b09b, #96c93d)",
      int time = 3000,
      bool showClose = false,
      int? textColor}) {
    String m = msg.replaceAll("'", "\\'").replaceAll("\n", "<br />");
    web.Element? ele = web.document.querySelector("#toast-content");
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
    if (web.document.querySelector("#toast-content") != null) {
      ele!.remove();
    }
    final web.HTMLScriptElement scriptText = web.HTMLScriptElement()
      ..id = "toast-content"
      ..innerHTML = content;
    web.document.body!.append(scriptText);
    if (textColor != null) {
      web.Element toast = web.document.querySelector('.toastify')!;
      String tcRadix = textColor.toRadixString(16);
      final String tC = "${tcRadix.substring(2)}${tcRadix.substring(0, 2)}";
      final style = toast.getAttribute('style') ?? '';
      toast.setAttribute('style', '$style color: #$tC;');
    }
  }
}
