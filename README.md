# Ruby_Unicorn_HAT_ws2812_ffi_C
Ruby_Unicorn_HAT_ws2812 with ffi C lang.

same as Ruby_Unicorn_HAT_ws2812 but most of fc rewrited with C thru ffi

usage: gcc -Wall -c c_lib.c -o c_lib.o && gcc -shared -o c_lib.so c_lib.o && sudo ruby grid2_1.rb
