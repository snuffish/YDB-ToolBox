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
S ROW(1)="First Row"
S ROW(2)="Second Row"
S ROW(3)="Third Row"

;; Pass the Array as reference to the Frame
YDB> D CLEAR^%GUI,FRAME^%GUI("ArrayFrame",50,.ROW)

╔════════════════════ArrayFrame════════════════════╗
║First Row                                         ║
║Second Row                                        ║
║Third Row                                         ║
╚══════════════════════════════════════════════════╝
```

### Select View
