local TextService = game:GetService("TextService")

local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.PropTypes)

local Label = Roact.Component:extend("Label")

Label.defaultProps = {
	LayoutOrder = 0,
	labelText = "props.labelText",
	textSize = 15,
	font = Enum.Font.SourceSans,
	maxSize = Vector2.new(10000, 10000),
	padding = 0,
	textColor = Color3.fromRGB(0, 0, 0),
}

Label.validateProps = t.object({
	LayoutOrder = t.number,

	labelText = t.string,
	textSize = t.number,
	font = t.enumOf(Enum.Font),
	maxSize = t.Vector2,
	padding = t.number,
	textColor = t.Color3,
})

function Label:render()
	local props = self.props
	local padding = props.padding
	if typeof(padding) == 'number' then
		padding = Vector2.new(1, 1) * padding
	end

	local bounds = TextService:GetTextSize(props.labelText, props.textSize, props.font, props.maxSize)

	return Roact.createElement("TextLabel", {
		LayoutOrder = props.LayoutOrder,
		Size = UDim2.new(0, bounds.X + padding.X * 2, 0, bounds.Y + padding.Y * 2),

		Text = props.labelText,
		TextSize = props.textSize,
		Font = props.font,

		TextColor3 = props.textColor,
		BackgroundTransparency = 1.0,
	})
end

return Label
