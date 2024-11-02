package com.waterbus.wanted

import android.annotation.SuppressLint
import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.MediaStore
import android.text.TextUtils
import android.webkit.MimeTypeMap
import android.window.OnBackInvokedDispatcher
import androidx.activity.OnBackPressedCallback
import androidx.appcompat.app.AppCompatActivity
import com.cloudwebrtc.webrtc.FlutterRTCBeautyFilters
import com.example.waterbus.FlutterViewEngine
import com.pixpark.gpupixel.GPUPixel
import com.waterbus.wanted.databinding.ActivityMainBinding
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.io.OutputStream

class MainActivity: AppCompatActivity()  {
    private lateinit var binding: ActivityMainBinding
    private lateinit var flutterViewEngine: FlutterViewEngine
    private val gallerySaver: String = "waterbus/gallery-saver"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // TODO: create a multi-engine version after
        // https://github.com/flutter/flutter/issues/72009 is built.
        val engine = FlutterEngine(applicationContext)
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        );

        flutterViewEngine = FlutterViewEngine(engine)
        // The activity and FlutterView have different lifecycles.
        // Attach the activity right away but only start rendering when the
        // view is also scrolled into the screen.
        flutterViewEngine.attachToActivity(this)

        val flutterView = binding.flutterView

        // Attach FlutterEngine to FlutterView
        flutterView.attachToFlutterEngine(engine)
        flutterViewEngine.attachFlutterView(flutterView)

        configureFlutterEngine(engine)

        // Handle back
        onBackPressedDispatcher.addCallback(this, object : OnBackPressedCallback(true) {
            override fun handleOnBackPressed() {
                flutterViewEngine.engine.navigationChannel.popRoute()
            }
        })

        GPUPixel.setContext(applicationContext)
        FlutterRTCBeautyFilters.initialize()
    }

    override fun onDestroy() {
        super.onDestroy()
        flutterViewEngine.detachActivity()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        flutterViewEngine.onRequestPermissionsResult(requestCode, permissions, grantResults)
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        flutterViewEngine.onActivityResult(requestCode, resultCode, data)
        super.onActivityResult(requestCode, resultCode, data)
    }

    @SuppressLint("MissingSuperCall")
    override fun onUserLeaveHint() {
        flutterViewEngine.onUserLeaveHint()
        super.onUserLeaveHint()
    }

    private fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger, gallerySaver
        ).setMethodCallHandler { call, result ->
            if (call.method == "saveImageToGallery") {
                val image = call.argument<ByteArray?>("imageBytes")
                val quality = call.argument<Int?>("quality")
                val name = call.argument<String?>("name")

                result.success(
                    saveImageToGallery(
                        BitmapFactory.decodeByteArray(
                            image ?: ByteArray(0),
                            0,
                            image?.size ?: 0
                        ), quality, name
                    )
                )
            } else if (call.method == "saveFileToGallery") {
                val path = call.argument<String?>("file")
                val name = call.argument<String?>("name")
                result.success(saveFileToGallery(path, name))
            }
        }
    }

    private fun generateUri(extension: String = "", name: String? = null): Uri? {
        var fileName = name ?: System.currentTimeMillis().toString()
        val mimeType = getMIMEType(extension)
        val isVideo = mimeType?.startsWith("video")==true

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // >= android 10
            val uri = when {
                isVideo -> MediaStore.Video.Media.EXTERNAL_CONTENT_URI
                else -> MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            }

            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(
                    MediaStore.MediaColumns.RELATIVE_PATH, when {
                        isVideo -> Environment.DIRECTORY_MOVIES
                        else -> Environment.DIRECTORY_PICTURES
                    }
                )
                if (!TextUtils.isEmpty(mimeType)) {
                    put(when {isVideo -> MediaStore.Video.Media.MIME_TYPE
                        else -> MediaStore.Images.Media.MIME_TYPE
                    }, mimeType)
                }
            }

            applicationContext?.contentResolver?.insert(uri, values)

        } else {
            // < android 10
            val storePath =
                Environment.getExternalStoragePublicDirectory(when {
                    isVideo -> Environment.DIRECTORY_MOVIES
                    else -> Environment.DIRECTORY_PICTURES
                }).absolutePath
            val appDir = File(storePath).apply {
                if (!exists()) {
                    mkdir()
                }
            }

            val file =
                File(appDir, if (extension.isNotEmpty()) "$fileName.$extension" else fileName)
            Uri.fromFile(file)
        }
    }

    /**
     * get file Mime Type
     *
     * @param extension extension
     * @return file Mime Type
     */
    private fun getMIMEType(extension: String): String? {
        return if (!TextUtils.isEmpty(extension)) {
            MimeTypeMap.getSingleton().getMimeTypeFromExtension(extension.lowercase())
        } else {
            null
        }
    }

    /**
     * Send storage success notification
     *
     * @param context context
     * @param fileUri file path
     */
    private fun sendBroadcast(context: Context, fileUri: Uri?) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) {
            val mediaScanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
            mediaScanIntent.data = fileUri
            context.sendBroadcast(mediaScanIntent)
        }
    }

    private fun saveImageToGallery(
        bmp: Bitmap?,
        quality: Int?,
        name: String?
    ): HashMap<String, Any?> {
        // check parameters
        if (bmp == null || quality == null) {
            return SaveResultModel(false, null, "parameters error").toHashMap()
        }
        // check applicationContext
        val context = applicationContext
            ?: return SaveResultModel(false, null, "applicationContext null").toHashMap()
        var fileUri: Uri? = null
        var fos: OutputStream? = null
        var success = false
        try {
            fileUri = generateUri("jpg", name = name)
            if (fileUri != null) {
                fos = context.contentResolver.openOutputStream(fileUri)
                if (fos != null) {
                    println("ImageGallerySaverPlugin $quality")
                    bmp.compress(Bitmap.CompressFormat.JPEG, quality, fos)
                    fos.flush()
                    success = true
                }
            }
        } catch (e: IOException) {
            SaveResultModel(false, null, e.toString()).toHashMap()
        } finally {
            fos?.close()
            bmp.recycle()
        }
        return if (success) {
            sendBroadcast(context, fileUri)
            SaveResultModel(fileUri.toString().isNotEmpty(), fileUri.toString(), null).toHashMap()
        } else {
            SaveResultModel(false, null, "saveImageToGallery fail").toHashMap()
        }
    }

    private fun saveFileToGallery(filePath: String?, name: String?): HashMap<String, Any?> {
        // check parameters
        if (filePath == null) {
            return SaveResultModel(false, null, "parameters error").toHashMap()
        }
        val context = applicationContext ?: return SaveResultModel(
            false,
            null,
            "applicationContext null"
        ).toHashMap()
        var fileUri: Uri? = null
        var outputStream: OutputStream? = null
        var fileInputStream: FileInputStream? = null
        var success = false

        try {
            val originalFile = File(filePath)
            if(!originalFile.exists()) return SaveResultModel(false, null, "$filePath does not exist").toHashMap()
            fileUri = generateUri(originalFile.extension, name)
            if (fileUri != null) {
                outputStream = context.contentResolver?.openOutputStream(fileUri)
                if (outputStream != null) {
                    fileInputStream = FileInputStream(originalFile)

                    val buffer = ByteArray(10240)
                    var count = 0
                    while (fileInputStream.read(buffer).also { count = it } > 0) {
                        outputStream.write(buffer, 0, count)
                    }

                    outputStream.flush()
                    success = true
                }
            }
        } catch (e: IOException) {
            SaveResultModel(false, null, e.toString()).toHashMap()
        } finally {
            outputStream?.close()
            fileInputStream?.close()
        }
        return if (success) {
            sendBroadcast(context, fileUri)
            SaveResultModel(fileUri.toString().isNotEmpty(), fileUri.toString(), null).toHashMap()
        } else {
            SaveResultModel(false, null, "saveFileToGallery fail").toHashMap()
        }
    }
}

class SaveResultModel(var isSuccess: Boolean,
                      var filePath: String? = null,
                      var errorMessage: String? = null) {
    fun toHashMap(): HashMap<String, Any?> {
        val hashMap = HashMap<String, Any?>()
        hashMap["isSuccess"] = isSuccess
        hashMap["filePath"] = filePath
        hashMap["errorMessage"] = errorMessage
        return hashMap
    }
}
