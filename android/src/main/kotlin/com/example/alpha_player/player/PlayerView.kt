package com.example.alpha_player.player

import android.content.Context
import android.net.Uri
import android.view.View
import android.view.LayoutInflater
import io.flutter.plugin.platform.PlatformView
import com.alphamovie.lib.AlphaMovieView
import com.example.alpha_player.R

internal class PlayerView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val playerView: View = LayoutInflater.from(context).inflate(R.layout.alpha_player, null)
    private val alphaMovieView: AlphaMovieView = playerView.findViewById(R.id.video_player)

    private val media: ByteArray? = creationParams?.get("media") as ByteArray?
    private val isPlaying: Boolean = creationParams?.get("playing") as Boolean
    // private val width: Int? = creationParams?.get("width") as Int?
    // private val height: Int? = creationParams?.get("height") as Int?

    override fun getView(): View = playerView

    override fun dispose() {}

    init {
        if(media != null) {
            val uri: Uri = Uri.parse(String(media))
            alphaMovieView.setVideoFromUri(context, uri)
        }

        // playerView.layoutParams.width = width ?: playerView.layoutParams.width
        // playerView.layoutParams.height = height ?: playerView.layoutParams.height

        if(isPlaying) alphaMovieView.start() else alphaMovieView.stop()
    }
}
