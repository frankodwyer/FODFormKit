# FODFormKit

[![Version](http://cocoapod-badges.herokuapp.com/v/FODFormKit/badge.png)](http://cocoadocs.org/docsets/FODFormKit)
[![Platform](http://cocoapod-badges.herokuapp.com/p/FODFormKit/badge.png)](http://cocoadocs.org/docsets/FODFormKit)

## Usage

FODFormKit is a library for creating dynamic forms for iOS.

To run the example project; clone the repo, and run `pod install` from the Project directory first.

For details of how to use the library in your own project, see [Creating Forms](#CreatingFormsAnchor) below.

## Screeenshots

###Form with subform:

<img src="https://github.com/frankodwyer/FODFormKit/raw/master/screenshots/form-with-subform.png" width="25%" height="25%"/>&nbsp;
<img src="https://github.com/frankodwyer/FODFormKit/raw/master/screenshots/form-with-subform-pushed.png" width="25%" height="25%"/>

###Inline (expandable) subform:

<img src="https://github.com/frankodwyer/FODFormKit/raw/master/screenshots/inline-subform-collapsed.png" width="25%" height="25%"/>&nbsp;
<img src="https://github.com/frankodwyer/FODFormKit/raw/master/screenshots/inline-subform-expanded.png" width="25%" height="25%"/>&nbsp;

###Inline (expandable) editors

<img src="https://github.com/frankodwyer/FODFormKit/raw/master/screenshots/inline-picker-expanded.png" width="25%" height="25%"/>&nbsp;
<img src="https://github.com/frankodwyer/FODFormKit/raw/master/screenshots/inline-date-editor-expanded.png" width="25%" height="25%"/>

###Textfield navigation:

<img src="https://github.com/frankodwyer/FODFormKit/raw/master/screenshots/textfield-navigation.png" width="25%" height="25%"/>&nbsp;

## Requirements

FODFormKit currently requires iOS7. It mostly works on iOS6 with cosmetic issues, but I don't have a need for this currently so I'm unlikely to fix them myself. Pull requests with iOS6 fixes are welcome, though.

## Installation

FODFormKit is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "FODFormKit"

## <a name="CreatingFormsAnchor"></a>Creating Forms

### Creating forms programmatically 

You can create forms programmatically using a `FODFormBuilder` object. See the demo project (*FODViewController.m*) for more examples.

    FODFormBuilder *builder = [[FODFormBuilder alloc] init];

    [builder startFormWithTitle:@"Main Form"];

    [builder section:@"Section 1"];

    [builder selectionRowWithKey:@"picker"
                        andTitle:@"Select a wibble"
                        andValue:nil
                        andItems:@[@"wibble1", @"wibble2", @"wibble3"]];

    [builder selectionRowWithKey:@"picker2"
                        andTitle:@"Select a fooby"
                        andValue:nil
                        andItems:@[@"fooby1", @"fooby2", @"fooby3"]].displayInline = YES;

    [builder section];

    [builder rowWithKey:@"date2"
                ofClass:[FODDateSelectionRow class]
               andTitle:@"When"
               andValue:nil];
    [builder rowWithKey:@"date1"
                ofClass:[FODDateSelectionRow class]
               andTitle:@"When Inline"
               andValue:nil].displayInline = YES;

    FODForm *form = [builder finishForm];

The builder object automatically keeps track of nested subforms and wires them up appropriately to their parent forms. 

Each call to the builder object returns the form, row, or section that was just created. To have a form or row display inline if possible (using expanding/collapsing cells), add `.displayInline = YES;`. (Currently only subforms, and rows of type `FODSelectionRow` or `FODDateSelectionRow` support this option.)

Each row must have a unique key within its form (and, in the case of inline subforms, the key must be unique within the parent form also). The key is used to retrieve the form values after a form has been completed.

### Creating forms from a plist

You can get the plist representation of a form by building it programmatically and calling `form.toPlist`. This format can then be written to a file in order to get a template that you can edit. For example, you can do this kind of thing in the debugger:

    (lldb) po [form.toPlist writeToFile:@"/Users/frank/form2.plist" atomically:YES]

To load a form from a plist, use:

    id plist = // load the plist from somewhere, e.g. a file or resource
    FODForm *form = [FODForm fromPlist:plist];
    
## Using a form

To display a form and allow a user to complete it:

    FODFormViewController *vc = [[FODFormViewController alloc] initWithForm:form userInfo:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];

To retrieve the values that a user filled in, and to handle cancellation, implement the form delegate methods:

    - (void)formSaved:(FODForm *)model
             userInfo:(id)userInfo {
        NSString *value1 = (NSString*)[model valueForKeyPath:@"somekey"];
        NSString *value2 = (NSString*)[model valueForKeyPath:@"subform.somekey"];
        [self.navigationController popViewControllerAnimated:YES];
    }

    - (void)formCancelled:(FODForm *)model
                 userInfo:(id)userInfo {
        [self.navigationController popViewControllerAnimated:YES];
    }

## Customisation

The library does not support much customisation yet, however many aspects can be tailored by subclassing `FODCellFactory` to return different cells for different row types. (For example, subclasses of the existing cells, or a new subclass of `FODFormCell`) 

You can also add entirely new row types by adding subclasses of `FODFormRow`, adding a subclass of `FODFormCell` to represent it, and then extending `FODFormBuilder` and `FODCellFactory` to support the new row and cell types.

To add new kinds of inline editable cells, you can subclass `FODInlineEditorCell` and provide a view controller that edits your row type. Given overrides for the following methods, the superclass will manage containment of your view controller.

    - (UIViewController*)createEditorController;
    - (CGFloat) heightForEditorController:(CGFloat)maxHeight;

See `FODInlinePickerCell` or `FODInlineDatePickerCell` for examples of this.

(If you add a subclass or new row type, feel free to send a pull request)

## Caveats

* Take the 0.x version number seriously :-) This is a first cut of the library made over a few days. Though most aspects are working pretty well, the API will definitely change. For example, I want to add the ability to customise the keyboard that is shown for text fields and add further row types and customisation options.

* Many aspects will not work well in landscape mode or if the device is rotated. Autorotation is handled however for some editor types there is not enough height in landscape for them to be useable. You may want to prevent rotation to landscape because of this.

* There is not much in the way of iPad support yet. 

## Author

Frank O'Dwyer

## License

FODFormKit is available under the MIT license. See the LICENSE file for more info.

