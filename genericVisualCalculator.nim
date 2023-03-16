import nigui
import strutils

app.init()

var numButtons = newSeq[Button]()

### LAYOUT ###

# This is long and dumb, as I don't know if there's a grid layout etc. to create the buttons with a for loop and stuff.
# It's good enough, and it's 1 am

var mainWindow = newWindow("Nim Calculator")
mainWindow.height = 400.scaleToDpi
mainWindow.width = 300.scaleToDpi

var rootContainer = newLayoutContainer(Layout_Vertical)
rootContainer.widthMode = WidthMode_Expand
rootContainer.heightMode = HeightMode_Expand
mainWindow.add(rootContainer)

var outputLabel = newLabel("0")
outputLabel.fontSize = 32
outputLabel.widthMode = WidthMode_Expand
outputLabel.xTextAlign = XTextAlign_Right
rootContainer.add(outputLabel)

var buttonVerticalContainer = newLayoutContainer(Layout_Vertical)
buttonVerticalContainer.widthMode = WidthMode_Expand
buttonVerticalContainer.heightMode = HeightMode_Expand
rootContainer.add(buttonVerticalContainer)
var topBarContainer = newLayoutContainer(Layout_Horizontal)
topBarContainer.widthMode = WidthMode_Expand
topBarContainer.heightMode = HeightMode_Expand
buttonVerticalContainer.add(topBarContainer)

var sevenButton = newButton("7")
sevenButton.widthMode = WidthMode_Expand
sevenButton.heightMode = HeightMode_Expand
numButtons.add(sevenButton)
topBarContainer.add(sevenButton)
var eightButton = newButton("8")
eightButton.widthMode = WidthMode_Expand
eightButton.heightMode = HeightMode_Expand
numButtons.add(eightButton)
topBarContainer.add(eightButton)
var nineButton = newButton("9")
nineButton.widthMode = WidthMode_Expand
nineButton.heightMode = HeightMode_Expand
numButtons.add(nineButton)
topBarContainer.add(nineButton)
var addButton = newButton("+")
addButton.widthMode = WidthMode_Expand
addButton.heightMode = HeightMode_Expand
topBarContainer.add(addButton)

var midBarContainer = newLayoutContainer(Layout_Horizontal)
midBarContainer.widthMode = WidthMode_Expand
midBarContainer.heightMode = HeightMode_Expand
buttonVerticalContainer.add(midBarContainer)

var fourButton = newButton("4")
fourButton.widthMode = WidthMode_Expand
fourButton.heightMode = HeightMode_Expand
numButtons.add(fourButton)
midBarContainer.add(fourButton)
var fiveButton = newButton("5")
fiveButton.widthMode = WidthMode_Expand
fiveButton.heightMode = HeightMode_Expand
numButtons.add(fiveButton)
midBarContainer.add(fiveButton)
var sixButton = newButton("6")
sixButton.widthMode = WidthMode_Expand
sixButton.heightMode = HeightMode_Expand
numButtons.add(sixButton)
midBarContainer.add(sixButton)
var subtractButton = newButton("-")
subtractButton.widthMode = WidthMode_Expand
subtractButton.heightMode = HeightMode_Expand
midBarContainer.add(subtractButton)

var bottomBarContainer = newLayoutContainer(Layout_Horizontal)
bottomBarContainer.widthMode = WidthMode_Expand
bottomBarContainer.heightMode = HeightMode_Expand
buttonVerticalContainer.add(bottomBarContainer)

var oneButton = newButton("1")
oneButton.widthMode = WidthMode_Expand
oneButton.heightMode = HeightMode_Expand
numButtons.add(oneButton)
bottomBarContainer.add(oneButton)
var twoButton = newButton("2")
twoButton.widthMode = WidthMode_Expand
twoButton.heightMode = HeightMode_Expand
numButtons.add(twoButton)
bottomBarContainer.add(twoButton)
var threeButton = newButton("3")
threeButton.widthMode = WidthMode_Expand
threeButton.heightMode = HeightMode_Expand
numButtons.add(threeButton)
bottomBarContainer.add(threeButton)
var multiplyButton = newButton("*")
multiplyButton.widthMode = WidthMode_Expand
multiplyButton.heightMode = HeightMode_Expand
bottomBarContainer.add(multiplyButton)

var operationBarContainer = newLayoutContainer(Layout_Horizontal)
operationBarContainer.widthMode = WidthMode_Expand
operationBarContainer.heightMode = HeightMode_Expand
buttonVerticalContainer.add(operationBarContainer)

var zeroButton = newButton("0")
zeroButton.widthMode = WidthMode_Expand
zeroButton.heightMode = HeightMode_Expand
numButtons.add(zeroButton)
operationBarContainer.add(zeroButton)
var decimalButton = newButton(".")
decimalButton.widthMode = WidthMode_Expand
decimalButton.heightMode = HeightMode_Expand
operationBarContainer.add(decimalButton)
var clearButton = newButton("C")
clearButton.widthMode = WidthMode_Expand
clearButton.heightMode = HeightMode_Expand
operationBarContainer.add(clearButton)
var divideButton = newButton("/")
divideButton.widthMode = WidthMode_Expand
divideButton.heightMode = HeightMode_Expand
operationBarContainer.add(divideButton)

var equalsButton = newButton("=")
equalsButton.widthMode = WidthMode_Expand
equalsButton.heightMode = HeightMode_Expand
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

# Set outputLabel to 0. MIGHT need to clear firstNum here too?
clearButton.onClick = proc(event: ClickEvent) = outputLabel.text = "0"

# Add decimal place if it's not there already
decimalButton.onClick = proc(event: ClickEvent) =
    if (not outputLabel.text.contains(".")):
        outputLabel.text = outputLabel.text & "."

# Set operation enum variable to whatever is needed on click
addButton.onClick = proc(event: ClickEvent) = operatorClicked(add)
subtractButton.onClick = proc(event: ClickEvent) = operatorClicked(subtract)
multiplyButton.onClick = proc(event: ClickEvent) = operatorClicked(multiply)
divideButton.onClick = proc(event: ClickEvent) = operatorClicked(divide)

# The very simple code for calculating the answer. Literally your generic CLI calculator equals check
equalsButton.onClick = proc(event: ClickEvent) = 
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

mainWindow.show()
app.run()