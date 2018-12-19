local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.PropTypes)

local enabledImage = "rbxasset://textures/TerrainTools/icon_tick.png"
--local disabledImage = "rbxasset://textures/TerrainTools/icon_tick_grey.png"
local frameImage = "rbxasset://textures/TerrainTools/checkbox_square.png"

local Checkbox = Roact.Component:extend("Checkbox")

Checkbox.defaultProps = {
	Size = UDim2.new(0, 20, 0, 20),
}

Checkbox.validateProps = t.object({
	LayoutOrder = t.opt(t.number),
	Size = t.opt(t.UDim2),

	value = t.opt(t.boolean),
	setValue = t.opt(t.func),
})

function Checkbox:render()
	local props = self.props
	-- nil == indeterminate
	local value = props.value
	local setValue = props.setValue

	return Roact.createElement("ImageButton", {
		LayoutOrder = props.LayoutOrder,
		Size = props.Size,
		BackgroundTransparency = 1.0,

		[Roact.Event.MouseButton1Click] = function(rbx)
			-- nil -> true, false -> true, true -> false
			if setValue then
				setValue(value ~= true)
			end
		end,
	}, {
		Frame = Roact.createElement("ImageLabel", {
			Image = frameImage,
			Size = UDim2.new(0, 12, 0, 12),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BorderSizePixel = 0,
		}, {
			CheckImage = Roact.createElement("ImageLabel", {
				Size = UDim2.new(0, 8, 0, 8),
				Image = value and enabledImage or "",
				BackgroundTransparency = value == nil and 0.0 or 1.0,
				BackgroundColor3 = Color3.fromRGB(192, 192, 255),
				BorderSizePixel = 0,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
			})
		})
	})
end

return Checkbox
