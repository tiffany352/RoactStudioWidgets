local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.PropTypes)

local sliderAsset = "rbxasset://textures/TerrainTools/sliderbar_button.png"
local preAsset = "rbxasset://textures/TerrainTools/sliderbar_blue.png"
local postAsset = "rbxasset://textures/TerrainTools/sliderbar_grey.png"

local Slider = Roact.PureComponent:extend("Slider")

Slider.defaultProps = {
	LayoutOrder = 0,
	Size = UDim2.new(0, 100, 0, 20),

	value = 0.5,
	ticks = nil,
	setValue = nil,
}

Slider.validateProps = t.object({
	LayoutOrder = t.number,
	Size = t.UDim2,

	value = t.number,
	ticks = t.opt(t.number),
	setValue = t.opt(t.func),
})

function Slider:render()
	local props = self.props
	return Roact.createElement("ImageButton", {
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 1.0,

		[Roact.Event.InputBegan] = function(rbx, input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				self.startPos = input.Position
				self:setState({
					pressed = true,
				})
			end
		end,
		[Roact.Event.InputChanged] = function(rbx, input)
			if self.startPos and input.UserInputType == Enum.UserInputType.MouseMovement then
				local mousePos = Vector2.new(
					input.Position.X,
					input.Position.Y
				)
				local value = (mousePos - rbx.AbsolutePosition) / rbx.AbsoluteSize
				if props.setValue then
					props.setValue(value.X)
				end
			end
		end,
		[Roact.Event.InputEnded] = function(rbx, input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				self.startPos = nil
				self:setState({
					pressed = false,
				})
			end
		end,
	}, {
		Bar = Roact.createElement("ImageLabel", {
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Size = UDim2.new(1, -16, 0, 11),
			BackgroundTransparency = 1.0,
			Image = sliderAsset,
			ScaleType = Enum.ScaleType.Slice,
			SliceCenter = Rect.new(5, 5, 6, 6),
		}, {
			Fill = Roact.createElement("ImageLabel", {
				Position = UDim2.new(0, 2, 0, 2),
				Size = UDim2.new(props.value, 0, 0, 7),
				BackgroundTransparency = 1.0,
				Image = self.state.pressed and preAsset or postAsset,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = Rect.new(1, 1, 34, 2),
			}),
		})
	})
end

return Slider
