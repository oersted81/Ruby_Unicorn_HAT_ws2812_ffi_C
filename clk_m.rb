require 'sun_times'
require 'ffi'

module UniH_time
  extend FFI::Library
  ffi_lib "./c_lib.so"
  attach_function :time_now, [:pointer, :int, :string, :int, :int, :int, :int], :pointer
  attach_function :div_grid_time, [:pointer, :int, :int], :pointer
end

module Clk_def
 include UniH_time


    def sun  #resolve sun rise/set according coordinate 
      day = Date.new(Time.now.strftime("%Y").to_i, Time.now.strftime("%m").to_i, Time.now.strftime("%d").to_i)
      latitude = 50.075383 #Prague/Czech 
      longitude = 14.455366
      sun_times = SunTimes.new
      sun_rise = sun_times.rise(day, latitude, longitude) + (60*60*2) #UTC to local +2h - Prague
      sun_set = sun_times.set(day, latitude, longitude)  + (60*60*2)
    return sun_rise, sun_set
    end

    def time_get_c(sel)
      ss_h = sun[0].strftime("%H").to_i
      ss_m = sun[0].strftime("%M").to_i
      sr_h = sun[1].strftime("%H").to_i
      sr_m = sun[1].strftime("%M").to_i
      offset = 0
      t_array = Array.new(4,0)
      t_pointer = FFI::MemoryPointer.new :int, t_array.length.to_i
      t_pointer.put_array_of_int offset, t_array
      rt_pointer = UniH_time.time_now(t_pointer, 4, sel, ss_h, ss_m, sr_h, sr_m)
      rt_array = rt_pointer.read_array_of_int(4)
     return rt_array
    end 

    def grid_time_c(time)
      offset = 0
      gt_array = [0,0,0,0]
      gt_pointer = FFI::MemoryPointer.new :int, gt_array.length.to_i
      gt_pointer.put_array_of_int offset, gt_array
      grt_pointer = UniH_time.div_grid_time(gt_pointer, 4, time)
      grt_array = grt_pointer.read_array_of_int(4)
      return grt_array
    end

    def every_sec(seconds) #main loop
      last_tick = Time.now
      loop do
        sleep 0.25
        if Time.now - last_tick >= seconds
          last_tick += seconds
          yield
        end 
      end
    end  

 module_function :every_sec
 module_function :grid_time_c
 module_function :time_get_c
end
