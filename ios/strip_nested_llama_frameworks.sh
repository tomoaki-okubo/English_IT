#!/bin/sh
set -e

FRAMEWORKS_DIR="${TARGET_BUILD_DIR}/${FRAMEWORKS_FOLDER_PATH}"
LLAMA_FRAMEWORK="${FRAMEWORKS_DIR}/Llama.framework"
NESTED_FRAMEWORKS="${LLAMA_FRAMEWORK}/Frameworks"
TARGET_MIN_OS="${IPHONEOS_DEPLOYMENT_TARGET:-16.0}"

echo "=== [AppStore] Packaging Llama Native Frameworks ==="
echo "Target Frameworks dir: ${FRAMEWORKS_DIR}"
echo "Deployment Target: ${TARGET_MIN_OS}"

create_framework_bundle() {
    local name="$1"
    local bundle_id="$2"
    local src_file="$3"
    local fw_dir="${FRAMEWORKS_DIR}/${name}.framework"
    
    mkdir -p "${fw_dir}"
    cp -f "${src_file}" "${fw_dir}/${name}"
    
    cat << PLIST > "${fw_dir}/Info.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>en</string>
	<key>CFBundleExecutable</key>
	<string>${name}</string>
	<key>CFBundleIdentifier</key>
	<string>${bundle_id}</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>${name}</string>
	<key>CFBundlePackageType</key>
	<string>FMWK</string>
	<key>CFBundleShortVersionString</key>
	<string>0.1.0</string>
	<key>CFBundleVersion</key>
	<string>0.1.0</string>
	<key>MinimumOSVersion</key>
	<string>${TARGET_MIN_OS}</string>
</dict>
</plist>
PLIST

    install_name_tool -id "@rpath/${name}.framework/${name}" "${fw_dir}/${name}" 2>/dev/null || true
}

update_install_names() {
    local target="$1"
    install_name_tool -change "@rpath/libggml-base.dylib" "@rpath/ggml_base.framework/ggml_base" "$target" 2>/dev/null || true
    install_name_tool -change "@loader_path/Frameworks/libggml-base.dylib" "@rpath/ggml_base.framework/ggml_base" "$target" 2>/dev/null || true
    
    install_name_tool -change "@rpath/libggml-blas.dylib" "@rpath/ggml_blas.framework/ggml_blas" "$target" 2>/dev/null || true
    install_name_tool -change "@loader_path/Frameworks/libggml-blas.dylib" "@rpath/ggml_blas.framework/ggml_blas" "$target" 2>/dev/null || true
    
    install_name_tool -change "@rpath/libggml-cpu.dylib" "@rpath/ggml_cpu.framework/ggml_cpu" "$target" 2>/dev/null || true
    install_name_tool -change "@loader_path/Frameworks/libggml-cpu.dylib" "@rpath/ggml_cpu.framework/ggml_cpu" "$target" 2>/dev/null || true
    
    install_name_tool -change "@rpath/libggml-metal.dylib" "@rpath/ggml_metal.framework/ggml_metal" "$target" 2>/dev/null || true
    install_name_tool -change "@loader_path/Frameworks/libggml-metal.dylib" "@rpath/ggml_metal.framework/ggml_metal" "$target" 2>/dev/null || true
    
    install_name_tool -change "@rpath/libggml.dylib" "@rpath/ggml.framework/ggml" "$target" 2>/dev/null || true
    install_name_tool -change "@loader_path/Frameworks/libggml.dylib" "@rpath/ggml.framework/ggml" "$target" 2>/dev/null || true
    
    install_name_tool -change "@rpath/libllama.dylib" "@rpath/llama_lib.framework/llama_lib" "$target" 2>/dev/null || true
    install_name_tool -change "@loader_path/Frameworks/libllama.dylib" "@rpath/llama_lib.framework/llama_lib" "$target" 2>/dev/null || true
    
    install_name_tool -change "@rpath/libmtmd.dylib" "@rpath/mtmd.framework/mtmd" "$target" 2>/dev/null || true
    install_name_tool -change "@loader_path/Frameworks/libmtmd.dylib" "@rpath/mtmd.framework/mtmd" "$target" 2>/dev/null || true
}

# 1. Convert nested dylibs to framework bundles
if [ -d "${NESTED_FRAMEWORKS}" ]; then
    echo "Converting nested dylibs to standard iOS frameworks..."
    
    [ -f "${NESTED_FRAMEWORKS}/libggml-base.dylib" ] && create_framework_bundle "ggml_base" "io.github.netdur.ggml-base" "${NESTED_FRAMEWORKS}/libggml-base.dylib"
    [ -f "${NESTED_FRAMEWORKS}/libggml-blas.dylib" ] && create_framework_bundle "ggml_blas" "io.github.netdur.ggml-blas" "${NESTED_FRAMEWORKS}/libggml-blas.dylib"
    [ -f "${NESTED_FRAMEWORKS}/libggml-cpu.dylib" ] && create_framework_bundle "ggml_cpu" "io.github.netdur.ggml-cpu" "${NESTED_FRAMEWORKS}/libggml-cpu.dylib"
    [ -f "${NESTED_FRAMEWORKS}/libggml-metal.dylib" ] && create_framework_bundle "ggml_metal" "io.github.netdur.ggml-metal" "${NESTED_FRAMEWORKS}/libggml-metal.dylib"
    [ -f "${NESTED_FRAMEWORKS}/libggml.dylib" ] && create_framework_bundle "ggml" "io.github.netdur.ggml" "${NESTED_FRAMEWORKS}/libggml.dylib"
    [ -f "${NESTED_FRAMEWORKS}/libllama.dylib" ] && create_framework_bundle "llama_lib" "io.github.netdur.llama-lib" "${NESTED_FRAMEWORKS}/libllama.dylib"
    [ -f "${NESTED_FRAMEWORKS}/libmtmd.dylib" ] && create_framework_bundle "mtmd" "io.github.netdur.mtmd" "${NESTED_FRAMEWORKS}/libmtmd.dylib"
    
    rm -rf "${NESTED_FRAMEWORKS}"
fi

# Clean up any loose .dylib files in FRAMEWORKS_DIR
for dylib in "${FRAMEWORKS_DIR}"/*.dylib; do
    if [ -f "$dylib" ]; then
        echo "Removing loose dylib: $(basename "$dylib")"
        rm -f "$dylib"
    fi
done

# 2. Update install names for all frameworks
if [ -f "${LLAMA_FRAMEWORK}/Llama" ]; then
    update_install_names "${LLAMA_FRAMEWORK}/Llama"
fi

for name in ggml_base ggml_blas ggml_cpu ggml_metal ggml llama_lib mtmd; do
    if [ -f "${FRAMEWORKS_DIR}/${name}.framework/${name}" ]; then
        update_install_names "${FRAMEWORKS_DIR}/${name}.framework/${name}"
    fi
done

# 3. Update Llama.framework Info.plist MinimumOSVersion
LLAMA_INFO_PLIST="${LLAMA_FRAMEWORK}/Info.plist"
if [ -f "${LLAMA_INFO_PLIST}" ]; then
    /usr/libexec/PlistBuddy -c "Set :MinimumOSVersion ${TARGET_MIN_OS}" "${LLAMA_INFO_PLIST}" 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :MinimumOSVersion string ${TARGET_MIN_OS}" "${LLAMA_INFO_PLIST}" 2>/dev/null || true
fi

# 4. Re-sign all created frameworks with their exact CFBundleIdentifier
SIGN_IDENTITY="${EXPANDED_CODE_SIGN_IDENTITY:-}"
if [ -z "$SIGN_IDENTITY" ]; then
    SIGN_IDENTITY="-"
fi

if [ "${CODE_SIGNING_ALLOWED:-YES}" != "NO" ]; then
    echo "Re-signing frameworks with identity: ${SIGN_IDENTITY}"
    for fw in "${FRAMEWORKS_DIR}"/ggml*.framework "${FRAMEWORKS_DIR}"/llama_lib.framework "${FRAMEWORKS_DIR}"/mtmd.framework "${LLAMA_FRAMEWORK}"; do
        if [ -d "$fw" ]; then
            BUNDLE_ID=$(/usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" "$fw/Info.plist" 2>/dev/null || echo "")
            if [ -n "$BUNDLE_ID" ]; then
                echo "Code signing $(basename "$fw") with identifier: $BUNDLE_ID"
                /usr/bin/codesign --force --sign "${SIGN_IDENTITY}" -i "${BUNDLE_ID}" ${OTHER_CODE_SIGN_FLAGS:-} --preserve-metadata=entitlements "$fw" 2>/dev/null || true
            else
                /usr/bin/codesign --force --sign "${SIGN_IDENTITY}" ${OTHER_CODE_SIGN_FLAGS:-} --preserve-metadata=entitlements "$fw" 2>/dev/null || true
            fi
        fi
    done
fi

echo "=== Packaging completed successfully ==="
