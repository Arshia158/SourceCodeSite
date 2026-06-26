package com.arshia.sourcecodesite

import android.app.Activity
import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "source_code_site/native"
    private val saveRequestCode = 4821
    private var pendingContent: String? = null
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveHtml" -> {
                    val fileName = call.argument<String>("fileName") ?: "source.html"
                    val content = call.argument<String>("content") ?: ""
                    pendingContent = content
                    pendingResult = result

                    val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
                        addCategory(Intent.CATEGORY_OPENABLE)
                        type = "text/html"
                        putExtra(Intent.EXTRA_TITLE, fileName)
                    }

                    try {
                        startActivityForResult(intent, saveRequestCode)
                    } catch (e: Exception) {
                        pendingContent = null
                        pendingResult = null
                        result.error("SAVE_ERROR", e.message, null)
                    }
                }

                "shareHtml" -> {
                    val content = call.argument<String>("content") ?: ""
                    val intent = Intent(Intent.ACTION_SEND).apply {
                        type = "text/html"
                        putExtra(Intent.EXTRA_SUBJECT, "source.html")
                        putExtra(Intent.EXTRA_TEXT, content)
                    }

                    try {
                        startActivity(Intent.createChooser(intent, "اشتراک گذاری سورس"))
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("SHARE_ERROR", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == saveRequestCode) {
            val result = pendingResult
            val content = pendingContent
            pendingResult = null
            pendingContent = null

            if (resultCode == Activity.RESULT_OK && data?.data != null && content != null) {
                try {
                    val uri: Uri = data.data!!
                    contentResolver.openOutputStream(uri)?.use { stream ->
                        stream.write(content.toByteArray(Charsets.UTF_8))
                    }
                    result?.success(true)
                } catch (e: Exception) {
                    result?.error("WRITE_ERROR", e.message, null)
                }
            } else {
                result?.success(false)
            }
        }
    }
}
