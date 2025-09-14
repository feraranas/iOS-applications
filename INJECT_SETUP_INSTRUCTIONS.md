# Inject Hot Reloading Setup Instructions

## Step 1: Add Swift Package Dependency

Since your Xcode project is already open, follow these steps:

1. In Xcode, go to **File** → **Add Package Dependencies...**
2. In the search field, enter: `https://github.com/krzysztofzablocki/Inject.git`
3. Click **Add Package**
4. Select your `think` target and click **Add Package**

## Step 2: Configure Build Settings

1. In Xcode, select your project in the navigator
2. Select the `think` target
3. Go to **Build Settings**
4. Search for "Other Linker Flags"
5. For the **Debug** configuration, add: `-Xlinker -interposable`

## Step 3: Install InjectionIII

1. Download InjectionIII from: https://github.com/johnno1962/InjectionIII/releases
2. Move the `InjectionIII.app` to your `/Applications` folder
3. Launch InjectionIII
4. Select your project workspace when prompted

## Step 4: Build and Test

1. Build your project (⌘+B)
2. Run your app (⌘+R)
3. Make a small change to any SwiftUI view (like changing text color or content)
4. Save the file (⌘+S)
5. You should see the changes reflected immediately in the running app without rebuilding!

## What's Already Configured

✅ All SwiftUI views have been updated with:
- `@ObserveInjection var inject` property
- `.enableInjection()` modifier
- Conditional compilation flags (`#if DEBUG`) to ensure Inject only runs in debug builds

## Files Modified

- `thinkApp.swift` - Added Inject import
- `ContentView.swift` - Added injection support
- `Views/LinkRowView.swift` - Added injection support  
- `Views/LinksListView.swift` - Added injection support
- `Views/AddLinkView.swift` - Added injection support

## Testing Hot Reloading

Try making these changes to test hot reloading:

1. Change text content in any view
2. Modify colors or styling
3. Add/remove UI elements
4. Adjust layout properties

The changes should appear instantly without rebuilding!

## Troubleshooting

- Ensure InjectionIII is running and has selected your project
- Check that the linker flag `-Xlinker -interposable` is set for Debug builds
- Make sure you're running in Debug mode, not Release
- Verify the Inject package was properly added to your target
