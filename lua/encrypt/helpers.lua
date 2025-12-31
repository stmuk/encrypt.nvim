---@return function string
local getPasswordFactory = function()
  local bufferPasswordMap = {}

  return function(confirm)
    local key = string.format("%s", vim.fn.bufnr())
    if bufferPasswordMap[key] == nil then
      password = vim.fn.inputsecret("Enter password: ")
      if password == "" then
        vim.notify("Password is cancelled", vim.log.levels.WARN)
        return nil
      end
      
      if confirm then
        local password_confirm = vim.fn.inputsecret("Confirm password: ")
        if password ~= password_confirm then
          vim.notify("Passwords do not match", vim.log.levels.ERROR)
          return nil
        end
      end
      
      bufferPasswordMap[key] = password
    end
    return bufferPasswordMap[key]
  end
end

local getPassword = getPasswordFactory()
local ENCRYPTED_PREFIX = "-----BEGIN AGE ENCRYPTED FILE-----"

---@enum buftype
local BUFTYPE = {
  encrypted = 1,
  plaintext = 2,
}

local function bufferEncrypted()
  local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
  if first_line == ENCRYPTED_PREFIX then
    return true
  end
end

return {
  getPassword = getPassword,
  ENCRYPTED_PREFIX = ENCRYPTED_PREFIX,
  BUFTYPE = BUFTYPE,
  bufferEncrypted = bufferEncrypted,
}
