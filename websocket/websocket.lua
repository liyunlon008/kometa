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
    end
}

return Websocket_Manager