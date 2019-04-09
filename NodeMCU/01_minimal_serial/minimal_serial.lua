serial_count=0
serial_running=false
serial_baud=4800 -- 115200
serial_databits=8
serial_parity=uart.PARITY_NONE
serial_stopbits=uart.STOPBITS_1

serial_save_baud=nil
serial_save_databits=nil
serial_save_parity=nil
serial_save_stopbits=nil

serial_timer=tmr.create()

function on_uart_data(data)
  blink_LED()
  payload=string.sub(data,1,3)
  --if data=="ping" then
    uart.write(0, "you typed key <" .. payload .. ">  " .. serial_count .. " to go\n\r")
  --end  
  serial_count = serial_count - 1
  if serial_count < 1 or payload=="bye" then 
    stop_serial()
  end
end

function start_serial()
  if serial_running then 
    return
  end
  print("Start Serial")
  serial_running = true
  serial_count=10
  tmr.alarm(serial_timer, 60000, tmr.ALARM_SINGLE, stop_serial)

  serial_save_baud, serial_save_databits, serial_save_parity, serial_save_stopbits = uart.getconfig(0)
 
  uart.alt(1)
  uart.setup(0, serial_baud, serial_databits, serial_parity, serial_stopbits)

  baud, databits, parity, stopbits =uart.getconfig(0)
  uart.on("data", 4, on_uart_data, 0) 
  --  uart.on("data", "\r", on_uart_data)
end

function stop_serial()
  if not serial_running then 
    return
  end  
  serial_running = false
  uart.on("data") -- unregister callback function
  uart.alt(0)
  uart.setup(0, serial_save_baud, serial_save_databits, serial_save_parity, serial_save_stopbits)
  serial_count=10
  print("Stop Serial")
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

