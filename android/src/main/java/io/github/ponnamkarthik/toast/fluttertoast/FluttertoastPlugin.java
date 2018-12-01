package io.github.ponnamkarthik.toast.fluttertoast;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import android.content.Context;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RoundRectShape;
import android.os.Build;
import android.view.Gravity;
import android.widget.TextView;
import android.widget.Toast;
import android.util.Log;

/** FluttertoastPlugin */
public class FluttertoastPlugin implements MethodCallHandler {

  Context ctx;

  int defaultTextColor = Color.TRANSPARENT;

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
      String bgcolor = call.argument("bgcolor").toString();
      String textcolor = call.argument("textcolor").toString();

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
        if (defaultTextColor == 0) {
            defaultTextColor = text.getCurrentTextColor();
        }
        if (!bgcolor.equals("null")) {

            try {

                RoundRectShape rectShape = new RoundRectShape(new float[] {100f, 100f, 100f, 100f, 100f, 100f, 100f, 100f}, null, null);

                ShapeDrawable shapeDrawable = new ShapeDrawable(rectShape);
                shapeDrawable.getPaint().setColor(Color.parseColor(bgcolor));
                shapeDrawable.getPaint().setStyle(Paint.Style.FILL);
                shapeDrawable.getPaint().setAntiAlias(true);
                shapeDrawable.getPaint().setFlags(Paint.ANTI_ALIAS_FLAG);

                if (android.os.Build.VERSION.SDK_INT <= 27) {
                    toast.getView().setBackground(shapeDrawable);
                } else {
                    text.setBackground(shapeDrawable);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        if (!textcolor.equals("null")) {
            try {
                text.setTextColor(Color.parseColor(textcolor));
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            text.setTextColor(defaultTextColor);
        }

        toast.show();

      result.success("Success");

    } else {
      result.notImplemented();
    }
  }
}
