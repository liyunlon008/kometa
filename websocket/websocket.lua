local Websocket_Manager = {
    ['Connect'] = function()
        if Krnl then
            if pcall(function() Krnl.Websocket.connect("ws://130.61.108.155:8888/") end) then
                return Krnl.Websocket.connect("ws://130.61.108.155:8888/")
            else
                return nil
            end
        elseif syn then
            if pcall(function()syn.websocket.connect("ws://130.61.108.155:8888/") end) then
                return syn.websocket.connect("ws://130.61.108.155:8888/")
            else
                return nil
            end
        end
    end,
    ['SaveConfig'] = function(Websocket, Config)
        if Websocket and Config then
            if Krnl then
                Websocket:Send(game:GetService('HttpService'):JSONEncode({
                    action = 'ConfigSave',
                    hwid = game:GetService("RbxAnalyticsService"):GetClientId(),
                    cfg = Config
                }))

                Websocket.OnMessage:Connect(function(Message)
                    if game:GetService('HttpService'):JSONDecode(Message) then
                        local Data = game:GetService('HttpService'):JSONDecode(Message)
                        if Data.statusCode == 601 then
                            return Data.id
                        else
                            return nil
                        end
                    end
                    Websocket:Close()
                end)
            elseif syn then
                Websocket:Send(game:GetService('HttpService'):JSONEncode({
                    action = 'ConfigSave',
                    hwid = game:GetService("RbxAnalyticsService"):GetClientId(),
                    cfg = Config
                }))

                Websocket.OnMessage:Connect(function(Message)
                    if game:GetService('HttpService'):JSONDecode(Message) then
                        local Data = game:GetService('HttpService'):JSONDecode(Message)
                        if Data.statusCode == 601 then
                            return Data.id
                        else
                            return nil
                        end
                    end
                    Websocket:Close()
                end)
            end
        end
    end
}

return Websocket_Manager