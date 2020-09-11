package io.github.ponnamkarthik.toast.fluttertoast

import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry.Registrar

/** FlutterToastPlugin */
public class FlutterToastPlugin: FlutterPlugin {

  private var channel : MethodChannel? = null

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val plugin = FlutterToastPlugin()
      plugin.setupChannel(registrar.messenger(), registrar.context())
    }
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    setupChannel(binding.binaryMessenger, binding.applicationContext)
  }

  override fun onDetachedFromEngine(p0: FlutterPlugin.FlutterPluginBinding) {
    teardownChannel();
  }

  fun setupChannel(messenger: BinaryMessenger, context: Context) {
    channel = MethodChannel(messenger, "PonnamKarthik/fluttertoast")
    val handler = MethodCallHandlerImpl(context)
    channel?.setMethodCallHandler(handler)
  }

  private fun teardownChannel() {
    channel?.setMethodCallHandler(null)
    channel = null
  }

}

