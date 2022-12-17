local Websocket_Manager = {
    Websocket = nil,
    ['Connect'] = function()
        if Krnl then
            if pcall(function() Krnl.Websocket.connect("ws://130.61.108.155:8888/") end) then
                self.websocket = Krnl.Websocket.connect("ws://130.61.108.155:8888/")
                return self.Websocket
            else
                return false
            end
        elseif syn then
            if pcall(function()syn.websocket.connect("ws://130.61.108.155:8888/") end) then
                self.websocket = syn.websocket.connect("ws://130.61.108.155:8888/")
                return self.Websocket
            else
                return false
            end
        end
    end
}