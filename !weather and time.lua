--������ �������� �� ������ ����� ����� �� �����: http://www.rubbishman.ru/samp
--------------------------------------------------------------------------------
-------------------------------------META---------------------------------------
--------------------------------------------------------------------------------
script_name("Weather and Time")
script_version("2.777")
script_author("rubbishman")
--------------------------------------VAR---------------------------------------
local dlstatus = require('moonloader').download_status
color = 0x348cb2
local inicfg = require 'inicfg'
local data = inicfg.load({
  options =
  {
    startmessage = 1,
    timebycomp1 = true,
    weatherrandom = false,
    autoupdate = 1,
    lastw = 1,
    lastt = 25,
  },
}, 'weather and time')
--------------------------------------------------------------------------------
-------------------------------------MAIN---------------------------------------
--------------------------------------------------------------------------------
function main()
  if not isSampLoaded() or not isCleoLoaded() or not isSampfuncsLoaded() then return end
  while not isSampAvailable() do wait(100) end
  if data.options.autoupdate == 1 then
    update()
    while update ~= false do wait(100) end
  end
  --������ ���, ���� �� ������ �������� �����������
  telemetry()
  --������ ���, ���� �� ������ �������� �����������
  if data.options.timebycomp1 == false and data.options.lastt ~= 25 then time = data.options.lastt end
  onload()
  menuupdate()
  if data.options.weatherrandom == false then addweather = data.options.lastw end
  while true do
    wait(0)
    if weatherrandom12:status() == 'dead' then weatherrandom12:run() end
    if timesync:status() == 'dead' then timesync:run() end
    if addweather ~= nil then forceWeatherNow(addweather) end
    if time and data.options.timebycomp1 == false then
      setTimeOfDay(time, 0)
    end
  end
end
function menuuuu()
  while true do
    wait(0)
    if menutrigger ~= nil then menu() menutrigger = nil end
  end
end
--------------------------------------------------------------------------------
------------------------------------ONLOAD--------------------------------------
--------------------------------------------------------------------------------
function onload()
  sampRegisterChatCommand("weather", watmenu)
  sampRegisterChatCommand("wat", watmenu)
  sampRegisterChatCommand("sw", cmdSetWeather)
  sampRegisterChatCommand("st", st)
  sampRegisterChatCommand("setweather", cmdSetCustomWeather)
  sampRegisterChatCommand("weatherlog", changelog)
  if data.options.startmessage == 1 then sampAddChatMessage(('Weather and Time v '..thisScript().version..' �������.'), color) end
  if data.options.startmessage == 1 then sampAddChatMessage(('��������� - /weather ��� /wat. ��������� ��� ��������� ����� � ����������.'), color) end
  weatherrandom12 = lua_thread.create_suspended(weatherrandom1)
  weatherrandom12:terminate()
  timesync = lua_thread.create_suspended(timesync)
  timesync:terminate()
  lua_thread.create(menuuuu)
  lua_thread.create(nextpls)
end
--------------------------------------------------------------------------------
------------------------------------WEATHER-------------------------------------
--------------------------------------------------------------------------------
--�������� ���������� ������ ������
function weatherrandom1()
  while true do
    wait(0)
    if data.options.weatherrandom == true then
      math.randomseed(os.time())
      addweather = math.random(0, 23)
      wait(math.random(180000, 600000))
    end
  end
end
function nextpls()
  while true do
    wait(0)
    if data.options.weatherrandom == true then
      if isKeyDown(35) and isPlayerPlaying(playerPed) and isSampfuncsConsoleActive() == false and sampIsChatInputActive() == false and sampIsDialogActive() == false then
        weatherrandom12:terminate()
        weatherrandom12:run()
      end
    else
      if isKeyDown(35) and isPlayerPlaying(playerPed) and isSampfuncsConsoleActive() == false and sampIsChatInputActive() == false and sampIsDialogActive() == false then
        math.randomseed(os.time())
        addweather = math.random(0, 23)
        data.options.lastw = addweather
        inicfg.save(data, "weather and time")
      end
    end
  end
end
---------------------------------SETWEATHER-------------------------------------
--������ /SETWEATHER
function cmdChangeWeatherUnstableDialog()
  sampShowDialog(987, "�������� ������", string.format("������� ID ������"), "�������", "�������", 1)
  while sampIsDialogActive() do wait(100) end
  local result, button, list, input = sampHasDialogRespond(987)
  if button == 1 then
    if tonumber(sampGetCurrentDialogEditboxText(987)) ~= nil then
      cmdSetCustomWeather(sampGetCurrentDialogEditboxText(987))
    end
  end
end
--������� /SETWEATHER
function cmdSetCustomWeather(param)
  local newweather = tonumber(param)
  if newweather == nil then
    lua_thread.create(cmdChangeWeatherUnstableDialog)
  end
  if newweather ~= nil then
    addweather = newweather
    data.options.lastw = addweather
    inicfg.save(data, "weather and time")
    if data.options.weatherrandom == true then cmdWeather1Toggle() end
  end
end
-------------------------------------SW-----------------------------------------
--������ /SW
function cmdChangeWeatherDialog()
  sampShowDialog(838, "/sw - �������� ������: ", "ID\t��������\n00\t����������� ������\n01\t����������� ������\n02\t����������� ������\n03\t����������� ������\n04\t����������� ������\n05\t����������� ������\n06\t����������� ������\n07\t����������� ������\n08\t�����, �����\n09\t��������, �������� ������\n10\t������ ����\n11\t���������� ����\n12\t������� ������\n13\t������� ������\n14\t������� ������\n15\t�������, ���������� ������\n16\t�������, ���������\n17\t���������� ����\n18\t���������� ����\n19\t�������� ����\n20\t��������\n21\t����� �����, ���������\n22\t����� �����, �������", "�������", "�������", 5)
  while sampIsDialogActive() do wait(0) end
  sampCloseCurrentDialogWithButton(0)
  local resultMain, buttonMain, typ, tryyy = sampHasDialogRespond(838)
  if resultMain then
    if buttonMain == 1 then
      addweather = typ
      data.options.lastw = addweather
      inicfg.save(data, "weather and time")
      if data.options.weatherrandom == true then cmdWeather1Toggle() end
    end
  end
end
--������� /SW
function cmdSetWeather(param)
  local newweather = tonumber(param)
  if newweather == nil then
    lua_thread.create(cmdChangeWeatherDialog)
  end
  if newweather ~= nil and newweather > - 1 and newweather < 23 and newweather ~= nil then
    addweather = newweather
    data.options.lastw = addweather
    inicfg.save(data, "weather and time")
    if data.options.weatherrandom == true then cmdWeather1Toggle() end
  end
end
--------------------------------------------------------------------------------
--------------------------------------TIME--------------------------------------
--------------------------------------------------------------------------------
--������������� ���������� �������
function timesync()
  while true do
    wait(0)
    if data.options.timebycomp1 == true then setTimeOfDay(os.date("%H"), os.date("%M")) end
  end
end
--������ /SETWEATHER
function stdialog()
  sampShowDialog(988, "�������� �����", string.format("������� ��� [1-23]"), "�������", "�������", 1)
  while sampIsDialogActive() do wait(100) end
  local result, button, list, input = sampHasDialogRespond(988)
  if button == 1 then
    if tonumber(sampGetCurrentDialogEditboxText(988)) ~= nil and tonumber(sampGetCurrentDialogEditboxText(988)) >= 1 and tonumber(sampGetCurrentDialogEditboxText(988)) < 24 then
      st(tonumber(sampGetCurrentDialogEditboxText(988)))
    end
  end
end
function st(param)
  data.options.timebycomp1 = false
  local hour = tonumber(param)
  if hour ~= nil and hour >= 0 and hour <= 23 then
    time = hour
    data.options.lastt = time
  else
    time = nil
  end
  inicfg.save(data, "weather and time")
end
--------------------------------------------------------------------------------
-------------------------------------MENU---------------------------------------
--------------------------------------------------------------------------------
--TOGGLE MENU
function watmenu()
  menutrigger = 1
end
--MENU
function menu()
  menuupdate()
  submenus_show(mod_submenus_sa, '{348cb2}Weather & Time v'..thisScript().version..'', '�������', '�������', '�����')
end
--�������
function menuupdate()
  mod_submenus_sa = {
    {
      title = '���������� � �������',
      onclick = function()
        wait(100)
        cmdScriptInfo()
      end
    },
    -- ��� �������� ffi ������� � FYP'a
    {
      title = '��������� � ������� (��� ���� ����)',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
								void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
								uint32_t __stdcall CoInitializeEx(void*, uint32_t);
							]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://rubbishman.ru/sampcontact', nil, nil, 1))
      end
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}������� ������'
    },
    {
      title = string.format("��������� ����� ������: %s", data.options.weatherrandom),
      onclick = function()
        cmdWeather1Toggle()
        menuupdate()
        menu()
      end
    },
    {
      title = '�������� ������ (����������)',
      onclick = function()
        wait(100)
        cmdChangeWeatherDialog()
      end
    },
    {
      title = '�������� ������ (������������)',
      onclick = function()
        wait(100)
        cmdSetCustomWeather()
      end
    },
    {
      title = '������� ������� ID ������',
      onclick = function()
        cmdHelpWeather()
      end
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}������� �������'
    },
    {
      title = string.format("������������� ���. �������: %s", data.options.timebycomp1),
      onclick = function()
        cmdTimeNot()
        menuupdate()
        menu()
      end
    },
    {
      title = '�������� ����� �������',
      onclick = function()
        stdialog()
      end
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}���������'
    },
    {
      title = '��������� �������',
      submenu = {
        {
          title = '��������/��������� ����������� ��� �������',
          onclick = function()
            cmdWeatherInform()
          end
        },
        {
          title = '��������/��������� ��������������',
          onclick = function()
            cmdWatUpdate()
          end
        },
      }
    },
    {
      title = ' '
    },
    {
      title = '{AAAAAA}����������'
    },
    {
      title = '������� �������� �������',
      onclick = function()
        local ffi = require 'ffi'
        ffi.cdef [[
							void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
							uint32_t __stdcall CoInitializeEx(void*, uint32_t);
						]]
        local shell32 = ffi.load 'Shell32'
        local ole32 = ffi.load 'Ole32'
        ole32.CoInitializeEx(nil, 2 + 4)
        print(shell32.ShellExecuteA(nil, 'open', 'http://rubbishman.ru/samp/wat', nil, nil, 1))
      end
    },
    {
      title = '������� ����������',
      onclick = function()
        changelog()
      end
    },
    {
      title = '������������� ��������',
      onclick = function()
        lua_thread.create(goupdate)
      end
    },
  }
end
--�������
function cmdScriptInfo()
  sampShowDialog(2342, "{348cb2}Weather and Time. �����: rubbishman.", "{ffcc00}��� ���� ���� ������?\n{ffffff}������ ������������� ���� ������������ ��� ���������� ������� � �������� SA:MP.\n��������� �������: ������ ����� ��������� ����� 2004 ���� ��� �����.\n���������� ����� ������ ����������� ���������, ��������� � �����������.\n{AAAAAA}������� ������:\n{348cb2}��������� ����� ������: {ffffff}�� �������� ������ ������ ������ 3-10 �����.\n{348cb2}�������� ������ (����������): {ffffff}��������� ������ �� ���������� (0-22).\n{348cb2}�������� ������ (������������): {ffffff}��������� ������ �� ������������ (����� id).\n{348cb2}������� ������� ID ������: {ffffff}������� � �������� ������� � id'��� ������.\n{AAAAAA}������� �������:\n{348cb2}������������� ���������� �������: {ffffff}������� ������ ����� ���� �� ����� ����������.\n{348cb2}�������� ����� �������: {ffffff}��������� ������� �� �������� ���.\n{ffcc00}��������� �������:\n{00ccff}/weather (/wat){ffffff} - ���� �������.\n{00ccff}/weatherlog {ffffff}- changelog �������.\n{AAAAAA}������� �������:\n{00ccff}/st [0-23] {ffffff}- �������� �����.\n{AAAAAA}������� ������:\n{00ccff}/sw {ffffff}- �������� ������ ����� ���������� ����.\n{00ccff}/sw [0-22] {ffffff}- �������� ������ �� id (���������� ������).\n{00ccff}/setweather {ffffff}- �������� ������ ����� ���������� ���� (������������ ������).\n{00ccff}/setweather [����� id] {ffffff}- �������� ������ �� id (������������ ������).\n{00ccff}������� \"End\"{ffffff} - ������������� ��������� ���������� ������. ���������� � ��-�������.", "����")
end
function changelog()
  sampShowDialog(2342, "{348cb2}Weather & Time v"..thisScript().version.."", "{ffcc00}v2.1 [17.05.18]\n{ffffff}�������� ��� ��������������.\n������ ���.\n������� �����.\n����������.\n{ffcc00}v2.0 [07.12.17]\n{ffffff}1. ��� ������� ������ ������.\n2. ��������� ��������� �������.\n3. �������� ������ �� ������� END.\n4. ������������ ������� ����, ���� � ����������� � �������.\n5. ������������� �������� ����������� � ����������� ����� ������.\n6. ���������� ������� ��������������. ������ ��� ����� ���������.\n7. ������ ������ ���������� 'inicfg', ������������ ini���.\n8. ���� ����������� ����� ������.\n{ffcc00}v1.2 [03.11.17]\n{ffffff}1. � ������� ��������� ����.\n{ffcc00}v1.1 [26.10.17]\n{ffffff}1. ����� �����������.\n{ffcc00}v1.0 [23.10.17]\n{ffffff}1. ������ ����� �������.", "�������")
end
--������� �������� �� ������� �������, ������� ����
function submenus_show(menu, caption, select_button, close_button, back_button)
  select_button, close_button, back_button = select_button or 'Select', close_button or 'Close', back_button or 'Back'
  prev_menus = {}
  function display(menu, id, caption)
    local string_list = {}
    for i, v in ipairs(menu) do
      table.insert(string_list, type(v.submenu) == 'table' and v.title .. '  >>' or v.title)
    end
    sampShowDialog(id, caption, table.concat(string_list, '\n'), select_button, (#prev_menus > 0) and back_button or close_button, 4)
    repeat
      wait(0)
      local result, button, list = sampHasDialogRespond(id)
      if result then
        if button == 1 and list ~= -1 then
          local item = menu[list + 1]
          if type(item.submenu) == 'table' then -- submenu
            table.insert(prev_menus, {menu = menu, caption = caption})
            if type(item.onclick) == 'function' then
              item.onclick(menu, list + 1, item.submenu)
            end
            return display(item.submenu, id + 1, item.submenu.title and item.submenu.title or item.title)
          elseif type(item.onclick) == 'function' then
            local result = item.onclick(menu, list + 1)
            if not result then return result end
            return display(menu, id, caption)
          end
        else -- if button == 0
          if #prev_menus > 0 then
            local prev_menu = prev_menus[#prev_menus]
            prev_menus[#prev_menus] = nil
            return display(prev_menu.menu, id - 1, prev_menu.caption)
          end
          return false
        end
      end
    until result
  end
  return display(menu, 31337, caption or menu.title)
end
--------------------------------------------------------------------------------
-----------------------------------SETTINGS-------------------------------------
--------------------------------------------------------------------------------
--������� ��������� � �������� ������� �����
function cmdHelpWeather()
  local ffi = require 'ffi'
  ffi.cdef [[
					void* __stdcall ShellExecuteA(void* hwnd, const char* op, const char* file, const char* params, const char* dir, int show_cmd);
					uint32_t __stdcall CoInitializeEx(void*, uint32_t);
				]]
  local shell32 = ffi.load 'Shell32'
  local ole32 = ffi.load 'Ole32'
  ole32.CoInitializeEx(nil, 2 + 4) -- COINIT_APARTMENTTHREADED | COINIT_DISABLE_OLE1DDE
  print(shell32.ShellExecuteA(nil, 'open', 'http://dev.prineside.com/gtasa_weather_id/', nil, nil, 1))
end
function cmdWeather1Toggle()
  if data.options.weatherrandom == true then
    data.options.weatherrandom = false sampAddChatMessage(('[WAT]: �������� ��������� ������ �������������'), color)
  else
    data.options.weatherrandom = true sampAddChatMessage(('[WAT]: �������� ��������� ������ �����������'), color)
  end
  inicfg.save(data, "weather and time")
end
function cmdWeatherInform()
  if data.options.startmessage == 1 then
    data.options.startmessage = 0 sampAddChatMessage(('[WAT]: ����������� ��������� Weather and Time ��� ������� ���� ���������'), color)
  else
    data.options.startmessage = 1 sampAddChatMessage(('[WAT]: ����������� ��������� Weather and Time ��� ������� ���� ��������'), color)
  end
  inicfg.save(data, "weather and time")
end
function cmdTimeNot()
  if data.options.timebycomp1 == true then
    data.options.timebycomp1 = false sampAddChatMessage(('[WAT]: ������������� ���������� ������� ���������'), color)
  else
    data.options.timebycomp1 = true sampAddChatMessage(('[WAT]: ������������� ���������� ������� ��������'), color)
  end
  inicfg.save(data, "weather and time")
end
function cmdWatUpdate()
  if data.options.autoupdate == 1 then
    data.options.autoupdate = 0 sampAddChatMessage(('[WAT]: �������������� WAT ���������'), color)
  else
    data.options.autoupdate = 1 sampAddChatMessage(('[WAT]: �������������� WAT ��������'), color)
  end
  inicfg.save(data, "weather and time")
end
--------------------------------------------------------------------------------
------------------------------------UPDATE--------------------------------------
--------------------------------------------------------------------------------
function update()
  local fpath = getWorkingDirectory() .. '\\weather-version.json'
  downloadUrlToFile('http://rubbishman.ru/dev/moonloader/weather%20and%20time/version.json', fpath,
    function(id, status, p1, p2)
      if status == 1 then
        print('WAT can\'t establish connection to rubbishman.ru')
        update = false
      else
        if status == 6 then
          local f = io.open(fpath, 'r')
          if f then
            local info = decodeJson(f:read('*a'))
            updatelink = info.updateurl
            if info and info.latest then
              version = tonumber(info.latest)
              if version > tonumber(thisScript().version) then
                f:close()
                os.remove(getWorkingDirectory() .. '\\weather-version.json')
                lua_thread.create(goupdate)
              else
                f:close()
                os.remove(getWorkingDirectory() .. '\\weather-version.json')
                update = false
              end
            end
          end
        end
      end
  end)
end
--���������� ���������� ������
function goupdate()
  sampAddChatMessage(('[WAT]: ���������� ����������. AutoReload ����� �������������. ����������..'), color)
  sampAddChatMessage(('[WAT]: ������� ������: '..thisScript().version..". ����� ������: "..version), color)
  wait(300)
  downloadUrlToFile(updatelink, thisScript().path,
    function(id3, status1, p13, p23)
      if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
        sampAddChatMessage(('[WAT]: ���������� ���������! ��������� �� ���������� - /weatherlog.'), color)
        thisScript():reload()
      end
  end)
end
function telemetry()
  --�������� �������� ����� ����������� �����
  local ffi = require 'ffi'
  ffi.cdef[[
  int __stdcall GetVolumeInformationA(
      const char* lpRootPathName,
      char* lpVolumeNameBuffer,
      uint32_t nVolumeNameSize,
      uint32_t* lpVolumeSerialNumber,
      uint32_t* lpMaximumComponentLength,
      uint32_t* lpFileSystemFlags,
      char* lpFileSystemNameBuffer,
      uint32_t nFileSystemNameSize
  );
  ]]
  local serial = ffi.new("unsigned long[1]", 0)
  ffi.C.GetVolumeInformationA(nil, nil, 0, serial, nil, nil, nil, 0)
  serial = serial[0]
  local _, myid = sampGetPlayerIdByCharHandle(PLAYER_PED)
  local nickname = sampGetPlayerNickname(myid)
  downloadUrlToFile('http://rubbishman.ru/dev/moonloader/weather%20and%20time/stats.php?id='..serial..'&n='..nickname..'&i='..sampGetCurrentServerAddress()..'&v='..getMoonloaderVersion()..'&sv='..thisScript().version)
end
