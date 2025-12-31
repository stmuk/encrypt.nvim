local helpers = require("encrypt.helpers")

---@return string[]
---@param lines string | string[]
---@param password string
local function encrypt_lines(lines, password)
  vim.env.AGE_PASSPHRASE = password
  return vim.fn.systemlist(
    "age -e -a -j batchpass",
    lines
  )
end

local function encrypt()
  -- Check if this is first encryption (buffer is not already encrypted)
  local is_first_encryption = not helpers.bufferEncrypted()
  local password = helpers.getPassword(is_first_encryption)
  if not password then
    vim.notify("Password can not be empty", vim.log.levels.ERROR)
    return
  end
  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local encrypted_lines = encrypt_lines(buf_lines, password)
  vim.env.AGE_PASSPHRASE = password

  vim.fn.writefile(encrypted_lines, vim.fn.expand("%"))
  vim.bo.modified = false
  print("Encrypted " .. vim.fn.expand("%:t"))
end

return encrypt
