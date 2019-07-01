package org.godotengine.godot;

import android.app.Activity;
import android.app.Application;
import android.content.Intent;
import android.util.Log;
import android.os.Bundle;
import java.util.Map;
import java.util.List;
import java.util.Arrays;
import org.json.JSONObject;
import org.json.JSONArray;
import org.json.JSONException;
import com.kochava.base.Tracker;
import com.kochava.base.Tracker.Configuration;
import com.godot.game.BuildConfig;

public class GodotKochava extends Godot.SingletonBase {

    private Godot activity = null;

    static public Godot.SingletonBase initialize(Activity p_activity) 
    { 
        return new GodotKochava(p_activity); 
    } 

    public GodotKochava(Activity p_activity) 
    {
        registerClass("GodotKochava", new String[]{
                "init",
                "event",
                "event_with_param",
                "event_with_params",
                "standard_event",
                "standard_event_with_param",
                "standard_event_with_params"
            });
        activity = (Godot)p_activity;
    }

    // Public methods

    public void init(final String key)
    {
        activity.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                try {
                    Tracker.configure(new Configuration(activity.getApplicationContext())
                                      .setAppGuid(key)
                                      //.setLogLevel(Tracker.LOG_LEVEL_TRACE)
                                      .setLogLevel(BuildConfig.DEBUG ? Tracker.LOG_LEVEL_DEBUG : Tracker.LOG_LEVEL_INFO)
                                      );
                } catch (Exception e) {
                    Log.e("godot", "Failed to initialize KochavaSdk: " + e.getMessage()); 
                }
            }
        });
    }

    public void event(final String event)
    {
        Tracker.sendEvent(event, "");
    }

    public void event_with_param(final String event, final String param)
    {
        if(param == null) {
            Log.w("godot", "Event "+event+" with null params");
            Tracker.sendEvent(event, "");
        } else {
            Tracker.sendEvent(event, param);
        }
    }

    public void event_with_params(final String event, final Dictionary params)
    {
        if(params == null) {
            Log.w("godot", "Event "+event+" with null params");
            Tracker.sendEvent(event, "");
        } else {
            try {
                Object json = toJSON((Dictionary)params);
                Tracker.sendEvent(event, json.toString());
            } catch (JSONException e) {
                Log.e("godot", "JSON Exception: "+e.toString());
            }
        }
    }

    public void standard_event(int eventId)
    {
        Tracker.Event event = new Tracker.Event(eventId);
        Tracker.sendEvent(event);
    }

    public void standard_event_with_param(int eventId, final String param)
    {
        Tracker.Event event = new Tracker.Event(eventId);
        if(param == null) {
            Log.w("godot", "Standard event "+eventId+" with null params");
        } else {
            event.setName(param);
        }
        Tracker.sendEvent(event);
    }

    public void standard_event_with_params(int eventId, final Dictionary params)
    {
        Tracker.Event event = new Tracker.Event(eventId);
        if(params == null) {
            Log.w("godot", "Standard event "+eventId+" with null params");
        } else {
            for(String key: params.get_keys()) {
                event.addCustom(key, params.get(key).toString());
            }
        }
        Tracker.sendEvent(event);
    }

    // Internal methods

    @Override protected void onMainActivityResult (int requestCode, int resultCode, Intent data)
    {
    }

    private Object toJSON(Object object) throws JSONException {
        if (object instanceof Map) {
            JSONObject json = new JSONObject();
            Map map = (Map) object;
            for (Object key : map.keySet()) {
                json.put(key.toString(), toJSON(map.get(key)));
            }
            return json;
        } else if (object instanceof Iterable) {
            JSONArray json = new JSONArray();
            for (Object value : ((Iterable) object)) {
                json.put(value);
            }
            return json;
        } else {
            return object;
        }
    }
}
