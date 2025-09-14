#!/bin/bash

# Script to configure Inject hot reloading for the think project
# This script adds the necessary linker flags to the project

echo "🔧 Configuring Inject hot reloading for think project..."

# Check if we're in the right directory
if [ ! -f "think.xcodeproj/project.pbxproj" ]; then
    echo "❌ Error: think.xcodeproj not found. Make sure you're in the project root directory."
    exit 1
fi

# Create backup of project file
echo "📋 Creating backup of project.pbxproj..."
cp think.xcodeproj/project.pbxproj think.xcodeproj/project.pbxproj.backup

# Add linker flags for Debug configuration
echo "🔗 Adding linker flags for hot reloading..."

# Use sed to add the linker flags to the Debug configuration
sed -i '' 's/OTHER_LDFLAGS = (/OTHER_LDFLAGS = (\
					"-Xlinker",\
					"-interposable",/g' think.xcodeproj/project.pbxproj

# If OTHER_LDFLAGS doesn't exist, add it
if ! grep -q "OTHER_LDFLAGS" think.xcodeproj/project.pbxproj; then
    # Find Debug configuration and add OTHER_LDFLAGS
    sed -i '' '/Debug.*buildSettings = {/,/};/ s/};/				OTHER_LDFLAGS = (\
					"-Xlinker",\
					"-interposable",\
				);\
			};/' think.xcodeproj/project.pbxproj
fi

echo "✅ Configuration complete!"
echo ""
echo "Next steps:"
echo "1. Open Xcode and add the Inject package dependency:"
echo "   https://github.com/krzysztofzablocki/Inject.git"
echo "2. Download and install InjectionIII from:"
echo "   https://github.com/johnno1962/InjectionIII/releases"
echo "3. Build and run your project!"
echo ""
echo "📖 See INJECT_SETUP_INSTRUCTIONS.md for detailed instructions."
