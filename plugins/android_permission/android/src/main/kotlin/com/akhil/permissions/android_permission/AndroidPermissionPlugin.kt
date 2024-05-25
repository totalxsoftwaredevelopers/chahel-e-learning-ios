package com.akhil.permissions.android_permission

import android.Manifest.permission.READ_EXTERNAL_STORAGE
import android.Manifest.permission.READ_MEDIA_AUDIO

import android.Manifest.permission.READ_MEDIA_IMAGES
import android.Manifest.permission.READ_MEDIA_VIDEO
import android.Manifest.permission.WRITE_EXTERNAL_STORAGE

import android.app.Activity

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** AndroidPermissionPlugin */
class AndroidPermissionPlugin: FlutterPlugin, MethodCallHandler, ActivityAware  {

  private lateinit var channel : MethodChannel
  private lateinit var activity: Activity
  private lateinit var context: Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "android_permission")
    channel.setMethodCallHandler(this)
    this.context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "checkPermissionGranted") {


      if ( ContextCompat.checkSelfPermission(context, READ_MEDIA_IMAGES) == PackageManager.PERMISSION_GRANTED){
          result.success("GRANTED")
        } else if ( ContextCompat.checkSelfPermission(context, READ_MEDIA_IMAGES) == PackageManager.PERMISSION_DENIED) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
          activity.requestPermissions(arrayOf(READ_MEDIA_IMAGES, READ_MEDIA_VIDEO, READ_MEDIA_AUDIO), 22)
        } else {
          ActivityCompat.requestPermissions( activity, arrayOf(WRITE_EXTERNAL_STORAGE, READ_EXTERNAL_STORAGE), 21)
        }
      }
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding.activity
  }

  override fun onDetachedFromActivityForConfigChanges() {
    TODO("Not yet implemented")
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    TODO("Not yet implemented")
  }

  override fun onDetachedFromActivity() {

  }
}
