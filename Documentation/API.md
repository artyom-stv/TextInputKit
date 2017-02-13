## TextInputKit API

### Principles

TextInputKit API was created based on the following principles:
* Provide consistent Swift API on iOS, macOS and tvOS.
* Use Swift `String` and not to use `NSString`, `NSRange` where possible.
* Keep code (which uses TextInputKit) simple.
* Provide the capability of implementing custom text input formats.
* Not to subclass UI components.

### Basic API

To work with a text input UI control (e.g., `UITextField`), further referred as "text field", TextInputKit exposes `TextInputBinding` class.

An instance of `TextInputBinding` acts like a text field controller object:
* it validates the text input (edits the inputted text in a text field if necessary);
* it contains a `value` which represents the text in a text field;
* it propagates events from a text field (*TODO: Write about event handlers*).

`TextInputBinding` is named so because it binds a text field with a `TextInputFormat`.

`TextInputFormat` is a stateless structure representing the rules of text input formatting and value serialization/deserialization.

#### Creating TextInputFormat

For convenience, the creation of `TextInputFormat` instances was aggregated in static factory methods of `TextInputFormats` structure.

##### Plain Format

The most primitive `TextInputFormat` is the `plain` format:

```swift
let format = TextInputFormats.plain // -> TextInputFormat<String>
```

It leaves the default behavior of a text field (doesn't edit inputted text) and doesn't convert the text during serialization/deserialization (the resulting `TextInputBinding` provides the text of a text field as a `value`).

##### Built-in Formats

TextInputKit provides several built-in formats, e.g.:

```swift
let bankCardNumberFormat = TextInputFormats.bankCardNumber() // -> TextInputFormat<BankCardNumber>
let phoneNumberFormat = TextInputFormats.phoneNumber() // -> TextInputFormat<PhoneNumber>
```

Further, see [the full list of built-in formats](BuiltinFormats.md).

##### Custom Formats

TextInputKit provides the capability to create custom formats. Lightweight examples:

```swift
let cvvFormat = TextInputFormats.plain
    .filter(by: CharacterSet.decimalDigits)
    .filter(constrainingCharactersCount: 3)
    .transformValue(direct: { Int($0) }, reverse: { $0.description })
// -> TextInputFormat<Int>

let uppercasedLettersFormat = TextInputFormats.plain
    .filter(by: CharacterSet.letters)
    .map({ (text, selectedRange) in (text.uppercased(), selectedRange) })
// -> TextInputFormat<String>
```

Further, read [how to create a custom format](CustomFormats.md).

#### Binding TextInputFormat to a Text Field

After you've created a `TextInputFormat`, you can bind it to a `UITextField` or an `NSTextField`.

```swift
let textInputBinding = format.bind(to: textField)
```

:warning: After binding a `TextInputFormat` to a text field, the text in a text field is reset to `""`.

:warning: While a text field is bound to a `TextInputFormat`, you shouldn't access the text, selected range, delegate or formatter (on macOS) of a text field directly.

#### Using TextInputBinding

```swift
textInputBinding.value
```

*TODO: Write about event handlers*

### Advanced API

[`TextInputFormat`](#textinputformat) — an immutable structure containing instructions for text input formatting and value serialization/deserialization.

[`TextInputBinding`](#textinputbinding) — a base class for bindings of `TextInputFormat` to UI components (e.g., to `UITextField`). A subclass of `TextInputBinding`

[`TextInputFormatter`](#textinputformatter) — one of the components of `TextInputFormat`, a base class for a formatter which validates text input.

[`TextInputSerializer`](#textinputserializer) — another component of `TextInputFormat`, a base class for ... .

#### TextInputFormat

A `TextInputFormat` consists of a `TextInputFormatter` and a `TextInputSerializer`.

```swift
public struct TextInputFormat<Value> {

    public init(_ serializer: TextInputSerializer<Value>, _ formatter: TextInputFormatter)

    public let serializer: TextInputSerializer<Value>

    public let formatter: TextInputFormatter

}
```

#### TextInputBinding

```swift
public protocol TextInputBindingType : class {

    associatedtype Value

    var value: Value? { get set }

    func unbind()

}

public class TextInputBinding<Value> : TextInputBindingType {

    public let format: TextInputFormat<Value>

    public init(_ format: TextInputFormat<Value>)

    ...

}
```

#### TextInputFormatter

`TextInputFormatter` validates user text input, just like standard [`Formatter`](https://developer.apple.com/reference/foundation/formatter) does on macOS.

```swift
public enum TextInputValidationResult {

    case accepted

    case changed(String, selectedRange: Range<String.Index>)

    case rejected

}

public protocol TextInputFormatterType : class {

    func validate(
        editing originalString: String,
        withSelection originalSelectedRange: Range<String.Index>,
        replacing replacementString: String,
        at editedRange: Range<String.Index>) -> TextInputValidationResult

}

open class TextInputFormatter : TextInputFormatterType { ... }
```

#### TextInputSerializer

`TextInputSerializer` converts inputted text to a value and back — a value to text.

```swift
public protocol TextInputSerializerType : class {

    associatedtype Value

    func string(for value: Value) -> String

    func value(for string: String) throws -> Value

}

open class TextInputSerializer<Value> : TextInputSerializerType { ... }
```
