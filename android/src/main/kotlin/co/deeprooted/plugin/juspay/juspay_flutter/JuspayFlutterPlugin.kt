package co.deeprooted.plugin.juspay.juspay_flutter

import `in`.juspay.hypersdk.data.JuspayResponseHandler
import `in`.juspay.hypersdk.ui.HyperPaymentsCallbackAdapter
import `in`.juspay.services.HyperServices
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull
import androidx.fragment.app.FragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject

class JuspayFlutterPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private lateinit var channel: MethodChannel
    private var binding: ActivityPluginBinding? = null
    private var hyperServices: HyperServices? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "juspay")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.binding = binding
        val fragmentActivity = binding.activity as FragmentActivity
        hyperServices = HyperServices(fragmentActivity)
        binding.addActivityResultListener(this)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivity() {
        this.binding!!.removeActivityResultListener(this)
        this.binding = null
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        try {
            hyperServices!!.onActivityResult(requestCode, resultCode, data!!)
            return true
        } catch (e: Exception) {
            return false;
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "prefetch" -> prefetch(call.argument<Map<String, Any>>("params"), result)
            "initiate" -> initiate(call.argument<Map<String, Any>>("params"), result)
            "process" -> process(call.argument<Map<String, Any>>("params"), result)
            "terminate" -> terminate(result)
            "isInitialised" -> isInitialised(result)
            "backPress" -> onBackPressed(result)
            else -> result.notImplemented()
        }
    }

    private fun isInitialised(result: Result) {
        try {
            var isInitiated = hyperServices!!.isInitialised()
            result.success(isInitiated)
        } catch(e: Exception) {
            result.success(false)
        }
    }

    private fun prefetch(params: Map<String, Any>?, result: Result) {
        try {
            HyperServices.preFetch(binding!!.activity, JSONObject(params))
            result.success(true)
        } catch (e: Exception) {
            result.error("FETCH_ERROR", e.message, e)
        }
    }

    private fun initiate(params: Map<String, Any>?, result: Result) = try {
        val invokeMethodResult = object : Result {
            override fun success(result: Any?) {
                Log.d(this.javaClass.canonicalName, "success: ${result.toString()}")
                println("result = ${result.toString()}")
            }

            override fun error(errorCode: String?, errorMessage: String?, errorDetails: Any?) {
                Log.e(this.javaClass.canonicalName, "$errorCode\n$errorMessage")
            }

            override fun notImplemented() {
                Log.e(this.javaClass.canonicalName, "notImplemented")
            }
        }
        val callback = object : HyperPaymentsCallbackAdapter() {
            override fun onEvent(data: JSONObject, p1: JuspayResponseHandler?) {
                try {
                    when (data.getString("event")) {
                        "show_loader" -> {
                            channel.invokeMethod("onShowLoader", "", invokeMethodResult)
                        }
                        "hide_loader" -> {
                            channel.invokeMethod("onHideLoader", "", invokeMethodResult)
                        }
                        "initiate_result" -> {
                            channel.invokeMethod("onInitiateResult", data.toString(), invokeMethodResult)
                        }
                        "process_result" -> {
                            channel.invokeMethod("onProcessResult", data.toString(), invokeMethodResult)
                        }
                    }
                } catch (e: Exception) {
                    Log.e(this.javaClass.canonicalName, "Failed to invoke method from native to dart", e)
                }
            }
        }
        hyperServices!!.initiate(binding!!.activity as FragmentActivity, JSONObject(params), callback)
        result.success(true)
    } catch (e: Exception) {
        result.error("INIT_ERROR", e.localizedMessage, e)
    }

    private fun process(params: Map<String, Any>?, result: Result) {
        hyperServices!!.process(JSONObject(params))
        result.success(true)
    }

    private fun terminate(result: Result) {
        hyperServices!!.terminate()
        result.success(true)
    }

    private fun onBackPressed(result: Result) {
        try{
            hyperServices!!.onBackPressed()
            result.success(true)
        }
        catch(e: Exception){
            result.error("BACKPRESS_ERROR", e.localizedMessage, e)
        }
    }
}

