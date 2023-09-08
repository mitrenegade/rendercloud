# RenderCloud

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

RenderCloud is currently a private pod. To add it, first add the following line to your Podfile:

```ruby
pod 'RenderCloud'
```

In [https://https://console.firebase.google.com/]Firebase, create a new project, and generate a plist file by going to:

`Project Overview` -> `Project Settings` -> `General` 

and adding an iOS app. Store the file `GoogleService-Info.plist` in the project folder.

### Cloud Code

To use the included cloud API, Firebase Admin and functions must be enabled for your firebase project.

Install `firebase-tools`:

```
npm install -g firebase-tools
firebase login
```

Deploy the included functions:
```
firebase deploy
```

To create your own functions from scratch, use `firebase init functions`.
* This will overwrite the existing `functions` library and the APIs included with this pod will become invalid. 

## Author

Bobby Ren, bobbyren@gmail.com

## License

RenderCloud is available under the MIT license. See the LICENSE file for more info.


