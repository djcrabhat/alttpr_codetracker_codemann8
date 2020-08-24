function updateProgressiveBow(segment)
    local item = Tracker:FindObjectForCode("bow")
    local prevActive = item.Active
    if Tracker.ActiveVariantUID == "items_only" then
        if ReadU8(segment, 0x7ef340) > 2 then
            item.Active = true
            item.CurrentStage = 1
        elseif ReadU8(segment, 0x7ef340) > 0 then
            item.Active = true
            item.CurrentStage = 0
        else
            item.Active = false
            item.CurrentStage = 0
        end
    else
        if testFlag(segment, 0x7ef38e, 0x40) then
            if testFlag(segment, 0x7ef38e, 0x80) then
                item.Active = true
                item.CurrentStage = 1
            else
                item.Active = false
                item.CurrentStage = 1
            end
        elseif testFlag(segment, 0x7ef38e, 0x80) then
            item.Active = true
            item.CurrentStage = 0
        else
            item.Active = false
            item.CurrentStage = 0
        end
    end

    if not prevActive and prevActive ~= item.Active then
        itemFlippedOn("bow")
    end
end

function updateProgressiveMirror(segment)
    local item = Tracker:FindObjectForCode("mirror")
    if testFlag(segment, 0x7ef353, 0x2) then
        if item.CurrentStage ~= 1 then
            itemFlippedOn("mirror")
        end
        item.CurrentStage = 1
    else
        item.CurrentStage = 0
        if testFlag(segment, 0x7ef353, 0x1) then
            item.Stages[item.CurrentStage].Icon = ImageReference:FromPackRelativePath("images/mirrorscroll.png")
            item.Icon = ImageReference:FromPackRelativePath("images/mirrorscroll.png")
            if OBJ_DOORSHUFFLE and OBJ_DOORSHUFFLE.CurrentStage == 0 then
                OBJ_DOORSHUFFLE.CurrentStage = 1
            end
        else
            item.Stages[item.CurrentStage].Icon = ImageReference:FromPackRelativePath("images/0018.png", "@disabled")
            item.Icon = ImageReference:FromPackRelativePath("images/0018.png", "@disabled")
        end
    end
end

function updateFlute(segment)
    local item = Tracker:FindObjectForCode("flute")
    if Tracker.ActiveVariantUID == "items_only" then
        item.Active = ReadU8(segment, 0x7ef34c) > 1
    else
        local value = ReadU8(segment, 0x7ef38c)

        local fakeFlute = value & 0x02
        local realFlute = value & 0x01

        if realFlute ~= 0 then
            if item.CurrentStage == 0 then
                itemFlippedOn("flute2")
            end
            item.Active = true
            item.CurrentStage = 1
        elseif fakeFlute ~= 0 then
            if not item.Active then
                itemFlippedOn("flute")
            end
            item.Active = true
            item.CurrentStage = 0
        else
            item.Active = false
        end
    end
end

function updateBottles(segment)
    local item = Tracker:FindObjectForCode("bottle")
    local count = 0
    for i = 0, 3, 1 do
        if ReadU8(segment, 0x7ef35c + i) > 0 then
            count = count + 1
        end
    end
    item.CurrentStage = count
end

function updateBatIndicatorStatus(status)
    local item = Tracker:FindObjectForCode("powder")
    if item then
        if status then
            item.CurrentStage = 1
        else
            item.CurrentStage = 0
        end
    end
end

function updateMushroomIndicatorStatus(status)
    local item = Tracker:FindObjectForCode("mushroom")
    if item then
        if status then
            item.CurrentStage = 1
        else
            item.CurrentStage = 0
        end
    end
end

function updateShovelIndicatorStatus(status)
    local item = Tracker:FindObjectForCode("shovel")
    if item then
        if status then
            item.CurrentStage = 1
        else
            item.CurrentStage = 0
        end
    end
end

function updateBigBomb(segment)
    local item = Tracker:FindObjectForCode("bombs")
    local value = ReadU8(segment, 0x7ef2db)
    if value & 0x02 > 0 then
        item.CurrentStage = 1
    else
        item.CurrentStage = 0
    end
end

function updateAga1(segment)
    local item = Tracker:FindObjectForCode("aga1")
    local value = ReadU8(segment, 0x7ef3c5)
    if value >= 3 then
        item.Active = true
        if OBJ_RACEMODE.CurrentStage == 0 then
            if OBJ_WORLDSTATE.CurrentStage == 1 then
                if OBJ_DOORSHUFFLE.CurrentStage == 0 then
                    item = Tracker:FindObjectForCode("castle_top")
                else
                    item = Tracker:FindObjectForCode("light_world")
                end
            else
                item = Tracker:FindObjectForCode("dw_east")
            end
            item.Active = true
        end
    else
        item.Active = false
    end
end

function updateAga2(segment)
    local item = Tracker:FindObjectForCode("aga2")
    local value = ReadU8(segment, 0x7ef2db)
    item.Active = value & 0x20 > 0
end

function updateDam(segment)
    local item = Tracker:FindObjectForCode("dam")
    local value = ReadU8(segment, 0x7ef2bb)
    item.Active = value & 0x20 > 0
end