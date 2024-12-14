package io.github.ponnamkarthik.toast.fluttertoast

import android.app.Activity
import android.content.Context
import android.content.res.AssetManager
import android.graphics.PorterDuff
import android.graphics.Typeface
import android.graphics.drawable.Drawable
import android.os.Build
import android.view.Gravity
import android.view.LayoutInflater
import android.widget.TextView
import android.widget.Toast
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.FlutterInjector
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler

internal class MethodCallHandlerImpl(private var context: Context) : MethodCallHandler {

    private var mToast: Toast? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result,) {
        when (call.method) {
            "showToast" -> {
                val mMessage = call.argument<Any>("msg").toString()
                val length = call.argument<Any>("length").toString()
                val gravity = call.argument<Any>("gravity").toString()
                val bgcolor = call.argument<Number>("bgcolor")
                val textcolor = call.argument<Number>("textcolor")
                val fontSize = call.argument<Number>("fontSize")
                val fontAsset = call.argument<String>("fontAsset")

                val mGravity: Int = when (gravity) {
                    "top" -> Gravity.TOP
                    "center" -> Gravity.CENTER
                    else -> Gravity.BOTTOM
                }

                val mDuration: Int = if (length == "long") {
                    Toast.LENGTH_LONG
                } else {
                    Toast.LENGTH_SHORT
                }

                if (bgcolor != null) {
                    val layout = (context.getSystemService(Context.LAYOUT_INFLATER_SERVICE,) as LayoutInflater).inflate(R.layout.toast_custom, null,)
                    val text = layout.findViewById<TextView>(R.id.text,)
                    text.text = mMessage

                    val gradientDrawable: Drawable? = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                        context.getDrawable(R.drawable.corner)!!
                    } else {
                       // context.resources.getDrawable(R.drawable.corner)
                        ContextCompat.getDrawable(context, R.drawable.corner)
                    }
                    gradientDrawable!!.setColorFilter(bgcolor.toInt(), PorterDuff.Mode.SRC_IN)
                    text.background = gradientDrawable

                    if (fontSize != null) {
                        text.textSize = fontSize.toFloat()
                    }
                    if (textcolor != null) {
                        text.setTextColor(textcolor.toInt())
                    }

                    mToast = Toast(context,)
                    mToast?.duration = mDuration

                    if (fontAsset != null) {
                        val assetManager: AssetManager = context.assets
                        val key = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(fontAsset)
                        text.typeface = Typeface.createFromAsset(assetManager, key);
                    }
                    mToast?.view = layout
                } else {
                    Log.d("KARTHIK", "showToast: $bgcolor $textcolor $fontSize $fontAsset")
                    mToast = Toast.makeText(context, mMessage, mDuration)
                    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.R) {
                        val textView: TextView = mToast?.view!!.findViewById(android.R.id.message)
                        if (fontSize != null) {
                            textView.textSize = fontSize.toFloat()
                        }
                        if (textcolor != null) {
                            textView.setTextColor(textcolor.toInt())
                        }
                        if (fontAsset != null) {
                            val assetManager: AssetManager = context.assets
                            val key = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(fontAsset)
                            textView.typeface = Typeface.createFromAsset(assetManager, key);
                        }
                    }
                }

                try {
                    when (mGravity) {
                        Gravity.CENTER -> {
                            mToast?.setGravity(mGravity, 0, 0,)
                        }
                        Gravity.TOP -> {
                            mToast?.setGravity(mGravity, 0, 100,)
                        }
                        else -> {
                            mToast?.setGravity(mGravity, 0, 100,)
                        }
                    }
                } catch (e: Exception,) { }

                if (context is Activity) {
                    (context as Activity).runOnUiThread { mToast?.show() }
                } else {
                    mToast?.show()
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                    mToast?.addCallback(
                        object : Toast.Callback() {
                            override fun onToastHidden() {
                                super.onToastHidden()
                                mToast = null
                            }
                        },
                    )
                }
                result.success(true,)
            }
            "cancel" -> {
                if (mToast != null) {
                    mToast?.cancel()
                    mToast = null
                }
                result.success(true,)
            }
            else -> result.notImplemented()
        }
    }
}
