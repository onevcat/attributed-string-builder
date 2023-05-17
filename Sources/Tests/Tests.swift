import XCTest
import SwiftUI
import AttributedStringBuilder

var backgroundGradient: some View {
    RoundedRectangle(cornerRadius: 2)
        .fill(LinearGradient(colors: [.green, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
}

@AttributedStringBuilder @MainActor
var example: some AttributedStringConvertible {
    NumberedList {
        "First Item"
        Markdown("My second item")
        Array(repeating: "Third item. ", count: 10).joined(separator: "")
    }
    Group {
        "Hello, World!"
            .bold()
            .modify { $0.backgroundColor = .yellow }
        Footnote {
            Markdown("""
        Here's the *contents* of a footnote.
        """)
        }
        ". "
        "Some more text"
            .modify {
                $0.backgroundView = AnyView(backgroundGradient)
            }

    }.joined(separator: "")
    Array(repeating:
    """
    This is some markdown with **strong** `code` text. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas tempus, tortor eu maximus gravida, ante diam fermentum magna, in gravida ex tellus ac purus.

    - One
    - Two
    - Three
      - Four
      - Five

    ```
    some code
    ```

    And a number list:

    1. One
    1. Two
    1. Three
    
    Checklist:
    
    - [ ] Unchecked item
    - [x] Checked item

    Another *paragraph*.

    > A blockquote.
    """.markdown() as any AttributedStringConvertible, count: 2)
    Table(rows: [
        .init(cells: [
            .init(borderColor: .green, borderWidth: .init(right: 2), contents: "Table Testing"),
            .init(contents: Embed {
                        Circle().fill(LinearGradient(colors: [.blue, .red], startPoint: .top, endPoint: .bottom))
                    .frame(width: 100, height: 100)
                } )
        ])
    ])
    .modify { $0.size = 10 }

    String(UnicodeScalar(12)) // pagebreak

    Table(rows: [
        .init(cells: [
            .init(contents: "Here is the first cell\nwith a newline"),
            .init(contents: "And the second cell"),
        ]),
        .init(cells: [
            .init(contents: "Third"),
            .init(contents: "And fourth"),
        ])
    ])
    
//    NSImage(systemSymbolName: "hand.wave", accessibilityDescription: nil)!
    Embed {
        HStack {
            Image(systemName: "hand.wave")
                .font(.largeTitle)
            Text("Hello from SwiftUI")
            Color.red.frame(width: 100, height: 50)
        }
    }
}

let sampleAttributes = Attributes(family: "Georgia", size: 16, textColor: .black, paragraphSpacing: 10)


class Tests: XCTestCase {
    @MainActor
    func testPDF() {
        var context = Context(environment: .init(attributes: sampleAttributes))
        let data = example
            .joined(separator: "\n")
            .run(context: &context)
            .fancyPDF()
            .data
        try! data.write(to: .desktopDirectory.appending(component: "out.pdf"))

    }
}
