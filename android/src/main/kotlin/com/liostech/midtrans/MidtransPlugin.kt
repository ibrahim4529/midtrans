package com.liostech.midtrans

import android.app.Activity
import androidx.annotation.NonNull
import com.midtrans.sdk.corekit.core.MidtransSDK
import com.midtrans.sdk.corekit.core.TransactionRequest
import com.midtrans.sdk.corekit.core.themes.CustomColorTheme
import com.midtrans.sdk.corekit.models.BillingAddress
import com.midtrans.sdk.corekit.models.CustomerDetails
import com.midtrans.sdk.corekit.models.ItemDetails
import com.midtrans.sdk.corekit.models.ShippingAddress
import com.midtrans.sdk.uikit.SdkUIFlowBuilder
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import org.json.JSONArray
import org.json.JSONObject

/** MidtransPlugin */
class MidtransPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.liostech/midtrans")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "init" -> {
                val clientKey = call.argument<String>("client_key")
                val merchantBaseUrl = call.argument<String>("merchant_base_url")
                val language = call.argument<String>("language")
                val colorTheme = call.argument<HashMap<String, String>>("color_theme")
                initMidtransSdk(clientKey, merchantBaseUrl, language, colorTheme)
            }
            "payTransaction" -> {
                val dataTransaction: HashMap<String, Any?> = call.arguments()
                payTransaction(dataTransaction)
            }
            "payTransactionWithToken" -> {
                val token = call.argument<String>("token")
                payTransactionWithToken(token)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun payTransactionWithToken(token: String?) {
        try {
            MidtransSDK.getInstance().startPaymentUiFlow(activity, token)
        } catch (e: Exception) {
            Log.d("midtrans", "Error : ${e.message}")
        }
    }

    private fun payTransaction(dataTransaction: HashMap<String, Any?>) {
        try {
            val dataJsonTransaction = JSONObject(dataTransaction)
            val dataCustomer = dataJsonTransaction.getJSONObject("customer")
            val dataItems = dataJsonTransaction.getJSONArray("items")
            val customer = setupCustomer(dataCustomer)
            val items = setupItems(dataItems)
            val totalPrice = dataJsonTransaction.getDouble("amount")
            val request = TransactionRequest(System.currentTimeMillis().toString(), totalPrice)
            request.customerDetails = customer
            request.itemDetails = items
            MidtransSDK.getInstance().transactionRequest = request
            MidtransSDK.getInstance().startPaymentUiFlow(activity)
            print("Pragat Annjink")
        } catch (e: Exception) {
            Log.d("Midtrans", "error = ${e.message}")
        }

    }

    private fun setupItems(dataItems: JSONArray): ArrayList<ItemDetails> {
        val items = ArrayList<ItemDetails>()
        for (i in 0 until dataItems.length()) {
            val objItem = dataItems.getJSONObject(i)
            val item = ItemDetails(objItem.getString("id"),
                    objItem.getDouble("price"),
                    objItem.getInt("quantity"),
                    objItem.getString("name")
            )
            items.add(item)
        }
        return items
    }

    private fun setupCustomer(dataCustomer: JSONObject): CustomerDetails {
        val customer = CustomerDetails()
        customer.customerIdentifier = dataCustomer.getString("customer_identifier")
        customer.firstName = dataCustomer.getString("first_name")
        customer.lastName = dataCustomer.getString("last_name")
        customer.phone = dataCustomer.getString("phone")
        customer.email = dataCustomer.getString("email")

        if (dataCustomer.has("shipping_address")) {
            val shippingAddress = buildCustomerShippingAddress(dataCustomer.getJSONObject("shipping_address"))
            customer.shippingAddress = shippingAddress
        }
        if (dataCustomer.has("billing_address")) {
            val billingAddress = buildCustomerBillingAddress(dataCustomer.getJSONObject("billing_address"))
            customer.billingAddress = billingAddress
        }

        return customer
    }

    private fun buildCustomerBillingAddress(jsonObject: JSONObject): BillingAddress {
        val address = BillingAddress()
        address.address = jsonObject.getString("address")
        address.city = jsonObject.getString("city")
        address.postalCode = jsonObject.getString("postal_code")
        return address
    }

    private fun buildCustomerShippingAddress(jsonObject: JSONObject): ShippingAddress {
        val address = ShippingAddress()
        address.phone = jsonObject.getString("address")
        address.city = jsonObject.getString("city")
        address.postalCode = jsonObject.getString("postal_code")
        return address
    }

    private fun initMidtransSdk(clientKey: String?, merchantUrl: String?,
                                language: String?, colorTheme: HashMap<String, String>?) {
        val customColorTheme = CustomColorTheme(colorTheme?.get("light_primary_color"),
                colorTheme?.get("dark_primary_color"), colorTheme?.get("secondary_color"))
        SdkUIFlowBuilder.init()
                .setClientKey(clientKey)
                .setMerchantBaseUrl(merchantUrl)
                .setContext(activity)
                .setColorTheme(customColorTheme)
                .setLanguage(language)
                .enableLog(true)
                .setTransactionFinishedCallback {
                    val arguments: MutableMap<String, Any?> = HashMap()
                    arguments["transactionCanceled"] = it.isTransactionCanceled
                    arguments["status"] = it.status
                    arguments["source"] = it.source
                    arguments["statusMessage"] = it.statusMessage
                    if (it.response != null) {
                        arguments["response"] = it.response.toString()
                    } else arguments["response"] = null
                    Log.d("midtrans", "On Success Called")
                    channel.invokeMethod("onTransactionFinished", arguments)
                }
                .buildSDK()
    }


    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        print("On Detach")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        print("On Reatech")
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        print("Detached")
    }

}
