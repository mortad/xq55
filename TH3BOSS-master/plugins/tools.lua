--Begin Tools.lua :)
local SUDO = 60809019 -- حط ايديك هنا <===
function exi_files(cpath)
    local files = {}
    local pth = cpath
    for k, v in pairs(scandir(pth)) do
		table.insert(files, v)
    end
    return files
end

local function file_exi(name, cpath)
    for k,v in pairs(exi_files(cpath)) do
        if name == v then
            return true
        end
    end
    return false
end
local function run_bash(str)
    local cmd = io.popen(str)
    local result = cmd:read('*all')
    return result
end
local function index_function(user_id)
  for k,v in pairs(_config.admins) do
    if user_id == v[1] then
    	print(k)
      return k
    end
  end
  -- If not found
  return false
end

local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end 

local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

local function exi_file()
    local files = {}
    local pth = tcpath..'/data/document'
    for k, v in pairs(scandir(pth)) do
        if (v:match('.lua$')) then
            table.insert(files, v)
        end
    end
    return files
end

local function pl_exi(name)
    for k,v in pairs(exi_file()) do
        if name == v then
            return true
        end
    end
    return false
end

local function sudolist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = "*📌¦ List of sudo users :*\n"
   else
 text = "*📌¦ قائمه المطورين : \n"
  end
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end

local function adminlist(msg)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
local sudo_users = _config.sudo_users
  if not lang then
 text = '*📌¦ List of bot admins :*\n'
   else
 text = "*📌¦ قائمه الاداريين : *\n"
  end
		  	local compare = text
		  	local i = 1
		  	for v,user in pairs(_config.admins) do
			    text = text..i..'- '..(user[2] or '')..' ➣ ('..user[1]..')\n'
		  	i = i +1
		  	end
		  	if compare == text then
   if not lang then
		  		text = '📌¦ _No_ *admins* _available_'
      else
		  		text = '* 📌¦ لا يوجد اداريين  *'
           end
		  	end
		  	return text
    end

local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'No groups at the moment'
    end
    local message = '📌¦ قـائمـه الـكـروبـات :\n*Use #join (ID) to join*\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				group_name_id = name .. '\n(ID: ' ..group_id.. ')\n\n'
				if name:match("[\216-\219][\128-\191]") then
					group_info = i..' - \n'..group_name_id
				else
					group_info = i..' - '..group_name_id
				end
				i = i + 1
			end
        end
		message = message..group_info
    end
	return message
end

local function botrem(msg)
	local data = load_data(_config.moderation.data)
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get('CheckExpire::'..msg.to.id) then
		redis:del('CheckExpire::'..msg.to.id)
	end
	if redis:get('ExpireDate:'..msg.to.id) then
		redis:del('ExpireDate:'..msg.to.id)
	end
	tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
end

local function warning(msg)
	local hash = "gp_lang:"..msg.to.id
	local lang = redis:get(hash)
	local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
	if expiretime == -1 then
		return
	else
	local d = math.floor(expiretime / 86400) + 1
        if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
			if lang then
				tdcli.sendMessage(msg.to.id, 0, 1, '📌¦ يرجى التواصل مع مطور البوت لتجديد اشتراك البوت والا ساخرج تلقائيا ‼️', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, 0, 1, '*📌¦ please talk with my sudo to charge me here ‼️*', 1, 'md')
			end
		end
	end
end

local function action_by_reply(arg, data)
    local cmd = arg.cmd
if not tonumber(data.sender_user_id_) then return false end
    if data.sender_user_id_ then
    if cmd == "رفع اداري" then
local function adminprom_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if is_admin1(tonumber(data.id_)) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is already an_ *admin* ☑️_', 0, "md")
  else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_انه بالتأكيد اداري ☑️_', 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_has been promoted as_ *admin* ☑️_', 0, "md")
    else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_تمت ترقيته ليصبح اداري ☑️_', 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, adminprom_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "تنزيل اداري" then
local function admindem_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
	local nameid = index_function(tonumber(data.id_))
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if not is_admin1(data.id_) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is not a_ *admin* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد ليس اداري ☑️_', 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_has been demoted from_ *admin* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم تنزيله من الاداره ☑️_', 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, admindem_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
       if cmd == "رفع مطور" then
local function visudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
if already_sudo(tonumber(data.id_)) then
  if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is already a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد مطور ☑️_', 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is now_ *sudoer* ☑️_', 0, "md")
  else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم ترقيته ليصبح مطور ☑️_', 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, visudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
    if cmd == "تنزيل مطور" then
local function desudo_cb(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
     if not already_sudo(data.id_) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is not a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد ليس مطور ☑️_', 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is no longer a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم تنزيله من المطورين ☑️_', 0, "md")
   end
end
tdcli_function ({
    ID = "GetUser",
    user_id_ = data.sender_user_id_
  }, desudo_cb, {chat_id=data.chat_id_,user_id=data.sender_user_id_})
  end
else
    if lang then
  return tdcli.sendMessage(data.chat_id_, "", 0, "*📌¦ لا يوجد", 0, "md")
   else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*📌¦ User Not Found*", 0, "md")
      end
   end
end

local function action_by_username(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not arg.username then return false end
    if data.id_ then
if data.type_.user_.username_ then
user_name = '@'..check_markdown(data.type_.user_.username_)
else
user_name = check_markdown(data.title_)
end
    if cmd == "رفع اداري" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is already a_ *admin* ☑️_', 0, "md")
  else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد اداري ☑️_', 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is Now a_ *admin* ☑️_', 0, "md")
    else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم ترقيته ليصبح اداري ☑️_', 0, "md")
   end
end
    if cmd == "تنزيل اداري" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is not a_ *admin* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد ليس اداري ☑️_', 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_has been demoted from_ *admin* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم تنزيله من الاداره ☑️_', 0, "md")
   end
end
    if cmd == "رفع مطور" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is already a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد مطور ☑️_', 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is now_ *sudoer* ☑️_', 0, "md")
  else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم ترقيته ليصبح مطور ☑️_', 0, "md")
   end
end
    if cmd == "تنزيل مطور" then
     if not already_sudo(data.id_) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is not a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد ليس مطور ☑️_', 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is no longer a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم تنزيله من المطورين ☑️_', 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_📌¦  لا يوجد _", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*📌¦ User Not Found*", 0, "md")
      end
   end
end

local function action_by_id(arg, data)
local hash = "gp_lang:"..arg.chat_id
local lang = redis:get(hash)
    local cmd = arg.cmd
if not tonumber(arg.user_id) then return false end
   if data.id_ then
if data.username_ then
user_name = '@'..check_markdown(data.username_)
else
user_name = check_markdown(data.first_name_)
end
    if cmd == "رفع اداري" then
if is_admin1(tonumber(data.id_)) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is already a_ *admin* ☑️_', 0, "md")
  else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد اداري ☑️_', 0, "md")
      end
   end
	    table.insert(_config.admins, {tonumber(data.id_), user_name})
		save_config()
     if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is Now a_ *admin* ☑️_', 0, "md")
    else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تمت ترقيته ليصبح اداري ☑️_', 0, "md")
   end
end 
    if cmd == "تنزيل اداري" then
	local nameid = index_function(tonumber(data.id_))
if not is_admin1(data.id_) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is not a_ *admin* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد ليس اداري ☑️_', 0, "md")
      end
   end
		table.remove(_config.admins, nameid)
		save_config()
    if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_has been demoted from_ *admin* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم تنزيله من الاداره ☑️_', 0, "md")
   end
end
    if cmd == "رفع مطور" then
if already_sudo(tonumber(data.id_)) then
  if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is already a_ *sudoer* ☑️_', 0, "md")
   else 
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد مطور ☑️_', 0, "md")
      end
   end
          table.insert(_config.sudo_users, tonumber(data.id_))
		save_config()
     reload_plugins(true)
  if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is now_ *sudoer* ☑️_', 0, "md")
  else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم ترقيته ليصبح مطور ☑️_', 0, "md")
   end
end
    if cmd == "تنزيل مطور" then
     if not already_sudo(data.id_) then
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is not a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ انه بالتأكيد ليس مطور ☑️_', 0, "md")
      end
   end
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(data.id_)))
		save_config()
     reload_plugins(true) 
   if not lang then
         return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _User_ ['..user_name..'] \n📌¦ _ID_ *['..data.id_..']*\n📌¦_is no longer a_ *sudoer* ☑️_', 0, "md")
   else
        return tdcli.sendMessage(arg.chat_id, "", 0, '📌¦ _العضو_ ['..user_name..'] \n📌¦ _الايدي_ *['..data.id_..']*\n📌¦_ تم تنزيله من المطورين ☑️_', 0, "md")
      end
   end
else
    if lang then
  return tdcli.sendMessage(arg.chat_id, "", 0, "_📌¦ لا يوجد _", 0, "md")
   else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*📌¦ User Not Found*", 0, "md")
      end
   end
end

local function pre_process(msg)
	if msg.to.type ~= 'pv' then
		local hash = "gp_lang:"..msg.to.id
		local lang = redis:get(hash)
		local data = load_data(_config.moderation.data)
		local gpst = data[tostring(msg.to.id)]
		local chex = redis:get('CheckExpire::'..msg.to.id)
		local exd = redis:get('ExpireDate:'..msg.to.id)
		if gpst and not chex and msg.from.id ~= SUDO and not is_sudo(msg) then
			redis:set('CheckExpire::'..msg.to.id,true)
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 86400, true)
			if lang then
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦_تم دعم المجموعه لمده يوم واحد يرجى التحدث مع مطوري لتجديد الوقت_', 1, 'md')
			else
				tdcli.sendMessage(msg.to.id, msg.id_, 1, '*📌¦ please talk to my sudo to re charge me.*', 1, 'md')
			end
		end
		if chex and not exd and msg.from.id ~= SUDO and not is_sudo(msg) then
			local text1 = '📌¦ دعم ال مجموعه لقد انتهى⌚️ \n\nID:  <code>'..msg.to.id..'</code>\n\nعندما ترید البوت ان یترک المجموعه نفذ هذا الامر التالي\n\n/leave '..msg.to.id..'\nلدخول هذا المجموعه تستطیع الاستفاده من الامر التالي🛡:\n/jointo '..msg.to.id..'\n_________________\nعندما ترید دعم المجموعه من جدید تستطیع الاستفاده من الاوامر التالیه⌚️...\n\n<b>لدعم لمدت شهر:</b>\n/plan 1 '..msg.to.id..'\n\n<b>الدعم لمدة 3 اشهر:</b>\n/plan 2 '..msg.to.id..'\n\n<b>لدعم بلا نهایه👨🏻⌚️☑️:</b>\n/plan 3 '..msg.to.id
			local text2 = '📌¦_دعم هذه المجموعه انتهى ولان لم یتم الدعم المجدد المجموعه تم حذفها من قائمه البوت وسیخرج البوت من المجموعه._'
			local text3 = '_Charging finished._\n\n*Group ID:*\n\n*ID:* `'..msg.to.id..'`\n\n*If you want the robot to leave this group use the following command:*\n\n`/Leave '..msg.to.id..'`\n\n*For Join to this group, you can use the following command:*\n\n`/Jointo '..msg.to.id..'`\n\n_________________\n\n_If you want to recharge the group can use the following code:_\n\n*To charge 1 month:*\n\n`/Plan 1 '..msg.to.id..'`\n\n*To charge 3 months:*\n\n`/Plan 2 '..msg.to.id..'`\n\n*For unlimited charge:*\n\n`/Plan 3 '..msg.to.id..'`'
			local text4 = '_Charging finished. Due to lack of recharge remove the group from the robot list and the robot leave the group._'
			if lang then
				tdcli.sendMessage(SUDO, 0, 1, text1, 1, 'html')
				tdcli.sendMessage(msg.to.id, 0, 1, text2, 1, 'md')
			else
				tdcli.sendMessage(SUDO, 0, 1, text3, 1, 'md')
				tdcli.sendMessage(msg.to.id, 0, 1, text4, 1, 'md')
			end
			botrem(msg)
		else
			local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
			local day = (expiretime / 86400)
			if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
				warning(msg)
			end
		end
	end
end

local function run(msg, matches)
local hash = "gp_lang:"..msg.to.id
local lang = redis:get(hash)
 if tonumber(msg.from.id) == SUDO then
if matches[1] == "clear cache" then
     run_bash("rm -rf ~/.telegram-cli/data/sticker/*")
     run_bash("rm -rf ~/.telegram-cli/data/photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/animation/*")
     run_bash("rm -rf ~/.telegram-cli/data/video/*")
     run_bash("rm -rf ~/.telegram-cli/data/audio/*")
     run_bash("rm -rf ~/.telegram-cli/data/voice/*")
     run_bash("rm -rf ~/.telegram-cli/data/temp/*")
     run_bash("rm -rf ~/.telegram-cli/data/thumb/*")
     run_bash("rm -rf ~/.telegram-cli/data/document/*")
     run_bash("rm -rf ~/.telegram-cli/data/profile_photo/*")
     run_bash("rm -rf ~/.telegram-cli/data/encrypted/*")
    return "*All Cache Has Been Cleared*"
   end
if matches[1] == "رفع مطور" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="رفع مطور"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="رفع مطور"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="رفع مطور"})
      end
   end
if matches[1] == "تنزيل مطور" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="تنزيل مطور"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="تنزيل مطور"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="تنزيل مطور"})
      end
   end
end
if is_sudo(msg) then
   		if matches[1]:lower() == 'اضافه' and not redis:get('ExpireDate:'..msg.to.id) then
			redis:set('ExpireDate:'..msg.to.id,true)
			redis:setex('ExpireDate:'..msg.to.id, 180, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'تم ضبط الوقت 3 دقائق', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Group charged 3 minutes  for settings._', 1, 'md')
				end
		end
		if matches[1] == 'اضافه' then
			if redis:get('CheckExpire::'..msg.to.id) then
				redis:del('CheckExpire::'..msg.to.id)
			end
			redis:del('ExpireDate:'..msg.to.id)
		end
		if matches[1]:lower() == 'gid' then
			tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..msg.to.id..'`', 1,'md')
		end
		if matches[1] == 'غادر' and matches[2] then
			if lang then
				tdcli.sendMessage(matches[2], 0, 1, '📌¦ تم تنفيذ امر المطور سیخرج البوت من المجموعه📩 \n لمزید من التعلیمات تواصل معی المطور ☑️', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, 'تم ضبط الخروج  '..matches[2]..' ', 1,'md')
			else
				tdcli.sendMessage(matches[2], 0, 1, '_Robot left the group._\n*For more information contact The SUDO.*', 1, 'md')
				tdcli.changeChatMemberStatus(matches[2], our_id, 'Left', dl_cb, nil)
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Robot left from under group successfully:*\n\n`'..matches[2]..'`', 1,'md')
			end
		end
		if matches[1]:lower() == 'charge' and matches[2] and matches[3] then
		if string.match(matches[2], '^-%d+$') then
			if tonumber(matches[3]) > 0 and tonumber(matches[3]) < 1001 then
				local extime = (tonumber(matches[3]) * 86400)
				redis:setex('ExpireDate:'..matches[2], extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id,true)
				end
				if lang then
					tdcli.sendMessage(SUDO, 0, 1, '📌¦ وقت تفعيل المجموعة '..matches[2]..'📌¦ الوقت المقدر  '..matches[3]..' 📌¦ وقت التفعيل', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, 'تم تنفيذ امر المطور البوت بالمدة ⌚️☑️ `'..matches[3]..'` تم دعم یوم🛡 \n لمشاهده وقت دعم البوت ارسل فحص  🗣⚒...',1 , 'md')
				else
					tdcli.sendMessage(SUDO, 0, 1, '*Recharged successfully in the group:* `'..matches[2]..'`\n_Expire Date:_ `'..matches[3]..'` *Day(s)*', 1, 'md')
					tdcli.sendMessage(matches[2], 0, 1, '*Robot recharged* `'..matches[3]..'` *day(s)*\n*For checking expire date, send* `/check`',1 , 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, 'من 1 الى 1000 فقط', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Expire days must be between 1 - 1000_', 1, 'md')
				end
			end
		end
		end
		if matches[1]:lower() == 'المده' and matches[2] == '1' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			local timeplan1 = 2592000
			redis:setex('ExpireDate:'..matches[3], timeplan1, true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, '📌¦ تم تفعيل المجموعة بنجاح لامر 1 '..matches[3]..' تم التفعیل \n 📌¦ هذه المجموعه ل30 یوم مشحونه شهر واحد🛠 )', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '_📌¦ تم تفعیل المجموعه بنجاح وستبقی مشحونه الی 30 یوم⌚️_', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Plan 1 Successfully Activated!\nThis group recharged with plan 1 for 30 days (1 Month)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Successfully recharged*\n*Expire Date:* `30` *Days (1 Month)*', 1, 'md')
			end
		end
		end
		if matches[1]:lower() == 'المده' and matches[2] == '2' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			local timeplan2 = 7776000
			redis:setex('ExpireDate:'..matches[3],timeplan2,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, 0, 1, '📌¦ تم تفعيل المجموعة بنجاح لامر 2 '..matches[3]..' تم التفعيل\n لمده 3 اشهر صالحة ', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '📌¦ تم تفعيل البوت بنجاح وصلاحيته لمدة 90 يوم  )', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Plan 2 Successfully Activated!\nThis group recharged with plan 2 for 90 days (3 Month)*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Successfully recharged*\n*Expire Date:* `90` *Days (3 Months)*', 1, 'md')
			end
		end
		end
		if matches[1]:lower() == 'المده' and matches[2] == '3' and matches[3] then
		if string.match(matches[3], '^-%d+$') then
			redis:set('ExpireDate:'..matches[3],true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, '📌¦ تم تفعيل المجموعة بنجاح لامر 3 '..matches[3]..' تم التفعيل\nصالح مدى الحياه', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '📌¦ تم تفعيل البوت بنجاح وصلاحيته مدى الحياه )', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*Plan 3 Successfully Activated!\nThis group recharged with plan 3 for unlimited*', 1, 'md')
				tdcli.sendMessage(matches[3], 0, 1, '*Successfully recharged*\n*Expire Date:* `Unlimited`', 1, 'md')
			end
		end
		end
		if matches[1]:lower() == 'jointo' and matches[2] then
		if string.match(matches[2], '^-%d+$') then
			if lang then
				tdcli.sendMessage(SUDO, msg.id_, 1, '📌¦ اني ضفتك الى هذه المجموعه '..matches[2]..'📌¦ ', 1, 'md')
				tdcli.addChatMember(matches[2], SUDO, 0, dl_cb, nil)
				tdcli.sendMessage(matches[2], 0, 1, '', 1, 'md')
			else
				tdcli.sendMessage(SUDO, msg.id_, 1, '*📌¦ I added you to this group:*\n\n`'..matches[2]..'`', 1, 'md')
				tdcli.addChatMember(matches[2], SUDO, 0, dl_cb, nil)
				tdcli.sendMessage(matches[2], 0, 1, 'Admin Joined!', 1, 'md')
			end
		end
		end
end
	if matches[1]:lower() == 'حفظ ملف' and matches[2] and is_sudo(msg) then
		if msg.reply_id  then
			local folder = matches[2]
            function get_filemsg(arg, data)
				function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' or data.content_.ID == 'MessagePhoto' or data.content_.ID == 'MessageSticker' or data.content_.ID == 'MessageAudio' or data.content_.ID == 'MessageVoice' or data.content_.ID == 'MessageVideo' or data.content_.ID == 'MessageAnimation' then
                        if data.content_.ID == 'MessageDocument' then
							local doc_id = data.content_.document_.document_.id_
							local filename = data.content_.document_.file_name_
                            local pathf = tcpath..'/data/document/'..filename
							local cpath = tcpath..'/data/document'
                            if file_exi(filename, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(doc_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>📌¦ الملف</b> <code>'..folder..'</code> <b>📌¦ تم حفظ الملف بنجاح</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>📌¦ File</b> <code>'..folder..'</code> <b>📌¦ Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦ خطا في العثور على الملف حاول مره اخره ', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦ _This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessagePhoto' then
							local photo_id = data.content_.photo_.sizes_[2].photo_.id_
							local file = data.content_.photo_.id_
                            local pathf = tcpath..'/data/photo/'..file..'_(1).jpg'
							local cpath = tcpath..'/data/photo'
                            if file_exi(file..'_(1).jpg', cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(photo_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>📌¦ الصوره</b> <code>'..folder..'</code> <b>📌¦ تم حفظها</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>📌¦ Photo</b> <code>'..folder..'</code> <b>📌¦ Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_الملف المطلوب لا یوجد رجاََ ارسل الملف من جدید📩_', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
		                if data.content_.ID == 'MessageSticker' then
							local stpath = data.content_.sticker_.sticker_.path_
							local sticker_id = data.content_.sticker_.sticker_.id_
							local secp = tostring(tcpath)..'/data/sticker/'
							local ffile = string.gsub(stpath, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(stpath, pfile)
                                file_dl(sticker_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>ملسق</b> <code>'..folder..'</code> <b>تمت عملية الحفض</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Sticker</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦ _الملف المطلوب لا یوجد رجاََ ارسل الملف من جدید📩_', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAudio' then
						local audio_id = data.content_.audio_.audio_.id_
						local audio_name = data.content_.audio_.file_name_
                        local pathf = tcpath..'/data/audio/'..audio_name
						local cpath = tcpath..'/data/audio'
							if file_exi(audio_name, cpath) then
								local pfile = folder
								os.rename(pathf, pfile)
								file_dl(audio_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>📌¦ صوت</b> <code>'..folder..'</code> <b>📌¦ تم حفظ الصوت</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>📌¦ Audio</b> <code>'..folder..'</code> <b>📌¦ Has Been Saved.</b>', 1, 'html')
								end
							else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦ _الملف المطلوب لا یوجد رجاََ ارسل الملف من جدید📩_', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦ _This file does not exist. Send file again._', 1, 'md')
								end
							end
						end
						if data.content_.ID == 'MessageVoice' then
							local voice_id = data.content_.voice_.voice_.id_
							local file = data.content_.voice_.voice_.path_
							local secp = tostring(tcpath)..'/data/voice/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(voice_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>صوت</b> <code>'..folder..'</code> <b>📌¦تم حفظ الصوت.</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Voice</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦ _الملف المطلوب لا یوجد رجاََ ارسل الملف من جدید📩_', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '📌¦_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageVideo' then
							local video_id = data.content_.video_.video_.id_
							local file = data.content_.video_.video_.path_
							local secp = tostring(tcpath)..'/data/video/'
							local ffile = string.gsub(file, '-', '')
							local fsecp = string.gsub(secp, '-', '')
							local name = string.gsub(ffile, fsecp, '')
                            if file_exi(name, secp) then
                                local pfile = folder
                                os.rename(file, pfile)
                                file_dl(video_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>فيديو</b> <code>'..folder..'</code> <b>تم حفضه بنجاح</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Video</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_الملف المطلوب لا یوجد رجاََ ارسل الملف من جدید📩_', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
						if data.content_.ID == 'MessageAnimation' then
							local anim_id = data.content_.animation_.animation_.id_
							local anim_name = data.content_.animation_.file_name_
                            local pathf = tcpath..'/data/animation/'..anim_name
							local cpath = tcpath..'/data/animation'
                            if file_exi(anim_name, cpath) then
                                local pfile = folder
                                os.rename(pathf, pfile)
                                file_dl(anim_id)
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>صورة متحركة</b> <code>'..folder..'</code> <b>تم حفظها بنجاح</b>', 1, 'html')
								else
									tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Gif</b> <code>'..folder..'</code> <b>Has Been Saved.</b>', 1, 'html')
								end
                            else
								if lang then
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_الملف المطلوب لا یوجد رجاََ ارسل الملف من جدید📩_', 1, 'md')
								else
									tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
								end
                            end
						end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end
	if msg.to.type == 'channel' or msg.to.type == 'chat' then
		if matches[1] == 'charge' and matches[2] and not matches[3] and is_sudo(msg) then
			if tonumber(matches[2]) > 0 and tonumber(matches[2]) < 1001 then
				local extime = (tonumber(matches[2]) * 86400)
				redis:setex('ExpireDate:'..msg.to.id, extime, true)
				if not redis:get('CheckExpire::'..msg.to.id) then
					redis:set('CheckExpire::'..msg.to.id)
				end
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '⌚️\nتم شحن وقت التفعيل ل '..matches[2]..' تم شحن البوت⌚️...', 1, 'md')
                                        tdcli.sendMessage(SUDO, 0, 1, ' 📌¦ شحن البوت في مجموعه⌚️ '..matches[2]..' ل مدة '..msg.to.id..' تم تمدیده☑️', 1, 'md')
                        else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '⌚️\nتم شحن وقت التفعيل ل '..matches[2]..' تم شحن البوت⌚️...', 1, 'md')
                                        tdcli.sendMessage(SUDO, 0, 1, ' 📌¦ شحن البوت في مجموعه⌚️ '..matches[2]..' ل مدة '..msg.to.id..' تم تمدیده☑️', 1, 'md')
				end
			else
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_ اختر من 1 الى 1000 فقط ⌚️    ._', 1, 'md')
					else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Expire days must be between 1 - 1000_', 1, 'md')
				end
			end
		end
		if matches[1]:lower() == 'check' and is_mod(msg) and not matches[2] then
			local expi = redis:ttl('ExpireDate:'..msg.to.id)
			if expi == -1 then
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_المجموعة مفعله مدى الحياة⌚️_', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Unlimited Charging!_', 1, 'md')
				end
			else
				local day = math.floor(expi / 86400) + 1
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, day..' باقی یوم واحد ل اتمام دعم المجموعه⌚️', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..day..'` *Day(s) remaining until Expire.*', 1, 'md')
				end
			end
		end
		if matches[1] == 'check' and is_mod(msg) and matches[2] then
		if string.match(matches[2], '^-%d+$') then
			local expi = redis:ttl('ExpireDate:'..matches[2])
			if expi == -1 then
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_المجموعة مفعله مدى الحياة⌚️_', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '_Unlimited Charging!_', 1, 'md')
				end
			else
				local day = math.floor(expi / 86400 ) + 1
				if lang then
					tdcli.sendMessage(msg.to.id, msg.id_, 1, day..'مدة تفعيل المجموعة.', 1, 'md')
				else
					tdcli.sendMessage(msg.to.id, msg.id_, 1, '`'..day..'` *Day(s) remaining until Expire.*', 1, 'md')
				end
			end
		end
		end
	end
if matches[1] == "رفع اداري" and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="رفع اداري"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="رفع اداري"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="رفع اداري"})
      end
   end
if matches[1] == "تنزيل اداري" and is_sudo(msg) then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.to.id,cmd="تنزيل اداري"})
  end
  if matches[2] and string.match(matches[2], '^%d+$') then
tdcli_function ({
    ID = "GetUser",
    user_id_ = matches[2],
  }, action_by_id, {chat_id=msg.to.id,user_id=matches[2],cmd="تنزيل اداري"})
    end
  if matches[2] and not string.match(matches[2], '^%d+$') then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="تنزيل اداري"})
      end
   end

if matches[1] == 'صنع مجموعه' and is_admin(msg) then
local text = matches[2]
tdcli.createNewGroupChat({[0] = msg.from.id}, text, dl_cb, nil)
  if not lang then
return '📌¦ _Group Has Been Created ☑️_'
  else
return '_📌¦ تـم أنـشـاء الـمـجـوعـه ☑️_'
   end
end

if matches[1] == 'ترقيه سوبر' and is_admin(msg) then
local text = matches[2]
tdcli.createNewChannelChat(text, 1, '', dl_cb, nil)
   if not lang then 
return '_SuperGroup Has Been Created!_'
  else
return '_📌¦ تـم تـرقـيـه الـمـجـوعـه ☑️_'
   end
end

if matches[1] == 'سوبر كروب' and is_admin(msg) then
local id = msg.to.id
tdcli.migrateGroupChatToChannelChat(id, dl_cb, nil)
  if not lang then
return '📌¦ _Group Has Been Changed To SuperGroup!_'
  else
return '_📌¦ تـم تـرقـيـه الـمـجـوعـه ☑️_'
   end
end

if matches[1] == 'دخول' and is_admin(msg) then
tdcli.importChatInviteLink(matches[2])
   if not lang then
return '*Done !*'
  else
return '*تم !*'
  end
end

if matches[1] == 'اسم البوت' and is_sudo(msg) then
tdcli.changeName(matches[2])
   if not lang then
return '📌¦ _Bot Name Changed To:_ *'..matches[2]..'*'
  else
return '*📌¦ تم تغيير اسم البوت \n📌¦ الاسم الجديد : *'..matches[2]..'*'
   end
end

if matches[1] == 'معرف البوت' and is_sudo(msg) then
tdcli.changeUsername(matches[2])
   if not lang then
return '*📌¦ Bot Username Changed To *\n*📌¦ username :* @'..matches[2]
  else
return '*➿| تم تعديل معرف البوت *\n* 📌¦ المعرف الجديد :* @'..matches[2]..''
   end
end

if matches[1] == 'مسح معرف البوت' and is_sudo(msg) then
tdcli.changeUsername('')
   if not lang then
return '*Done!*'
  else
return '*تم !*'
  end
end

if matches[1] == 'الماركدوان' and is_sudo(msg) then
if matches[2] == 'تفعيل' then
redis:set('markread','on')
   if not lang then
return '_Markread >_ *ON*'
else
return '_تم تفعيل الماركدوان  📌¦_'
   end
end
if matches[2] == 'تعطيل' then
redis:set('markread','off')
  if not lang then
return '_Markread >_ *OFF*'
   else
return '_تم تعطيل الماركدوان  📌¦_'
      end
   end
end

if matches[1] == 'نشر' and is_admin(msg) then
		local text = matches[2]
tdcli.sendMessage(matches[3], 0, 0, text, 0)	end

if matches[1] == 'اذاعه' and is_sudo(msg) then		
local data = load_data(_config.moderation.data)		
local bc = matches[2]			
for k,v in pairs(data) do				
tdcli.sendMessage(k, 0, 0, bc, 0)			
end	
end

  if is_sudo(msg) then
	if matches[1]:lower() == "ارسل ملف" and matches[2] and 
matches[3] then
		local send_file = 
"./"..matches[2].."/"..matches[3]
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 
1, nil, send_file, '@TH3BOSS', dl_cb, nil)
	end
	if matches[1]:lower() == "جلب ملف" and matches[2] then
	    local plug = "./plugins/"..matches[2]..".lua"
		tdcli.sendDocument(msg.chat_id_, msg.id_,0, 
1, nil, plug, '@TH3BOSS', dl_cb, nil)
    end
  end

    if matches[1]:lower() == 'حفظ' and matches[2] and is_sudo(msg) then
        if tonumber(msg.reply_to_message_id_) ~= 0  then
            function get_filemsg(arg, data)
                function get_fileinfo(arg,data)
                    if data.content_.ID == 'MessageDocument' then
                        fileid = data.content_.document_.document_.id_
                        filename = data.content_.document_.file_name_
                        if (filename:lower():match('.lua$')) then
                            local pathf = tcpath..'/data/document/'..filename
                            if pl_exi(filename) then
                                local pfile = 'plugins/'..matches[2]..'.lua'
                                os.rename(pathf, pfile)
                                tdcli.downloadFile(fileid , dl_cb, nil)
                                tdcli.sendMessage(msg.to.id, msg.id_,1, '<b>Plugin</b> <code>'..matches[2]..'</code> <b>Has Been Saved.</b>', 1, 'html')
                            else
                                tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file does not exist. Send file again._', 1, 'md')
                            end
                        else
                            tdcli.sendMessage(msg.to.id, msg.id_, 1, '_This file is not Plugin File._', 1, 'md')
                        end
                    else
                        return
                    end
                end
                tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = data.id_ }, get_fileinfo, nil)
            end
	        tdcli_function ({ ID = 'GetMessage', chat_id_ = msg.chat_id_, message_id_ = msg.reply_to_message_id_ }, get_filemsg, nil)
        end
    end

if matches[1] == 'المطورين' and is_sudo(msg) then
return sudolist(msg)
    end
if matches[1] == 'المجموعات' and is_admin(msg) then
return chat_list(msg)
    end
   if matches[1]:lower() == 'دعوه' and is_admin(msg) and matches[2] then
	   tdcli.sendMessage(msg.to.id, msg.id, 1, 'I Invite you in '..matches[2]..'', 1, 'html')
	   tdcli.sendMessage(matches[2], 0, 1, "Admin Joined!🌚", 1, 'html')
    tdcli.addChatMember(matches[2], msg.from.id, 0, dl_cb, nil)
  end
		if matches[1] == 'مسح' and matches[2] and is_admin(msg) then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   tdcli.sendMessage(matches[2], 0, 1, "Group has been removed by admin command", 1, 'html')
    return '_Group_ *'..matches[2]..'* _removed_'
		end
if matches[1] == 'المطور' then
return tdcli.sendMessage(msg.to.id, msg.id, 1, _config.info_text, 1, 'html')
    end
if matches[1] == 'الاداريين' and is_admin(msg) then
return adminlist(msg)
    end
     if matches[1] == 'غادر' and is_admin(msg) then
  tdcli.changeChatMemberStatus(msg.to.id, our_id, 'Left', dl_cb, nil)
   end
     if matches[1] == 'الخروج التلقائي' and is_admin(msg) then
local hash = 'auto_leave_bot'
--Enable Auto Leave
     if matches[2] == 'تفعيل' then
    redis:del(hash)
   return '📌¦ _تم تفعيل الخروج التلقائي_'
--Disable Auto Leave
     elseif matches[2] == 'تعطيل' then
    redis:set(hash, true)
   return '📌¦ _تم تعطيل الخروج التلقائي_'
--Auto Leave Status
      elseif matches[2] == 'status' then
      if not redis:get(hash) then
   return 'Auto leave is enable'
       else
   return 'Auto leave is disable'
         end
      end
   end


if matches[1] == "اوامر المطور" and is_mod(msg) then
if not lang then
text = [[
_ sudo smile Bot v2 Help :_
*!visudo* `[username|id|reply]`
_Add Sudo_
*!desudo* `[username|id|reply]`
_Demote Sudo_
*!sudolist *
_Sudo(s) list_
*!adminprom* `[username|id|reply]`
_Add admin for bot_
*!admindem* `[username|id|reply]`
_Demote bot admin_
*!adminlist *
_Admin(s) list_
*!leave *
_Leave current group_
*!autoleave* `[disable/enable]`
_Automatically leaves group_
*!creategroup* `[text]`
_Create normal group_
*!createsuper* `[text]`
_Create supergroup_
*!tosuper *
_Convert to supergroup_
*!chats*
_List of added groups_
*!join* `[id]`
_Adds you to the group_
*!rem* `[id]`
_Remove a group from Database_
*!import* `[link]`
_Bot joins via link_
*!setbotname* `[text]`
_Change bot's name_
*!setbotusername* `[text]`
_Change bot's username_
*!delbotusername *
_Delete bot's username_
*!markread* `[off/on]`
_Second mark_
*!broadcast* `[text]`
_Send message to all added groups_
*!sendfile* `[folder] [file]`
_Send file from folder_
*!sendplug* `[plug]`
_Send plugin_
*!save* `[plugin name] [reply]`
_Save plugin by reply_
*!savefile* `[address/filename] [reply]`_Save File by reply to specific folder_
*!clear cache*
_Clear All Cache Of .telegram-cli/data_
*!check*
_Stated Expiration Date_
*!check* `[GroupID]`
_Stated Expiration Date Of Specific Group_
*!charge* `[GroupID]` `[Number Of Days]`
_Set Expire Time For Specific Group_
*!charge* `[Number Of Days]`
_Set Expire Time For Group_
*!jointo* `[GroupID]`
_Invite You To Specific Group_
*!leave* `[GroupID]`
_Leave Bot From Specific Group_
_You can use_ *[!/#]* _at the beginning of commands._
`This help is only for sudoers/bot admins.`
 
*This means only the sudoers and its bot admins can use mentioned commands.*
*Good luck ;)*]]
tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
else

text = [[
]]
tdcli.sendMessage(msg.chat_id_, 0, 1, text, 1, 'md')
end

end
end

return { 
patterns = {                                                                   
"^(اوامر المطور)$", 
"^(رفع مطور)$", 
"^(تنزيل مطور)$",
"^(المطورين)$",
"^(رفع مطور) (.*)$",
"^(تنزيل مطور) (.*)$",
"^(رفع اداري)$", 
"^(تنزيل اداري)$",
"^(الاداريين)$",
"^(رفع اداري) (.*)$", 
"^(تنزيل مطور) (.*)$",
"^(غادر)$",
"^(الخروج التلقائي) (.*)$", 
"^(المطور)$",
"^(صنع مجموعه) (.*)$",
"^(ترقيه سوبر) (.*)$",
"^(سوبر كروب)$",
"^(المجموعات)$",
"^(clear cache)$",
"^(دعوه) (.*)$",
"^(مسح) (.*)$",
"^(دخول) (.*)$",
"^(اسم البوت) (.*)$",
"^(معرف البوت) (.*)$",
"^(مسح معرف البوت) (.*)$",
"^(الماركدوان) (.*)$",
"^(نشر) +(.*) (.*)$",
"^(اذاعه) (.*)$",
"^(ارسل ملف) (.*) (.*)$",
"^(حفظ) (.*)$",
"^(جلب ملف) (.*)$",
"^(حفظ ملف) (.*)$",
"^(اضافه)$",
"^([Gg]id)$",
"^([Cc]heck)$",
"^([Cc]heck) (.*)$",
"^([Cc]harge) (.*) (%d+)$",
"^([Cc]harge) (%d+)$",
"^([Jj]ointo) (.*)$",
"^(غادر) (.*)$",
"^(المده) ([123]) (.*)$",
"^(اضافه)$",
}, 
run = run, pre_process = pre_process
}
-- BY TH3BOSS
-- BY @lldev1ll
-- BY @ll60kllbot
-- BY TH3BOSS_CLI
