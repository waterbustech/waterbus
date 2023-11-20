package com.waterbus.wanted

import android.content.res.Configuration
import androidx.annotation.NonNull
import cl.puntito.simple_pip_mode.PipCallbackHelperActivityWrapper
import io.flutter.embedding.android.FlutterActivity
import cl.puntito.simple_pip_mode.PipCallbackHelper
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: PipCallbackHelperActivityWrapper() {
    private var callbackHelper = PipCallbackHelper()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        callbackHelper.configureFlutterEngine(flutterEngine)
    }
    
    override fun onPictureInPictureModeChanged(active: Boolean, newConfig: Configuration?) {
        callbackHelper.onPictureInPictureModeChanged(active)
    }
}
