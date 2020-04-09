//
//  SettingsService.swift
//  minapps-alarm-clock
//
//  Created by Amnah on 27/01/2020.
//  Copyright © 2017 Amnah. All rights reserved.
//
//

import UIKit

class SettingsService
{
    let KEY_COLOR = "settings_color"
    let KEY_FONT = "settings_font"
    let KEY_USE_24_HOUR = "settings_use_24_hour_mode"
    let KEY_SHOW_SEC = "settings_show_seconds"
    let KEY_SHOW_DATE = "settings_show_date"
    let KEY_SHOW_BATT = "settings_show_battery"
    let KEY_BRIGHTNESS = "settings_brightness_level"
    let KEY_ENABLE_SWIPE_BRIGHTNESS = "settings_enable_brightness_swipe"
    let KEY_AUTOLOCK_PLUGGED_IN = "settings_enable_lock_plugged_in"
    
    
    static let instance = SettingsService()
    private init()
    {
        _settingsData = UserDefaults.standard
        _settingsData.synchronize()
        
        
        // Credit to Kamil Szostakowski: https://stackoverflow.com/a/46561995
        
        // Get settings dictionary from file
        let settingsUrl = Bundle.main.url(forResource: "Settings", withExtension: "bundle")!.appendingPathComponent("Root.plist")
        let settingsPlist = NSDictionary(contentsOf:settingsUrl)!
        let preferences = settingsPlist["PreferenceSpecifiers"] as! [NSDictionary]
        
        // Automatically get default values of all preferences
        var defaultsToRegister = [String:Any]()
        for preference in preferences
        {
            guard let key = preference["Key"] as? String else
            {
                //print("Key not found for: \(preference)")
                continue
            }
            
            defaultsToRegister[key] = preference["DefaultValue"]
        }
        
        // Register the preferences from the settings bundle
        UserDefaults.standard.register(defaults: defaultsToRegister)
    }
    
    
    private var _settingsData: UserDefaults
    
    
    
    
    
    
    
    
    func isUsing24HourConvention() -> Bool
    {
        return _settingsData.bool(forKey: KEY_USE_24_HOUR)
    }
    
    func doesShowSeconds() -> Bool
    {
        return _settingsData.bool(forKey: KEY_SHOW_SEC)
    }
    
    func doesShowDate() -> Bool
    {
        return _settingsData.bool(forKey: KEY_SHOW_DATE)
    }
    
    func doesShowBattery() -> Bool
    {
        return _settingsData.bool(forKey: KEY_SHOW_BATT)
    }
    
    
    func getBrightnessRatio() -> CGFloat
    {
        return CGFloat(_settingsData.float(forKey: KEY_BRIGHTNESS))
    }
    
    func setBrightnessRatio(_ value: CGFloat)
    {
        var newValue : CGFloat = 0.0
        
        // Clamp
        if value > 1.0
        {
            newValue = 1.0
        }
        else if value < 0.0
        {
            newValue = 0.0
        }
        else
        {
            newValue = value
        }
        
        _settingsData.set(newValue, forKey: KEY_BRIGHTNESS)
    }
    
    func canSwipeToControlBrightness() -> Bool
    {
        return _settingsData.bool(forKey: KEY_ENABLE_SWIPE_BRIGHTNESS)
    }
    
    func willAutoLockWhenPluggedIn() -> Bool
    {
        return _settingsData.bool(forKey: KEY_AUTOLOCK_PLUGGED_IN)
    }
    
    
    func getColor() -> UIColor
    {
        var chosenColor = #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1)
        
        let colorCode = _settingsData.integer(forKey: KEY_COLOR)
        
        switch colorCode
        {
        case 0: // Red
            chosenColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
            break
        case 1: // Orange
            chosenColor = #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            break
        case 2: // Yellow
            chosenColor = #colorLiteral(red: 0.952982206, green: 0.8705216945, blue: 0.01458402639, alpha: 1)
            break
        case 3: // Green
            chosenColor = #colorLiteral(red: 0.5563425422, green: 0.9793455005, blue: 0, alpha: 1)
            break
        case 4: // Blue
            chosenColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            break
        case 5: // Purple
            chosenColor = #colorLiteral(red: 0.7321786326, green: 0.3451030194, blue: 1, alpha: 1)
            break
        default:
            print("SETTINGS ERROR: Invalid Color Code!!! Will default to cyan color.")
        }
        
        return chosenColor
    }
    
    
    func getFont() -> String
    {
        return _settingsData.string(forKey: KEY_FONT)!
    }
    
    
    
    
    
}
