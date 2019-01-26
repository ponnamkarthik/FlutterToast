package io.github.ponnamkarthik.toast.fluttertoast;

import android.content.Context;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.os.Build;
import android.os.Handler;
import android.view.Gravity;
import android.view.MotionEvent;
import android.view.View;
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

  private Context ctx;
  private Toast toast = null;

  private FluttertoastPlugin(Context context) {
    ctx = context;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "PonnamKarthik/fluttertoast");
    channel.setMethodCallHandler(new FluttertoastPlugin(registrar.context()));
  }

  @Override
  public void onMethodCall(MethodCall call, final Result result) {
      switch (call.method) {
          case "showToast":
              showToast(call, result);
              break;
          case "cancel":
              if(toast != null) {
                  toast.cancel();
              }
              result.success(true);
              break;
          default:
              result.notImplemented();
              break;
      }
  }

  private void showToast(MethodCall call, Result result) {
      String msg  = call.argument("msg").toString();
      String length = call.argument("length").toString();
      String gravity = call.argument("gravity").toString();
      Number bgcolor = call.argument("bgcolor");
      Number textcolor = call.argument("textcolor");
      Number textSize = call.argument("fontSize");


      toast = Toast.makeText(ctx, msg, Toast.LENGTH_SHORT);

      toast.setText(msg);

      if(length.equals("long")) {
          toast.setDuration(Toast.LENGTH_LONG);
      } else {
          toast.setDuration(Toast.LENGTH_SHORT);
      }

      // later
//      Boolean sent = false;
//      final Handler handler = new Handler();
//      final Runnable run = new Runnable() {
//
//          @Override
//          public void run() {
//              try {
//                  result.success(false);
//
//              } catch (Exception e){
//                  e.printStackTrace();
//              }
//          }
//      };


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

      final TextView text = toast.getView().findViewById(android.R.id.message);
      text.setTextSize(textSize.floatValue());


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
      //later
//        text.setOnTouchListener(new View.OnTouchListener() {
//            @Override
//            public boolean onTouch(View v, MotionEvent event) {
//                handler.removeCallbacks(run);
//                text.setOnTouchListener(null);
//                toast.cancel();
//                try {
//
//                    result.success(true);
//
//                } catch (Exception e){
//                    e.printStackTrace();
//                }
//
//                return false;
//            }
//        });

      if(textcolor != null) {
          text.setTextColor(textcolor.intValue());
      }

      toast.show();
      result.success(true);
//      handler.postDelayed(run,toast.getDuration()*1000);
  }
}
