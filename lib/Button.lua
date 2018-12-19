local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.PropTypes)

local assetDefault = "rbxasset://textures/TerrainTools/button_default.png"
local assetHovered = "rbxasset://textures/TerrainTools/button_hover.png"
local assetPressed = "rbxasset://textures/TerrainTools/button_pressed.png"

local Button = Roact.PureComponent:extend("Button")

Button.defaultProps = {
	Size = UDim2.new(0, 150, 0, 24),
	LayoutOrder = 0,

	labelText = "props.labelText",
	disabled = false,
	pressed = false,
	onClick = nil,
}

Button.validateProps = t.object({
	Size = t.UDim2,
	LayoutOrder = t.number,

	labelText = t.string,
	disabled = t.boolean,
	pressed = t.boolean,
	onClick = t.opt(t.func),
})

function Button:render()
	local props = self.props

	local pressed = props.pressed or self.state.pressed

	return Roact.createElement("ImageButton", {
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,

		Image =
			props.disabled and assetDefault or
			pressed and assetPressed or
			self.state.hovered and assetHovered or
			assetDefault,
		BackgroundTransparency = 1.0,
		ScaleType = Enum.ScaleType.Slice,
		SliceCenter = Rect.new(7, 7, 156, 36),
		AutoButtonColor = false,

		[Roact.Event.InputBegan] = function(rbx, input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				self:setState({
					hovered = true
				})
			end
		end,

		[Roact.Event.InputEnded] = function(rbx, input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				self:setState({
					hovered = false
				})
			end
		end,

		[Roact.Event.MouseButton1Down] = function(rbx)
			self:setState({
				pressed = true
			})
		end,

		[Roact.Event.MouseButton1Up] = function(rbx)
			self:setState({
				pressed = false,
			})
		end,

		[Roact.Event.MouseButton1Click] = function(rbx)
			if props.onClick then
				props.onClick()
			end
		end,
	}, {
		ButtonLabel = Roact.createElement("TextLabel", {
			Text = props.labelText,
			TextColor3 =
				props.disabled and Color3.fromRGB(102, 102, 102) or
				pressed and Color3.fromRGB(255, 255, 255) or
				Color3.fromRGB(0, 0, 0),
			BackgroundTransparency = 1.0,
			Size = UDim2.new(1, 0, 1, 0),
			Font = Enum.Font.SourceSans,
			TextSize = 15,
		})
	})
end

return Button
