extends Control

var pointer
var data
var selection
var airportSel
var fade = false

var crt = true

var sprites = [preload("res://Sprites/q400.png"),
	preload("res://Sprites/crj9.png"),
	preload("res://Sprites/a21x.png"),
	preload("res://Sprites/b787.png"),
	preload("res://Sprites/a350.png"),
	preload("res://Sprites/b747.png")
]


func _ready():
	var icon = Texture2D.new()
	icon.set("texture","res://Sprites/plane-white.png")
	data = Global.getSave()
	_on_update_timeout()
	var purchase = $tabs/purchase
	
	$tabs/overview/container/name.text = data.name
	
	$tabs/purchase/scroll/purchaseList.fixed_icon_size = Vector2(512, 218)
	var n = 0
	for aircraft in data.aircraft:
		$tabs/purchase/scroll/purchaseList.add_item(aircraft.name,sprites[n])
		n += 1 
		
	for aircraft in data.aircraft:
		fly(aircraft)

func _process(delta):
	if crt:
		$crt.show()
	else:
		$crt.hide()
		
	if fade:
		$fade.color.a += delta*1.5
	elif not fade and $fade.color.a > 0:
		$fade.color.a -= delta*1.5

func _input(event):
	if event is InputEventMouse:
		pointer = event.position

func _on_update_timeout():
	var label
	var grid = $tabs/overview/container/hboxGrid/grid
	grid.columns = 2
	$tabs/routes/scroll/airportList.clear()
	
	for airport in data.airports:
		if airport.slot == false:
			$tabs/routes/scroll/airportList.add_item(" " + airport.code,load("res://Sprites/lock.png"))
		else:
			$tabs/routes/scroll/airportList.add_item("   " + airport.code)
	
	for child in $tabs/overview/container/hboxGrid/grid2.get_children():
		child.queue_free()
	
	for airport in data.airports:
		if airport.slot:
			label = Label.new()
			label.add_theme_font_size_override("font_size", 42)
			label.text = airport.name
			$tabs/overview/container/hboxGrid/grid2.add_child(label)
	
	for child in $tabs/overview/container/hboxGrid/grid.get_children():
		child.queue_free()
	
	for item in data.aircraft:
		var name_label = Label.new()
		var amount_label = Label.new()
		
		name_label.add_theme_font_size_override("font_size", 42)
		amount_label.add_theme_font_size_override("font_size", 42)
		amount_label.add_theme_color_override("font_color", Color(1,1,0.5,1))
		
		grid.add_child(name_label)
		grid.add_child(amount_label)
		
		name_label.text = "  " + item.name + "  "
		amount_label.text = "  " + str(item.amount) + "  "
	if data.money >= 1000000000:
		$tabs/purchase/moneyContainer/money.text = "    $" + str(data.money/1000000000) + "B"
		$tabs/routes/moneyContainer/money.text = "    $" + str(data.money/1000000000) + "B"
		$tabs/overview/moneyContainer/money.text = "    $" + str(data.money/1000000000) + "B"
	elif data.money >= 1000000:
		$tabs/purchase/moneyContainer/money.text = "    $" + str(data.money/1000000) + "M"
		$tabs/routes/moneyContainer/money.text = "    $" + str(data.money/1000000) + "M"
		$tabs/overview/moneyContainer/money.text = "    $" + str(data.money/1000000) + "M"
	elif data.money >= 10000:
		$tabs/purchase/moneyContainer/money.text = "    $" + str(data.money/1000) + "K"
		$tabs/routes/moneyContainer/money.text = "    $" + str(data.money/1000) + "K"
		$tabs/overview/moneyContainer/money.text = "    $" + str(data.money/1000) + "K"
	
	if calcRate() >= 1000000:
		$tabs/overview/moneyContainer/rate.text = "$" + str(int(calcRate()/1000000)) + "M /sec    ."
		$tabs/purchase/moneyContainer/rate.text = "$" + str(int(calcRate()/1000000)) + "M /sec    ."
		$tabs/routes/moneyContainer/rate.text = "$" + str(int(calcRate()/1000000)) + "M /sec    ."
	elif calcRate() >= 1000:
		$tabs/overview/moneyContainer/rate.text = "$" + str(int(calcRate()/1000)) + "K /sec    ."
		$tabs/purchase/moneyContainer/rate.text = "$" + str(int(calcRate()/1000)) + "K /sec    ."
		$tabs/routes/moneyContainer/rate.text = "$" + str(int(calcRate()/1000)) + "K /sec    ."
	else:
		$tabs/overview/moneyContainer/rate.text = "$" + str(int(calcRate())) + "/sec    ."
		$tabs/purchase/moneyContainer/rate.text = "$" + str(int(calcRate())) + "/sec    ."
		$tabs/routes/moneyContainer/rate.text = "$" + str(int(calcRate())) + "/sec    ."
		Global.setSave(data)

func _on_purchase_list_item_selected(index):
	$click.play()
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
		$select.play()
	else:
		$tabs/purchase/notice/text.text = "\n \nNot enough"
		$tabs/purchase/notice.popup_centered()
		$click.play()

func buySlot(index):
	$tabs/routes/buySlot.hide()
	if Global.getMoney() > data.airports[index].cost:
		$tabs/routes/notice/text.text =  "\n" + data.airports[index].name + " bought!"
		data.money -= data.airports[index].cost
		data.airports[index].slot = true
		$tabs/routes/notice.popup_centered()
		$select.play()
	else:
		$tabs/routes/notice/text.text = "\n \nNot enough"
		$tabs/routes/notice.popup_centered()
		$click.play()

func _on_buy_button_down():
	$click.play()
	print("buy button")
	buy(selection)

func _on_airport_list_item_selected(index):
	$click.play()
	var airport = data.airports[index]
	$tabs/routes/buySlot/vbox/name.text = "\n" + airport.name
	$tabs/routes/buySlot/vbox/mult.text = str(airport.mult) + "x multiplier"
	$tabs/routes/buySlot/vbox/code.text = airport.code
	if not airport.slot:
		$tabs/routes/buySlot/vbox/cost.text = "$" + str(airport.cost/1000000) + "M"
		$tabs/routes/buySlot/vbox/buySlot.disabled = false
	else:
		$tabs/routes/buySlot/vbox/cost.text = "purchased"
		$tabs/routes/buySlot/vbox/buySlot.disabled = true
	$tabs/routes/buySlot.popup_centered()
	airportSel = index

func _on_name_text_changed(new_text):
	data.name = $tabs/overview/container/name.text
	Global.setSave(data)

func _on_buy_slot_button_down():
	$click.play()
	buySlot(airportSel)


func _on_airports_button_down():
	$click.play()
	var range = data.aircraft[selection].range
	$tabs/purchase/notice/text.text = ""
	$tabs/purchase/buyMenu.popup_centered()
	for airport in data.airports:
		if airport.distance <= range:
			$tabs/purchase/notice/text.text += airport.code + ", "
	$tabs/purchase/notice.popup(Rect2i(pointer,Vector2i(200,150)))

func _on_buy_menu_close_requested():
	$click.play()
	$tabs/purchase/notice.hide()

func _on_buy_menu_go_back_requested():
	$click.play()
	$tabs/purchase/notice.hide()

func getBestAirport(aircraft):
	pass

func fly(aircraft):
	var airport = data.airports[1]
	for airports in data.airports:
		if airports.distance <= aircraft.range and airports.slot:
			if airports.mult > airport.mult:
				airport = airports
	await get_tree().create_timer(1.8**airport.distance + clamp(aircraft.baseRate/100,2,6)).timeout
	data.money += ((aircraft.baseRate * 500)*airport.mult)*aircraft.amount
	if ((aircraft.baseRate * 500)*airport.mult)*aircraft.amount > 0:
		print(str(((aircraft.baseRate * 500)*airport.mult)*aircraft.amount) + ", " + airport.code + ", " + aircraft.name)
	fly(aircraft)

func calcRate():
	var total = 0
	for aircraft in data.aircraft:
		var airport = data.airports[1]
		for airports in data.airports:
			if airports.distance <= aircraft.range and airports.slot:
				if airports.mult > airport.mult:
					airport = airports
		total += (((aircraft.baseRate * 500)*airport.mult)*aircraft.amount)/(1.8**airport.distance + clamp(aircraft.baseRate/100,2,6))
	return total

func _on_back_button_up():
	$click.play()
	_on_update_timeout()
	fade = true
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://Scenes/title.tscn")

func _on_tabs_tab_clicked(tab):
	$click.play()

func _on_crt_toggle_button_up():
	if crt:
		crt = false
	else:
		crt = true
