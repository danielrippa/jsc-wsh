# LiveScript Dependency Compiler

A sophisticated dependency resolution and compilation system for LiveScript that supports modular development with namespace-based dependency management. **Like Node.js module system, but produces standalone JavaScript files** that run without any runtime dependencies.

## Overview

This compiler transforms LiveScript files with dependency declarations into a **single, standalone JavaScript file** that contains all resolved dependencies. Unlike Node.js which requires a runtime and external modules, this system bundles everything into one executable file that runs directly in Windows Scripting Host or any JavaScript environment.

**Key Difference from Node.js:**
- **Node.js**: `require()` loads modules at runtime from `node_modules/`
- **This System**: All dependencies are resolved at compile-time and bundled into the output

The result is a completely self-contained JavaScript file with no external dependencies.

## Architecture

### Core Components

#### 1. **Script Parser** (`ScriptParser.ls`)
- Parses LiveScript files to extract dependency declarations and code
- Identifies dependency references using the `dependency` keyword
- Separates prelude (dependencies) from actual code
- Supports destructuring imports: `{ function-name } = dependency 'namespace.module'`

#### 2. **Dependency Management** (`DependencyManager.ls`, `DependencyBuilder.ls`)
- **DependencyManager**: Resolves dependency graphs and prevents circular dependencies
- **DependencyBuilder**: Locates and builds individual dependency modules
- Maintains a registry of resolved dependencies to avoid duplication
- Recursively resolves nested dependencies

#### 3. **Namespace Resolution** 
Two strategies for resolving namespace paths:

##### **Filesystem Strategy** (`FileSystemNamespaceResolutionStrategy.ls`)
- Maps namespaces to filesystem paths
- Converts qualified namespaces (e.g., `value.string.Case`) to folder paths (`value/string/Case.ls`)
- Caches resolved paths for performance

##### **Configuration Strategy** (`ConfigurationNamespaceResolutionStrategy.ls`)
- Uses `namespaces.conf` file for custom namespace mappings
- Supports root configuration (`.` key) for framework base paths
- Allows specific namespace overrides for versioning

#### 4. **Path Resolution** (`NamespacePathResolver.ls`)
Combines multiple resolution strategies in priority order:
1. Script folder filesystem resolution
2. Current working directory filesystem resolution  
3. Root configuration path (if specified)
4. Configuration-based namespace mappings

#### 5. **Code Composition** (`DependenciesComposer.ls`, `ScriptComposer.ls`)
- **DependenciesComposer**: Generates namespace declarations and dependency modules
- **ScriptComposer**: Combines dependencies with main script code
- Creates proper JavaScript module structure with IIFE patterns

### Utility Modules

#### **Native Wrappers**
- `NativeString.ls`: String manipulation utilities (trim, indent, line splitting)
- `NativeArray.ls`: Array operations (map, filter, fold, each)
- `NativeObject.ls`: Object utilities for member access
- `NativeType.ls`: Type checking and validation
- `NativeError.ls`: Error handling utilities

#### **System Integration**
- `FileSystem.ls`: File/folder operations using Windows Scripting Host
- `TextFile.ls`: Text file reading operations
- `ObjectFile.ls`: Configuration file parsing (key-value pairs)
- `ComObject.ls`: COM object creation for system integration
- `IO.ls`: Input/output operations
- `Script.ls`: Script execution context and error handling

## Usage

### Basic Dependency Declaration

```livescript
# In your LiveScript file
{ function-name, another-function } = dependency 'namespace.module'
{ utility-function } = dependency 'utils.helpers'

# Your code using the imported functions
result = function-name input
processed = utility-function result
```

### Configuration File (`namespaces.conf`)

```
# Root framework path
. C:\framework\core

# Specific namespace overrides  
value.legacy C:\old-versions\value-v1
utils.experimental C:\dev\experimental-utils
```

### Compilation Process

1. **Parse** main script and extract dependencies
2. **Resolve** each dependency using namespace resolution strategies
3. **Build** dependency tree recursively
4. **Compose** final JavaScript with:
   - Namespace declarations
   - Dependency modules (in dependency order)
   - Main script code

### Output Structure

The compiler produces a **single, standalone JavaScript file** containing all dependencies:

```javascript
// Namespaces
value = {};
value.string = value.string || {};
utils = utils || {};

// Dependency value.string.Case
// (C:\path\to\value\string\Case.ls)
value.string.Case = function(){
  // Compiled dependency code
  return { camelCase: camelCase, kebabCase: kebabCase };
}();

// Dependency utils.helpers  
// (C:\path\to\utils\helpers.ls)
utils.helpers = function(){
  // All helper functions bundled here
  return { processData: processData, formatOutput: formatOutput };
}();

// Main Script
// (C:\path\to\main.ls)  
var camelCase = value.string.Case.camelCase;
var processData = utils.helpers.processData;
// Main script code...
```

**This single file runs on any Windows machine using `cscript filename.js` - no installation or setup required.**

## Key Features

### **Dependency Resolution**
- Automatic dependency graph resolution
- Circular dependency detection
- Duplicate dependency elimination
- Nested dependency support

### **Namespace Management**
- Hierarchical namespace structure
- Multiple resolution strategies
- Configuration-based overrides
- Filesystem-based auto-discovery

### **Code Organization**
- Modular development support
- Clean separation of concerns
- Proper JavaScript module patterns
- Dependency injection through destructuring

### **Error Handling**
- Detailed error messages with file paths and line numbers
- Graceful failure with proper exit codes
- Missing dependency detection
- Invalid syntax reporting

## File Extensions and Conventions

- **Source files**: `.ls` (LiveScript)
- **Configuration**: `namespaces.conf` (key-value pairs)
- **Output**: `.js` (JavaScript)

## Dependencies

**Runtime Dependencies: NONE**
- The compiled JavaScript runs on **cscript.exe** (Windows Scripting Host)
- **cscript is pre-installed on every Windows machine** (unlike Node.js or .NET)
- Code targets **ES3 compatibility** for maximum compatibility
- **Zero installation required** - works on any Windows computer out of the box

**Build-time Dependencies:**
- LiveScript compiler (for development only)
- File system access permissions

## Error Codes

- `6`: Unable to resolve namespace paths
- `7`: Unable to locate dependency file
- `1`: General compilation failure (default)

## Universal Windows Compatibility

This compiler enables sophisticated modular development in LiveScript while producing **universally compatible Windows executables**:

- **No Runtime Required**: Unlike Node.js or .NET, cscript.exe is built into Windows
- **ES3 Compatibility**: Code runs on Windows XP through Windows 11 without changes  
- **Zero Installation**: Deploy single `.js` files that run immediately
- **Enterprise Ready**: Works in locked-down corporate environments
- **Full Windows Support**: Compatible with all Windows versions from XP to Windows 11

Perfect for system administration scripts, enterprise tools, and utilities that need to run everywhere without dependencies.
