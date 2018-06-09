package io.github.ponnamkarthik.toast.fluttertoast

import android.content.Context
import android.util.Log
import android.view.Gravity
import android.widget.Toast
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.Drawable
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.widget.TextView
import android.graphics.Paint
import android.graphics.drawable.ShapeDrawable
import android.graphics.drawable.shapes.RoundRectShape





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
        val bgcolor: String = call.argument("bgcolor")
        val textcolor: String = call.argument("textcolor")

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

        val text: TextView = toast.view.findViewById(android.R.id.message)
        if(bgcolor != "null") {

            try {

                val rectShape = RoundRectShape(floatArrayOf(50f, 50f, 50f, 50f, 50f, 50f, 50f, 50f), null, null)

                val shapeDrawable = ShapeDrawable(rectShape)
                shapeDrawable.paint.color = Color.parseColor(bgcolor)
                shapeDrawable.paint.style = Paint.Style.FILL
                shapeDrawable.paint.isAntiAlias = true
                shapeDrawable.paint.flags = Paint.ANTI_ALIAS_FLAG

                text.setBackgroundDrawable(shapeDrawable)
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }
        if(textcolor != "null") {
            try {
                text.setTextColor(Color.parseColor(textcolor))
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        toast.show()

      result.success("Success")
    } else {
      result.notImplemented()
    }
  }
}
