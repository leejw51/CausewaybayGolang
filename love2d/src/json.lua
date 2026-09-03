-- Minimal JSON encode/decode. Enough for the Ollama chat API: objects,
-- arrays, strings (with \u escapes), numbers, booleans and null.

local Json = {}

local ESC = {
  ['"'] = '\\"',
  ["\\"] = "\\\\",
  ["\b"] = "\\b",
  ["\f"] = "\\f",
  ["\n"] = "\\n",
  ["\r"] = "\\r",
  ["\t"] = "\\t",
}

local function escape(s)
  return (s:gsub('[%c"\\]', function(c)
    return ESC[c] or string.format("\\u%04x", c:byte())
  end))
end

local function isArray(t)
  local n = 0
  for k in pairs(t) do
    if type(k) ~= "number" then
      return false
    end
    n = n + 1
  end
  -- {} encodes as an object: the tool schema needs "properties": {} for a
  -- no-argument function, and no payload here ever sends an empty array.
  if n == 0 then
    return false
  end
  return n == #t
end

function Json.encode(v)
  local ty = type(v)
  if v == nil then
    return "null"
  end
  if ty == "boolean" then
    return tostring(v)
  end
  if ty == "number" then
    if v ~= v or v == math.huge or v == -math.huge then
      return "null"
    end
    return string.format("%.14g", v)
  end
  if ty == "string" then
    return '"' .. escape(v) .. '"'
  end
  if ty == "table" then
    local out = {}
    if isArray(v) then
      for i = 1, #v do
        out[i] = Json.encode(v[i])
      end
      return "[" .. table.concat(out, ",") .. "]"
    end
    for k, val in pairs(v) do
      out[#out + 1] = '"' .. escape(tostring(k)) .. '":' .. Json.encode(val)
    end
    return "{" .. table.concat(out, ",") .. "}"
  end
  return "null"
end

-- decode ---------------------------------------------------------------

local decodeValue

local function skip(s, i)
  local _, j = s:find("^[ \t\r\n]*", i)
  return (j or i - 1) + 1
end

local function utf8char(c)
  if c < 0x80 then
    return string.char(c)
  end
  if c < 0x800 then
    return string.char(0xC0 + math.floor(c / 0x40), 0x80 + c % 0x40)
  end
  if c < 0x10000 then
    return string.char(0xE0 + math.floor(c / 0x1000), 0x80 + math.floor(c / 0x40) % 0x40, 0x80 + c % 0x40)
  end
  return string.char(
    0xF0 + math.floor(c / 0x40000),
    0x80 + math.floor(c / 0x1000) % 0x40,
    0x80 + math.floor(c / 0x40) % 0x40,
    0x80 + c % 0x40
  )
end

local UNESC = {
  ['"'] = '"',
  ["\\"] = "\\",
  ["/"] = "/",
  b = "\b",
  f = "\f",
  n = "\n",
  r = "\r",
  t = "\t",
}

local function decodeString(s, i)
  local out, j = {}, i + 1
  while true do
    local c = s:sub(j, j)
    if c == "" then
      return nil, j, "unterminated string"
    end
    if c == '"' then
      return table.concat(out), j + 1
    end
    if c == "\\" then
      local e = s:sub(j + 1, j + 1)
      if e == "u" then
        local hex = s:sub(j + 2, j + 5)
        local cp = tonumber(hex, 16)
        j = j + 6
        if cp and cp >= 0xD800 and cp <= 0xDBFF and s:sub(j, j + 1) == "\\u" then
          local lo = tonumber(s:sub(j + 2, j + 5), 16)
          if lo and lo >= 0xDC00 and lo <= 0xDFFF then
            cp = 0x10000 + (cp - 0xD800) * 0x400 + (lo - 0xDC00)
            j = j + 6
          end
        end
        out[#out + 1] = utf8char(cp or 0x3F)
      else
        out[#out + 1] = UNESC[e] or e
        j = j + 2
      end
    else
      local nxt = s:find('[\\"]', j) or (#s + 1)
      out[#out + 1] = s:sub(j, nxt - 1)
      j = nxt
    end
  end
end

decodeValue = function(s, i)
  i = skip(s, i)
  local c = s:sub(i, i)
  if c == "" then
    return nil, i, "eof"
  end
  if c == '"' then
    return decodeString(s, i)
  end
  if c == "{" then
    local obj = {}
    i = skip(s, i + 1)
    if s:sub(i, i) == "}" then
      return obj, i + 1
    end
    while true do
      local k, v, err
      i = skip(s, i)
      if s:sub(i, i) ~= '"' then
        return nil, i, "bad key"
      end
      k, i, err = decodeString(s, i)
      if err then
        return nil, i, err
      end
      i = skip(s, i)
      if s:sub(i, i) ~= ":" then
        return nil, i, "expected :"
      end
      v, i, err = decodeValue(s, i + 1)
      if err then
        return nil, i, err
      end
      obj[k] = v
      i = skip(s, i)
      local d = s:sub(i, i)
      if d == "," then
        i = i + 1
      elseif d == "}" then
        return obj, i + 1
      else
        return nil, i, "expected , or }"
      end
    end
  end
  if c == "[" then
    local arr = {}
    i = skip(s, i + 1)
    if s:sub(i, i) == "]" then
      return arr, i + 1
    end
    while true do
      local v, err
      v, i, err = decodeValue(s, i)
      if err then
        return nil, i, err
      end
      arr[#arr + 1] = v
      i = skip(s, i)
      local d = s:sub(i, i)
      if d == "," then
        i = i + 1
      elseif d == "]" then
        return arr, i + 1
      else
        return nil, i, "expected , or ]"
      end
    end
  end
  if s:sub(i, i + 3) == "true" then
    return true, i + 4
  end
  if s:sub(i, i + 4) == "false" then
    return false, i + 5
  end
  if s:sub(i, i + 3) == "null" then
    return nil, i + 4
  end
  local num, j = s:match("^(-?%d+%.?%d*[eE]?[-+]?%d*)()", i)
  if num and tonumber(num) then
    return tonumber(num), j
  end
  return nil, i, "unexpected token " .. c
end

-- Returns value, err
function Json.decode(s)
  if type(s) ~= "string" then
    return nil, "not a string"
  end
  local v, _, err = decodeValue(s, 1)
  if err then
    return nil, err
  end
  return v
end

return Json
