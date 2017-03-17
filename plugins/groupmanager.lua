--begin groupmanager by @nigga _marshal |:
--This Is Self Bot Based On shadow |:
local function action_by_reply(arg, data)
   local cmd = arg.cmd
  if data.sender_user_id_ then
   if cmd == "inv" then
 invite_user(data.sender_user_id_, data.chat_id_)
   end
   if cmd == "kick" then
 kick_user(data.sender_user_id_, data.chat_id_)
   end
  if cmd == "delall" then
tdcli.deleteMessagesFromUser(data.chat_id_, data.sender_user_id_, dl_cb, nil)
   end
   if cmd == "id" then
    tdcli.sendMessage(data.chat_id_, "", 0, "*"..data.sender_user_id_.."*", 0, "md")
   end
else
  return tdcli.sendMessage(data.chat_id_, "", 0, "*User not founded*", 0, "md")
     end
  end

local function action_by_username(arg, data)
   local cmd = arg.cmd
  if data.id_ then
   if cmd == "inv" then
 invite_user(data.id_, arg.chat_id)
   end
   if cmd == "kick" then
 kick_user(data.id_, arg.chat_id)
   end
   if cmd == "delall" then
tdcli.deleteMessagesFromUser(arg.chat_id, data.id_, dl_cb, nil)
   end
   if cmd == "id" then
     tdcli.sendMessage(arg.chat_id, "", 0, "*"..data.id_.."*", 0, "md")
   end
else
  return tdcli.sendMessage(arg.chat_id, "", 0, "*User not founded*", 0, "md")
     end
  end

local function run(msg, matches)
   local chat = msg.to.id
   local user = msg.from.id
  if is_sudo(msg) then
if matches[1] == "gpid" then
if not matches[2] and not msg.reply_id then
     if chat:match("-100") then
    gpid = string.gsub(chat, "-100", "")
        else
    gpid = string.gsub(chat, "-", "")
   end
return "*Group ID :* _"..gpid.."_"
  end
end
if matches[1] == "id" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="id"})
  end
if matches[2] and not msg.reply_id then
   tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="id"})
      end
   end
 if matches[1] == "kick" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_to_message_id_
    }, action_by_reply, {chat_id=msg.to.id,cmd="kick"})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
   kick_user(matches[2], msg.to.id)
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="kick"})
         end
      end
if matches[1] == "inv" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="inv"})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
   invite_user(matches[2], msg.to.id)
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="inv"})
         end
      end
 if matches[1] == "delall" and msg.to.type == "channel" then
if not matches[2] and msg.reply_id then
    tdcli_function ({
      ID = "GetMessage",
      chat_id_ = msg.to.id,
      message_id_ = msg.reply_id
    }, action_by_reply, {chat_id=msg.to.id,cmd="delall"})
end
  if matches[2] and string.match(matches[2], '^%d+$') and not msg.reply_id then
tdcli.deleteMessagesFromUser(msg.to.id, matches[2], dl_cb, nil)
   end
  if matches[2] and not string.match(matches[2], '^%d+$') and not msg.reply_id then
    tdcli_function ({
      ID = "SearchPublicChat",
      username_ = matches[2]
    }, action_by_username, {chat_id=msg.to.id,username=matches[2],cmd="delall"})
         end
      end
if matches[1] == 'setlink' then
            hash = 'gplink:'..chat
            redis:set(hash, matches[2])
    return "*Newlink* _لینک _"
  end
    if matches[1] == 'link' and is_sudo(msg) then
            hash = 'gplink:'..chat
            local linkgp = redis:get(hash)
            if not linkgp then
     return "_اول لینک را تنظیم کنید➣ /setlink link*"
         end
        tdcli.sendMessage(user, "", 1, "<b>Group Link :</b>\n"..linkgp, 1, 'html')
            return "_لینک به PV ارسال شد_"
     end
if matches[1] == "setname" and matches[2] then
local gp_name = string.gsub(matches[2], "_","")
tdcli.changeChatTitle(chat, gp_name, dl_cb, nil)
end
if matches[1] == 'tosuper' then
local id = msg.to.id
     if msg.to.type == "channel" then
   return "_سوپر گپه اوزگل!_"
     else
   tdcli.migrateGroupChatToChannelChat(id)
    return '_سوپر گپ شد ممبرک🖤!_'
   end
end
     if msg.to.type == "channel" then
    if matches[1] == "mute" then
    if matches[2] == "all" then
                    local hash = 'mute_gp:'..chat
                    if redis:get(hash) then
                    return "سکوت فعال"
                else
                    redis:set(hash, true)
                    return "سکوت فعال بود ممبرک"
                     end
                  end
    elseif matches[1] == "unmute" then
      if matches[2] == 'all' then
                    local hash = 'mute_gp:'..chat
                    if not redis:get(hash) then
                    return "سکوت غیرفعاله ممبرک"
                else
                    redis:del(hash)
                    return "سکوت غیر فعال شد ممبرک"
                   end
					   end
             end
  if matches[1] == "setdes" and matches[2] then
   tdcli.changeChannelAbout(chat, matches[2], dl_cb, nil)
    return "توضیحات تنظیم شد"
  end
if matches[1] == "del" then
   del_msg(msg.to.id, msg.reply_id)
del_msg(msg.to.id, msg.id)
end
if matches[1] == "pin" and msg.reply_id then
tdcli.pinChannelMessage(msg.to.id, msg.reply_id, 1, dl_cb, nil)
return "پیام پین شد"
end
if matches[1] == 'unpin' then
tdcli.unpinChannelMessage(msg.to.id, dl_cb, nil)
return "پیام ان پین شد عیششششش"
         end
      end
   end
end
return { 
patterns = { 
"^[!/#](pin)$", 
"^[!/#](unpin)$",
"^[!/#](inv)$", 
"^[!/#](kick)$",
"^[!/#](inv) (.*)$", 
"^[!/#](kick) (.*)$",
"^[!/#](id)$",
"^[!/#](id) (.*)$", 
"^[!/#](delall)$",
"^[!/#](delall) (.*)$", 
"^[!/#](gpid)$",
"^[!/#](del)$", 
"^[!/#](tosuper)$", 
"^[!/#](setname) (.*)$",
"^[!/#](link)$",
"^[!/#](setlink) (.*)$", 
"^[!/#](setdes) (.*)$",
"^[!/#](import) (.*)$",
"^[!/#](mute) (.*)$",
"^[!/#](unmute) (.*)$",
}, 
run = run 
}

