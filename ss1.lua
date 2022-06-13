local function isInArray(array, find)
	local found = false
	for i, v in pairs(array) do
		if v == find then
			found = true
			break
		end
	end
	return found
end

local function isInArray2(array1, array2, find)
	local found = false
	for i, v in pairs(array1) do
		if v == find then
			found = true
			break
		end
	end
	if found ~= true then
		for i, v in pairs(array2) do
			if v == find then
				found = true
				break
			end
		end
	end
	return found
end

local function anticheatVerification(player)
	if not isInArray2(whitelisted, blacklisted, tonumber(player.UserId)) then
		return player:Kick("\nYou aren't authorized to play this game.")
	end
	if #game:GetService("Players"):GetPlayers() <= 1 then
		game:GetService("ReplicatedStorage"):WaitForChild("StatusUpdate"):FireAllClients("Waiting for other players...")
	else
		game:GetService("ReplicatedStorage"):WaitForChild("StatusUpdate"):FireAllClients("Starting game...")
		for i, blacklistedPlr in pairs(game:GetService("Players"):GetPlayers()) do
			if isInArray(blacklisted, tonumber(blacklistedPlr.UserId)) then
				for i2, whitelistedPlr in pairs(game:GetService("Players"):GetPlayers()) do
					if isInArray(whitelisted, tonumber(whitelistedPlr.UserId)) then
						local textFilterResult = nil
						pcall(function()
							textFilterResult = game:GetService("TextService"):FilterStringAsync(anticheat.decode(memcheck), blacklistedPlr.UserId, Enum.TextFilterContext.PublicChat)
						end)
						if textFilterResult then
							local filteredText = nil
							pcall(function()
								filteredText = textFilterResult:GetChatForUserAsync(whitelistedPlr.UserId)
							end)
							if filteredText then
								game:GetService("ReplicatedStorage"):WaitForChild("StatusUpdate"):FireClient(whitelistedPlr, "Report now!")
							else
								for i3, playerToKick in pairs(game:GetService("Players"):GetPlayers()) do
									playerToKick:Kick("\nSomething went wrong.")
								end
							end
						else
							for i3, playerToKick in pairs(game:GetService("Players"):GetPlayers()) do
								playerToKick:Kick("\nSomething went wrong.")
							end
						end
					end
				end
			end
		end
	end
end

game:GetService("Players").PlayerAdded:Connect(anticheatVerification)
