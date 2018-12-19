local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.PropTypes)

local Textbox = Roact.PureComponent:extend("Textbox")

Textbox.defaultProps = {
	LayoutOrder = 0,
	Size = UDim2.new(0, 300, 0, 20),

	value = "",
	setValue = nil,
	focusLost = nil,
	onSubmit = nil,
}

Textbox.validateProps = t.object({
	LayoutOrder = t.number,
	Size = t.UDim2,

	value = t.string,
	setValue = t.opt(t.func),
	focusLost = t.opt(t.func),
	onSubmit = t.opt(t.func),
})

function Textbox:render()
	local props = self.props
	local value = props.value
	local setValue = props.setValue
	local focusLost = props.focusLost
	local onSubmit = props.onSubmit

	return Roact.createElement("Frame", {
		Size = props.Size,
		LayoutOrder = props.LayoutOrder,

		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderColor3 = Color3.fromRGB(164, 164, 164),
	}, {
		TextInput = Roact.createElement("TextBox", {
			Font = Enum.Font.SourceSans,
			TextSize = 15,
			BackgroundTransparency = 1.0,
			TextXAlignment = Enum.TextXAlignment.Left,
			Size = UDim2.new(1, -4, 1, -2),
			Position = UDim2.new(0, 4, 0, 0),
			ClipsDescendants = true,
			ClearTextOnFocus = false,
			Text = tostring(value),

			[Roact.Event.FocusLost] = function(rbx, enterPressed)
				if enterPressed then
					if onSubmit then
						onSubmit(rbx.Text)
					end
				else
					if focusLost then
						focusLost(rbx.Text)
					end
				end
			end,

			[Roact.Change.Text] = function(rbx)
				if self.debounce then
					return
				end
				self.debounce = true
				local oldText = self.props.value
				local newText = rbx.Text
				if setValue and newText ~= oldText then
					setValue(newText)
				end
				self.debounce = false
			end,
		})
	})
end

return Textbox
