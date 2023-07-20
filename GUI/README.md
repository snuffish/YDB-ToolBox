# GUI - Graphical User Interface

This is a Utility to create interactive CLI GUI Interactions.

----------------------------------------------------------------

## Window Frames

Create a Window Frame with custom content.

#### Usages:

Using a string and split by the default delimiter `\n`
```Mumps
;; The content to render to the Frame
YDB> S CONTENT="Lorem Ipsum is simply dummy text of the printing\nand typesetting industry. Lorem Ipsum has been\nthe industry's standard dummy text ever since the\n1500s, when an unknown printer too
k a galley of\ntype and scrambled it to make a type specimen\nbook."

;; Clear the screen and render the Frame
YDB> D CLEAR^%GUI,FRAME^%GUI("StringFrame",50,CONTENT)

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
YDB> D CLEAR^%GUI,FRAME^%GUI("ArrayFrame",50,.ROW)

╔════════════════════ArrayFrame════════════════════╗
║First Row                                         ║
║Second Row                                        ║
║Third Row                                         ║
╚══════════════════════════════════════════════════╝
```

## Select View

Create and render a **Select View** element that you can navigate through to select an option.

#### Usages:

Using a string values to create an, its key-value will be according to it`s string order.
```Mumps
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
YDB>S OPTION("key1")="foo"
YDB>S OPTION("key2")="bar"
YDB>S OPTION("key3")="baz"

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
