# GUI - Graphical User Interface

This is a Utility to create interactive CLI GUI Interactions.

The best practice is to use `D CLEAR^%GUI` before every re-rendering to prevent terminal formatting issues.

----------------------------------------------------------------

## Window Frames

Create a Window Frame with custom content.

#### Usages:

Using a string and split by the default delimiter `\n`
```Mumps
;; The content to render to the Frame
YDB> S CONTENT="Lorem Ipsum is simply dummy text of the printing\nand typesetting industry. Lorem Ipsum has been\nthe industry's standard dummy text ever since the\n1500s, when an unknown printer too
k a galley of\ntype and scrambled it to make a type specimen\nbook."

;; Render the Frame
YDB> D FRAME^%GUI("StringFrame",50,CONTENT)

╔═══════════════════StringFrame════════════════════╗
║Lorem Ipsum is simply dummy text of the printing  ║
║and typesetting industry. Lorem Ipsum has been    ║
║the industry's standard dummy text ever since the ║
║1500s, when an unknown printer took a galley of   ║
║type and scrambled it to make a type specimen     ║
║book.                                             ║
╚══════════════════════════════════════════════════╝
```

Using an MUMPS Array
```Mumps
;; Setup the Mumps Array
YDB> S ROW(1)="First Row"
YDB> S ROW(2)="Second Row"
YDB> S ROW(3)="Third Row"

;; Pass the Array as reference to the Frame
YDB> D FRAME^%GUI("ArrayFrame",50,.ROW)

╔════════════════════ArrayFrame════════════════════╗
║First Row                                         ║
║Second Row                                        ║
║Third Row                                         ║
╚══════════════════════════════════════════════════╝
```

## Select View

Create and render a **Select View** component that you can navigate through to select an option.

#### Usages:

Using string values to create Select-options, its key-value will be according to it`s string order.
```Mumps
;; Create an Select View component using string-values with default delimiter `|`
YDB> S *VALUE=$$SELECT^%GUI("foo|bar|baz")

foo
➔ bar
baz
[w-up, s-down, space-select, q-quit]

YDB>zwr VALUE
VALUE("KEY")=2
VALUE("VALUE")="bar"
```

If you want a more custom key-value you can use an Mumps Array instead
```Mumps
;; Setup the Key-Value Mumps Array
YDB>S OPTION("key1")="foo"
YDB>S OPTION("key2")="bar"
YDB>S OPTION("key3")="baz"

;; Pass the Array as reference
YDB>S *VALUE=$$SELECT^%GUI(.OPTION)

foo
bar
➔ baz
[w-up, s-down, space-select, q-quit]

YDB>zwr VALUE
VALUE("KEY")="key3"
VALUE("VALUE")="baz"
```

If you type `q` and quit the select view, it will return `-1`.
```Mumps
➔ foo
bar
baz
[w-up, s-down, space-select, q-quit]
q

YDB>zwr VALUE 
VALUE=-1
```

## Clearscreen

Simply clear the CLI Screen
```Mumps
YDB> D CLEAR^%GUI
```

----------------------------------------------------------------

## Special State Variables

### %X & %Y

These are internal state-variable that keeps track on your `%X`/`%Y` cursor position while rendering your GUI Components.
 
The value of `%Y` is being **$INCREMENT**ed after every render on the Y-axis.

This enables you to draw multiple Frames after one-another, also to place them at a desired position on the screen _(in-dependent from the other frames)_.

#### Usages:

```Mumps
WindowFrameRoutine
	D CLEAR^%GUI ;; Clear the screen
	D FRAME^%GUI("FirstFrame",50,"Some content...") ;; ==> %X=1,%Y=4
	D FRAME^%GUI("SecondFrame",30,"Some other content...") ;; ==> %X=1,%Y=7
	
	S %X=55,%Y=1
	D FRAME^%GUI("RightFrame",30,"Custom %X/%U positioned Frame\nwith some random\n text...") ;; ==> %X=55,%Y=6
	Q

YDB> D WindowFrameRoutine
╔════════════════════FirstFrame════════════════════╗  ╔══════════RightFrame══════════╗
║Some content...                                   ║  ║Custom %X/%Y positioned Frame ║
╚══════════════════════════════════════════════════╝  ║with some random              ║
╔═════════SecondFrame══════════╗                      ║simple content text...        ║
║Some other content...         ║                      ╚══════════════════════════════╝
╚══════════════════════════════╝
```

In this example we render 2 Frames to the left and 1 Frame to the right. When `%X`/`%Y` is unset, their values defaults to `1`.
- After the **FirstFrame** has been rendered the posotion has been set to `%X=1,%Y=4`
- After the **SecondFrame** has been rendered the position has been set to `%X=1,%Y=7` - because it continues where the previous **FirstFrame** finished.
- On the **RightFrame** we re-set the `%X` & `%Y` values to `%X=55,%Y=1` which means that we move the Cursor-pointer to the xy-coordinates `55,1`. Then we render the frame from that position.
