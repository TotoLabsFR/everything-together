export type MusicInteractionStatus = "PLAYING" | "PAUSED" | "STOPPED"

export type MusicInteraction = {
    Status: MusicInteractionStatus,
    Sound: Sound,
    play: (self: any) -> (),
    pause: (self: any) -> (),
    stop: (self: any) -> (),
    TimeUpdated: BindableEvent,
}

local RunService = game:GetService("RunService")

local MusicInteraction = {}
MusicInteraction.__index = MusicInteraction

function MusicInteraction.new(soundId: string, parent: Instance?)
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Parent = parent or workspace

    local self = {} :: any -- shenanigans else vs code yells at me
    self.Status = "STOPPED" :: MusicInteractionStatus
    self.Sound = sound
    self.TimeUpdated = Instance.new("BindableEvent") :: BindableEvent

    -- update loop
    RunService.Heartbeat:Connect(function(deltaTime)
        if self.Status == "PLAYING" then
            local elapsed = self.Sound.TimePosition
            local remaining = self.Sound.TimeLength - elapsed
            self.TimeUpdated:Fire(elapsed, remaining)
        end
    end)

    return setmetatable(self, MusicInteraction) :: MusicInteraction
end

function MusicInteraction:play()
    self.Sound:Play()
    self.Status = "PLAYING"
end

function MusicInteraction:pause()
    self.Sound:Pause()
    self.Status = "PAUSED"
end

function MusicInteraction:stop()
    self.Sound:Stop()
    self.Status = "STOPPED"
end

return MusicInteraction