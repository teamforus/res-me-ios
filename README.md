# Me iOS
iOS implementation of the [me app](https://github.com/teamforus/me)

## Getting Started

# Setup 
* install cocoapods `brew install cocoapods`
* `cd  ../me-ios` and run `pod install`
* then open `../me-ios/Me-iOS.xcworkspace`
* Select Me-iOS Target and run project.

### Human Interface Guidelines

If you're coming from another platform, do take some time to familiarize yourself with Apple's [Human Interface Guidelines][ios-hig] for the platform. There is a strong emphasis on good design in the iOS world, and your app should be no exception. The guidelines also provide a handy overview of native UI elements, technologies such as 3D Touch or Wallet, and icon dimensions for designers.

[ios-hig]: https://developer.apple.com/ios/human-interface-guidelines/

### Xcode

[Xcode][xcode] is the IDE of choice for most iOS developers, and the only one officially supported by Apple. Despite its shortcomings, it's actually quite usable nowadays!

To install, simply download [Xcode on the Mac App Store][xcode-app-store]. It comes with the newest SDK and simulators, and you can install more stuff under _Preferences > Downloads_.

[xcode]: https://developer.apple.com/xcode/
[xcode-app-store]: https://itunes.apple.com/us/app/xcode/id497799835

### Project Setup

A common question when beginning an iOS project is whether to write all views in code or use Interface Builder with Storyboards or XIB files. Both are known to occasionally result in working software. However, there are a few considerations:

#### Why code?
* Storyboards are more prone to version conflicts due to their complex XML structure. This makes merging much harder than with code.
* It's easier to structure and reuse views in code, thereby keeping your codebase [DRY][dry].
* All information is in one place. In Interface Builder you have to click through all the inspectors to find what you're looking for.
* Storyboards introduce coupling between your code and UI, which can lead to crashes e.g. when an outlet or action is not set up correctly. These issues are not detected by the compiler.

[dry]: https://en.wikipedia.org/wiki/Don%27t_repeat_yourself

#### Why Storyboards?
* For the less technically inclined, Storyboards can be a great way to contribute to the project directly, e.g. by tweaking colors or layout constraints. However, this requires a working project setup and some time to learn the basics.
* Iteration is often faster since you can preview certain changes without building the project.
* Custom fonts and UI elements are represented visually in Storyboards, giving you a much better idea of the final appearance while designing.
* For [size classes][size-classes], Interface Builder gives you a live layout preview for the devices of your choice, including iPad split-screen multitasking.

[size-classes]: http://futurice.com/blog/adaptive-views-in-ios-8

#### Why not both?
To get the best of both worlds, you can also take a hybrid approach: Start off by sketching the initial design with Storyboards, which are great for tinkering and quick changes. You can even invite designers to participate in this process. As the UI matures and reliability becomes more important, you then transition into a code-based setup that's easier to maintain and collaborate on.

### Ignores

A good first step when putting a project under version control is to have a decent `.gitignore` file. That way, unwanted files (user settings, temporary files, etc.) will never even make it into your repository. Luckily, GitHub has us covered for both [Swift][swift-gitignore] and [Objective-C][objc-gitignore].

[swift-gitignore]: https://github.com/github/gitignore/blob/master/Swift.gitignore
[objc-gitignore]: https://github.com/github/gitignore/blob/master/Objective-C.gitignore

### Usage of localization

Project uses [R.swift more details here](https://github.com/mac-cain13/R.swift).

#### Generate localizations key to variables
After `Localizable.string` is generated we need to run script for **Me-iOS Target** in **Build Phase** script are in `R.Swift`.

To generate `R.generated.swift` file, uncomment `"${PODS_ROOT}/R.swift/rswift" generate "$SRCROOT/me-ios/Resources/R.generated.swift"`, after better to comment back to optimize the building time.
File will be generated to `../me-ios/Resources/`

#### Why use this?

It makes your code that uses resources:

- Fully typed, less casting and guessing what a method will return
- Compile time checked, no more incorrect strings that make your app crash at runtime
- Autocompleted, never have to guess that image name again

Making a new build for App store (Dev only)
============================================

1. Open Project
2. Choose xcodeproj and change build number
3. Select build variant 
4. Select top bar menu Product->Archive
5. Distribute App 
6. Next step uncheck all three variants and just press next


<a href='https://apps.apple.com/nl/app/me-forus/id1422610676?l=en'><img alt='Get it on App Store' src='https://www.rbcwealthmanagement.com/_global/static/img/misc/download-on-the-app-store-badge.jpg' width='220px'/></a>
