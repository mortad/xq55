local function delmsg (arg,data)
    for k,v in pairs(data.messages_) do
        tdcli.deleteMessages(v.chat_id_,{[0] = v.id_}, dl_cb, cmd)
    end
end
local function th3boss(msg, matches)
    local chat_id = msg.chat_id_
    local msg_id = msg.id_
    if matches[1] == 'تنظيف الكل' or matches[1] == 'delall' or matches[1] == 'تنظيف الكل' then
        if tostring(chat_id):match("^-100") then 
            if is_owner(msg) then
                    tdcli.getChatHistory(chat_id, msg_id, 0, all, delmsg, nil)
                    return '_📌 تم ☑️ تـنـظـيـف الـمـجـمـوعـه 🛡👍🏿 🍃 🗑_'
                end
        else
            return '_تستطيع فقط التنظيف في المجموعات الخارقه  فـقـط 👮_'
        end
    end
end

return {patterns = {
        '^(delall)$',
        '^(تنظيف الكل)$',
    },
    run = th3boss}
--By @TH3BOSS
