package com.example.alpha_player.player

import android.content.Context
import android.view.View
import android.view.LayoutInflater
import io.flutter.plugin.platform.PlatformView
import com.alphamovie.lib.AlphaMovieView
import com.example.alpha_player.R

internal class PlayerView(context: Context, id: Int, creationParams: Map<String?, Any?>?) : PlatformView {
    private val playerView: View
    private val alphaMovieView: AlphaMovieView

    override fun getView(): View {
        return playerView
    }

    override fun dispose() {}

    init {
        playerView = LayoutInflater.from(context).inflate(R.layout.alpha_player, null)
        alphaMovieView = playerView.findViewById(R.id.video_player)
    }
}
