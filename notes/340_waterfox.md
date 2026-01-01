# 340 - Waterfox Browser

## Overview

Waterfox is a privacy-focused web browser based on Firefox. It must be installed natively (not via Flatpak) to enable KeePassXC browser integration, as Flatpak sandboxing prevents the native messaging required for password manager communication.

**Installation Location**: `/opt/waterfox/`  
**Executable**: `/usr/local/bin/waterfox`  
**Configuration**: `~/.waterfox/`  
**Desktop Entry**: `/usr/share/applications/waterfox.desktop`

## Installation

**Installation Method**: Manual tarball extraction

### Step 1: Uninstall Flatpak Version (if installed)

```bash
flatpak uninstall -y net.waterfox.waterfox
```

### Step 2: Download Latest Version

```bash
cd ~/Downloads
wget -O waterfox.tar.bz2 "https://cdn1.waterfox.net/waterfox/releases/6.6.7/Linux_x86_64/waterfox-6.6.7.tar.bz2"
```

**Note**: Check [Waterfox releases](https://github.com/BrowserWorks/waterfox/releases) for the latest version number and update URL accordingly.

### Step 3: Extract and Install

```bash
# Extract tarball
tar xjf waterfox.tar.bz2

# Move to /opt
sudo mv waterfox /opt/

# Create symlink for easy access
sudo ln -sf /opt/waterfox/waterfox /usr/local/bin/waterfox
```

### Step 4: Create Desktop Entry

```bash
sudo tee /usr/share/applications/waterfox.desktop > /dev/null <<'EOF'
[Desktop Entry]
Version=1.0
Name=Waterfox
GenericName=Web Browser
Comment=Browse the World Wide Web
Exec=/opt/waterfox/waterfox %u
Icon=/opt/waterfox/browser/chrome/icons/default/default128.png
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF

# Update desktop database
sudo update-desktop-database
```

## KeePassXC Browser Integration

### Why Native Installation is Required

- **Flatpak Limitation**: Flatpak sandboxing blocks inter-process communication
- **Native Messaging**: KeePassXC uses native messaging to communicate with browsers
- **Native Installation**: Allows KeePassXC to inject credentials directly into the browser

### Installing KeePassXC Browser Extension

1. Open Waterfox
2. Visit: [KeePassXC Browser Extension](https://addons.mozilla.org/en-US/firefox/addon/keepassxc-browser/)
3. Click "Add to Firefox" (works in Waterfox)
4. Accept permissions when prompted

### Configuring KeePassXC

#### Step 1: Enable Browser Integration in KeePassXC

1. Open KeePassXC
2. Go to **Tools** → **Settings** → **Browser Integration**
3. Check **Enable browser integration**
4. Check **Waterfox** (if available) or follow custom browser setup below

#### Step 2: Add Custom Browser (if Waterfox not listed)

If Waterfox doesn't appear in the browser list, configure it as a custom browser:

1. In KeePassXC: **Tools** → **Settings** → **Browser Integration**
2. Click **Advanced** tab
3. Under **Custom browser support**, add a custom browser location
4. Enter the native messaging host directory:

   - **Config Location**: `~/.mozilla/native-messaging-hosts/`

5. Click **OK** to save

#### Step 3: Connect Browser to KeePassXC

1. In Waterfox, click the KeePassXC extension icon in the toolbar
2. Click **Connect** button
3. KeePassXC will show a popup asking to allow the connection
4. Enter a name for the connection (e.g., "Waterfox")
5. Click **Save and allow access**
6. The extension should now show "Connected"

### Alternative: Manual Native Messaging Configuration

If the automatic setup doesn't work, manually configure native messaging:

1. **Find the native messaging manifest location**:

   ```bash
   # For Firefox-based browsers like Waterfox
   mkdir -p ~/.mozilla/native-messaging-hosts/
   ```

2. **Create symbolic link to KeePassXC native messaging manifest**:

   ```bash
   # Find KeePassXC manifest (usually in /usr/lib/mozilla/native-messaging-hosts/)
   ln -sf /usr/lib/mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json \
          ~/.mozilla/native-messaging-hosts/
   ```

3. **Restart Waterfox** and try connecting again

### Troubleshooting

**Extension shows "Cannot connect to KeePassXC"**:

- Make sure KeePassXC is running
- Check that Browser Integration is enabled in KeePassXC settings
- Verify native messaging manifest exists:

  ```bash
  ls ~/.mozilla/native-messaging-hosts/org.keepassxc.keepassxc_browser.json
  ```

- Restart both KeePassXC and Waterfox

**Extension connects but doesn't fill passwords**:

- Open your database in KeePassXC
- Make sure URLs in KeePassXC entries match the website
- Check that the database is unlocked

**Permissions error**:

- Ensure KeePassXC has permission to read/write to native messaging manifest
- Check file permissions:

  ```bash
  ls -la ~/.mozilla/native-messaging-hosts/
  ```

## Configuration

Waterfox stores its profile data in:

- **Profile Location**: `~/.waterfox/`
- **Bookmarks, History, Extensions**: Stored in profile directory

## Updating Waterfox

To update to a new version:

```bash
cd ~/Downloads
wget -O waterfox.tar.bz2 "https://cdn1.waterfox.net/waterfox/releases/<VERSION>/Linux_x86_64/waterfox-<VERSION>.tar.bz2"
tar xjf waterfox.tar.bz2
sudo rm -rf /opt/waterfox
sudo mv waterfox /opt/
```

The symlink and desktop entry don't need to be recreated.

## Uninstallation

```bash
sudo rm -rf /opt/waterfox
sudo rm /usr/local/bin/waterfox
sudo rm /usr/share/applications/waterfox.desktop
sudo update-desktop-database
```

Profile data will remain at `~/.waterfox/` unless manually deleted.

## Related Documentation

- [300_applications.md](300_applications.md) - Custom applications overview
