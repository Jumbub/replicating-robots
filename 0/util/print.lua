local oldPrint = _G["print"]

_G["print"] = function(...)
  oldPrint(...)
end
