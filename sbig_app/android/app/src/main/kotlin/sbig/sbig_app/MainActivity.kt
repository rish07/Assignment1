package sbig.sbig_app

import android.os.Bundle
import android.view.WindowManager.LayoutParams;

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  //  getWindow().addFlags(LayoutParams.FLAG_SECURE);
  }
}
