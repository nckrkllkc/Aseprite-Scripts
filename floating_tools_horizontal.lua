if global_full_quick_tools_dialog then
  global_full_quick_tools_dialog:close()
  global_full_quick_tools_dialog = nil
else
  local tools = {
    { icon = "rectangular_marquee", name = "Rectangular Marquee Tool", tool = "rectangular_marquee", key = "M" },
    { icon = "elliptical_marquee", name = "Elliptical Marquee Tool", tool = "elliptical_marquee", key = "Shift+M" },
    { icon = "lasso", name = "Lasso Tool", tool = "lasso", key = "Q" },
    { icon = "polygonal_lasso", name = "Polygonal Lasso Tool", tool = "polygonal_lasso", key = "Shift+Q" },
    { icon = "magic_wand", name = "Magic Wand Tool", tool = "magic_wand", key = "W" },
    { icon = "pencil", name = "Pencil Tool", tool = "pencil", key = "B" },
    { icon = "spray", name = "Spray Tool", tool = "spray", key = "Shift+B" },
    { icon = "eraser", name = "Eraser Tool", tool = "eraser", key = "E" },
    { icon = "eyedropper", name = "Eyedropper Tool", tool = "eyedropper", key = "I" },
    { icon = "zoom", name = "Zoom Tool", tool = "zoom", key = "Z" },
    { icon = "hand", name = "Hand Tool", tool = "hand", key = "H" },
    { icon = "move", name = "Move Tool", tool = "move", key = "V" },
    { icon = "slice", name = "Slice Tool", tool = "slice", key = "Shift+C" },
    { icon = "paint_bucket", name = "Paint Bucket Tool", tool = "paint_bucket", key = "G" },
    { icon = "gradient", name = "Gradient Tool", tool = "gradient", key = "Shift+G" },
    { icon = "line", name = "Line Tool", tool = "line", key = "L" },
    { icon = "curve", name = "Curve Tool", tool = "curve", key = "Shift+L" },
    { icon = "rectangle", name = "Rectangle Tool", tool = "rectangle", key = "U" },
    { icon = "filled_rectangle", name = "Filled Rectangle Tool", tool = "filled_rectangle", key = "U" },
    { icon = "ellipse", name = "Ellipse Tool", tool = "ellipse", key = "Shift+U" },
    { icon = "filled_ellipse", name = "Filled Ellipse Tool", tool = "filled_ellipse", key = "Shift+U" },
    { icon = "contour", name = "Contour Tool", tool = "contour", key = "D" },
    { icon = "polygon", name = "Polygon Tool", tool = "polygon", key = "Shift+D" },
    { icon = "blur", name = "Blur Tool", tool = "blur", key = "R" },
    { icon = "jumble", name = "Jumble Tool", tool = "jumble", key = "R" },
    { icon = "text", name = "Text Tool", tool = "text", key = "T" },
  }

  local btn_w, btn_h = 18, 18
  local hover_idx = nil

  local fixed_win_w = 480
  local fixed_win_h = 48

  local dlg = Dialog{
    title = "Tools",
    resizable = false
  }

  global_full_quick_tools_dialog = dlg

  dlg:canvas{
    id = "tool_canvas",
    width = 468,
    height = 22,

    onpaint = function(ev)
      local gc = ev.context
      local bounds = dlg.bounds

      if bounds.width ~= fixed_win_w or bounds.height ~= fixed_win_h then
        dlg.bounds = Rectangle(bounds.x, bounds.y, fixed_win_w, fixed_win_h)
      end

      for i, t in ipairs(tools) do
        local x = (i - 1) * btn_w
        local y = 2

        if hover_idx == i then
          gc.color = Color{ r = 90, g = 90, b = 120 }
        else
          gc.color = Color{ r = 50, g = 50, b = 58 }
        end

        gc:fillRect(Rectangle(x, y, btn_w - 1, btn_h - 1))

        gc.color = Color{ r = 30, g = 30, b = 35 }
        gc:strokeRect(Rectangle(x, y, btn_w - 1, btn_h - 1))

        gc:drawThemeImage("tool_" .. t.icon, x + 1, y + 1)
      end
    end,

    onmousemove = function(ev)
      local col = math.floor(ev.x / btn_w)

      if col >= 0 and col < #tools and ev.y >= 0 and ev.y <= btn_h + 2 then
        local idx = col + 1

        if hover_idx ~= idx then
          hover_idx = idx
          local t = tools[hover_idx]

          dlg:modify{
            title = t.name .. " [" .. t.key .. "]"
          }

          dlg:repaint()
        end

        return
      end

      if hover_idx ~= nil then
        hover_idx = nil

        dlg:modify{
          title = "Tools"
        }

        dlg:repaint()
      end
    end,

    onmouseup = function(ev)
      if hover_idx and tools[hover_idx] then
        app.tool = tools[hover_idx].tool
      end
    end
  }

  dlg:show{ wait = false }

  local bounds = dlg.bounds
  dlg.bounds = Rectangle(
    bounds.x,
    bounds.y,
    fixed_win_w,
    fixed_win_h
  )
end