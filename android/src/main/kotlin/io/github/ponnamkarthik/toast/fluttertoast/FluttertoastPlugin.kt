package io.github.ponnamkarthik.toast.fluttertoast

import android.content.Context
import android.util.Log
import android.view.Gravity
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
        val gravity: String = call.argument("gravity")

        var toast: Toast = Toast.makeText(ctx, msg, Toast.LENGTH_SHORT);

      if(length.equals("long")) {
          toast.duration = Toast.LENGTH_LONG
      } else {
          toast.duration = Toast.LENGTH_SHORT
      }

        if(gravity.equals("top")) {
            toast.setGravity(Gravity.TOP, 0, 100)
        } else if(gravity.equals("center")) {
            toast.setGravity(Gravity.CENTER, 0, 0)
        } else {
            toast.setGravity(Gravity.BOTTOM, 0, 100)
        }

        toast.show()

      result.success("Success")
    } else {
      result.notImplemented()
    }
  }
}
