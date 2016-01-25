package net.nopattern.cordova.gfk;

import java.util.*;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;

import android.util.Log;

import com.google.gson.Gson;

import com.gfk.ssa.SSA;
import com.gfk.ssa.Agent;

public class GFKSSAPlugin extends CordovaPlugin {
  private SSA ssa;
  private Agent agent;
  private CordovaWebView appView;

  @Override
  public void initialize(CordovaInterface cordova, CordovaWebView webView) {
    super.initialize(cordova, webView);
    appView = webView;
  }

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("startStream")) {
      String contentId = args.getString(0);
      JSONObject params = args.getJSONObject(1);

      this.startStream(contentId, params, callbackContext);
      return true;
    } else if (action.equals("initStream")) {
      String mediaId = args.getString(0);
      this.initStream(mediaId, callbackContext);
      return true;
    } else if (action.equals("playEvent") | action.equals("idleEvent")) {
      this.fireEvent(action, callbackContext);
      return true;
    }

    return false;
  }

  // Main Cordova functions implementation
  public void initStream(final String mediaId, CallbackContext callbackContext) {
    if (mediaId == "null"){
      callbackContext.error("[SST] No Media ID :/ How should I send stats..?");
      return;
    }

    final Context context = this.cordova.getActivity().getApplicationContext();

    this.cordova.getActivity().runOnUiThread(new Runnable() {
      public void run() {
        ssa = new SSA(context, "https://config.sensic.net/pl1-ssa-android.json");
        agent = ssa.getAgent(mediaId);
      }
    });

    callbackContext.success("[SSA] Inited with provided Media ID. ");
  }

  public void startStream(String contentId, JSONObject params, CallbackContext callbackContext) {
    if (contentId != "null" & agent != null) {
      String message = this.notifyLoadedSSA(contentId, params);

      callbackContext.success(message);
    } else if (agent == null) {
      callbackContext.error("[SSA] No Agent. Please init the SSA.");
    } else {
      callbackContext.error("[SSA] No content ID. Can't notify");
    }
  }

  public void fireEvent(String action, CallbackContext callbackContext) {
    if (agent == null) {
      callbackContext.error("[SSA] No Agent inited. Please init and start the SSA");
      return;
    }

    if (action.equals("playEvent")) {
      agent.notifyPlay();
    } else if (action.equals("idleEvent")) {
      agent.notifyIdle();
    }

    callbackContext.success("[SSA] " + action + " fired.");
  }

  // Helpers
  public String notifyLoadedSSA(String contentId, JSONObject params) {
    if (params.length() == 0) {
      agent.notifyLoaded(contentId, null);

      return "[SSA] Notified loaded with content id.";
    } else {
      try {
        Map<String, Object> customParams = this.jsonToMap(params);
        agent.notifyLoaded(contentId, customParams);
      } catch(JSONException e) {
        Log.v("[SSA]", "Wrong JSON :/");
        return "[SSA] Wrong JSON :/";
      }

      return "[SSA] Notified loaded with content id and custom parameters.";
    }
  }

  public static Map<String, Object> jsonToMap(JSONObject json) throws JSONException {
    Map<String, Object> retMap = new HashMap<String, Object>();

    if(json != JSONObject.NULL) {
      retMap = toMap(json);
    }
    return retMap;
  }

  public static Map<String, Object> toMap(JSONObject object) throws JSONException {
    Map<String, Object> map = new HashMap<String, Object>();

    Iterator<String> keysItr = object.keys();
    while(keysItr.hasNext()) {
      String key = keysItr.next();
      Object value = object.get(key);

      if(value instanceof JSONArray) {
        value = toList((JSONArray) value);
      }

      else if(value instanceof JSONObject) {
        value = toMap((JSONObject) value);
      }
      map.put(key, value);
    }
    return map;
  }

  public static List<Object> toList(JSONArray array) throws JSONException {
    List<Object> list = new ArrayList<Object>();
    for(int i = 0; i < array.length(); i++) {
      Object value = array.get(i);
      if(value instanceof JSONArray) {
        value = toList((JSONArray) value);
      }

      else if(value instanceof JSONObject) {
        value = toMap((JSONObject) value);
      }
      list.add(value);
    }
    return list;
  }
}
