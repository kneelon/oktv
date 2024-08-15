package com.kantayo.oktv

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.projection.MediaProjectionManager
import android.os.Bundle
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val SCREEN_RECORD_REQUEST_CODE = 1000
    private lateinit var mediaProjectionManager: MediaProjectionManager
    private lateinit var result: MethodChannel.Result
    private var filePath: String? = null
    private lateinit var recordingStoppedReceiver: BroadcastReceiver

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.kantayo.oktv/recording").setMethodCallHandler { call, result ->
            this.result = result
            when (call.method) {
                "startScreenRecording" -> startScreenRecording()
                "stopScreenRecording" -> stopScreenRecording()
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        recordingStoppedReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent?) {
                filePath = intent?.getStringExtra("filePath")
                result.success(filePath)
            }
        }
        registerReceiver(recordingStoppedReceiver, IntentFilter("com.kantayo.oktv.RECORDING_STOPPED"))
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(recordingStoppedReceiver)
    }

    private fun startScreenRecording() {
        mediaProjectionManager = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startActivityForResult(mediaProjectionManager.createScreenCaptureIntent(), SCREEN_RECORD_REQUEST_CODE)
    }

    private fun stopScreenRecording() {
        val intent = Intent(this, ScreenRecordingService::class.java)
        stopService(intent)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == SCREEN_RECORD_REQUEST_CODE) {
            if (resultCode == RESULT_OK && data != null) {
                val intent = Intent(this, ScreenRecordingService::class.java)
                intent.putExtra("resultCode", resultCode)
                intent.putExtra("data", data)
                startForegroundService(intent)
                result.success(true)
            } else {
                result.success(false)
            }
        }
    }
}
