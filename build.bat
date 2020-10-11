cl /Fo"build/" /c src/kernel.cpp 
nasm -isrc/ -fbin src/boot.asm -o build/boot.bin 
nasm -isrc/ -fbin src/kernel.asm -o build/kernel.bin 
nasm -isrc/ -fbin src/file_table.asm -o build/file_table.bin 

::link build/boot.obj build/kernel.obj /out:build/main.bin
cd build
type boot.bin kernel.bin file_table.bin > JusaOS.bin
cd ../
