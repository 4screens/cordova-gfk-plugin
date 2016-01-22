package net.nopattern.cordova.gfk;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;

import android.util.Log;

import com.gfk.sst.SensicSiteTracker;

public class GFKSSTPlugin extends CordovaPlugin {
  private SensicSiteTracker tracker;
  private CordovaWebView appView;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    appView = webView;
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("initTraffic")) {
      String mediaId = args.getString(0);
      this.initTraffic(mediaId, callbackContext);
      return true;
    } else if (action.equals("sendImpression")) {
      String contentId = args.getString(0);
      this.sendImpression(contentId, callbackContext);
      return true;
    }

    return false;
  }

  public void initTraffic(final String mediaId, CallbackContext callbackContext) {
    if (mediaId == "null"){
      callbackContext.error("[SST] No Media ID :/ How should I send stats..?");
      return;
    }

    final Context context = this.cordova.getActivity().getApplicationContext();

    this.cordova.getActivity().runOnUiThread(new Runnable() {
      public void run() {
        tracker = new SensicSiteTracker(context, mediaId);
      }
    });

    callbackContext.success("[SST] Inited with provided Media ID.");
  }

  public void sendImpression(String contentId, CallbackContext callbackContext) {
    if (contentId == "null") {
      callbackContext.error("[SST] No Content ID :/ How should I send stats..?");
      return;
    }

    if (tracker == null) {
      callbackContext.error("[SST] Not inited. Please init first.");
      return;
    }

    tracker.trackPageImpression(contentId);
    callbackContext.success("[SST] Sent impression");
  }
}
