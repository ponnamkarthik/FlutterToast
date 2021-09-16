package io.github.ponnamkarthik.toast.fluttertoast

import android.app.Activity
import android.app.Application
import android.content.Context
import android.graphics.PorterDuff
import android.graphics.drawable.Drawable
import android.os.Build
import android.view.Gravity
import android.view.LayoutInflater
import android.widget.TextView
import android.widget.Toast
import com.hjq.toast.ToastUtils
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

internal class MethodCallHandlerImpl(var context: Context) : MethodCallHandler {

//    private lateinit var mToast: Toast

    init {
        ToastUtils.init(when (context) {
            is Activity -> (context as Activity).application
            else -> context as Application
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "showToast" -> {
                val mMessage = call.argument<Any>("msg").toString()
                val length = call.argument<Any>("length").toString()
                val gravity = call.argument<Any>("gravity").toString()
                val bgcolor = call.argument<Number>("bgcolor")
                val textcolor = call.argument<Number>("textcolor")
                val textSize = call.argument<Number>("fontSize")
                val mGravity: Int
                mGravity = when (gravity) {
                    "top" -> Gravity.TOP
                    "center" -> Gravity.CENTER
                    else -> Gravity.BOTTOM
                }
                val mDuration: Int
                mDuration = if (length == "long") {
                    Toast.LENGTH_LONG
                } else {
                    Toast.LENGTH_SHORT
                }
                if (bgcolor != null || textcolor != null || textSize != null) {
                    val layout = (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(R.layout.toast_custom, null)
                    val text = layout.findViewById<TextView>(R.id.text)
                    text.text = mMessage

                    val gradientDrawable: Drawable = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        context.getDrawable(R.drawable.corner)!!
                    } else {
                        context.resources.getDrawable(R.drawable.corner)
                    }
                    if (bgcolor != null && gradientDrawable != null) {
                        gradientDrawable.setColorFilter(bgcolor.toInt(), PorterDuff.Mode.SRC_ATOP)
                    }
                    text.background = gradientDrawable
                    if (textSize != null) {
                        text.textSize = textSize.toFloat()
                    }
                    if (textcolor != null) {
                        text.setTextColor(textcolor.toInt())
                    }
//                    mToast = Toast(context)
//                    mToast.setDuration(mDuration)
//                    mToast.setView(layout)
//                    mToast = ToastUtils.getToast()
//                    mToast.duration = mDuration
//                    mToast.view = layout
                    ToastUtils.setView(R.layout.toast_custom)
                    //        ToastUtils.getToast().setDuration(Toast.LENGTH_SHORT);
                    ToastUtils.setGravity(Gravity.BOTTOM or Gravity.CENTER_HORIZONTAL, 0, 200)
                } else {
//                    mToast = Toast.makeText(context, mMessage, mDuration)
//                    mToast = ToastUtils.getToast()
//                    mToast.setText(mMessage)
//                    mToast.duration = mDuration
                }
                if (mGravity == Gravity.CENTER) {
//                    mToast.setGravity(mGravity, 0, 0)
                    ToastUtils.setGravity(mGravity, 0, 0)
                } else if (mGravity == Gravity.TOP) {
//                    mToast.setGravity(mGravity, 0, 100)
                    ToastUtils.setGravity(mGravity, 0, 100)
                } else {
//                    mToast.setGravity(mGravity, 0, 100)
                    ToastUtils.setGravity(mGravity, 0, 100)
                }
                if (context is Activity) {
                    (context as Activity).runOnUiThread {
                        ToastUtils.show(mMessage)
                    }
                } else {
                    ToastUtils.show(mMessage)
                }
                result.success(true)
            }
            "cancel" -> {
                if (ToastUtils.isInit()) {
                    ToastUtils.cancel()
                }
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }
}