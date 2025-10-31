-- Keyboard remap for Mac Polish keyboard

-- Only load on macOS
if vim.fn.has("mac") == 0 and vim.fn.has("macunix") == 0 then
  return
end

-- Map special characters to Alt/Option key combinations
local function map_meta(char, key)
  vim.keymap.set({ "i", "n", "v", "o" }, char, "<M-" .. key .. ">", { remap = true })
end

local function map_meta_shift(char, key)
  vim.keymap.set({ "i", "n", "v", "o" }, char, "<M-S-" .. key .. ">", { remap = true })
end

map_meta("Ō", "q")
map_meta("∑", "w")
map_meta("ę", "e")
map_meta("®", "r")
map_meta("†", "t")
map_meta("ī", "y")
map_meta("¨", "u")
map_meta("^", "i")
map_meta("ó", "o")
map_meta("Ļ", "p")
map_meta("ą", "a")
map_meta("ś", "s")
map_meta("∂", "d")
map_meta("ń", "f")
map_meta("©", "g")
map_meta("ķ", "h")
map_meta("∆", "j")
map_meta("Ż", "k")
map_meta("ł", "l")
map_meta("ż", "z")
map_meta("ź", "x")
map_meta("ć", "c")
map_meta("√", "v")
map_meta("ļ", "b")
map_meta("ń", "n")
map_meta("Ķ", "m")

map_meta_shift("ő", "q")
map_meta_shift("„", "w")
map_meta_shift("Ę", "e")
map_meta_shift("£", "r")
map_meta_shift("ś", "t")
map_meta_shift("Á", "y")
map_meta_shift("Ť", "u")
map_meta_shift("ť", "i")
map_meta_shift("Ó", "o")
map_meta_shift("ł", "p")
map_meta_shift("Ą", "a")
map_meta_shift("Ś", "s")
map_meta_shift("Ž", "d")
map_meta_shift("ž", "f")
map_meta_shift("Ū", "g")
map_meta_shift("Ó", "h")
map_meta_shift("Ô", "j")
map_meta_shift("ū", "k")
map_meta_shift("Ł", "l")
map_meta_shift("Ż", "z")
map_meta_shift("Ź", "x")
map_meta_shift("Ć", "c")
map_meta_shift("◊", "v")
map_meta_shift("ű", "b")
map_meta_shift("Ń", "n")
map_meta_shift("ų", "m")
