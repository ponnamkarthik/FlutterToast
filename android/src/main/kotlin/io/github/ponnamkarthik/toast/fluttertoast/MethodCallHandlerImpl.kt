package io.github.ponnamkarthik.toast.fluttertoast

import android.app.Activity
import android.content.Context
import android.graphics.PorterDuff
import android.graphics.drawable.Drawable
import android.os.Build
import android.os.Handler
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowInsets
import android.view.inputmethod.InputMethodManager
import android.widget.TextView
import android.widget.Toast
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import kotlin.Exception

internal class MethodCallHandlerImpl(var context: Context) : MethodCallHandler {

    private lateinit var mToast: Toast

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

                if (bgcolor != null && Build.VERSION.SDK_INT <= 31) {
                    val layout = (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater).inflate(R.layout.toast_custom, null)
                    val text = layout.findViewById<TextView>(R.id.text)
                    text.text = mMessage

                    val gradientDrawable: Drawable = if (Build.VERSION.SDK_INT >= 21) {
                        context.getDrawable(R.drawable.corner)!!
                    } else {
                        context.resources.getDrawable(R.drawable.corner)
                    }
                    if (bgcolor != null) {
                        gradientDrawable.setColorFilter(bgcolor.toInt(), PorterDuff.Mode.SRC_IN)
                    }
                    text.background = gradientDrawable
                    if (textSize != null) {
                        text.textSize = textSize.toFloat()
                    }
                    if (textcolor != null) {
                        text.setTextColor(textcolor.toInt())
                    }
                    mToast = Toast(context)
                    mToast.duration = mDuration
                    mToast.view = layout
                } else {
                    mToast = Toast.makeText(context, mMessage, mDuration)
                    if (Build.VERSION.SDK_INT <= 31) {
                        try {
                            val textView: TextView = mToast.view!!.findViewById(android.R.id.message)
                            if (textSize != null) {
                                textView.textSize = textSize.toFloat()
                            }
                            if (textcolor != null) {
                                textView.setTextColor(textcolor.toInt())
                            }
                        } catch (e: Exception) {

                        }
                    }
                }
                if(Build.VERSION.SDK_INT <= 31) {
                    when (mGravity) {
                        Gravity.CENTER -> {
                            mToast.setGravity(mGravity, 0, 0)
                        }
                        Gravity.TOP -> {
                            mToast.setGravity(mGravity, 0, 100)
                        }
                        else -> {
                            mToast.setGravity(mGravity, 0, 100)
                        }
                    }
                }
                
                if (context is Activity) {
                    (context as Activity).runOnUiThread { mToast.show() }
                } else {
                    mToast.show()
                }
                resetToast();

                result.success(true)
            }
            "cancel" -> {
                if (::mToast.isInitialized) {
                    mToast.cancel()
                }
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    fun resetToast() {
        if (::mToast.isInitialized && mToast != null) {
            if (mToast.view?.visibility != View.VISIBLE) {
                mToast
            } else {
                Handler().postDelayed(Runnable {
                    resetToast()
                }, 1000);
            }
        }
    }
}
