#!/bin/bash
# OrcaSlicer Profile Sync Script (Bash)
# Syncs printer, material, and process profiles from repo to OrcaSlicer

set -e

FORCE=false
if [[ "$1" == "--force" ]] || [[ "$1" == "-f" ]]; then
    FORCE=true
fi

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}OrcaSlicer Profile Sync${NC}"
echo -e "${GREEN}========================================${NC}\n"

# Get script directory (where the profiles are)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_PROFILES_DIR="$SCRIPT_DIR"

# Find OrcaSlicer config directory
ORCA_CONFIG=""

# macOS paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    PATHS=(
        "$HOME/Library/Application Support/OrcaSlicer"
        "$HOME/.config/OrcaSlicer"
    )
# Linux paths
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PATHS=(
        "$HOME/.config/OrcaSlicer"
        "$HOME/.OrcaSlicer"
    )
# Windows (Git Bash/WSL)
else
    if [[ -n "$APPDATA" ]]; then
        PATHS=(
            "$APPDATA/OrcaSlicer"
            "$LOCALAPPDATA/OrcaSlicer"
        )
    else
        PATHS=(
            "$HOME/.config/OrcaSlicer"
        )
    fi
fi

# Try to find OrcaSlicer config
for path in "${PATHS[@]}"; do
    if [[ -d "$path" ]]; then
        ORCA_CONFIG="$path"
        echo -e "${GREEN}Found OrcaSlicer config at: $ORCA_CONFIG${NC}"
        break
    fi
done

if [[ -z "$ORCA_CONFIG" ]]; then
    echo -e "${RED}ERROR: Could not find OrcaSlicer config directory!${NC}"
    echo -e "${YELLOW}\nPlease ensure OrcaSlicer is installed and has been run at least once.${NC}"
    echo -e "${YELLOW}\nTried these locations:${NC}"
    for path in "${PATHS[@]}"; do
        echo -e "  - $path"
    done
    exit 1
fi

# Define profile directories
MACHINE_DIR="$ORCA_CONFIG/resources/profiles/machine"
PROCESS_DIR="$ORCA_CONFIG/resources/profiles/process"
FILAMENT_DIR="$ORCA_CONFIG/resources/profiles/filament"

# Create directories if they don't exist
echo -e "\n${CYAN}Creating profile directories if needed...${NC}"
mkdir -p "$MACHINE_DIR"
mkdir -p "$PROCESS_DIR"
mkdir -p "$FILAMENT_DIR"

# Function to copy file with confirmation
copy_profile_file() {
    local source="$1"
    local dest_dir="$2"
    local type="$3"
    
    if [[ ! -f "$source" ]]; then
        echo -e "  ${YELLOW}⚠ Skipping $type - Source not found: $source${NC}"
        return 1
    fi
    
    local filename=$(basename "$source")
    local dest_file="$dest_dir/$filename"
    
    if [[ -f "$dest_file" ]] && [[ "$FORCE" == "false" ]]; then
        echo -e "  ${YELLOW}⚠ $type already exists: $dest_file${NC}"
        echo -e "    Use --force to overwrite"
        return 1
    fi
    
    if cp -f "$source" "$dest_file" 2>/dev/null; then
        echo -e "  ${GREEN}✓ Copied $type${NC}"
        return 0
    else
        echo -e "  ${RED}✗ Failed to copy $type${NC}"
        return 1
    fi
}

# Copy printer profiles (machine)
echo -e "\n${CYAN}Copying Printer Profiles (Machine)...${NC}"
MACHINE_FILES=(
    "Printer-1.json"
    "Printer-2.json"
)

MACHINE_COUNT=0
for file in "${MACHINE_FILES[@]}"; do
    source="$REPO_PROFILES_DIR/$file"
    if copy_profile_file "$source" "$MACHINE_DIR" "$file"; then
        ((MACHINE_COUNT++))
    fi
done

# Copy process profiles
echo -e "\n${CYAN}Copying Print Settings (Process)...${NC}"
PROCESS_FILES=(
    "0.8mm_Printer-1.json"
    "0.8mm_Printer-2.json"
    "CR-PETG_0.8mm_Print_Settings.json"
)

PROCESS_COUNT=0
for file in "${PROCESS_FILES[@]}"; do
    source="$REPO_PROFILES_DIR/$file"
    if copy_profile_file "$source" "$PROCESS_DIR" "$file"; then
        ((PROCESS_COUNT++))
    fi
done

# Copy filament profiles
echo -e "\n${CYAN}Copying Material Profiles (Filament)...${NC}"
FILAMENT_FILES=(
    "CR-PETG_White.json"
    "CR-PETG_Black.json"
)

FILAMENT_COUNT=0
for file in "${FILAMENT_FILES[@]}"; do
    source="$REPO_PROFILES_DIR/$file"
    if copy_profile_file "$source" "$FILAMENT_DIR" "$file"; then
        ((FILAMENT_COUNT++))
    fi
done

# Summary
echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Sync Complete${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${CYAN}Copied:${NC}"
echo -e "  • $MACHINE_COUNT printer profile(s)"
echo -e "  • $PROCESS_COUNT print setting(s)"
echo -e "  • $FILAMENT_COUNT material profile(s)\n"

echo -e "${YELLOW}Next Steps:${NC}"
echo -e "  1. Restart OrcaSlicer if it's running"
echo -e "  2. Select your printer from the dropdown"
echo -e "  3. Select your material (CR-PETG White/Black)"
echo -e "  4. Configure Mainsail connection in Printer Settings\n"

echo -e "${GREEN}Profiles are now available in OrcaSlicer!${NC}\n"
