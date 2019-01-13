package io.github.ponnamkarthik.toast.fluttertoast;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.view.Gravity;
import android.widget.TextView;
import android.widget.Toast;

import android.support.v4.content.ContextCompat;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FluttertoastPlugin */
public class FluttertoastPlugin implements MethodCallHandler {

  Context ctx;

  FluttertoastPlugin(Context context) {
    ctx = context;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "PonnamKarthik/fluttertoast");
    channel.setMethodCallHandler(new FluttertoastPlugin(registrar.context()));
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("showToast")) {
      String msg  = call.argument("msg").toString();
      String length = call.argument("length").toString();
      String gravity = call.argument("gravity").toString();
      Number bgcolor = call.argument("bgcolor");
      Number textcolor = call.argument("textcolor");


      Toast toast = Toast.makeText(ctx, msg, Toast.LENGTH_SHORT);

      toast.setText(msg);

      if(length.equals("long")) {
        toast.setDuration(Toast.LENGTH_LONG);
      } else {
        toast.setDuration(Toast.LENGTH_SHORT);
      }

      switch (gravity) {
          case "top":
              toast.setGravity(Gravity.TOP, 0, 100);
              break;
          case "center":
              toast.setGravity(Gravity.CENTER, 0, 0);
              break;
          default:
              toast.setGravity(Gravity.BOTTOM, 0, 100);
        }

      TextView text = toast.getView().findViewById(android.R.id.message);

      if(bgcolor != null) {
          Drawable shapeDrawable = ContextCompat.getDrawable(ctx, R.drawable.toast_bg);

          if (shapeDrawable != null) {
              shapeDrawable.setColorFilter(bgcolor.intValue(), PorterDuff.Mode.SRC_IN);
              if (Build.VERSION.SDK_INT <= 27) {
                  toast.getView().setBackground(shapeDrawable);
              } else {
                  text.setBackground(shapeDrawable);
              }
          }

      }

      if(textcolor != null) {
          text.setTextColor(textcolor.intValue());
      }

      toast.show();

      result.success("Success");

    } else {
      result.notImplemented();
    }
  }
}
