local Roact = require(script.Parent.Parent.Roact)
local t = require(script.Parent.Parent.PropTypes)

local ListBox = Roact.Component:extend("ListBox")

ListBox.defaultProps = {
	LayoutOrder = 0,

	boxPadding = UDim2.new(0, 10, 0, 10),
	listSpacing = UDim.new(0, 5),
	backgroundColor = Color3.fromRGB(255, 255, 255),
	borderColor = Color3.fromRGB(238, 238, 238),
	borderSize = 0,
	fillDirection = Enum.FillDirection.Vertical,
	fillEmptySpace = false,
}

ListBox.validateProps = t.object({
	LayoutOrder = t.number,

	boxPadding = t.UDim2,
	listSpacing = t.UDim,
	backgroundColor = t.Color3,
	borderColor = t.Color3,
	borderSize = t.number,
	fillDirection = t.enumOf(Enum.FillDirection),
	-- Whether the cross direction should be auto-sized or not.
	fillEmptySpace = t.boolean,
})

function ListBox:render()
	local props = self.props

	local contentSize, contentSizeSetter = Roact.createBinding(Vector2.new())

	local children = {
		["$Layout"] = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = props.listSpacing,
			FillDirection = props.fillDirection,

			[Roact.Ref] = function(rbx)
				if rbx then
					contentSizeSetter(rbx.AbsoluteContentSize)
				end
			end,

			[Roact.Change.AbsoluteContentSize] = function(rbx)
				contentSizeSetter(rbx.AbsoluteContentSize)
			end,
		}),
		["$Padding"] = Roact.createElement("UIPadding", {
			PaddingLeft = props.boxPadding.X,
			PaddingRight = props.boxPadding.X,
			PaddingTop = props.boxPadding.Y,
			PaddingBottom = props.boxPadding.Y,
		}),
	}
	for key, value in pairs(props[Roact.Children]) do
		children[key] = value
	end

	return Roact.createElement("Frame", {
		LayoutOrder = props.LayoutOrder,
		Size = contentSize:map(function(size)
			local p = props.boxPadding
			local x = UDim.new(p.X.Scale * 2, p.X.Offset * 2 + size.X)
			local y = UDim.new(p.Y.Scale * 2, p.Y.Offset * 2 + size.Y)
			local f = UDim.new(1, 0)
			if props.fillDirection == Enum.FillDirection.Vertical and props.fillEmptySpace then
				return UDim2.new(f, y)
			elseif props.fillDirection == Enum.FillDirection.Horizontal and props.fillEmptySpace then
				return UDim2.new(x, f)
			else
				return UDim2.new(x, y)
			end
		end),

		BackgroundColor3 = props.backgroundColor,
		BorderColor3 = props.borderColor,
		BorderSizePixel = props.borderSize,
	}, children)
end

return ListBox
