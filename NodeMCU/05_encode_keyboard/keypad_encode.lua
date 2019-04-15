-- serial_count=0
serial_running=false
serial_baud=9600 -- 115200
serial_databits=8
serial_parity=uart.PARITY_NONE
serial_stopbits=uart.STOPBITS_1

serial_save_baud=nil
serial_save_databits=nil
serial_save_parity=nil
serial_save_stopbits=nil

-- setup button on D1 for stopping serial
gpio.mode(1,gpio.INT, gpio.PULLUP)
gpio.mode(2,gpio.INT, gpio.PULLUP)
gpio.trig(1, "down", function (a,b) stop_serial() end)
gpio.trig(2, "down", function (a,b) start_serial() end)


-- serial_timer=tmr.create()


trans = {}
-- trans['0'] = "zero"
-- trans['1'] = "one"
-- trans['2'] = "two"
-- trans['3'] = "three"
-- trans['4'] = "four"
-- trans['5'] = "five"
-- trans['6'] = "six"
-- trans['7'] = "seven"
-- trans['8'] = "eight"
-- trans['9'] = "nine"
-- trans['A'] = "ten"
-- trans['B'] = "eleven"
-- trans['C'] = "twelve"
-- trans['D'] = "thirteen"
-- trans['E'] = "fourteen"
-- trans['F'] = "fifteen"

--trans[1] = "one"
--trans[2] = "two"
--trans[3] = "three"
--trans[4] = "four"
--trans[5] = "five"
--trans[6] = "six"
--trans[7] = "seven"
--trans[8] = "eight"
--trans[9] = "nine"
--trans[10] = "ten"
--trans[11] = "eleven"
--trans[12] = "twelve"
--trans[13] = "thirteen"
--trans[14] = "fourteen"
--trans[15] = "fifteen"
--trans[16] = "sixteen"

trans = {
  "one",
  "two",
  "three",
  "four",
  "five",
  "six",
  "seven",
  "eight",
  "nine",
  "ten",
  "eleven",
  "twelve",
  "thirteen",
  "fourteen",
  "fifteen",
  "sixteen",
}
nx = table.getn(trans)

function on_uart_data(data)
  -- blink_LED()
  -- uart.write(0, trans[data] .. "\n\r")
  --  b=string.sub(data,1,1)
  --  uart.write(0, b)
  --  -- c=trans[string.char(b)]
  --  c = trans[b]
  --  if c == nil then 
  --    c = "Err"
  --  end
  --  uart.write(0, " -> " .. c .. "\r")
  --  uart.write(0, data)
  flash_led_xfois(1,20,100)

    n=string.byte(data)
    if (n>0 and n<=nx) then
      i=uart.write(0, trans[n])
    end
        
  -- serial_count = serial_count - 1
  -- if serial_count < 1 or c == 'q' then 
  --   stop_serial()
  -- end
end

function start_serial()
  if serial_running then 
    return
  end

  -- print("Start Serial")
  serial_running = true
  -- serial_count=10
  -- tmr.alarm(serial_timer, 60000, tmr.ALARM_SINGLE, stop_serial)

  serial_save_baud, serial_save_databits, serial_save_parity, serial_save_stopbits = uart.getconfig(0)
 
  uart.alt(1)
  uart.setup(0, serial_baud, serial_databits, serial_parity, serial_stopbits)

  baud, databits, parity, stopbits = uart.getconfig(0)

  -- reply to arduino at each char
  uart.on("data", 1, on_uart_data, 0) 
  flash_led_xfois(5,10,100)
end

function stop_serial()
  if not serial_running then 
    return
  end  
  serial_running = false
  uart.on("data") -- unregister callback function
  uart.alt(0)
  uart.setup(0, serial_save_baud, serial_save_databits, serial_save_parity, serial_save_stopbits)
  -- serial_count=10
  flash_led_xfois(2,500,200)
end

---- when 4 chars is received.
--uart.on("data", 2,
--  function(data)
--    count = count - 1 
--    print("receive from uart:", data)
--    if data=="quit" or count<1 then
--      uart.on("data") -- unregister callback function
--    end
--end, 0)
---- when '\r' is received.
--uart.on("data", "\r",
--  function(data)
--    count = count - 1 
--    print("receive from uart:", data)
--    if data=="quit\r" or count<1 then
--      uart.on("data") -- unregister callback function
--    end
--end, 0)
