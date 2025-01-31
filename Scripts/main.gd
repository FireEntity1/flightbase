extends Control

var pointer
var data
var selection
var airportSel

func _ready():
	var icon = Texture2D.new()
	icon.set("texture","res://Sprites/plane-white.png")
	data = Global.getSave()
	_on_update_timeout()
	var purchase = $tabs/purchase
	
	$tabs/overview/container/name.text = data.name
	print(data.name)
	
	$tabs/purchase/scroll/purchaseList.fixed_icon_size = Vector2(512, 218)
	for aircraft in data.aircraft:
		$tabs/purchase/scroll/purchaseList.add_item(aircraft.name,load("res://sprites/" + str(aircraft.code) + ".png"))
	
func _process(delta):
	pass
	
func _input(event):
	if event is InputEventMouse:
		pointer = event.position

func _on_update_timeout():
	var label
	var grid = $tabs/overview/container/grid
	grid.columns = 2
	$tabs/routes/scroll/airportList.clear()
	
	for airport in data.airports:
		if airport.slot == false:
			$tabs/routes/scroll/airportList.add_item(" " + airport.code,load("res://Sprites/lock.png"))
		else:
			$tabs/routes/scroll/airportList.add_item("   " + airport.code)
	
	for child in $tabs/overview/container/grid.get_children():
		child.queue_free()
	
	for item in data.aircraft:
		var name_label = Label.new()
		var amount_label = Label.new()
		
		name_label.add_theme_font_size_override("font_size", 42)
		amount_label.add_theme_font_size_override("font_size", 42)
		
		grid.add_child(name_label)
		grid.add_child(amount_label)
		
		name_label.text = "  " + item.name + "  "
		amount_label.text = "  " + str(item.amount) + "  "
		
		if data.money >= 1000000:
			$tabs/purchase/money.text = "$" + str(data.money/1000000) + "M"
		elif data.money >= 10000:
			$tabs/purchase/money.text = "$" + str(data.money/1000) + "K"
		
		if data.money >= 1000000:
			$tabs/routes/money.text = "$" + str(data.money/1000000) + "M"
		elif data.money >= 10000:
			$tabs/routes/money.text = "$" + str(data.money/1000) + "K"
			
		if data.money >= 1000000:
			$tabs/overview/money.text = "$" + str(data.money/1000000) + "M"
		elif data.money >= 10000:
			$tabs/overview/money.text = "$" + str(data.money/1000) + "K"
		
		Global.setSave(data)


func _on_purchase_list_item_selected(index):
	selection = index
	var plane = data.aircraft[index]
	$tabs/purchase/scroll/purchaseList.deselect_all()
	var image_path = "res://sprites/" + str(plane.code) + ".png"
	var texture = load(image_path)
	$tabs/purchase/buyMenu/vbox/photo.texture = texture
	$tabs/purchase/buyMenu/vbox/name.text = plane.name
	if plane.price >= 1000000:
			$tabs/purchase/buyMenu/vbox/cost.text = "$" + str(plane.price/1000000) + "M"
	elif plane.price >= 10000:
			$tabs/purchase/buyMenu/vbox/cost.text = "$" + str(plane.price/1000) + "K"
	$tabs/purchase/buyMenu.popup_centered()
	$tabs/purchase/buyMenu/vbox/baseRate.text = "$" + str(plane.baseRate) + "/sec"

func buy(index):
	$tabs/purchase/notice.size = Vector2(650,350)
	$tabs/purchase/buyMenu.hide()
	if Global.getMoney() > data.aircraft[index].price:
		$tabs/purchase/notice/text.text =  "\n" + data.aircraft[index].name + " bought!"
		data.money -= data.aircraft[index].price
		data.aircraft[index].amount += 1
		$tabs/purchase/notice.popup_centered()
	else:
		$tabs/purchase/notice/text.text = "Not enough"
		$tabs/purchase/notice.popup_centered()


func buySlot(index):
	$tabs/routes/buySlot.hide()
	if Global.getMoney() > data.airports[index].cost:
		$tabs/routes/notice/text.text =  "\n" + data.airports[index].name + " bought!"
		data.money -= data.airports[index].cost
		data.airports[index].slot = true
		$tabs/routes/notice.popup_centered()
	else:
		$tabs/routes/notice/text.text = "Not enough"
		$tabs/routes/notice.popup_centered()

func _on_buy_button_down():
	print("buy button")
	buy(selection)

func _on_airport_list_item_selected(index):
	var airport = data.airports[index]
	$tabs/routes/buySlot/vbox/name.text = "\n" + airport.name
	if airport.cost >= 1000000:
			$tabs/routes/buySlot/vbox/cost.text = "$" + str(airport.cost/1000000) + "M"
	elif airport.cost >= 10000:
		$tabs/routes/buySlot/vbox/cost.text = "$" + str(airport.cost/1000) + "K"
	$tabs/routes/buySlot.popup_centered()
	$tabs/routes/buySlot/vbox/mult.text = str(airport.mult) + "x multiplier"
	$tabs/routes/buySlot/vbox/code.text = airport.code
	airportSel = index

func _on_name_text_changed(new_text):
	data.name = $tabs/overview/container/name.text
	Global.setSave(data)

func _on_buy_slot_button_down():
	buySlot(airportSel)

func fly(aircraft,airport):
	await get_tree().create_timer(1.8**data.airports[airport].distance).timeout
	data.money += ((data.aircrafts[aircraft].baseRate * 500)*airport.mult)*aircraft.amount
	fly(aircraft,airport)

func _on_airports_button_down():
	var range = data.aircraft[selection].maxRouteStyle
	$tabs/purchase/notice/text.text = ""
	$tabs/purchase/buyMenu.popup_centered()
	for airport in data.airports:
		if airport.distance <= range:
			$tabs/purchase/notice/text.text += airport.code + ", "
	$tabs/purchase/notice.popup(Rect2i(pointer,Vector2i(200,150)))

func _on_buy_menu_close_requested():
	$tabs/purchase/notice.hide()

func _on_buy_menu_go_back_requested():
	$tabs/purchase/notice.hide()

func getBestAirport(aircraft):
	pass
