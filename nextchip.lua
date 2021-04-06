-- Chip8 emulator in lua for TI Nspire

-- lua-bitop: bit32 port for lua 5.1
-- https://github.com/AlberTajuelo/bitop-lua
-- bitwise lib proably not the most efficient possible but I can't be bothered to make my own

local M = {_TYPE='module', _NAME='bitop.funcs', _VERSION='1.0-0'}

local floor = math.floor

local MOD = 2^32
local MODM = MOD-1

local function memoize(f)

  local mt = {}
  local t = setmetatable({}, mt)

  function mt:__index(k)
    local v = f(k)
    t[k] = v
    return v
  end

  return t
end

local function make_bitop_uncached(t, m)
  local function bitop(a, b)
    local res,p = 0,1
    while a ~= 0 and b ~= 0 do
      local am, bm = a%m, b%m
      res = res + t[am][bm]*p
      a = (a - am) / m
      b = (b - bm) / m
      p = p*m
    end
    res = res + (a+b) * p
    return res
  end
  return bitop
end

local function make_bitop(t)
  local op1 = make_bitop_uncached(t, 2^1)
  local op2 = memoize(function(a)
    return memoize(function(b)
      return op1(a, b)
    end)
  end)
  return make_bitop_uncached(op2, 2^(t.n or 1))
end

-- ok? probably not if running on a 32-bit int Lua number type platform
function M.tobit(x)
  return x % 2^32
end

M.bxor = make_bitop {[0]={[0]=0,[1]=1},[1]={[0]=1,[1]=0}, n=4}
local bxor = M.bxor

function M.bnot(a)   return MODM - a end
local bnot = M.bnot

function M.band(a,b) return ((a+b) - bxor(a,b))/2 end
local band = M.band

function M.bor(a,b)  return MODM - band(MODM - a, MODM - b) end
local bor = M.bor

local lshift, rshift -- forward declare

function M.rshift(a,disp) -- Lua5.2 insipred
  if disp < 0 then return lshift(a,-disp) end
  return floor(a % 2^32 / 2^disp)
end
rshift = M.rshift

function M.lshift(a,disp) -- Lua5.2 inspired
  if disp < 0 then return rshift(a,-disp) end
  return (a * 2^disp) % 2^32
end
lshift = M.lshift

function M.tohex(x, n) -- BitOp style
  n = n or 8
  local up
  if n <= 0 then
    if n == 0 then return '' end
    up = true
    n = - n
  end
  x = band(x, 16^n-1)
  return ('%0'..n..(up and 'X' or 'x')):format(x)
end
local tohex = M.tohex

function M.extract(n, field, width) -- Lua5.2 inspired
  width = width or 1
  return band(rshift(n, field), 2^width-1)
end
local extract = M.extract

function M.replace(n, v, field, width) -- Lua5.2 inspired
  width = width or 1
  local mask1 = 2^width-1
  v = band(v, mask1) -- required by spec?
  local mask = bnot(lshift(mask1, field))
  return band(n, mask) + lshift(v, field)
end
local replace = M.replace

function M.bswap(x)  -- BitOp style
  local a = band(x, 0xff); x = rshift(x, 8)
  local b = band(x, 0xff); x = rshift(x, 8)
  local c = band(x, 0xff); x = rshift(x, 8)
  local d = band(x, 0xff)
  return lshift(lshift(lshift(a, 8) + b, 8) + c, 8) + d
end
local bswap = M.bswap

function M.rrotate(x, disp)  -- Lua5.2 inspired
  disp = disp % 32
  local low = band(x, 2^disp-1)
  return rshift(x, disp) + lshift(low, 32-disp)
end
local rrotate = M.rrotate

function M.lrotate(x, disp)  -- Lua5.2 inspired
  return rrotate(x, -disp)
end
local lrotate = M.lrotate

M.rol = M.lrotate  -- LuaOp inspired
M.ror = M.rrotate  -- LuaOp insipred


function M.arshift(x, disp) -- Lua5.2 inspired
  local z = rshift(x, disp)
  if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
  return z
end
local arshift = M.arshift

function M.btest(x, y) -- Lua5.2 inspired
  return band(x, y) ~= 0
end

--
-- Start Lua 5.2 "bit32" compat section.
--

M.bit32 = {} -- Lua 5.2 'bit32' compatibility


local function bit32_bnot(x)
  return (-1 - x) % MOD
end
M.bit32.bnot = bit32_bnot

local function bit32_bxor(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = bxor(a, b)
    if c then
      z = bit32_bxor(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end
M.bit32.bxor = bit32_bxor

local function bit32_band(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = ((a+b) - bxor(a,b)) / 2
    if c then
      z = bit32_band(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return MODM
  end
end
M.bit32.band = bit32_band

local function bit32_bor(a, b, c, ...)
  local z
  if b then
    a = a % MOD
    b = b % MOD
    z = MODM - band(MODM - a, MODM - b)
    if c then
      z = bit32_bor(z, c, ...)
    end
    return z
  elseif a then
    return a % MOD
  else
    return 0
  end
end
M.bit32.bor = bit32_bor

function M.bit32.btest(...)
  return bit32_band(...) ~= 0
end

function M.bit32.lrotate(x, disp)
  return lrotate(x % MOD, disp)
end

function M.bit32.rrotate(x, disp)
  return rrotate(x % MOD, disp)
end

function M.bit32.lshift(x,disp)
  if disp > 31 or disp < -31 then return 0 end
  return lshift(x % MOD, disp)
end

function M.bit32.rshift(x,disp)
  if disp > 31 or disp < -31 then return 0 end
  return rshift(x % MOD, disp)
end

function M.bit32.arshift(x,disp)
  x = x % MOD
  if disp >= 0 then
    if disp > 31 then
      return (x >= 0x80000000) and MODM or 0
    else
      local z = rshift(x, disp)
      if x >= 0x80000000 then z = z + lshift(2^disp-1, 32-disp) end
      return z
    end
  else
    return lshift(x, -disp)
  end
end

function M.bit32.extract(x, field, ...)
  local width = ... or 1
  if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
  x = x % MOD
  return extract(x, field, ...)
end

function M.bit32.replace(x, v, field, ...)
  local width = ... or 1
  if field < 0 or field > 31 or width < 0 or field+width > 32 then error 'out of range' end
  x = x % MOD
  v = v % MOD
  return replace(x, v, field, ...)
end

-- Chip8 Emulator (c) Edward 2019
-- Reference: www.multigesture.net/articles/how-to-write-an-emulator-chip-8-interpreter/
-- Implements all opcodes except 0x0NNN since obviously the code isn't being run on a RCA 1802 microcontroller

-- Future optimization potential: bitwise functions, sprite drawing opcode

local bit32 = M.bit32

-- Declaring everything as local vars speeds up var accesses
local pc = 0x200 -- program counter
local index = 0 -- register to store memory address
local sp = 0 -- stack pointer
local opcode = 0 -- current opcode
local memory = {}
local gfx = {}
local stack = {}
local registers = {}
local key = {}
local delay_timer = 0
local sound_timer = 0
local draw_flag = true
local inputTicks = 0
local i = 0

math.randomseed(timer.getMilliSecCounter()) -- seed PRNG

function init() -- Resets everything in emulator for ROM load
    pc = 0x200
    index = 0
    sp = 0
    opcode = 0

    for i = 0, 4095 do
        memory[i] = 0 -- clear memory
    end

    for i = 0, 2047 do -- clear graphics buffer
        gfx[i] = false -- Use boolean instead of number since the screen is b&w :P (memory saving)
    end

    for i = 0, 15 do -- 16 stack layers
        stack[i] = 0
    end

    key = {} -- clear input buffer: note tradeoff memory for speed

    for i = 0, 15 do -- 16 registers
        registers[i] = 0
    end

    local font_set = { -- system font
        0xF0, 0x90, 0x90, 0x90, 0xF0, --0
        0x20, 0x60, 0x20, 0x20, 0x70, --1
        0xF0, 0x10, 0xF0, 0x80, 0xF0, --2
        0xF0, 0x10, 0xF0, 0x10, 0xF0, --3
        0x90, 0x90, 0xF0, 0x10, 0x10, --4
        0xF0, 0x80, 0xF0, 0x10, 0xF0, --5
        0xF0, 0x80, 0xF0, 0x90, 0xF0, --6
        0xF0, 0x10, 0x20, 0x40, 0x40, --7
        0xF0, 0x90, 0xF0, 0x90, 0xF0, --8
        0xF0, 0x90, 0xF0, 0x10, 0xF0, --9
        0xF0, 0x90, 0xF0, 0x90, 0x90, --A
        0xE0, 0x90, 0xE0, 0x90, 0xE0, --B
        0xF0, 0x80, 0x80, 0x80, 0xF0, --C
        0xE0, 0x90, 0x90, 0x90, 0xE0, --D
        0xF0, 0x80, 0xF0, 0x80, 0xF0, --E
        0xF0, 0x80, 0xF0, 0x80, 0x80  --F
    }

    for i = 1, 80 do
        memory[i - 1] = font_set[i] -- mapped to memory[i - 1] since initialised lua arrays start from index 1 (annoying)
    end

    delay_timer = 0
    sound_timer = 0
    
    draw_flag = true
end

function load_rom(rom) -- does exactly what it's named :P
    for i = 1, #rom do
       memory[i - 1 + 0x200] = rom[i] -- mapped to memory[i - 1 + 0x200] since initialised lua arrays start from index 1 (annoying)
    end
end

function emulate_cycle() -- Emulates an instuction cycle of the chip8 vm
    opcode = bit32.bor(bit32.lshift(memory[pc], 8), memory[pc + 1]) -- Decode 2 byte big endian opcode
    local first_nibble = bit32.band(opcode, 0xF000)

    if first_nibble == 0x0000 then -- Splits opcodes based on their first nibble
        local last_nibble = bit32.band(opcode, 0x000F) -- Further splitting based on last nibble

        if last_nibble == 0x0000 then -- Opcode 0x00E0: Clear screen
            for i = 0, 2047 do -- clear display buffer
                gfx[i] = false
            end
            draw_flag = true -- screen redraw
            pc = pc + 2

        elseif last_nibble == 0x000E then -- Opcode 0x00EE: Return from subroutine
            sp = sp - 1 -- decrement stack pointer
            pc = stack[sp] -- jump to return address
            pc = pc + 2

        else
            print("Unknown opcode " .. opcode)
        end

    elseif first_nibble == 0x1000 then
        pc = bit32.band(opcode, 0x0FFF) -- Opcode 0x1NNN: Jumps to address 0x0NNN

    elseif first_nibble == 0x2000 then -- Opcode 0x2NNN: Calls subroutine at NNN.
        stack[sp] = pc
        sp = sp + 1
        pc = bit32.band(opcode, 0x0FFF)

    elseif first_nibble == 0x3000 then -- Opcode 0x3XNN: Skips the next instruction if register X equals NN
        if registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] == bit32.band(opcode, 0x00FF) then
            pc = pc + 4
        else
            pc = pc + 2
        end

    elseif first_nibble == 0x4000 then -- Opcode 0x4XNN: Skips the next instruction if register X doesn't equal NN
        if registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] ~= bit32.band(opcode, 0x00FF) then
            pc = pc + 4
        else
            pc = pc + 2
        end

    elseif first_nibble == 0x5000 then -- Opcode 0x5XY0: Skips the next instruction if VX equals VY.
        if registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] == registers[bit32.rshift(bit32.band(opcode, 0x00F0), 4)] then
            pc = pc + 4
        else
            pc = pc + 2
        end

    elseif first_nibble == 0x6000 then -- Opcode 0x6XNN: Sets register X to NN.
        registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = bit32.band(opcode, 0x00FF)
        pc = pc + 2

    elseif first_nibble == 0x7000 then -- Opcode 0x7XNN: Adds NN to register X.
        local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)
        registers[x] = (registers[x] + bit32.band(opcode, 0x00FF)) % 256 -- prevent from overflowing 8 bits
        pc = pc + 2

    elseif first_nibble == 0x8000 then
        local last_nibble = bit32.band(opcode, 0x000F)

        if last_nibble == 0x0000 then -- Opcode 0x8XY0: Sets register X to the value of register Y
            registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = registers[bit32.rshift(bit32.band(opcode, 0x00F0), 4)]
            pc = pc + 2

        elseif last_nibble == 0x0001 then -- Opcode 0x8XY1: Sets register X to "register X OR register Y"
            registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = bit32.bor(registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)], registers[bit32.rshift(bit32.band(opcode, 0x00F0), 4)])
            pc = pc + 2

        elseif last_nibble == 0x0002 then -- 0x8XY2: Sets register X to "register X AND register Y"
            registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = bit32.band(registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)], registers[bit32.rshift(bit32.band(opcode, 0x00F0), 4)])
            pc = pc + 2

        elseif last_nibble == 0x0003 then -- Opcode 0x8XY3: Sets register X to "register X XOR register Y"
            registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = bit32.bxor(registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)], registers[bit32.rshift(bit32.band(opcode, 0x00F0), 4)])
            pc = pc + 2

        elseif last_nibble == 0x0004 then -- Opcode 0x8XY4: Adds register Y to register X. register F is set to 1 when there's a carry, and to 0 when there isn't
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)
            local y = bit32.rshift(bit32.band(opcode, 0x00F0), 4)

            if registers[y] > 0xFF - registers[x] then -- checks if sum overflows 8 bits
                registers[0xF] = 1 -- set carry bit
            else
                registers[0xF] = 0
            end

            registers[x] = (registers[x] + registers[y]) % 256
            pc = pc + 2

        elseif last_nibble == 0x0005 then -- Opcode 0x8XY5: register Y is subtracted from register X. register F is set to 0 when there's a borrow, and 1 when there isn't
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)
            local y = bit32.rshift(bit32.band(opcode, 0x00F0), 4)

            if registers[y] >= registers[x] then -- checks if subtraction underflows
                registers[0xF] = 0
            else
                registers[0xF] = 1
            end

            registers[x] = (registers[x] - registers[y] + 256) % 256
            pc = pc + 2

        elseif last_nibble == 0x0006 then -- Opcode 0x8XY6: Shifts register X right by one. register F is set to the value of the least significant bit of register X before the shift
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)

            registers[0xF] = bit32.band(registers[x], 0x1)
            registers[x] = bit32.rshift(registers[x], 1)
            pc = pc + 2

        elseif last_nibble == 0x0007 then -- Opcode 0x8XY7: Sets register X to register Y minus register X. register F is set to 0 when there's a borrow, and 1 when there isn't
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)
            local y = bit32.rshift(bit32.band(opcode, 0x00F0), 4)

            if registers[x] >= registers[y] then -- checks if subtraction underflows
                registers[0xF] = 0
            else
                registers[0xF] = 1
            end

            registers[x] = (registers[y] - registers[x] + 256) % 256
            pc = pc + 2

        elseif last_nibble == 0x000E then -- Opcode 0x8XYE: Shifts register X left by one. register F is set to the value of the most significant bit of register X before the shift
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)

            registers[0xF] = bit32.band(registers[x], 0x1)
            registers[x] = (bit32.lshift(registers[x], 1) % 256)
            pc = pc + 2

        else
            print("Invalid opcode " .. opcode)
        end

    elseif first_nibble == 0x9000 then -- Opcode 0x9XY0: Skips the next instruction if register X doesn't equal register Y
        if registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] ~= registers[bit32.rshift(bit32.band(opcode, 0x00F0), 4)] then
            pc = pc + 4
        else
            pc = pc + 2
        end

    elseif first_nibble == 0xA000 then -- Opcode 0xANNN: Sets index register to the address NNN
        index = bit32.band(opcode, 0x0FFF)
        pc = pc + 2
    
    elseif first_nibble == 0xB000 then -- Opcode 0xBNNN: Jumps to the address NNN plus register 0
        pc = bit32.band(opcode, 0x0FFF) + registers[0]

    elseif first_nibble == 0xC000 then -- Opcode 0xCXNN: Sets register X to a random number and NN
        registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = bit32.band(math.random(0, 255), bit32.band(opcode, 0x00FF))
        pc = pc + 2

    elseif first_nibble == 0xD000 then 
        --[[ 
         Opcode 0xDXYN: Draws a sprite at coordinate (register X, register Y) that has a width of 8 pixels and a height of N pixels. 
         Each row of 8 pixels is read as bit-coded starting from memory location stored in index register; 
         The index register value doesn't change after the execution of this instruction. 
         VF is set to 1 if any screen pixels are flipped from set to unset when the sprite is drawn, 
         and to 0 if that doesn't happen
        ]]--
        local x = registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)]
        local y = registers[bit32.rshift(bit32.band(opcode, 0x00F0), 4)]
        local height = bit32.band(opcode, 0x000F)

        registers[0xF] = 0
        for yline = 0, height - 1 do
            local pixel = memory[index + yline]
             
            for xline = 0, 7 do
                if bit32.band(pixel, bit32.rshift(0x80, xline)) > 0 then
                    local dest = ((x + xline) % 64) + (((y + yline) % 32) * 64)

                    if gfx[dest] == true then -- invert pixel
                        registers[0xF] = 1
                        gfx[dest] = false
                    else
                        gfx[dest] = true
                    end
                end
            end
        end

        draw_flag = true
        pc = pc + 2

    elseif first_nibble == 0xE000 then
        local lower_byte = bit32.band(opcode, 0x00FF)

        if lower_byte == 0x009E then -- 0xEX9E: Skips the next instruction if the key stored in register X is pressed
            if key[registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)]] == true then
                pc = pc + 4
            else
                pc = pc + 2
            end

        elseif lower_byte == 0x00A1 then -- 0xEXA1: Skips the next instruction if the key stored in register X isn't pressed
            if key[registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)]] ~= true then
                pc = pc + 4
            else
                pc = pc + 2
            end

        else
            print("Invalid opcode " .. opcode)
        end

    elseif first_nibble == 0xF000 then
        local lower_byte = bit32.band(opcode, 0x00FF)

        if lower_byte == 0x0007 then -- Opcode 0xFX07: Sets register X to the value of the delay timer
            registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = delay_timer
            pc = pc + 2

        elseif lower_byte == 0x000A then -- Opcode 0xFX0A: A key press is awaited, and then stored in register X
            local keypress = false

            for i = 0, 15 do
                if key[i] == true then
                    registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] = i
                    keypress = true
                end
            end

            if keypress == false then -- pc will be stuck on this instruction so it will continue waiting for keypress
                return
            end

            pc = pc + 2

        elseif lower_byte == 0x0015 then -- Opcode 0xFX15: Sets the delay timer to register X
            delay_timer = registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)]
            pc = pc + 2

        elseif lower_byte == 0x0018 then -- Opcode 0xFX18: Sets the sound timer to register X
            sound_timer = registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)]
            pc = pc + 2

        elseif lower_byte == 0x001E then -- Opcode 0xFX1E: Adds register X to index register
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)

            if registers[x] + index > 0x0FFF then
                registers[0xF] = 1
            else
                registers[0xF] = 0
            end

            index = bit32.band((registers[x] + index), 0xFFF)
            pc = pc + 2

        elseif lower_byte == 0x0029 then -- Opcode 0xFX29: Sets I to the location of the sprite for the character in register X. Characters 0-F (in hexadecimal) are represented by a 4x5 font
            index = registers[bit32.rshift(bit32.band(opcode, 0x0F00), 8)] * 0x5
            pc = pc + 2

        elseif lower_byte == 0x0033 then -- Opcode 0xFX33: Stores the Binary-coded decimal representation of register X at the address in the index register, that address plus 1, and that address plus 2
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)

            memory[index] = registers[x] / 100
            memory[index + 1] = (registers[x] / 10) % 10
            memory[index + 2] = (registers[x] % 100) % 10
            pc = pc + 2

        elseif lower_byte == 0x0055 then -- Opcode 0xFX55: Stores register 0 to register X in memory starting at address in the index register	
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)
            
            for i = 0, x do
                memory[index + i] = registers[i]
            end

            -- On the original interpreter, when the operation is done, I = I + X + 1.
            index = index + x + 1

            pc = pc + 2

        elseif lower_byte == 0x0065 then -- Opcode 0xFX65: Fills V0 to VX with values from memory starting at index address 
            local x = bit32.rshift(bit32.band(opcode, 0x0F00), 8)

            for i = 0, x do
                registers[i] = memory[index + i]
            end

            -- On the original interpreter, when the operation is done, I = I + X + 1.
            index = index + x + 1

            pc = pc + 2

        else
            print("Invalid opcode " .. opcode)
        end

    else
        print("Invalid opcode " .. opcode)
    end
end

-- space invaders
myrom = {18, 37, 83, 80, 65, 67, 69, 32, 73, 78, 86, 65, 68, 69, 82, 83, 32, 118, 48, 46, 57, 32, 66, 121, 32, 68, 97, 118, 105, 100, 32, 87, 73, 78, 84, 69, 82, 96, 0, 97, 0, 98, 8, 163, 211, 208, 24, 113, 8, 242, 30, 49, 32, 18, 45, 112, 8, 97, 0, 48, 64, 18, 45, 105, 5, 108, 21, 110, 0, 35, 135, 96, 10, 240, 21, 240, 7, 48, 0, 18, 75, 35, 135, 126, 1, 18, 69, 102, 0, 104, 28, 105, 0, 106, 4, 107, 10, 108, 4, 109, 60, 110, 15, 0, 224, 35, 107, 35, 71, 253, 21, 96, 4, 224, 158, 18, 125, 35, 107, 56, 0, 120, 255, 35, 107, 96, 6, 224, 158, 18, 139, 35, 107, 56, 57, 120, 1, 35, 107, 54, 0, 18, 159, 96, 5, 224, 158, 18, 233, 102, 1, 101, 27, 132, 128, 163, 207, 212, 81, 163, 207, 212, 81, 117, 255, 53, 255, 18, 173, 102, 0, 18, 233, 212, 81, 63, 1, 18, 233, 212, 81, 102, 0, 131, 64, 115, 3, 131, 181, 98, 248, 131, 34, 98, 8, 51, 0, 18, 201, 35, 115, 130, 6, 67, 8, 18, 211, 51, 16, 18, 213, 35, 115, 130, 6, 51, 24, 18, 221, 35, 115, 130, 6, 67, 32, 18, 231, 51, 40, 18, 233, 35, 115, 62, 0, 19, 7, 121, 6, 73, 24, 105, 0, 106, 4, 107, 10, 108, 4, 125, 244, 110, 15, 0, 224, 35, 71, 35, 107, 253, 21, 18, 111, 247, 7, 55, 0, 18, 111, 253, 21, 35, 71, 139, 164, 59, 18, 19, 27, 124, 2, 106, 252, 59, 2, 19, 35, 124, 2, 106, 4, 35, 71, 60, 24, 18, 111, 0, 224, 164, 211, 96, 20, 97, 8, 98, 15, 208, 31, 112, 8, 242, 30, 48, 44, 19, 51, 240, 10, 0, 224, 166, 244, 254, 101, 18, 37, 163, 183, 249, 30, 97, 8, 35, 95, 129, 6, 35, 95, 129, 6, 35, 95, 129, 6, 35, 95, 123, 208, 0, 238, 128, 224, 128, 18, 48, 0, 219, 198, 123, 12, 0, 238, 163, 207, 96, 28, 216, 4, 0, 238, 35, 71, 142, 35, 35, 71, 96, 5, 240, 24, 240, 21, 240, 7, 48, 0, 19, 127, 0, 238, 106, 0, 141, 224, 107, 4, 233, 161, 18, 87, 166, 2, 253, 30, 240, 101, 48, 255, 19, 165, 106, 0, 107, 4, 109, 1, 110, 1, 19, 141, 165, 0, 240, 30, 219, 198, 123, 8, 125, 1, 122, 1, 58, 7, 19, 141, 0, 238, 60, 126, 255, 255, 153, 153, 126, 255, 255, 36, 36, 231, 126, 255, 60, 60, 126, 219, 129, 66, 60, 126, 255, 219, 16, 56, 124, 254, 0, 0, 127, 0, 63, 0, 127, 0, 0, 0, 1, 1, 1, 3, 3, 3, 3, 0, 0, 63, 32, 32, 32, 32, 32, 32, 32, 32, 63, 8, 8, 255, 0, 0, 254, 0, 252, 0, 254, 0, 0, 0, 126, 66, 66, 98, 98, 98, 98, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 125, 0, 65, 125, 5, 125, 125, 0, 0, 194, 194, 198, 68, 108, 40, 56, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 247, 16, 20, 247, 247, 4, 4, 0, 0, 124, 68, 254, 194, 194, 194, 194, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 239, 32, 40, 232, 232, 47, 47, 0, 0, 249, 133, 197, 197, 197, 197, 249, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 190, 0, 32, 48, 32, 190, 190, 0, 0, 247, 4, 231, 133, 133, 132, 244, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 127, 0, 63, 0, 127, 0, 0, 0, 239, 40, 239, 0, 224, 96, 111, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 255, 0, 0, 254, 0, 252, 0, 254, 0, 0, 0, 192, 0, 192, 192, 192, 192, 192, 0, 0, 252, 4, 4, 4, 4, 4, 4, 4, 4, 252, 16, 16, 255, 249, 129, 185, 139, 154, 154, 250, 0, 250, 138, 154, 154, 155, 153, 248, 230, 37, 37, 244, 52, 52, 52, 0, 23, 20, 52, 55, 54, 38, 199, 223, 80, 80, 92, 216, 216, 223, 0, 223, 17, 31, 18, 27, 25, 217, 124, 68, 254, 134, 134, 134, 252, 132, 254, 130, 130, 254, 254, 128, 192, 192, 192, 254, 252, 130, 194, 194, 194, 252, 254, 128, 248, 192, 192, 254, 254, 128, 240, 192, 192, 192, 254, 128, 190, 134, 134, 254, 134, 134, 254, 134, 134, 134, 16, 16, 16, 16, 16, 16, 24, 24, 24, 72, 72, 120, 156, 144, 176, 192, 176, 156, 128, 128, 192, 192, 192, 254, 238, 146, 146, 134, 134, 134, 254, 130, 134, 134, 134, 134, 124, 130, 134, 134, 134, 124, 254, 130, 254, 192, 192, 192, 124, 130, 194, 202, 196, 122, 254, 134, 254, 144, 156, 132, 254, 192, 254, 2, 2, 254, 254, 16, 48, 48, 48, 48, 130, 130, 194, 194, 194, 254, 130, 130, 130, 238, 56, 16, 134, 134, 150, 146, 146, 238, 130, 68, 56, 56, 68, 130, 130, 130, 254, 48, 48, 48, 254, 2, 30, 240, 128, 254, 0, 0, 0, 0, 6, 6, 0, 0, 0, 96, 96, 192, 0, 0, 0, 0, 0, 0, 24, 24, 24, 24, 0, 24, 124, 198, 12, 24, 0, 24, 0, 0, 254, 254, 0, 0, 254, 130, 134, 134, 134, 254, 8, 8, 8, 24, 24, 24, 254, 2, 254, 192, 192, 254, 254, 2, 30, 6, 6, 254, 132, 196, 196, 254, 4, 4, 254, 128, 254, 6, 6, 254, 192, 192, 192, 254, 130, 254, 254, 2, 2, 6, 6, 6, 124, 68, 254, 134, 134, 254, 254, 130, 254, 6, 6, 6, 68, 254, 68, 68, 254, 68, 168, 168, 168, 168, 168, 168, 168, 108, 90, 0, 12, 24, 168, 48, 78, 126, 0, 18, 24, 102, 108, 168, 90, 102, 84, 36, 102, 0, 72, 72, 24, 18, 168, 6, 144, 168, 18, 0, 126, 48, 18, 168, 132, 48, 78, 114, 24, 102, 168, 168, 168, 168, 168, 168, 144, 84, 120, 168, 72, 120, 108, 114, 168, 18, 24, 108, 114, 102, 84, 144, 168, 114, 42, 24, 168, 48, 78, 126, 0, 18, 24, 102, 108, 168, 114, 84, 168, 90, 102, 24, 126, 24, 78, 114, 168, 114, 42, 24, 48, 102, 168, 48, 78, 126, 0, 108, 48, 84, 78, 156, 168, 168, 168, 168, 168, 168, 168, 72, 84, 126, 24, 168, 144, 84, 120, 102, 168, 108, 42, 48, 90, 168, 132, 48, 114, 42, 168, 216, 168, 0, 78, 18, 168, 228, 162, 168, 0, 78, 18, 168, 108, 42, 84, 84, 114, 168, 132, 48, 114, 42, 168, 222, 156, 168, 114, 42, 24, 168, 12, 84, 72, 90, 120, 114, 24, 102, 168, 114, 24, 66, 66, 108, 168, 114, 42, 0, 114, 168, 114, 42, 24, 168, 48, 78, 126, 0, 18, 24, 102, 108, 168, 48, 78, 12, 102, 24, 0, 108, 24, 168, 114, 42, 24, 48, 102, 168, 30, 84, 102, 12, 24, 156, 168, 36, 84, 84, 18, 168, 66, 120, 12, 60, 168, 174, 168, 168, 168, 168, 168, 168, 168, 255, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}

init()
load_rom(myrom)

-- paint handing, timer handing

function on.timer()

    for i = 1, 10 do -- 10 emulation cycles per tick
        emulate_cycle()
    end
    
    if delay_timer > 0 then
        delay_timer = delay_timer - 1
    end

    if sound_timer > 0 then
        if sound_timer == 1 then
            -- nothing here! calculators don't have speakers :(
        end
        sound_timer = sound_timer - 1
    end
    
    if draw_flag == true then
        platform.window:invalidate() -- <-- undocumented evil magic right here
        draw_flag = false
    end

    if inputTicks > 4 then -- only reset input every 4 ticks
        key = {}
        inputTicks = 0
    else
        inputTicks = inputTicks + 1
    end
end

function on.paint(gc) -- calculator render perf is TERRIBLE D:< optimisation needed here :(
    local gfx = gfx
    local fill_rect = gc.fillRect
    
    fill_rect(gc,0,0,318,212) -- black screen
    gc:setColorRGB(255,255,255)

    for ypix = 0, 31 do
        for xpix = 0, 63 do
            if gfx[ypix*64 + xpix] == true then
                fill_rect(gc, xpix * 5, ypix * 5, 5, 5) -- chip8 pixels enlarged 5 times so you can see them :)
            end
        end
    end
end

function on.arrowUp()
    key[2] = true
end

function on.arrowDown()
    key[8] = true
end

function on.arrowLeft()
    key[4] = true
end

function on.arrowRight()
    key[6] = true
end

function on.mouseDown()
    key[5] = true
end

function on.charIn(character) -- map hexadecimal keypad to letters
    if character == "a" then
        key[1] = true
    elseif character == "b" then
        key[2] = true
    elseif character == "c" then
        key[3] = true
    elseif character == "d" then
        key[0xC] = true
    elseif character == "h" then
        key[4] = true
    elseif character == "i" then
        key[5] = true
    elseif character == "j" then
        key[6] = true
    elseif character == "k" then
        key[0xD] = true
    elseif character == "o" then
        key[7] = true
    elseif character == "p" then
        key[8] = true
    elseif character == "q" then
        key[9] = true
    elseif character == "r" then
        key[0xE] = true
    elseif character == "v" then
        key[0xA] = true
    elseif character == "w" then
        key[0] = true
    elseif character == "x" then
        key[0xB] = true
    elseif character == "y" then
        key[0xF] = true
    end
end

timer.start(0.016) -- Approximate 60hz tick pulse: timer is only accurate to 0.01s :(
