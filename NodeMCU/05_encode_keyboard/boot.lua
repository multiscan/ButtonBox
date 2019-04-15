-- Scripts à charger après le boot pour démarrer son appli

print("\n boot.lua zf190311.2238 \n")

function heartbeat()
    flash_led_xfois()
    boottimer1=tmr.create()
    tmr.alarm(boottimer1, 1*1000,  tmr.ALARM_AUTO, function()
        xfois =2
        blink_LED ()
    end)
end

f= "flash_led_xfois.lua"   if file.exists(f) then dofile(f) end
f= "wifi_ap_start.lua"   if file.exists(f) then dofile(f) end
f= "wifi_cli_conf.lua"   if file.exists(f) then dofile(f) end
f= "wifi_cli_start.lua"   if file.exists(f) then dofile(f) end
f= "wifi_get_ip.lua"   if file.exists(f) then dofile(f) end
f= "telnet_srv2.lua"   if file.exists(f) then dofile(f) end
f= "web_ide2.lua"   if file.exists(f) then dofile(f) end
f= "web_srv2.lua"   if file.exists(f) then dofile(f) end
f= "keypad_encode.lua" if file.exists(f) then dofile(f) end
f=nil
--heartbeat()
