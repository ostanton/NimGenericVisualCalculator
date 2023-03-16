import nigui
import strutils

app.init()

# Array that holds all created number buttons
var numButtons = newSeq[Button]()

### CUSTOM BUTTON ###
# Don't know how to do more detailed styling, it seems limited (no outline thickness, radius, hover events, etc.)
# Comment out from here to LAYOUT to go back to windows default. Only problem with this is widthMode and heightMode not being set.
# I don't know how to just override the default button. I tried result = new Button instead but it didn't draw, presumably because
# handleDrawEvent isn't called like it is for calculatorButton. Anyway, there's no docs for NiGui so I can't find out stuff like this
# when it isn't in the examples.

type calculatorButton* = ref object of Button

method handleDrawEvent(control: calculatorButton, event: DrawEvent) =
    let canvas = event.control.canvas
    canvas.areaColor = rgb(200, 200, 200)
    canvas.textColor = rgb(0, 0, 0)
    canvas.lineColor = rgb(180, 180, 180)
    canvas.lineWidth = 2
    canvas.drawRectArea(0, 0, control.width, control.height)
    canvas.drawTextCentered(control.text)
    canvas.drawRectOutline(4, 4, (control.width - 8), (control.height - 8))

# Overrides newButton so already created buttons don't need to be updated manually
proc newButton*(text: string): Button =
    result = new calculatorButton
    result.init()
    result.text = text
    result.fontSize = 24
    result.fontBold = true
    result.widthMode = WidthMode_Expand
    result.heightMode = HeightMode_Expand

### LAYOUT ###

# This is long and dumb, as I don't know if there's a grid layout etc. to create the buttons with a for loop and stuff.
# It's good enough, and it's 1 am

var mainWindow = newWindow("Nim Calculator")
mainWindow.height = 400.scaleToDpi
mainWindow.width = 300.scaleToDpi

var rootContainer = newLayoutContainer(Layout_Vertical)
rootContainer.widthMode = WidthMode_Expand
rootContainer.heightMode = HeightMode_Expand
rootContainer.padding = 0
rootContainer.spacing = 4
mainWindow.add(rootContainer)

var outputLabel = newLabel("0")
outputLabel.fontSize = 48
outputLabel.widthMode = WidthMode_Expand
outputLabel.xTextAlign = XTextAlign_Right
rootContainer.add(outputLabel)

var buttonVerticalContainer = newLayoutContainer(Layout_Vertical)
buttonVerticalContainer.widthMode = WidthMode_Expand
buttonVerticalContainer.heightMode = HeightMode_Expand
buttonVerticalContainer.padding = 0
buttonVerticalContainer.spacing = 2
rootContainer.add(buttonVerticalContainer)
var topBarContainer = newLayoutContainer(Layout_Horizontal)
topBarContainer.widthMode = WidthMode_Expand
topBarContainer.heightMode = HeightMode_Expand
topBarContainer.padding = 0
topBarContainer.spacing = 2
buttonVerticalContainer.add(topBarContainer)

var sevenButton = newButton("7")
numButtons.add(sevenButton)
topBarContainer.add(sevenButton)
var eightButton = newButton("8")
numButtons.add(eightButton)
topBarContainer.add(eightButton)
var nineButton = newButton("9")
numButtons.add(nineButton)
topBarContainer.add(nineButton)
var addButton = newButton("+")
topBarContainer.add(addButton)

var midBarContainer = newLayoutContainer(Layout_Horizontal)
midBarContainer.widthMode = WidthMode_Expand
midBarContainer.heightMode = HeightMode_Expand
midBarContainer.padding = 0
midBarContainer.spacing = 2
buttonVerticalContainer.add(midBarContainer)

var fourButton = newButton("4")
numButtons.add(fourButton)
midBarContainer.add(fourButton)
var fiveButton = newButton("5")
numButtons.add(fiveButton)
midBarContainer.add(fiveButton)
var sixButton = newButton("6")
numButtons.add(sixButton)
midBarContainer.add(sixButton)
var subtractButton = newButton("-")
midBarContainer.add(subtractButton)

var bottomBarContainer = newLayoutContainer(Layout_Horizontal)
bottomBarContainer.widthMode = WidthMode_Expand
bottomBarContainer.heightMode = HeightMode_Expand
bottomBarContainer.padding = 0
bottomBarContainer.spacing = 2
buttonVerticalContainer.add(bottomBarContainer)

var oneButton = newButton("1")
numButtons.add(oneButton)
bottomBarContainer.add(oneButton)
var twoButton = newButton("2")
numButtons.add(twoButton)
bottomBarContainer.add(twoButton)
var threeButton = newButton("3")
numButtons.add(threeButton)
bottomBarContainer.add(threeButton)
var multiplyButton = newButton("*")
bottomBarContainer.add(multiplyButton)

var operationBarContainer = newLayoutContainer(Layout_Horizontal)
operationBarContainer.widthMode = WidthMode_Expand
operationBarContainer.heightMode = HeightMode_Expand
operationBarContainer.padding = 0
operationBarContainer.spacing = 2
buttonVerticalContainer.add(operationBarContainer)

var zeroButton = newButton("0")
numButtons.add(zeroButton)
operationBarContainer.add(zeroButton)
var decimalButton = newButton(".")
operationBarContainer.add(decimalButton)
var clearButton = newButton("C")
operationBarContainer.add(clearButton)
var divideButton = newButton("/")
operationBarContainer.add(divideButton)

var equalsButton = newButton("=")
buttonVerticalContainer.add(equalsButton)

### FUNCTIONALITY ###

# Variable declaration

var firstNum: float
var secondNum: float

# Enum for selected operation
type operations = enum
    none, add, subtract, multiply, divide
var selectedOperation: operations = none

# True if operation has been selected
var operatorSelector: bool = false

# Set outputLabel = string of num input if it has no value (0), and concat num on the end if it has a value (!0)
proc numberPressed(num: int) =
    if (outputLabel.text != "0"):
        outputLabel.text = outputLabel.text & $num
    else:
        outputLabel.text = $num

# Set firstNum to float value of outputLabel's text, and set operation-related variables
proc operatorClicked(operation: operations) =
    firstNum = outputLabel.text.parseFloat()
    outputLabel.text = "0"
    operatorSelector = true
    selectedOperation = operation

proc equalsClicked() =
    if (operatorSelector):
        secondNum = outputLabel.text.parseFloat()
        case selectedOperation:
            of add:
                outputLabel.text = $(firstNum + secondNum)
            of subtract:
                outputLabel.text = $(firstNum - secondNum)
            of multiply:
                outputLabel.text = $(firstNum * secondNum)
            of divide:
                outputLabel.text = $(firstNum / secondNum)
            of none:
                outputLabel.text = "Error"
        operatorSelector = false

proc decimalClicked() =
    if (not outputLabel.text.contains(".")):
        outputLabel.text = outputLabel.text & "."

# Couldn't get a loop working for this so it's just in a list
zeroButton.onClick = proc(event: ClickEvent) = numberPressed(0)
oneButton.onClick = proc(event: ClickEvent) = numberPressed(1)
twoButton.onClick = proc(event: ClickEvent) = numberPressed(2)
threeButton.onClick = proc(event: ClickEvent) = numberPressed(3)
fourButton.onClick = proc(event: ClickEvent) = numberPressed(4)
fiveButton.onClick = proc(event: ClickEvent) = numberPressed(5)
sixButton.onClick = proc(event: ClickEvent) = numberPressed(6)
sevenButton.onClick = proc(event: ClickEvent) = numberPressed(7)
eightButton.onClick = proc(event: ClickEvent) = numberPressed(8)
nineButton.onClick = proc(event: ClickEvent) = numberPressed(9)

# Keyboard inputs
mainWindow.onKeyDown = proc(event: KeyboardEvent) =
    if Key_Number0.isDown() or Key_Numpad0.isDown():
        numberPressed(0)
    elif Key_Number1.isDown() or Key_Numpad1.isDown():
        numberPressed(1)
    elif Key_Number2.isDown() or Key_Numpad2.isDown():
        numberPressed(2)
    elif Key_Number3.isDown() or Key_Numpad3.isDown():
        numberPressed(3)
    elif Key_Number4.isDown() or Key_Numpad4.isDown():
        numberPressed(4)
    elif Key_Number5.isDown() or Key_Numpad5.isDown():
        numberPressed(5)
    elif Key_Number6.isDown() or Key_Numpad6.isDown():
        numberPressed(6)
    elif Key_Number7.isDown() or Key_Numpad7.isDown():
        numberPressed(7)
    elif not Key_ShiftL.isDown() and (Key_Number8.isDown() or Key_Numpad8.isDown()):
        numberPressed(8)
    elif Key_Number9.isDown() or Key_Numpad9.isDown():
        numberPressed(9)
    elif Key_NumpadEnter.isDown() or Key_Return.isDown() or (Key_Plus.isDown() and not Key_ShiftL.isDown()):
        equalsClicked()
    elif (Key_Plus.isDown() and Key_ShiftL.isDown()) or Key_NumpadAdd.isDown():
        operatorClicked(add)
    elif Key_Minus.isDown() or Key_NumpadSubtract.isDown():
        operatorClicked(subtract)
    elif Key_Divide.isDown() or Key_NumpadDivide.isDown(): # What is the forward slash "/" key?!
        operatorClicked(divide)
    elif Key_NumpadMultiply.isDown() or (Key_Number8.isDown() and Key_ShiftL.isDown()):
        operatorClicked(multiply)
    elif Key_NumpadDecimal.isDown() or Key_Point.isDown():
        decimalClicked()
    elif Key_Backspace.isDown() or Key_Delete.isDown():
        outputLabel.text = "0"

# Set outputLabel to 0. MIGHT need to clear firstNum here too?
clearButton.onClick = proc(event: ClickEvent) = outputLabel.text = "0"

# Add decimal place if it's not there already
decimalButton.onClick = proc(event: ClickEvent) = decimalClicked()
    

# Set operation enum variable to whatever is needed on click
addButton.onClick = proc(event: ClickEvent) = operatorClicked(add)
subtractButton.onClick = proc(event: ClickEvent) = operatorClicked(subtract)
multiplyButton.onClick = proc(event: ClickEvent) = operatorClicked(multiply)
divideButton.onClick = proc(event: ClickEvent) = operatorClicked(divide)

# The very simple code for calculating the answer. Literally your generic CLI calculator equals check
equalsButton.onClick = proc(event: ClickEvent) = equalsClicked()
    

mainWindow.show()
app.run()