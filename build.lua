
local ____modules = {}
local ____moduleCache = {}
local ____originalRequire = require
local function require(file)
    if ____moduleCache[file] then
        return ____moduleCache[file]
    end
    if ____modules[file] then
        ____moduleCache[file] = ____modules[file]()
        return ____moduleCache[file]
    else
        if ____originalRequire then
            return ____originalRequire(file)
        else
            error("module '" .. file .. "' not found")
        end
    end
end
____modules = {
["lualib_bundle"] = function() function __TS__ArrayConcat(arr1, ...)
    local args = {...}
    local out = {}
    for ____, val in ipairs(arr1) do
        out[#out + 1] = val
    end
    for ____, arg in ipairs(args) do
        if pcall(
            function() return #arg end
        ) and (type(arg) ~= "string") then
            local argAsArray = arg
            for ____, val in ipairs(argAsArray) do
                out[#out + 1] = val
            end
        else
            out[#out + 1] = arg
        end
    end
    return out
end

function __TS__ArrayEvery(arr, callbackfn)
    do
        local i = 0
        while i < #arr do
            if not callbackfn(_G, arr[i + 1], i, arr) then
                return false
            end
            i = i + 1
        end
    end
    return true
end

function __TS__ArrayFilter(arr, callbackfn)
    local result = {}
    do
        local i = 0
        while i < #arr do
            if callbackfn(_G, arr[i + 1], i, arr) then
                result[#result + 1] = arr[i + 1]
            end
            i = i + 1
        end
    end
    return result
end

function __TS__ArrayForEach(arr, callbackFn)
    do
        local i = 0
        while i < #arr do
            callbackFn(_G, arr[i + 1], i, arr)
            i = i + 1
        end
    end
end

function __TS__ArrayFind(arr, predicate)
    local len = #arr
    local k = 0
    while k < len do
        local elem = arr[k + 1]
        if predicate(_G, elem, k, arr) then
            return elem
        end
        k = k + 1
    end
    return nil
end

function __TS__ArrayFindIndex(arr, callbackFn)
    do
        local i = 0
        local len = #arr
        while i < len do
            if callbackFn(_G, arr[i + 1], i, arr) then
                return i
            end
            i = i + 1
        end
    end
    return -1
end

function __TS__ArrayIncludes(self, searchElement, fromIndex)
    if fromIndex == nil then
        fromIndex = 0
    end
    local len = #self
    local k = fromIndex
    if fromIndex < 0 then
        k = len + fromIndex
    end
    if k < 0 then
        k = 0
    end
    for i = k, len do
        if self[i + 1] == searchElement then
            return true
        end
    end
    return false
end

function __TS__ArrayIndexOf(arr, searchElement, fromIndex)
    local len = #arr
    if len == 0 then
        return -1
    end
    local n = 0
    if fromIndex then
        n = fromIndex
    end
    if n >= len then
        return -1
    end
    local k
    if n >= 0 then
        k = n
    else
        k = len + n
        if k < 0 then
            k = 0
        end
    end
    do
        local i = k
        while i < len do
            if arr[i + 1] == searchElement then
                return i
            end
            i = i + 1
        end
    end
    return -1
end

function __TS__ArrayJoin(self, separator)
    if separator == nil then
        separator = ","
    end
    local result = ""
    for index, value in ipairs(self) do
        if index > 1 then
            result = tostring(result) .. tostring(separator)
        end
        result = tostring(result) .. tostring(
            tostring(value)
        )
    end
    return result
end

function __TS__ArrayMap(arr, callbackfn)
    local newArray = {}
    do
        local i = 0
        while i < #arr do
            newArray[i + 1] = callbackfn(_G, arr[i + 1], i, arr)
            i = i + 1
        end
    end
    return newArray
end

function __TS__ArrayPush(arr, ...)
    local items = {...}
    for ____, item in ipairs(items) do
        arr[#arr + 1] = item
    end
    return #arr
end

function __TS__ArrayReduce(arr, callbackFn, ...)
    local len = #arr
    local k = 0
    local accumulator = nil
    if select("#", ...) ~= 0 then
        accumulator = select(1, ...)
    elseif len > 0 then
        accumulator = arr[1]
        k = 1
    else
        error("Reduce of empty array with no initial value", 0)
    end
    for i = k, len - 1 do
        accumulator = callbackFn(_G, accumulator, arr[i + 1], i, arr)
    end
    return accumulator
end

function __TS__ArrayReduceRight(arr, callbackFn, ...)
    local len = #arr
    local k = len - 1
    local accumulator = nil
    if select("#", ...) ~= 0 then
        accumulator = select(1, ...)
    elseif len > 0 then
        accumulator = arr[k + 1]
        k = k - 1
    else
        error("Reduce of empty array with no initial value", 0)
    end
    for i = k, 0, -1 do
        accumulator = callbackFn(_G, accumulator, arr[i + 1], i, arr)
    end
    return accumulator
end

function __TS__ArrayReverse(arr)
    local i = 0
    local j = #arr - 1
    while i < j do
        local temp = arr[j + 1]
        arr[j + 1] = arr[i + 1]
        arr[i + 1] = temp
        i = i + 1
        j = j - 1
    end
    return arr
end

function __TS__ArrayShift(arr)
    return table.remove(arr, 1)
end

function __TS__ArrayUnshift(arr, ...)
    local items = {...}
    do
        local i = #items - 1
        while i >= 0 do
            table.insert(arr, 1, items[i + 1])
            i = i - 1
        end
    end
    return #arr
end

function __TS__ArraySort(arr, compareFn)
    if compareFn ~= nil then
        table.sort(
            arr,
            function(a, b) return compareFn(_G, a, b) < 0 end
        )
    else
        table.sort(arr)
    end
    return arr
end

function __TS__ArraySlice(list, first, last)
    local len = #list
    local relativeStart = first or 0
    local k
    if relativeStart < 0 then
        k = math.max(len + relativeStart, 0)
    else
        k = math.min(relativeStart, len)
    end
    local relativeEnd = last
    if last == nil then
        relativeEnd = len
    end
    local final
    if relativeEnd < 0 then
        final = math.max(len + relativeEnd, 0)
    else
        final = math.min(relativeEnd, len)
    end
    local out = {}
    local n = 0
    while k < final do
        out[n + 1] = list[k + 1]
        k = k + 1
        n = n + 1
    end
    return out
end

function __TS__ArraySome(arr, callbackfn)
    do
        local i = 0
        while i < #arr do
            if callbackfn(_G, arr[i + 1], i, arr) then
                return true
            end
            i = i + 1
        end
    end
    return false
end

function __TS__ArraySplice(list, ...)
    local len = #list
    local actualArgumentCount = select("#", ...)
    local start = select(1, ...)
    local deleteCount = select(2, ...)
    local actualStart
    if start < 0 then
        actualStart = math.max(len + start, 0)
    else
        actualStart = math.min(start, len)
    end
    local itemCount = math.max(actualArgumentCount - 2, 0)
    local actualDeleteCount
    if actualArgumentCount == 0 then
        actualDeleteCount = 0
    elseif actualArgumentCount == 1 then
        actualDeleteCount = len - actualStart
    else
        actualDeleteCount = math.min(
            math.max(deleteCount or 0, 0),
            len - actualStart
        )
    end
    local out = {}
    do
        local k = 0
        while k < actualDeleteCount do
            local from = actualStart + k
            if list[from + 1] then
                out[k + 1] = list[from + 1]
            end
            k = k + 1
        end
    end
    if itemCount < actualDeleteCount then
        do
            local k = actualStart
            while k < (len - actualDeleteCount) do
                local from = k + actualDeleteCount
                local to = k + itemCount
                if list[from + 1] then
                    list[to + 1] = list[from + 1]
                else
                    list[to + 1] = nil
                end
                k = k + 1
            end
        end
        do
            local k = len
            while k > ((len - actualDeleteCount) + itemCount) do
                list[k] = nil
                k = k - 1
            end
        end
    elseif itemCount > actualDeleteCount then
        do
            local k = len - actualDeleteCount
            while k > actualStart do
                local from = (k + actualDeleteCount) - 1
                local to = (k + itemCount) - 1
                if list[from + 1] then
                    list[to + 1] = list[from + 1]
                else
                    list[to + 1] = nil
                end
                k = k - 1
            end
        end
    end
    local j = actualStart
    for i = 3, actualArgumentCount do
        list[j + 1] = select(i, ...)
        j = j + 1
    end
    do
        local k = #list - 1
        while k >= ((len - actualDeleteCount) + itemCount) do
            list[k + 1] = nil
            k = k - 1
        end
    end
    return out
end

function __TS__ArrayToObject(array)
    local object = {}
    do
        local i = 0
        while i < #array do
            object[i] = array[i + 1]
            i = i + 1
        end
    end
    return object
end

function __TS__ArrayFlat(array, depth)
    if depth == nil then
        depth = 1
    end
    local result = {}
    for ____, value in ipairs(array) do
        if ((depth > 0) and (type(value) == "table")) and ((value[1] ~= nil) or (next(value, nil) == nil)) then
            result = __TS__ArrayConcat(
                result,
                __TS__ArrayFlat(value, depth - 1)
            )
        else
            result[#result + 1] = value
        end
    end
    return result
end

function __TS__ArrayFlatMap(array, callback)
    local result = {}
    do
        local i = 0
        while i < #array do
            local value = callback(_G, array[i + 1], i, array)
            if (type(value) == "table") and ((value[1] ~= nil) or (next(value, nil) == nil)) then
                result = __TS__ArrayConcat(result, value)
            else
                result[#result + 1] = value
            end
            i = i + 1
        end
    end
    return result
end

function __TS__ArraySetLength(arr, length)
    if (((length < 0) or (length ~= length)) or (length == math.huge)) or (math.floor(length) ~= length) then
        error(
            "invalid array length: " .. tostring(length),
            0
        )
    end
    do
        local i = #arr - 1
        while i >= length do
            arr[i + 1] = nil
            i = i - 1
        end
    end
    return length
end

function __TS__Class(self)
    local c = {prototype = {}}
    c.prototype.__index = c.prototype
    c.prototype.constructor = c
    return c
end

function __TS__ClassExtends(target, base)
    target.____super = base
    local staticMetatable = setmetatable({__index = base}, base)
    setmetatable(target, staticMetatable)
    local baseMetatable = getmetatable(base)
    if baseMetatable then
        if type(baseMetatable.__index) == "function" then
            staticMetatable.__index = baseMetatable.__index
        end
        if type(baseMetatable.__newindex) == "function" then
            staticMetatable.__newindex = baseMetatable.__newindex
        end
    end
    setmetatable(target.prototype, base.prototype)
    if type(base.prototype.__index) == "function" then
        target.prototype.__index = base.prototype.__index
    end
    if type(base.prototype.__newindex) == "function" then
        target.prototype.__newindex = base.prototype.__newindex
    end
    if type(base.prototype.__tostring) == "function" then
        target.prototype.__tostring = base.prototype.__tostring
    end
end

function __TS__CloneDescriptor(____bindingPattern0)
    local enumerable
    enumerable = ____bindingPattern0.enumerable
    local configurable
    configurable = ____bindingPattern0.configurable
    local get
    get = ____bindingPattern0.get
    local set
    set = ____bindingPattern0.set
    local writable
    writable = ____bindingPattern0.writable
    local value
    value = ____bindingPattern0.value
    local descriptor = {enumerable = enumerable == true, configurable = configurable == true}
    local hasGetterOrSetter = (get ~= nil) or (set ~= nil)
    local hasValueOrWritableAttribute = (writable ~= nil) or (value ~= nil)
    if hasGetterOrSetter and hasValueOrWritableAttribute then
        error("Invalid property descriptor. Cannot both specify accessors and a value or writable attribute.", 0)
    end
    if get or set then
        descriptor.get = get
        descriptor.set = set
    else
        descriptor.value = value
        descriptor.writable = writable == true
    end
    return descriptor
end

function __TS__Decorate(decorators, target, key, desc)
    local result = target
    do
        local i = #decorators
        while i >= 0 do
            local decorator = decorators[i + 1]
            if decorator then
                local oldResult = result
                if key == nil then
                    result = decorator(_G, result)
                elseif desc == true then
                    local value = rawget(target, key)
                    local descriptor = __TS__ObjectGetOwnPropertyDescriptor(target, key) or ({configurable = true, writable = true, value = value})
                    local desc = decorator(_G, target, key, descriptor) or descriptor
                    local isSimpleValue = (((desc.configurable == true) and (desc.writable == true)) and (not desc.get)) and (not desc.set)
                    if isSimpleValue then
                        rawset(target, key, desc.value)
                    else
                        __TS__SetDescriptor(
                            target,
                            key,
                            __TS__ObjectAssign({}, descriptor, desc)
                        )
                    end
                elseif desc == false then
                    result = decorator(_G, target, key, desc)
                else
                    result = decorator(_G, target, key)
                end
                result = result or oldResult
            end
            i = i - 1
        end
    end
    return result
end

function __TS__DecorateParam(paramIndex, decorator)
    return function(____, target, key) return decorator(_G, target, key, paramIndex) end
end

function __TS__ObjectGetOwnPropertyDescriptors(object)
    local metatable = getmetatable(object)
    if not metatable then
        return {}
    end
    return rawget(metatable, "_descriptors")
end

function __TS__Delete(target, key)
    local descriptors = __TS__ObjectGetOwnPropertyDescriptors(target)
    local descriptor = descriptors[key]
    if descriptor then
        if not descriptor.configurable then
            error(
                ((("Cannot delete property " .. tostring(key)) .. " of ") .. tostring(target)) .. ".",
                0
            )
        end
        descriptors[key] = nil
        return true
    end
    if target[key] ~= nil then
        target[key] = nil
        return true
    end
    return false
end

function __TS__DelegatedYield(iterable)
    if type(iterable) == "string" then
        for index = 0, #iterable - 1 do
            coroutine.yield(
                __TS__StringAccess(iterable, index)
            )
        end
    elseif iterable.____coroutine ~= nil then
        local co = iterable.____coroutine
        while true do
            local status, value = coroutine.resume(co)
            if not status then
                error(value, 0)
            end
            if coroutine.status(co) == "dead" then
                return value
            else
                coroutine.yield(value)
            end
        end
    elseif iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        while true do
            local result = iterator:next()
            if result.done then
                return result.value
            else
                coroutine.yield(result.value)
            end
        end
    else
        for ____, value in ipairs(iterable) do
            coroutine.yield(value)
        end
    end
end

function __TS__New(target, ...)
    local instance = setmetatable({}, target.prototype)
    instance:____constructor(...)
    return instance
end

function __TS__GetErrorStack(self, constructor)
    local level = 1
    while true do
        local info = debug.getinfo(level, "f")
        level = level + 1
        if not info then
            level = 1
            break
        elseif info.func == constructor then
            break
        end
    end
    return debug.traceback(nil, level)
end
function __TS__WrapErrorToString(self, getDescription)
    return function(self)
        local description = getDescription(self)
        local caller = debug.getinfo(3, "f")
        if (_VERSION == "Lua 5.1") or (caller and (caller.func ~= error)) then
            return description
        else
            return (tostring(description) .. "\n") .. tostring(self.stack)
        end
    end
end
function __TS__InitErrorClass(self, Type, name)
    Type.name = name
    return setmetatable(
        Type,
        {
            __call = function(____, _self, message) return __TS__New(Type, message) end
        }
    )
end
Error = __TS__InitErrorClass(
    _G,
    (function()
        local ____ = __TS__Class()
        ____.name = ""
        function ____.prototype.____constructor(self, message)
            if message == nil then
                message = ""
            end
            self.message = message
            self.name = "Error"
            self.stack = __TS__GetErrorStack(_G, self.constructor.new)
            local metatable = getmetatable(self)
            if not metatable.__errorToStringPatched then
                metatable.__errorToStringPatched = true
                metatable.__tostring = __TS__WrapErrorToString(_G, metatable.__tostring)
            end
        end
        function ____.prototype.__tostring(self)
            return (((self.message ~= "") and (function() return (tostring(self.name) .. ": ") .. tostring(self.message) end)) or (function() return self.name end))()
        end
        return ____
    end)(),
    "Error"
)
for ____, errorName in ipairs({"RangeError", "ReferenceError", "SyntaxError", "TypeError", "URIError"}) do
    _G[errorName] = __TS__InitErrorClass(
        _G,
        (function()
            local ____ = __TS__Class()
            ____.name = ____.name
            __TS__ClassExtends(____, Error)
            function ____.prototype.____constructor(self, ...)
                Error.prototype.____constructor(self, ...)
                self.name = errorName
            end
            return ____
        end)(),
        errorName
    )
end

__TS__Unpack = table.unpack or unpack

function __TS__FunctionBind(fn, thisArg, ...)
    local boundArgs = {...}
    return function(____, ...)
        local args = {...}
        do
            local i = 0
            while i < #boundArgs do
                table.insert(args, i + 1, boundArgs[i + 1])
                i = i + 1
            end
        end
        return fn(
            thisArg,
            __TS__Unpack(args)
        )
    end
end

____symbolMetatable = {
    __tostring = function(self)
        return ("Symbol(" .. tostring(self.description or "")) .. ")"
    end
}
function __TS__Symbol(description)
    return setmetatable({description = description}, ____symbolMetatable)
end
Symbol = {
    iterator = __TS__Symbol("Symbol.iterator"),
    hasInstance = __TS__Symbol("Symbol.hasInstance"),
    species = __TS__Symbol("Symbol.species"),
    toStringTag = __TS__Symbol("Symbol.toStringTag")
}

function __TS__GeneratorIterator(self)
    return self
end
function __TS__GeneratorNext(self, ...)
    local co = self.____coroutine
    if coroutine.status(co) == "dead" then
        return {done = true}
    end
    local status, value = coroutine.resume(co, ...)
    if not status then
        error(value, 0)
    end
    return {
        value = value,
        done = coroutine.status(co) == "dead"
    }
end
function __TS__Generator(fn)
    return function(...)
        local args = {...}
        local argsLength = select("#", ...)
        return {
            ____coroutine = coroutine.create(
                function() return fn(
                    (unpack or table.unpack)(args, 1, argsLength)
                ) end
            ),
            [Symbol.iterator] = __TS__GeneratorIterator,
            next = __TS__GeneratorNext
        }
    end
end

function __TS__InstanceOf(obj, classTbl)
    if type(classTbl) ~= "table" then
        error("Right-hand side of 'instanceof' is not an object", 0)
    end
    if classTbl[Symbol.hasInstance] ~= nil then
        return not (not classTbl[Symbol.hasInstance](classTbl, obj))
    end
    if type(obj) == "table" then
        local luaClass = obj.constructor
        while luaClass ~= nil do
            if luaClass == classTbl then
                return true
            end
            luaClass = luaClass.____super
        end
    end
    return false
end

function __TS__InstanceOfObject(value)
    local valueType = type(value)
    return (valueType == "table") or (valueType == "function")
end

function __TS__IteratorGeneratorStep(self)
    local co = self.____coroutine
    local status, value = coroutine.resume(co)
    if not status then
        error(value, 0)
    end
    if coroutine.status(co) == "dead" then
        return
    end
    return true, value
end
function __TS__IteratorIteratorStep(self)
    local result = self:next()
    if result.done then
        return
    end
    return true, result.value
end
function __TS__IteratorStringStep(self, index)
    index = index + 1
    if index > #self then
        return
    end
    return index, string.sub(self, index, index)
end
function __TS__Iterator(iterable)
    if type(iterable) == "string" then
        return __TS__IteratorStringStep, iterable, 0
    elseif iterable.____coroutine ~= nil then
        return __TS__IteratorGeneratorStep, iterable
    elseif iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        return __TS__IteratorIteratorStep, iterator
    else
        return ipairs(iterable)
    end
end

Map = (function()
    local Map = __TS__Class()
    Map.name = "Map"
    function Map.prototype.____constructor(self, entries)
        self[Symbol.toStringTag] = "Map"
        self.items = {}
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if entries == nil then
            return
        end
        local iterable = entries
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                local value = result.value
                self:set(value[1], value[2])
            end
        else
            local array = entries
            for ____, kvp in ipairs(array) do
                self:set(kvp[1], kvp[2])
            end
        end
    end
    function Map.prototype.clear(self)
        self.items = {}
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Map.prototype.delete(self, key)
        local contains = self:has(key)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[key]
            local previous = self.previousKey[key]
            if next and previous then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[key] = nil
            self.previousKey[key] = nil
        end
        self.items[key] = nil
        return contains
    end
    function Map.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(
            self:keys()
        ) do
            callback(_G, self.items[key], key, self)
        end
    end
    function Map.prototype.get(self, key)
        return self.items[key]
    end
    function Map.prototype.has(self, key)
        return (self.nextKey[key] ~= nil) or (self.lastKey == key)
    end
    function Map.prototype.set(self, key, value)
        local isNewValue = not self:has(key)
        if isNewValue then
            self.size = self.size + 1
        end
        self.items[key] = value
        if self.firstKey == nil then
            self.firstKey = key
            self.lastKey = key
        elseif isNewValue then
            self.nextKey[self.lastKey] = key
            self.previousKey[key] = self.lastKey
            self.lastKey = key
        end
        return self
    end
    Map.prototype[Symbol.iterator] = function(self)
        return self:entries()
    end
    function Map.prototype.entries(self)
        local ____ = self
        local items = ____.items
        local nextKey = ____.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, items[key]}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Map.prototype.values(self)
        local ____ = self
        local items = ____.items
        local nextKey = ____.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = items[key]}
                key = nextKey[key]
                return result
            end
        }
    end
    Map[Symbol.species] = Map
    return Map
end)()

__TS__MathAtan2 = math.atan2 or math.atan

function __TS__Number(value)
    local valueType = type(value)
    if valueType == "number" then
        return value
    elseif valueType == "string" then
        local numberValue = tonumber(value)
        if numberValue then
            return numberValue
        end
        if value == "Infinity" then
            return math.huge
        end
        if value == "-Infinity" then
            return -math.huge
        end
        local stringWithoutSpaces = string.gsub(value, "%s", "")
        if stringWithoutSpaces == "" then
            return 0
        end
        return 0 / 0
    elseif valueType == "boolean" then
        return (value and 1) or 0
    else
        return 0 / 0
    end
end

function __TS__NumberIsFinite(value)
    return (((type(value) == "number") and (value == value)) and (value ~= math.huge)) and (value ~= -math.huge)
end

function __TS__NumberIsNaN(value)
    return value ~= value
end

____radixChars = "0123456789abcdefghijklmnopqrstuvwxyz"
function __TS__NumberToString(self, radix)
    if ((((radix == nil) or (radix == 10)) or (self == math.huge)) or (self == -math.huge)) or (self ~= self) then
        return tostring(self)
    end
    radix = math.floor(radix)
    if (radix < 2) or (radix > 36) then
        error("toString() radix argument must be between 2 and 36", 0)
    end
    local integer, fraction = math.modf(
        math.abs(self)
    )
    local result = ""
    if radix == 8 then
        result = string.format("%o", integer)
    elseif radix == 16 then
        result = string.format("%x", integer)
    else
        repeat
            do
                result = tostring(
                    __TS__StringAccess(____radixChars, integer % radix)
                ) .. tostring(result)
                integer = math.floor(integer / radix)
            end
        until not (integer ~= 0)
    end
    if fraction ~= 0 then
        result = tostring(result) .. "."
        local delta = 1e-16
        repeat
            do
                fraction = fraction * radix
                delta = delta * radix
                local digit = math.floor(fraction)
                result = tostring(result) .. tostring(
                    __TS__StringAccess(____radixChars, digit)
                )
                fraction = fraction - digit
            end
        until not (fraction >= delta)
    end
    if self < 0 then
        result = "-" .. tostring(result)
    end
    return result
end

function __TS__ObjectAssign(to, ...)
    local sources = {...}
    if to == nil then
        return to
    end
    for ____, source in ipairs(sources) do
        for key in pairs(source) do
            to[key] = source[key]
        end
    end
    return to
end

function ____descriptorIndex(self, key)
    local value = rawget(self, key)
    if value ~= nil then
        return value
    end
    local metatable = getmetatable(self)
    while metatable do
        local rawResult = rawget(metatable, key)
        if rawResult ~= nil then
            return rawResult
        end
        local descriptors = rawget(metatable, "_descriptors")
        if descriptors then
            local descriptor = descriptors[key]
            if descriptor then
                if descriptor.get then
                    return descriptor.get(self)
                end
                return descriptor.value
            end
        end
        metatable = getmetatable(metatable)
    end
end
function ____descriptorNewindex(self, key, value)
    local metatable = getmetatable(self)
    while metatable do
        local descriptors = rawget(metatable, "_descriptors")
        if descriptors then
            local descriptor = descriptors[key]
            if descriptor then
                if descriptor.set then
                    descriptor.set(self, value)
                else
                    if descriptor.writable == false then
                        error(
                            ((("Cannot assign to read only property '" .. tostring(key)) .. "' of object '") .. tostring(self)) .. "'",
                            0
                        )
                    end
                    descriptor.value = value
                end
                return
            end
        end
        metatable = getmetatable(metatable)
    end
    rawset(self, key, value)
end
function __TS__SetDescriptor(target, key, desc, isPrototype)
    if isPrototype == nil then
        isPrototype = false
    end
    local metatable = ((isPrototype and (function() return target end)) or (function() return getmetatable(target) end))()
    if not metatable then
        metatable = {}
        setmetatable(target, metatable)
    end
    local value = rawget(target, key)
    if value ~= nil then
        rawset(target, key, nil)
    end
    if not rawget(metatable, "_descriptors") then
        metatable._descriptors = {}
    end
    local descriptor = __TS__CloneDescriptor(desc)
    metatable._descriptors[key] = descriptor
    metatable.__index = ____descriptorIndex
    metatable.__newindex = ____descriptorNewindex
end

function __TS__ObjectDefineProperty(target, key, desc)
    local luaKey = (((type(key) == "number") and (function() return key + 1 end)) or (function() return key end))()
    local value = rawget(target, luaKey)
    local hasGetterOrSetter = (desc.get ~= nil) or (desc.set ~= nil)
    local descriptor
    if hasGetterOrSetter then
        if value ~= nil then
            error(
                "Cannot redefine property: " .. tostring(key),
                0
            )
        end
        descriptor = desc
    else
        local valueExists = value ~= nil
        descriptor = {
            set = desc.set,
            get = desc.get,
            configurable = (((desc.configurable ~= nil) and (function() return desc.configurable end)) or (function() return valueExists end))(),
            enumerable = (((desc.enumerable ~= nil) and (function() return desc.enumerable end)) or (function() return valueExists end))(),
            writable = (((desc.writable ~= nil) and (function() return desc.writable end)) or (function() return valueExists end))(),
            value = (((desc.value ~= nil) and (function() return desc.value end)) or (function() return value end))()
        }
    end
    __TS__SetDescriptor(target, luaKey, descriptor)
    return target
end

function __TS__ObjectEntries(obj)
    local result = {}
    for key in pairs(obj) do
        result[#result + 1] = {key, obj[key]}
    end
    return result
end

function __TS__ObjectFromEntries(entries)
    local obj = {}
    local iterable = entries
    if iterable[Symbol.iterator] then
        local iterator = iterable[Symbol.iterator](iterable)
        while true do
            local result = iterator:next()
            if result.done then
                break
            end
            local value = result.value
            obj[value[1]] = value[2]
        end
    else
        for ____, entry in ipairs(entries) do
            obj[entry[1]] = entry[2]
        end
    end
    return obj
end

function __TS__ObjectGetOwnPropertyDescriptor(object, key)
    local metatable = getmetatable(object)
    if not metatable then
        return
    end
    if not rawget(metatable, "_descriptors") then
        return
    end
    return rawget(metatable, "_descriptors")[key]
end

function __TS__ObjectKeys(obj)
    local result = {}
    for key in pairs(obj) do
        result[#result + 1] = key
    end
    return result
end

function __TS__ObjectRest(target, usedProperties)
    local result = {}
    for property in pairs(target) do
        if not usedProperties[property] then
            result[property] = target[property]
        end
    end
    return result
end

function __TS__ObjectValues(obj)
    local result = {}
    for key in pairs(obj) do
        result[#result + 1] = obj[key]
    end
    return result
end

function __TS__ParseFloat(numberString)
    local infinityMatch = string.match(numberString, "^%s*(-?Infinity)")
    if infinityMatch then
        return (((__TS__StringAccess(infinityMatch, 0) == "-") and (function() return -math.huge end)) or (function() return math.huge end))()
    end
    local number = tonumber(
        string.match(numberString, "^%s*(-?%d+%.?%d*)")
    )
    return number or (0 / 0)
end

__TS__parseInt_base_pattern = "0123456789aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTvVwWxXyYzZ"
function __TS__ParseInt(numberString, base)
    if base == nil then
        base = 10
        local hexMatch = string.match(numberString, "^%s*-?0[xX]")
        if hexMatch then
            base = 16
            numberString = ((string.match(hexMatch, "-") and (function() return "-" .. tostring(
                __TS__StringSubstr(numberString, #hexMatch)
            ) end)) or (function() return __TS__StringSubstr(numberString, #hexMatch) end))()
        end
    end
    if (base < 2) or (base > 36) then
        return 0 / 0
    end
    local allowedDigits = (((base <= 10) and (function() return __TS__StringSubstring(__TS__parseInt_base_pattern, 0, base) end)) or (function() return __TS__StringSubstr(__TS__parseInt_base_pattern, 0, 10 + (2 * (base - 10))) end))()
    local pattern = ("^%s*(-?[" .. tostring(allowedDigits)) .. "]*)"
    local number = tonumber(
        string.match(numberString, pattern),
        base
    )
    if number == nil then
        return 0 / 0
    end
    if number >= 0 then
        return math.floor(number)
    else
        return math.ceil(number)
    end
end

Set = (function()
    local Set = __TS__Class()
    Set.name = "Set"
    function Set.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "Set"
        self.size = 0
        self.nextKey = {}
        self.previousKey = {}
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self:add(result.value)
            end
        else
            local array = values
            for ____, value in ipairs(array) do
                self:add(value)
            end
        end
    end
    function Set.prototype.add(self, value)
        local isNewValue = not self:has(value)
        if isNewValue then
            self.size = self.size + 1
        end
        if self.firstKey == nil then
            self.firstKey = value
            self.lastKey = value
        elseif isNewValue then
            self.nextKey[self.lastKey] = value
            self.previousKey[value] = self.lastKey
            self.lastKey = value
        end
        return self
    end
    function Set.prototype.clear(self)
        self.nextKey = {}
        self.previousKey = {}
        self.firstKey = nil
        self.lastKey = nil
        self.size = 0
    end
    function Set.prototype.delete(self, value)
        local contains = self:has(value)
        if contains then
            self.size = self.size - 1
            local next = self.nextKey[value]
            local previous = self.previousKey[value]
            if next and previous then
                self.nextKey[previous] = next
                self.previousKey[next] = previous
            elseif next then
                self.firstKey = next
                self.previousKey[next] = nil
            elseif previous then
                self.lastKey = previous
                self.nextKey[previous] = nil
            else
                self.firstKey = nil
                self.lastKey = nil
            end
            self.nextKey[value] = nil
            self.previousKey[value] = nil
        end
        return contains
    end
    function Set.prototype.forEach(self, callback)
        for ____, key in __TS__Iterator(
            self:keys()
        ) do
            callback(_G, key, key, self)
        end
    end
    function Set.prototype.has(self, value)
        return (self.nextKey[value] ~= nil) or (self.lastKey == value)
    end
    Set.prototype[Symbol.iterator] = function(self)
        return self:values()
    end
    function Set.prototype.entries(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = {key, key}}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.keys(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    function Set.prototype.values(self)
        local nextKey = self.nextKey
        local key = self.firstKey
        return {
            [Symbol.iterator] = function(self)
                return self
            end,
            next = function(self)
                local result = {done = not key, value = key}
                key = nextKey[key]
                return result
            end
        }
    end
    Set[Symbol.species] = Set
    return Set
end)()

WeakMap = (function()
    local WeakMap = __TS__Class()
    WeakMap.name = "WeakMap"
    function WeakMap.prototype.____constructor(self, entries)
        self[Symbol.toStringTag] = "WeakMap"
        self.items = {}
        setmetatable(self.items, {__mode = "k"})
        if entries == nil then
            return
        end
        local iterable = entries
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                local value = result.value
                self.items[value[1]] = value[2]
            end
        else
            for ____, kvp in ipairs(entries) do
                self.items[kvp[1]] = kvp[2]
            end
        end
    end
    function WeakMap.prototype.delete(self, key)
        local contains = self:has(key)
        self.items[key] = nil
        return contains
    end
    function WeakMap.prototype.get(self, key)
        return self.items[key]
    end
    function WeakMap.prototype.has(self, key)
        return self.items[key] ~= nil
    end
    function WeakMap.prototype.set(self, key, value)
        self.items[key] = value
        return self
    end
    WeakMap[Symbol.species] = WeakMap
    return WeakMap
end)()

WeakSet = (function()
    local WeakSet = __TS__Class()
    WeakSet.name = "WeakSet"
    function WeakSet.prototype.____constructor(self, values)
        self[Symbol.toStringTag] = "WeakSet"
        self.items = {}
        setmetatable(self.items, {__mode = "k"})
        if values == nil then
            return
        end
        local iterable = values
        if iterable[Symbol.iterator] then
            local iterator = iterable[Symbol.iterator](iterable)
            while true do
                local result = iterator:next()
                if result.done then
                    break
                end
                self.items[result.value] = true
            end
        else
            for ____, value in ipairs(values) do
                self.items[value] = true
            end
        end
    end
    function WeakSet.prototype.add(self, value)
        self.items[value] = true
        return self
    end
    function WeakSet.prototype.delete(self, value)
        local contains = self:has(value)
        self.items[value] = nil
        return contains
    end
    function WeakSet.prototype.has(self, value)
        return self.items[value] == true
    end
    WeakSet[Symbol.species] = WeakSet
    return WeakSet
end)()

function __TS__SourceMapTraceBack(fileName, sourceMap)
    _G.__TS__sourcemap = _G.__TS__sourcemap or ({})
    _G.__TS__sourcemap[fileName] = sourceMap
    if _G.__TS__originalTraceback == nil then
        _G.__TS__originalTraceback = debug.traceback
        debug.traceback = function(thread, message, level)
            local trace
            if ((thread == nil) and (message == nil)) and (level == nil) then
                trace = _G.__TS__originalTraceback()
            else
                trace = _G.__TS__originalTraceback(thread, message, level)
            end
            if type(trace) ~= "string" then
                return trace
            end
            local result = string.gsub(
                trace,
                "(%S+).lua:(%d+)",
                function(file, line)
                    local fileSourceMap = _G.__TS__sourcemap[tostring(file) .. ".lua"]
                    if fileSourceMap and fileSourceMap[line] then
                        return (tostring(file) .. ".ts:") .. tostring(fileSourceMap[line])
                    end
                    return (tostring(file) .. ".lua:") .. tostring(line)
                end
            )
            return result
        end
    end
end

function __TS__Spread(iterable)
    local arr = {}
    if type(iterable) == "string" then
        do
            local i = 0
            while i < #iterable do
                arr[#arr + 1] = __TS__StringAccess(iterable, i)
                i = i + 1
            end
        end
    else
        for ____, item in __TS__Iterator(iterable) do
            arr[#arr + 1] = item
        end
    end
    return __TS__Unpack(arr)
end

function __TS__StringAccess(self, index)
    if (index >= 0) and (index < #self) then
        return string.sub(self, index + 1, index + 1)
    end
end

function __TS__StringCharAt(self, pos)
    if pos ~= pos then
        pos = 0
    end
    if pos < 0 then
        return ""
    end
    return string.sub(self, pos + 1, pos + 1)
end

function __TS__StringCharCodeAt(self, index)
    if index ~= index then
        index = 0
    end
    if index < 0 then
        return 0 / 0
    end
    return string.byte(self, index + 1) or (0 / 0)
end

function __TS__StringConcat(str1, ...)
    local args = {...}
    local out = str1
    for ____, arg in ipairs(args) do
        out = tostring(out) .. tostring(arg)
    end
    return out
end

function __TS__StringEndsWith(self, searchString, endPosition)
    if (endPosition == nil) or (endPosition > #self) then
        endPosition = #self
    end
    return string.sub(self, (endPosition - #searchString) + 1, endPosition) == searchString
end

function __TS__StringPadEnd(self, maxLength, fillString)
    if fillString == nil then
        fillString = " "
    end
    if maxLength ~= maxLength then
        maxLength = 0
    end
    if (maxLength == -math.huge) or (maxLength == math.huge) then
        error("Invalid string length", 0)
    end
    if (#self >= maxLength) or (#fillString == 0) then
        return self
    end
    maxLength = maxLength - #self
    if maxLength > #fillString then
        fillString = tostring(fillString) .. tostring(
            string.rep(
                fillString,
                math.floor(maxLength / #fillString)
            )
        )
    end
    return tostring(self) .. tostring(
        string.sub(
            fillString,
            1,
            math.floor(maxLength)
        )
    )
end

function __TS__StringPadStart(self, maxLength, fillString)
    if fillString == nil then
        fillString = " "
    end
    if maxLength ~= maxLength then
        maxLength = 0
    end
    if (maxLength == -math.huge) or (maxLength == math.huge) then
        error("Invalid string length", 0)
    end
    if (#self >= maxLength) or (#fillString == 0) then
        return self
    end
    maxLength = maxLength - #self
    if maxLength > #fillString then
        fillString = tostring(fillString) .. tostring(
            string.rep(
                fillString,
                math.floor(maxLength / #fillString)
            )
        )
    end
    return tostring(
        string.sub(
            fillString,
            1,
            math.floor(maxLength)
        )
    ) .. tostring(self)
end

function __TS__StringReplace(source, searchValue, replaceValue)
    searchValue = string.gsub(searchValue, "[%%%(%)%.%+%-%*%?%[%^%$]", "%%%1")
    if type(replaceValue) == "string" then
        replaceValue = string.gsub(replaceValue, "%%", "%%%%")
        local result = string.gsub(source, searchValue, replaceValue, 1)
        return result
    else
        local result = string.gsub(
            source,
            searchValue,
            function(match) return replaceValue(_G, match) end,
            1
        )
        return result
    end
end

function __TS__StringSlice(self, start, ____end)
    if (start == nil) or (start ~= start) then
        start = 0
    end
    if ____end ~= ____end then
        ____end = 0
    end
    if start >= 0 then
        start = start + 1
    end
    if (____end ~= nil) and (____end < 0) then
        ____end = ____end - 1
    end
    return string.sub(self, start, ____end)
end

function __TS__StringSplit(source, separator, limit)
    if limit == nil then
        limit = 4294967295
    end
    if limit == 0 then
        return {}
    end
    local out = {}
    local index = 0
    local count = 0
    if (separator == nil) or (separator == "") then
        while (index < (#source - 1)) and (count < limit) do
            out[count + 1] = __TS__StringAccess(source, index)
            count = count + 1
            index = index + 1
        end
    else
        local separatorLength = #separator
        local nextIndex = (string.find(source, separator, nil, true) or 0) - 1
        while (nextIndex >= 0) and (count < limit) do
            out[count + 1] = __TS__StringSubstring(source, index, nextIndex)
            count = count + 1
            index = nextIndex + separatorLength
            nextIndex = (string.find(
                source,
                separator,
                math.max(index + 1, 1),
                true
            ) or 0) - 1
        end
    end
    if count < limit then
        out[count + 1] = __TS__StringSubstring(source, index)
    end
    return out
end

function __TS__StringStartsWith(self, searchString, position)
    if (position == nil) or (position < 0) then
        position = 0
    end
    return string.sub(self, position + 1, #searchString + position) == searchString
end

function __TS__StringSubstr(self, from, length)
    if from ~= from then
        from = 0
    end
    if length ~= nil then
        if (length ~= length) or (length <= 0) then
            return ""
        end
        length = length + from
    end
    if from >= 0 then
        from = from + 1
    end
    return string.sub(self, from, length)
end

function __TS__StringSubstring(self, start, ____end)
    if ____end ~= ____end then
        ____end = 0
    end
    if (____end ~= nil) and (start > ____end) then
        start, ____end = __TS__Unpack({____end, start})
    end
    if start >= 0 then
        start = start + 1
    else
        start = 1
    end
    if (____end ~= nil) and (____end < 0) then
        ____end = 0
    end
    return string.sub(self, start, ____end)
end

function __TS__StringTrim(self)
    local result = string.gsub(self, "^[%s ﻿]*(.-)[%s ﻿]*$", "%1")
    return result
end

function __TS__StringTrimEnd(self)
    local result = string.gsub(self, "[%s ﻿]*$", "")
    return result
end

function __TS__StringTrimStart(self)
    local result = string.gsub(self, "^[%s ﻿]*", "")
    return result
end

____symbolRegistry = {}
function __TS__SymbolRegistryFor(key)
    if not ____symbolRegistry[key] then
        ____symbolRegistry[key] = __TS__Symbol(key)
    end
    return ____symbolRegistry[key]
end
function __TS__SymbolRegistryKeyFor(sym)
    for key in pairs(____symbolRegistry) do
        if ____symbolRegistry[key] == sym then
            return key
        end
    end
end

function __TS__TypeOf(value)
    local luaType = type(value)
    if luaType == "table" then
        return "object"
    elseif luaType == "nil" then
        return "undefined"
    else
        return luaType
    end
end

end,
["application.Api"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.apiFactory = function() return {
    up = function()
        return turtle.up()
    end,
    down = function()
        return turtle.down()
    end,
    forward = function()
        return turtle.forward()
    end,
    back = function()
        return turtle.back()
    end,
    dig = function()
        return turtle.dig()
    end,
    digUp = function()
        return turtle.digUp()
    end,
    digDown = function()
        return turtle.digDown()
    end,
    inspect = function()
        return {
            turtle.inspect()
        }
    end,
    inspectUp = function()
        return {
            turtle.inspectUp()
        }
    end,
    turnLeft = function()
        return turtle.turnLeft()
    end,
    turnRight = function()
        return turtle.turnRight()
    end,
    inspectDown = function()
        return {
            turtle.inspectDown()
        }
    end,
    getFuelLevel = function()
        return turtle.getFuelLevel()
    end
} end
return ____exports
end,
["application.Logger"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local isLogger, getColor
____exports.loggerFactory = function()
    local logger = {
        write = function(____, input, color)
            term.setTextColor(
                getColor(_G, color)
            )
            write(input)
            term.setTextColor(
                getColor(_G, "white")
            )
            local logs = fs.open("logs", "a")
            logs:write(input)
            logs:close()
        end
    }
    logger.print = function(____, input, color) return logger:write(
        tostring(input) .. "\n",
        color
    ) end
    if isLogger(_G, logger) then
        return logger
    else
        error("never", 0)
    end
end
isLogger = function(____, logger) return not (not logger.print) end
getColor = function(____, color)
    if color == "white" then
        return colors.white
    elseif color == "orange" then
        return colors.orange
    elseif color == "magenta" then
        return colors.magenta
    elseif color == "lightBlue" then
        return colors.lightBlue
    elseif color == "yellow" then
        return colors.yellow
    elseif color == "lime" then
        return colors.lime
    elseif color == "pink" then
        return colors.pink
    elseif color == "gray" then
        return colors.gray
    elseif color == "lightGray" then
        return colors.lightGray
    elseif color == "cyan" then
        return colors.cyan
    elseif color == "purple" then
        return colors.purple
    elseif color == "blue" then
        return colors.blue
    elseif color == "brown" then
        return colors.brown
    elseif color == "green" then
        return colors.green
    elseif color == "red" then
        return colors.red
    elseif color == "black" then
        return colors.black
    end
    return colors.white
end
return ____exports
end,
["theory.satisfyFacts"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local log
____exports.satisfyFacts = function(____, facts, factToAction, actionToFacts, factIsTrue, actionToMethod, state, logger)
    log(
        _G,
        logger,
        0,
        "satisfyFacts",
        table.concat(facts, ", " or ",")
    )
    local tasks = {{nil, facts}}
    while #tasks > 0 do
        local action = tasks[1][1]
        local requiredFacts = tasks[1][2]
        log(
            _G,
            logger,
            #tasks,
            "checking",
            table.concat(requiredFacts, ", " or ",")
        )
        local unsatisfiedFact = __TS__ArrayFind(
            requiredFacts,
            function(____, fact) return not factIsTrue[fact](factIsTrue, state) end
        )
        if unsatisfiedFact ~= nil then
            log(_G, logger, #tasks, "unsatisfiedFact", unsatisfiedFact)
            local action = factToAction[unsatisfiedFact]
            local requirements = actionToFacts[action]
            log(_G, logger, #tasks, "factToAction", action)
            __TS__ArrayUnshift(tasks, {action, requirements})
        else
            if action ~= nil then
                log(_G, logger, #tasks, "actionToMethod", action)
                local result = actionToMethod[action](actionToMethod, state)
                if not result then
                    error(
                        __TS__New(Error, "Failed to perform action!"),
                        0
                    )
                end
                log(_G, logger, #tasks, "actionToMethod!", action)
            end
            __TS__ArrayShift(tasks)
        end
    end
    log(
        _G,
        logger,
        0,
        "return",
        table.concat(facts, ", " or ",")
    )
end
log = function(____, logger, depth, key, value)
    if key == "actionToMethod!" then
        logger:print("!", "lime")
        return
    end
    logger:write(
        string.rep(
            "| ",
            math.floor(depth)
        ),
        "gray"
    )
    if value == "" then
        value = "EMPTY"
    end
    if key == "satisfyFacts" then
        logger:write("$ ")
        logger:print(value, "yellow")
    elseif key == "checking" then
        logger:write("? ", "yellow")
        logger:print(value)
    elseif key == "unsatisfiedFact" then
        logger:write("! ", "red")
        logger:print(value)
    elseif key == "factToAction" then
        logger:write("@ ", "gray")
        logger:print(value)
    elseif key == "actionToMethod" then
        logger:write(value, "lime")
    elseif key == "return" then
        logger:write("$ ")
        logger:print(value, "lime")
    end
end
return ____exports
end,
["logic.factsAndActions"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.FACT_TO_ACTION = {NOT_AT_BASE = "MOVE_FORWARD", HAS_FUEL = "DIE", FACING_AIR = "DIG_FORWARD", BELOW_AIR = "DIG_UP", BEYOND_AIR = "DIG_BACK", GROUNDED = "MOVE_DOWN", ABOVE_AIR = "DIG_DOWN", ABOVE_BLOCK = "MOVE_DOWN", NO_LOG_ABOVE = "MOVE_UP", REMOVED_FACING_TREE = "MOVE_BACK_FROM_REMOVE_TREE", UNDER_TREE = "MOVE_UNDER_TREE"}
____exports.ACTION_TO_FACTS = {MOVE_FORWARD = {"HAS_FUEL", "FACING_AIR"}, MOVE_UP = {"HAS_FUEL", "BELOW_AIR"}, MOVE_DOWN = {"HAS_FUEL", "ABOVE_AIR"}, MOVE_BACK = {"HAS_FUEL", "BEYOND_AIR"}, DIG_FORWARD = {}, DIG_UP = {}, DIG_DOWN = {}, DIG_BACK = {}, DIE = {}, MOVE_BACK_FROM_REMOVE_TREE = {"HAS_FUEL", "UNDER_TREE", "NO_LOG_ABOVE", "ABOVE_BLOCK", "BEYOND_AIR"}, MOVE_UNDER_TREE = {"HAS_FUEL", "FACING_AIR"}}
return ____exports
end,
["logic.state.GPS"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
____exports.ZERO_VECTOR = {x = 0, y = 0, z = 0, r = 0}
____exports.ROTATION_TO_AXIS = {[0] = {"z", -1}, [2] = {"z", 1}, [1] = {"x", 1}, [3] = {"x", -1}}
return ____exports
end,
["logic.state.State"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____GPS = require("logic.state.GPS")
local ZERO_VECTOR = ____GPS.ZERO_VECTOR
____exports.initialStateFactory = function() return {gps = ZERO_VECTOR, underTree = false} end
return ____exports
end,
["logic.actionToMethod"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____GPS = require("logic.state.GPS")
local ROTATION_TO_AXIS = ____GPS.ROTATION_TO_AXIS
____exports.actionToMethodFactory = function(____, api)
    local function moveBack(____, state)
        if api:back() then
            local axis, sign = unpack(ROTATION_TO_AXIS[state.gps.r])
            local ____obj, ____index = state.gps, axis
            ____obj[____index] = ____obj[____index] + sign
            return true
        end
        return false
    end
    local function moveForward(____, state)
        if api:forward() then
            local axis, sign = unpack(ROTATION_TO_AXIS[state.gps.r])
            local ____obj, ____index = state.gps, axis
            ____obj[____index] = ____obj[____index] + sign
            return true
        end
        return false
    end
    return {
        MOVE_FORWARD = moveForward,
        MOVE_BACK = moveBack,
        MOVE_UP = function(____, state)
            if api:up() then
                local ____obj, ____index = state.gps, "y"
                ____obj[____index] = ____obj[____index] + 1
                return true
            end
            return false
        end,
        MOVE_DOWN = function(____, state)
            if api:down() then
                local ____obj, ____index = state.gps, "y"
                ____obj[____index] = ____obj[____index] - 1
                return true
            end
            return false
        end,
        DIG_FORWARD = function(____, _) return api:dig() end,
        DIG_BACK = function(____, _)
            return (((api:turnLeft() and api:turnLeft()) and api:dig()) and api:turnLeft()) and api:turnLeft()
        end,
        DIG_UP = function(____, _) return api:digUp() end,
        DIG_DOWN = function(____, _) return api:digDown() end,
        DIE = function(____, _)
            return false
        end,
        MOVE_BACK_FROM_REMOVE_TREE = function(____, state)
            state.underTree = false
            return moveBack(_G, state)
        end,
        MOVE_UNDER_TREE = function(____, state)
            state.underTree = true
            return moveForward(_G, state)
        end
    }
end
return ____exports
end,
["logic.factToMethod"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
____exports.factToMethodFactory = function(____, api)
    local function ____not(____, checker)
        return function(____, state) return not checker(_G, state) end
    end
    local function aboveBlock(____, _)
        local is = unpack(
            api:inspectDown()
        )
        return is
    end
    local function belowBlock(____, _)
        local is = unpack(
            api:inspectUp()
        )
        return is
    end
    return {
        NOT_AT_BASE = function(____, state) return (state.gps.x + state.gps.z) ~= 0 end,
        HAS_FUEL = function(____, _) return api:getFuelLevel() > 0 end,
        FACING_AIR = function(____, _)
            local is = unpack(
                api:inspect()
            )
            return not is
        end,
        REMOVED_FACING_TREE = function(____, _)
            local ____, x = unpack(
                api:inspect()
            )
            return (x == "No block to inspect") or (not x.tags["minecraft:logs"])
        end,
        NO_LOG_ABOVE = function(____, _)
            local ____, x = unpack(
                api:inspectUp()
            )
            return (x == "No block to inspect") or (not x.tags["minecraft:logs"])
        end,
        UNDER_TREE = function(____, state)
            return state.underTree
        end,
        BELOW_AIR = ____not(_G, belowBlock),
        GROUNDED = aboveBlock,
        ABOVE_AIR = ____not(_G, aboveBlock),
        ABOVE_BLOCK = aboveBlock,
        BEYOND_AIR = function(____, _)
            if api:turnLeft() and api:turnLeft() then
                local is = unpack(
                    api:inspect()
                )
                if api:turnLeft() and api:turnLeft() then
                    return not is
                end
            end
            error(
                __TS__New(Error, "Failure to rotate??"),
                0
            )
        end
    }
end
return ____exports
end,
["testHelpers"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____Api = require("application.Api")
local apiFactory = ____Api.apiFactory
local ____Logger = require("application.Logger")
local loggerFactory = ____Logger.loggerFactory
local currentLabel = "no current test"
____exports.setupGlobals = function()
    describe = describe or (function(____, label, test)
        currentLabel = label
        test(_G)
    end)
    it = it or (function(____, label, test)
        currentLabel = label
        test(_G)
    end)
end
____exports.stringMatch = function(____, expected, actual)
    if expect then
        expect(_G, expected):toEqual(actual)
    else
        assert(
            expected == actual,
            (((("Test failure!\nExpected:\n" .. tostring(expected)) .. "\nActual:\n") .. tostring(actual)) .. "\nTest: ") .. tostring(currentLabel)
        )
    end
end
____exports.stringArrayMatch = function(____, expected, actual)
    if expect then
        expect(_G, expected):toEqual(actual)
    else
        __TS__ArrayForEach(
            expected,
            function(____, _, i) return assert(
                expected[i + 1] == actual[i + 1],
                (((("Test failure!\nExpected:\n" .. tostring(expected[i + 1])) .. "\nActual:\n") .. tostring(actual[i + 1])) .. "\nTest: ") .. tostring(currentLabel)
            ) end
        )
    end
end
local function isTestLogger(____, logger)
    return logger.logs ~= nil
end
____exports.testLoggerFactory = function()
    local logger = loggerFactory(_G)
    logger.logs = ""
    logger.write = function(____, input, _) return (function()
        local ____tmp = tostring(logger.logs) .. tostring(input)
        logger.logs = ____tmp
        return ____tmp
    end)() end
    if isTestLogger(_G, logger) then
        return logger
    else
        error("testLoggerFactory failed", 0)
    end
end
____exports.testApiFactory = function()
    local api = apiFactory(_G)
    return api
end
return ____exports
end,
["__tests__.thoeryTest"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____satisfyFacts = require("theory.satisfyFacts")
local satisfyFacts = ____satisfyFacts.satisfyFacts
local ____testHelpers = require("testHelpers")
local setupGlobals = ____testHelpers.setupGlobals
local stringArrayMatch = ____testHelpers.stringArrayMatch
local stringMatch = ____testHelpers.stringMatch
____exports.theoryTest = function()
    setupGlobals(_G)
    describe(
        _G,
        "demo situation",
        function()
            local api = {
                destroyWhateverFacing = function(____, state)
                    __TS__ArrayPush(state.moves, "doing action: destroying whatever facing")
                    state.facingSomething = false
                    return true
                end,
                moveForward = function(____, state)
                    __TS__ArrayPush(state.moves, "doing action: move forward")
                    state.facingSomething = true
                    return true
                end,
                isFacingSomething = function(____, state)
                    __TS__ArrayPush(state.moves, "checking fact: is facing something")
                    return state.facingSomething
                end
            }
            local actionToMethod = {
                MOVE_FORWARD = function(____, state) return api:moveForward(state) end,
                DESTROY_WHATEVER_FACING = function(____, state) return api:destroyWhateverFacing(state) end,
                NOTHING = function() return true end,
                UNKNOWN = function()
                    return false
                end
            }
            local factToAction = {FACING_SOMETHING = "UNKNOWN", FACING_NOTHING = "DESTROY_WHATEVER_FACING", MOVED_FORWARD = "MOVE_FORWARD"}
            local factChecker = {
                FACING_SOMETHING = function(____, state) return api:isFacingSomething(state) end,
                FACING_NOTHING = function(____, state) return not api:isFacingSomething(state) end,
                MOVED_FORWARD = function(____, state)
                    __TS__ArrayPush(state.moves, "checking fact: has moved forward")
                    return __TS__ArrayIncludes(state.moves, "doing action: move forward")
                end
            }
            local actionToFacts = {MOVE_FORWARD = {"FACING_NOTHING"}, DESTROY_WHATEVER_FACING = {"FACING_SOMETHING"}, NOTHING = {}, UNKNOWN = {}}
            it(
                _G,
                "should solve: remove blocker when nothing to remove",
                function()
                    local state = {moves = {}, facingSomething = false}
                    satisfyFacts(
                        _G,
                        {"FACING_NOTHING"},
                        factToAction,
                        actionToFacts,
                        factChecker,
                        actionToMethod,
                        state,
                        {
                            write = function()
                            end,
                            print = function()
                            end
                        }
                    )
                    stringArrayMatch(_G, state.moves, {"checking fact: is facing something"})
                end
            )
            it(
                _G,
                "should solve: remove blocker when something to remove",
                function()
                    local state = {moves = {}, facingSomething = true}
                    satisfyFacts(
                        _G,
                        {"FACING_NOTHING"},
                        factToAction,
                        actionToFacts,
                        factChecker,
                        actionToMethod,
                        state,
                        {
                            write = function()
                            end,
                            print = function()
                            end
                        }
                    )
                    stringArrayMatch(_G, state.moves, {"checking fact: is facing something", "checking fact: is facing something", "doing action: destroying whatever facing", "checking fact: is facing something"})
                end
            )
            it(
                _G,
                "should solve: move forward without blocker",
                function()
                    local state = {moves = {}, facingSomething = false}
                    satisfyFacts(
                        _G,
                        {"MOVED_FORWARD"},
                        factToAction,
                        actionToFacts,
                        factChecker,
                        actionToMethod,
                        state,
                        {
                            write = function()
                            end,
                            print = function()
                            end
                        }
                    )
                    stringArrayMatch(_G, state.moves, {"checking fact: has moved forward", "checking fact: is facing something", "doing action: move forward", "checking fact: has moved forward"})
                end
            )
            it(
                _G,
                "should solve: move forward with blocker",
                function()
                    local state = {moves = {}, facingSomething = true}
                    satisfyFacts(
                        _G,
                        {"MOVED_FORWARD"},
                        factToAction,
                        actionToFacts,
                        factChecker,
                        actionToMethod,
                        state,
                        {
                            write = function()
                            end,
                            print = function()
                            end
                        }
                    )
                    stringArrayMatch(_G, state.moves, {"checking fact: has moved forward", "checking fact: is facing something", "checking fact: is facing something", "doing action: destroying whatever facing", "checking fact: is facing something", "doing action: move forward", "checking fact: has moved forward"})
                end
            )
            it(
                _G,
                "should log correctly",
                function()
                    local state = {moves = {}, facingSomething = true}
                    local logs = ""
                    local logger = {
                        print = function(____, input)
                            logs = (tostring(logs) .. tostring(input)) .. "\n"
                        end,
                        write = function(____, input)
                            logs = tostring(logs) .. tostring(input)
                        end
                    }
                    satisfyFacts(_G, {"MOVED_FORWARD"}, factToAction, actionToFacts, factChecker, actionToMethod, state, logger)
                    stringArrayMatch(_G, state.moves, {"checking fact: has moved forward", "checking fact: is facing something", "checking fact: is facing something", "doing action: destroying whatever facing", "checking fact: is facing something", "doing action: move forward", "checking fact: has moved forward"})
                    stringMatch(_G, logs, "$ MOVED_FORWARD\n| ? MOVED_FORWARD\n| ! MOVED_FORWARD\n| @ MOVE_FORWARD\n| | ? FACING_NOTHING\n| | ! FACING_NOTHING\n| | @ DESTROY_WHATEVER_FACING\n| | | ? FACING_SOMETHING\n| | | DESTROY_WHATEVER_FACING!\n| | ? FACING_NOTHING\n| | MOVE_FORWARD!\n| ? MOVED_FORWARD\n$ MOVED_FORWARD\n")
                end
            )
        end
    )
end
if (process and process.env) and (process.env.NODE_ENV == "test") then
    ____exports.theoryTest(_G)
end
return ____exports
end,
["__tests__.emptyFactsTest"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____actionToMethod = require("logic.actionToMethod")
local actionToMethodFactory = ____actionToMethod.actionToMethodFactory
local ____factsAndActions = require("logic.factsAndActions")
local ACTION_TO_FACTS = ____factsAndActions.ACTION_TO_FACTS
local FACT_TO_ACTION = ____factsAndActions.FACT_TO_ACTION
local ____factToMethod = require("logic.factToMethod")
local factToMethodFactory = ____factToMethod.factToMethodFactory
local ____State = require("logic.state.State")
local initialStateFactory = ____State.initialStateFactory
local ____satisfyFacts = require("theory.satisfyFacts")
local satisfyFacts = ____satisfyFacts.satisfyFacts
local ____testHelpers = require("testHelpers")
local setupGlobals = ____testHelpers.setupGlobals
local stringMatch = ____testHelpers.stringMatch
local testLoggerFactory = ____testHelpers.testLoggerFactory
local testApiFactory = ____testHelpers.testApiFactory
____exports.emptyFactsTest = function()
    setupGlobals(_G)
    it(
        _G,
        "should handle empty fact list",
        function()
            local api = testApiFactory(_G)
            local logger = testLoggerFactory(_G)
            satisfyFacts(
                _G,
                {},
                FACT_TO_ACTION,
                ACTION_TO_FACTS,
                factToMethodFactory(_G, api),
                actionToMethodFactory(_G, api),
                initialStateFactory(_G),
                logger
            )
            stringMatch(_G, "$ EMPTY\n| ? EMPTY\n$ EMPTY\n", logger.logs)
        end
    )
end
if (process and process.env) and (process.env.NODE_ENV == "test") then
    ____exports.emptyFactsTest(_G)
end
return ____exports
end,
["__tests__.chopTreeTest"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____actionToMethod = require("logic.actionToMethod")
local actionToMethodFactory = ____actionToMethod.actionToMethodFactory
local ____factsAndActions = require("logic.factsAndActions")
local ACTION_TO_FACTS = ____factsAndActions.ACTION_TO_FACTS
local FACT_TO_ACTION = ____factsAndActions.FACT_TO_ACTION
local ____factToMethod = require("logic.factToMethod")
local factToMethodFactory = ____factToMethod.factToMethodFactory
local ____State = require("logic.state.State")
local initialStateFactory = ____State.initialStateFactory
local ____satisfyFacts = require("theory.satisfyFacts")
local satisfyFacts = ____satisfyFacts.satisfyFacts
local ____testHelpers = require("testHelpers")
local setupGlobals = ____testHelpers.setupGlobals
local stringMatch = ____testHelpers.stringMatch
local testLoggerFactory = ____testHelpers.testLoggerFactory
local testApiFactory = ____testHelpers.testApiFactory
____exports.chopTreeTest = function()
    setupGlobals(_G)
    it(
        _G,
        "should handle empty fact list",
        function()
            local api = testApiFactory(_G)
            local logger = testLoggerFactory(_G)
            satisfyFacts(
                _G,
                {},
                FACT_TO_ACTION,
                ACTION_TO_FACTS,
                factToMethodFactory(_G, api),
                actionToMethodFactory(_G, api),
                initialStateFactory(_G),
                logger
            )
            stringMatch(_G, "$ EMPTY\n| ? EMPTY\n$ EMPTY\n", logger.logs)
        end
    )
end
if (process and process.env) and (process.env.NODE_ENV == "test") then
    ____exports.chopTreeTest(_G)
end
return ____exports
end,
["main"] = function() --[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____Logger = require("application.Logger")
local loggerFactory = ____Logger.loggerFactory
local ____thoeryTest = require("__tests__.thoeryTest")
local theoryTest = ____thoeryTest.theoryTest
local ____emptyFactsTest = require("__tests__.emptyFactsTest")
local emptyFactsTest = ____emptyFactsTest.emptyFactsTest
local ____chopTreeTest = require("__tests__.chopTreeTest")
local chopTreeTest = ____chopTreeTest.chopTreeTest
local logger = loggerFactory(_G)
do
    local ____try, err = pcall(
        function()
            theoryTest(_G)
            emptyFactsTest(_G)
            chopTreeTest(_G)
            logger:print("Tests passed!", "lime")
        end
    )
    if not ____try then
        local fileName = "errors.txt"
        local errFile = fs.open(fileName, "a")
        errFile:write(
            "\n\n" .. tostring(err)
        )
        errFile:close()
        logger:print(err, "red")
        logger:print(
            "See: " .. tostring(fileName),
            "yellow"
        )
    end
end
return ____exports
end,
}
return require("main")
