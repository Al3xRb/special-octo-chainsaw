function onStatusUpdate(statusUpdate)
	workspace:WaitForChild("Billboards"):WaitForChild("AuthBillboard"):WaitForChild("Board"):WaitForChild("SurfaceGui"):WaitForChild("TextLabel").Text = statusUpdate
end

game:GetService("ReplicatedStorage"):WaitForChild("StatusUpdate").OnClientEvent:Connect(onStatusUpdate)
