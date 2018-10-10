package io.github.ponnamkarthik.toast.fluttertoast

import android.content.Context
import android.graphics.Color
import android.graphics.Paint
import android.graphics.drawable.ColorDrawable
import android.graphics.drawable.ShapeDrawable
import android.graphics.drawable.shapes.RoundRectShape
import android.view.Gravity
import android.widget.TextView
import android.widget.Toast
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar
import android.util.Log


class FluttertoastPlugin(context: Context) : MethodCallHandler {

    var ctx: Context? = context


    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar): Unit {
            val channel = MethodChannel(registrar.messenger(), "PonnamKarthik/fluttertoast")
            channel.setMethodCallHandler(FluttertoastPlugin(registrar.context()))
        }
    }

    var defaultTextColor: Int = Color.TRANSPARENT

    override fun onMethodCall(call: MethodCall, result: Result): Unit {

        if (call.method == "showToast") {

            val msg = call.argument<String>("msg")
            val length = call.argument<String>("length")
            val gravity = call.argument<String>("gravity")
            val bgcolor = call.argument<String>("bgcolor")
            val textcolor = call.argument<String>("textcolor")

            val toast: Toast = Toast.makeText(ctx, msg, Toast.LENGTH_SHORT);
            toast.setText(msg)
            if (length.equals("long")) {
                toast.duration = Toast.LENGTH_LONG
            } else {
                toast.duration = Toast.LENGTH_SHORT
            }

            when (gravity) {
                "top" -> toast.setGravity(Gravity.TOP, 0, 100)
                "center" -> toast.setGravity(Gravity.CENTER, 0, 0)
                else -> toast.setGravity(Gravity.BOTTOM, 0, 100)
            }

            val text: TextView = toast.view.findViewById(android.R.id.message)
            if (defaultTextColor == 0) {
                defaultTextColor = text.currentTextColor
            }
            if (bgcolor != "null") {

                try {

                    val rectShape = RoundRectShape(floatArrayOf(50f, 50f, 50f, 50f, 50f, 50f, 50f, 50f), null, null)

                    val shapeDrawable = ShapeDrawable(rectShape)
                    shapeDrawable.paint.color = Color.parseColor(bgcolor)
                    shapeDrawable.paint.style = Paint.Style.FILL
                    shapeDrawable.paint.isAntiAlias = true
                    shapeDrawable.paint.flags = Paint.ANTI_ALIAS_FLAG

                    toast.view.setBackgroundDrawable(shapeDrawable)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            } else {
                text.setBackgroundDrawable(ColorDrawable(Color.TRANSPARENT))
            }
            if (textcolor != "null") {
                try {
                    text.setTextColor(Color.parseColor(textcolor))
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            } else {
                text.setTextColor(defaultTextColor)
            }

            toast.show()

            result.success("Success")
        } else {
            result.notImplemented()
        }
    }
}
