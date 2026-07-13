--- @since 26.1.22

local M = {}

local function fail(job, message)
  ya.preview_widget(job, ui.Text.parse(message):area(job.area):wrap(ui.Wrap.YES))
end

local function make_links_visible(text)
  -- mdcat emits OSC 8 hyperlinks. Yazi's ANSI parser drops OSC 8, so keep
  -- both the label and destination as ordinary visible text.
  text = text:gsub("\27%]8;;([^\27]*)\27\\(.-)\27%]8;;\27\\", "%2 (%1)")
  text = text:gsub("\27%]8;;[^\27]*\27\\", "")
  text = text:gsub("\27%]8;;\27\\", "")
  return text
end

function M:peek(job)
  local command = job.args[1] or [[
    CLICOLOR_FORCE=1 FORCE_COLOR=1 mdcat --ansi --local \
      --columns="$w" \
      --theme="$([ "$t" = "dark" ] && echo catppuccin-mocha || echo catppuccin-latte)" \
      "$1"
  ]]
  local child, err = Command("sh")
    :arg({ "-c", command, "sh", tostring(job.file.path) })
    :env("w", job.area.w)
    :env("h", job.area.h)
    :env("t", rt.term.light and "light" or "dark")
    :stdout(Command.PIPED)
    :stderr(Command.PIPED)
    :spawn()

  if not child then
    return fail(job, "sh: " .. err)
  end

  local limit = job.area.h
  local i, outputs, errors = 0, {}, {}

  repeat
    local line, event = child:read_line()
    if event == 1 then
      errors[#errors + 1] = line
    elseif event ~= 0 then
      break
    end

    i = i + 1
    if i > job.skip then
      outputs[#outputs + 1] = line
    end
  until i >= job.skip + limit

  child:start_kill()
  if #errors > 0 then
    return fail(job, table.concat(errors, ""))
  elseif job.skip > 0 and i < job.skip + limit then
    return ya.emit("peek", {
      math.max(0, i - limit),
      only_if = job.file.url,
      upper_bound = true,
    })
  end

  local text = table.concat(outputs, "")
  text = make_links_visible(text)
  text = text:gsub("\t", string.rep(" ", rt.preview.tab_size))
  ya.preview_widget(job, ui.Text.parse(text):area(job.area))
end

function M:seek(job)
  return require("code"):seek(job)
end

return M
