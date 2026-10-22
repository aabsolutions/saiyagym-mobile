package com.saiyagym.app

import android.content.ContentValues
import android.media.AudioAttributes
import android.media.MediaPlayer
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors

/**
 * Custom rest-alarm sounds (MethodChannel `saiyagym/alarm_sound`).
 *
 * A notification channel plays a content:// uri the system can read, so the
 * downloaded mp3 is inserted into MediaStore (Notifications/SaiyaGym). On
 * API 29+ this needs no permission (scoped storage: we own what we insert).
 * Below API 29 `install` answers null and Dart falls back to the default
 * `rest_timer` channel. Every failure is reported as null/false, never thrown
 * to Dart: the worst case is the default sound.
 */
class MainActivity : FlutterActivity() {
    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private var player: MediaPlayer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "install" -> {
                        val path = call.argument<String>("path")
                        val assetKey = call.argument<String>("assetKey")
                        if (path == null || assetKey == null) {
                            result.success(null)
                        } else {
                            io.execute {
                                val uri = runCatching { install(path, assetKey) }.getOrNull()
                                main.post { result.success(uri) }
                            }
                        }
                    }
                    "exists" -> {
                        val uri = call.argument<String>("uri")
                        io.execute {
                            val exists = uri != null && runCatching { exists(uri) }.getOrDefault(false)
                            main.post { result.success(exists) }
                        }
                    }
                    "remove" -> {
                        val uri = call.argument<String>("uri")
                        io.execute {
                            if (uri != null) runCatching { contentResolver.delete(Uri.parse(uri), null, null) }
                            main.post { result.success(null) }
                        }
                    }
                    "removeAll" -> {
                        io.execute {
                            val removed = runCatching { removeAll() }.getOrDefault(0)
                            main.post { result.success(removed) }
                        }
                    }
                    "preview" -> {
                        val path = call.argument<String>("path")
                        if (path != null) preview(path)
                        result.success(null)
                    }
                    "stopPreview" -> {
                        stopPreview()
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onDestroy() {
        stopPreview()
        io.shutdown()
        super.onDestroy()
    }

    /** Inserts the file into MediaStore (idempotent per asset key). Null when unsupported. */
    private fun install(path: String, assetKey: String): String? {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return null
        val source = File(path)
        if (!source.exists() || source.length() == 0L) return null

        val collection = MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        val displayName = "$assetKey.mp3"
        val relativePath = RELATIVE_PATH

        // Already inserted by a previous run: reuse it.
        contentResolver.query(
            collection,
            arrayOf(MediaStore.Audio.Media._ID),
            "${MediaStore.Audio.Media.DISPLAY_NAME} = ? AND ${MediaStore.Audio.Media.RELATIVE_PATH} LIKE ?",
            arrayOf(displayName, "$relativePath%"),
            null,
        )?.use { cursor ->
            if (cursor.moveToFirst()) {
                return Uri.withAppendedPath(collection, cursor.getLong(0).toString()).toString()
            }
        }

        val values = ContentValues().apply {
            put(MediaStore.Audio.Media.DISPLAY_NAME, displayName)
            put(MediaStore.Audio.Media.TITLE, "SaiyaGym $assetKey")
            put(MediaStore.Audio.Media.MIME_TYPE, "audio/mpeg")
            put(MediaStore.Audio.Media.RELATIVE_PATH, relativePath)
            put(MediaStore.Audio.Media.IS_NOTIFICATION, 1)
            put(MediaStore.Audio.Media.IS_PENDING, 1)
        }
        val uri = contentResolver.insert(collection, values) ?: return null
        try {
            contentResolver.openOutputStream(uri)?.use { out ->
                source.inputStream().use { it.copyTo(out) }
            } ?: throw IllegalStateException("no output stream")
            val done = ContentValues().apply { put(MediaStore.Audio.Media.IS_PENDING, 0) }
            contentResolver.update(uri, done, null, null)
        } catch (e: Exception) {
            runCatching { contentResolver.delete(uri, null, null) }
            return null
        }
        return uri.toString()
    }

    /** Is the MediaStore item still there (the user may have cleaned it)? */
    private fun exists(uri: String): Boolean =
        contentResolver.query(Uri.parse(uri), arrayOf(MediaStore.Audio.Media._ID), null, null, null)
            ?.use { it.moveToFirst() } ?: false

    /**
     * Deletes every MediaStore item under Notifications/SaiyaGym. Scoped
     * storage only returns the items this app owns; one it can't delete (e.g.
     * left by a previous install) is skipped. Returns how many were deleted.
     */
    private fun removeAll(): Int {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.Q) return 0
        val collection = MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)
        val uris = mutableListOf<Uri>()
        contentResolver.query(
            collection,
            arrayOf(MediaStore.Audio.Media._ID),
            "${MediaStore.Audio.Media.RELATIVE_PATH} LIKE ?",
            arrayOf("$RELATIVE_PATH%"),
            null,
        )?.use { cursor ->
            while (cursor.moveToNext()) {
                uris.add(Uri.withAppendedPath(collection, cursor.getLong(0).toString()))
            }
        }
        var removed = 0
        for (uri in uris) {
            try {
                if (contentResolver.delete(uri, null, null) > 0) removed++
            } catch (e: SecurityException) {
                // Not ours (includes RecoverableSecurityException): skip it.
            }
        }
        return removed
    }

    private fun preview(path: String) {
        stopPreview()
        try {
            player = MediaPlayer().apply {
                setAudioAttributes(
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_MEDIA)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build(),
                )
                setDataSource(path)
                setOnPreparedListener { it.start() }
                setOnCompletionListener { stopPreview() }
                setOnErrorListener { _, _, _ -> stopPreview(); true }
                prepareAsync()
            }
        } catch (e: Exception) {
            stopPreview()
        }
    }

    private fun stopPreview() {
        player?.let {
            runCatching { it.stop() }
            runCatching { it.release() }
        }
        player = null
    }

    companion object {
        const val CHANNEL = "saiyagym/alarm_sound"
        const val RELATIVE_PATH = "Notifications/SaiyaGym"
    }
}
