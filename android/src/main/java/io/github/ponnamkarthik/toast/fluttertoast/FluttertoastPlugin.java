package io.github.ponnamkarthik.toast.fluttertoast;

import android.content.Context;
import android.graphics.drawable.GradientDrawable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FluttertoastPlugin
 */
public class FluttertoastPlugin implements MethodCallHandler {

    private Context mContext;
    private Toast mToast;

    private FluttertoastPlugin(Context context) {
        mContext = context;
    }

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "PonnamKarthik/fluttertoast");
        channel.setMethodCallHandler(new FluttertoastPlugin(registrar.context()));
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case "showToast":
                String mMessage = call.argument("msg").toString();
                String length = call.argument("length").toString();
                String gravity = call.argument("gravity").toString();
                Number bgcolor = call.argument("bgcolor");
                Number textcolor = call.argument("textcolor");
                Number textSize = call.argument("fontSize");

                int mGravity;
                switch (gravity) {
                    case "top":
                        mGravity = Gravity.TOP;
                        break;
                    case "center":
                        mGravity = Gravity.CENTER;
                        break;
                    default:
                        mGravity = Gravity.BOTTOM;
                        break;
                }
                int mDuration;
                if (length.equals("long")) {
                    mDuration = Toast.LENGTH_LONG;
                } else {
                    mDuration = Toast.LENGTH_SHORT;
                }

                if (bgcolor != null && textcolor != null && textSize != null) {
                    LayoutInflater inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
                    View layout = inflater.inflate(R.layout.toast_custom, null);
                    TextView text = layout.findViewById(R.id.text);
                    text.setText(mMessage);

                    // Custom style
                    GradientDrawable gradientDrawable = new GradientDrawable();
                    gradientDrawable.setColor(bgcolor.intValue());
                    gradientDrawable.setCornerRadius(dp2px(4.0f));
                    text.setBackground(gradientDrawable);
                    text.setTextSize(textSize.floatValue());
                    text.setTextColor(textcolor.intValue());

                    mToast = new Toast(mContext);
                    mToast.setDuration(mDuration);
                    mToast.setView(layout);
                } else {
                    mToast = Toast.makeText(mContext, mMessage, mDuration);
                }

                if (mGravity == Gravity.CENTER) {
                    mToast.setGravity(mGravity, 0, 0);
                } else if (mGravity == Gravity.TOP) {
                    mToast.setGravity(mGravity, 0, 100);
                } else {
                    mToast.setGravity(mGravity, 0, 100);
                }
                mToast.show();

                result.success(true);
                break;
            case "cancel":
                if (mToast != null) {
                    mToast.cancel();
                }
                result.success(true);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private float dp2px(float dp) {
        final float scale = mContext.getResources().getDisplayMetrics().density;
        return dp * scale + 0.5f;
    }
}
