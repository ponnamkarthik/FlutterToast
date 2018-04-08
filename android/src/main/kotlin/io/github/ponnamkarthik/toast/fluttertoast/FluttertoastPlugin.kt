package io.github.ponnamkarthik.toast.fluttertoast

import android.content.Context
import android.util.Log
import android.widget.Toast
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar

class FluttertoastPlugin(context: Context): MethodCallHandler {

  var ctx: Context? = context

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar): Unit {
      val channel = MethodChannel(registrar.messenger(), "PonnamKarthik/fluttertoast")

      channel.setMethodCallHandler(FluttertoastPlugin(registrar.context()))
    }
  }


  override fun onMethodCall(call: MethodCall, result: Result): Unit {

    if (call.method.equals("showToast")) {
      val msg: String = call.argument("msg")
      val length: String = call.argument("length")

      if(length.equals("long")) {
        Toast.makeText(ctx, msg, Toast.LENGTH_LONG).show()
      } else {
        Toast.makeText(ctx, msg, Toast.LENGTH_SHORT).show()
      }

      result.success("Success")
    } else {
      result.notImplemented()
    }
  }
}
