local common = {}

common.diseases = {
    {
        id = "disease 1"
    }
}

common.traps = {
    -- On a timer, checks proximity to player and triggers trap.
    timer = {
        ["my timer trap 1"] = {
            animate = true,
            proximity = 256
        }
    },
    -- Constantly checks proximity to player and triggers trap.
    proximity = {
        ["my timer trap 1"] = {
            animate = true,
            proximity = 256,
            diseaseId = "example disease override Id"
        }
    },
    -- Triggers trap on collision with player.
    collision = {
        ["my timer trap 1"] = {
            animate = true
        }
    }
}

return common