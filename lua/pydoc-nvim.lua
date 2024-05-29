-- Compares two version strings. E.g. 2.9 < 2.10
function compare(a, b)
  local function padnum(n, rest) return ("%06d" .. (rest or "")):format(tonumber(n)) end
  return tostring(a):gsub("(%d+)",padnum) < tostring(b):gsub("(%d+)",padnum)
end

local M = {}

M.script_path = (function ()
   local str = debug.getinfo(2, 'S').source:sub(2)
   return str:match('(.*/)')
end)()

M.python_docs = {}
-- Append a '\n' to make the split work for the last element
files_output = vim.fn['glob'](M.script_path .. "../python_docs/*") .. "\n"
versions = {}
for path in files_output:gmatch("(.-)\n") do
    for first in path:gmatch("doc_py([%d]+[.][%d]+)") do
        version = first
        break
    end
    M.python_docs[version] = path
    table.insert(versions, version)
end

-- Sort from oldest to newest version
table.sort(versions, compare)
M.latest_version = versions[#versions]


M.select_version = function(current_version, silent)
    -- Remove previous documentation from runtimepath
    if M.current_version ~= nil then
        old_doc_path = M.python_docs[M.current_version]
        vim.opt.runtimepath:remove(old_doc_path)
    end

    M.current_version = current_version
    -- Add selected documentation to runtimepath
    doc_path = M.python_docs[M.current_version]
    vim.opt.runtimepath:append(',' .. doc_path .. ',')

    if not silent then
        print("PyDoc version set to " .. M.current_version)
    end
end

-- Function called by the vim api
local _usercommand_select_version = function(opts)
    current_version = opts.fargs[1]
    if current_version == nil then
        error("Command needs one argument")
        return
    end

    M.select_version(current_version)
end

M.available_versions = function()
    return versions
end

M.setup = function(opts)
    opts = opts or {}
    vim.api.nvim_create_user_command('PyDocVersion', _usercommand_select_version,
        {
            bang = true,
            nargs = '*',
            complete = M.available_versions
        }
    )

    version = opts["version"] or M.latest_version

    M.select_version(version, true)
end


return M
