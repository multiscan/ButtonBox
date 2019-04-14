do
  -- use pin 1 as the input pulse width counter
  local pin, pulse1, du, now, trig, count = 1, 0, 0, tmr.now, gpio.trig, 0
  gpio.mode(pin,gpio.INT, gpio.PULLUP)
  local function pin1cb(level, pulse2)
    print("ciao " .. count)
    count = count + 1
    pulse1 = pulse2
    --trig(pin, level == gpio.HIGH  and "down" or "up")
--    gpio.trig(pin, "down", pin1cb)
  end
  gpio.trig(pin, "down", pin1cb)
  -- trig(pin, "down", pin1cb)
end

