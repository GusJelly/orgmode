local config = require('orgmode.config')
local utils = require('orgmode.utils')
local state = require('orgmode.state.state')

-- TODO
-- Create org-store-link
-- On store link, check for variable org-id-link-to-org-use-id
-- Create link with id
-- Support links with id: prefix
local OrgId = {}

function OrgId.new()
  return OrgId._generate()
end

---@private
---@return string
function OrgId._generate()
  if config.org_id_method == 'uuid' then
    if vim.fn.executable(config.org_id_uuid_program) ~= 1 then
      utils.echo_error('org_id_uuid_program is not executable: ' .. config.org_id_uuid_program)
      return ''
    end
    return tostring(vim.fn.system(config.org_id_uuid_program):gsub('%s+', ''))
  end

  if config.org_id_method == 'ts' then
    return tostring(os.date(config.org_id_ts_format))
  end

  if config.org_id_method == 'org' then
    math.randomseed(os.clock() * 100000000000)
    return ('%s%s'):format(vim.trim(config.org_id_prefix or ''), math.random(100000000000000))
  end

  utils.echo_error('Invalid org_id_method: ' .. config.org_id_method)
  return ''
end

return OrgId
