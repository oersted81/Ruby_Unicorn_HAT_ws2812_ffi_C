require 'ws2812'
require 'ffi'
require 'benchmark'
require_relative 'clk_m.rb'
require_relative 'splash_m.rb'
include Clk_def
include Splash

#-------------FFI_C_ini---------------------#
module UniH_color
  extend FFI::Library
  ffi_lib "./c_lib.so"
  attach_function :color, [:pointer, :int, :int], :pointer
  attach_function :brightness, [:int], :int
  attach_function :unih_ary, [:pointer, :int, :int], :pointer
end

offset = 0
br_array = Array.new(4,0)
br_pointer = FFI::MemoryPointer.new :int, br_array.length.to_i
br_pointer.put_array_of_int offset, br_array

sg_array = Array.new(16,0)
sg_pointer = FFI::MemoryPointer.new :int, sg_array.length.to_i
sg_pointer.put_array_of_int offset, sg_array
#-------------FFI_C_ini---------------------#

#HAT/time variables
unicorn =  Array.new(4, Array.new(4,0))
index = [[0,4,8,12],[1,5,9,13],[2,6,10,14],[3,7,11,15]].flatten
time_spec = ['time', 'date', 'sun_rise', 'sun_set']
converted_time = []

#Unicor_HAT ini
n = 64 # num leds
ws = Ws2812::Basic.new(n, 18) # +n+ leds at pin 18, using defaults
ws.open

#splash screen
Splash.light_show.each_index {|i|
  ws[light_show[i]] = Ws2812::Color.new(80,80,80)
  sleep 0.01
  ws.show}
#main loop
begin
Clk_def.every_sec(1) do
#  puts Benchmark.measure {
  ws.brightness = UniH_color.brightness(Time.now.strftime("%H").to_i)
  time_spec.each_index { |n|
    Clk_def.time_get_c(time_spec[n]).each_with_index { |j,i| unicorn[i] = Clk_def.grid_time_c(j)}
      index.each_with_index {|j,i| converted_time[j] = unicorn.flatten[i] }
        converted_time.each_with_index { |j,i|
          rbr_pointer = UniH_color.color(br_pointer, 4, n)
          rbr_array = rbr_pointer.read_array_of_int(4)  
          rsg_pointer = UniH_color.unih_ary(sg_pointer, 16, n)
          rsg_array = rsg_pointer.read_array_of_int(16)
          ws[rsg_array[i]] = Ws2812::Color.new(rbr_array[0],rbr_array[1],rbr_array[2]) if converted_time[i] == 1
          ws[rsg_array[i]] = Ws2812::Color.new(0,0,0) if converted_time[i] == 0}
        }#}
   ws.show
  end
rescue Interrupt
    ws[0..63] = Ws2812::Color.new(0,0,0)
    ws.show
end
