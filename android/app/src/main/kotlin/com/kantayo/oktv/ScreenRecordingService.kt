package com.kantayo.oktv

import android.app.*
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Build
import android.os.Environment
import android.os.IBinder
import androidx.core.app.NotificationCompat
import android.util.Log
import java.io.IOException
import java.io.File

class ScreenRecordingService : Service() {

    private lateinit var mediaProjectionManager: MediaProjectionManager
    private var mediaProjection: MediaProjection? = null
    private var mediaRecorder: MediaRecorder? = null
    private var filePath: String? = null

    override fun onCreate() {
        super.onCreate()
        mediaProjectionManager = getSystemService(Context.MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        startForeground(1, createNotification())
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val resultCode = intent?.getIntExtra("resultCode", Activity.RESULT_CANCELED) ?: Activity.RESULT_CANCELED
        val data = intent?.getParcelableExtra<Intent>("data")
        if (resultCode == Activity.RESULT_OK && data != null) {
            mediaProjection = mediaProjectionManager.getMediaProjection(resultCode, data)
            setupMediaRecorder()
            mediaProjection?.let {
                val virtualDisplay = it.createVirtualDisplay(
                    "ScreenRecordingService",
                    1080, 1920, resources.displayMetrics.densityDpi,
                    0, mediaRecorder?.surface, null, null
                )
                mediaRecorder?.start()
            }
        }
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            mediaRecorder?.let {
                it.stop()
                it.reset()
                Log.d("ScreenRecordingService", "MediaRecorder stopped and reset")
            }
        } catch (e: IllegalStateException) {
            e.printStackTrace()
            Log.e("ScreenRecordingService", "MediaRecorder stopping failed: ${e.message}")
        }
        mediaProjection?.stop()
        stopForeground(true)
        Log.d("ScreenRecordingService", "Screen recording service stopped")
        sendBroadcast(Intent("com.kantayo.oktv.RECORDING_STOPPED").apply {
            putExtra("filePath", filePath)
        })
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun setupMediaRecorder() {
        filePath = getFilePath()
        mediaRecorder = MediaRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setOutputFile(filePath)
            setVideoSize(1080, 1920)
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setVideoEncodingBitRate(512 * 1000)
            setVideoFrameRate(30)
            try {
                prepare()
                Log.d("ScreenRecordingService", "MediaRecorder prepared successfully")
            } catch (e: IOException) {
                e.printStackTrace()
                Log.e("ScreenRecordingService", "MediaRecorder preparation failed: ${e.message}")
            }
        }
    }

//    private fun getFilePath(): String {
//        val directory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
//        if (directory != null && !directory.exists()) {
//            directory.mkdirs()
//        }
//        return "${directory?.absolutePath}/screen_recording_${System.currentTimeMillis()}.mp4"
//    }

    private fun getFilePath(): String {
        val parentDirectory = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
        val oktvDirectory = File(parentDirectory, "Oktv")

        // Create the Oktv directory if it doesn't exist
        if (!oktvDirectory.exists()) {
            oktvDirectory.mkdirs()
        }

        return "${oktvDirectory.absolutePath}/oktv_${System.currentTimeMillis()}.mp4"
    }

    private fun createNotification(): Notification {
        val notificationChannelId = "SCREEN_RECORDING_CHANNEL"
        val channelName = "Screen Recording"
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val chan = NotificationChannel(notificationChannelId, channelName, NotificationManager.IMPORTANCE_NONE)
            chan.lightColor = Color.BLUE
            chan.lockscreenVisibility = Notification.VISIBILITY_PRIVATE
            notificationManager.createNotificationChannel(chan)
        }

        val notificationBuilder = NotificationCompat.Builder(this, notificationChannelId)
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            notificationIntent,
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) PendingIntent.FLAG_IMMUTABLE else 0
        )

        return notificationBuilder.setOngoing(true)
            .setContentTitle("Screen Recording")
            .setContentText("Recording your screen")
            .setSmallIcon(android.R.drawable.ic_media_play)
            .setContentIntent(pendingIntent)
            .setPriority(NotificationCompat.PRIORITY_MIN)
            .setCategory(Notification.CATEGORY_SERVICE)
            .build()
    }
}
