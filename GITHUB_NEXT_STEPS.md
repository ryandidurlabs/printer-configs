# GitHub Setup - Next Steps

Your local git repository is ready! Now follow these steps to create the GitHub repository and push your code.

## Step 1: Create GitHub Repository

1. **Go to GitHub**: https://github.com/new
2. **Repository name**: `printer-configs` (or your preferred name)
3. **Description**: "CR-10S Printer Configurations - Klipper/MainsailOS"
4. **Visibility**: Choose **Private** (recommended) or **Public**
5. **IMPORTANT**: Do NOT check "Initialize with README" (we already have files)
6. Click **Create repository**

## Step 2: Connect and Push

After creating the repository, GitHub will show you commands. Use these (replace `YOUR_USERNAME` with your actual GitHub username):

### Option A: Using HTTPS (Easier)

```powershell
# Add remote repository
git remote add origin https://github.com/YOUR_USERNAME/printer-configs.git

# Push to GitHub
git push -u origin main
```

**Note**: When prompted for password, use a **Personal Access Token** instead:
- Go to: GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
- Click "Generate new token (classic)"
- Give it a name like "Printer Configs"
- Select scope: `repo` (full control of private repositories)
- Click "Generate token"
- **Copy the token** (you won't see it again!)
- Use this token as your password when pushing

### Option B: Using SSH (More Secure, Recommended)

If you prefer SSH (no password prompts after setup):

1. **Generate SSH key** (if you don't have one):
   ```powershell
   ssh-keygen -t ed25519 -C "your.email@example.com"
   # Press Enter to accept default location
   # Optionally set a passphrase
   ```

2. **Copy your public key**:
   ```powershell
   cat ~/.ssh/id_ed25519.pub
   ```

3. **Add to GitHub**:
   - Go to: GitHub → Settings → SSH and GPG keys
   - Click "New SSH key"
   - Title: "My Computer" (or any name)
   - Paste your public key
   - Click "Add SSH key"

4. **Use SSH URL**:
   ```powershell
   git remote add origin git@github.com:YOUR_USERNAME/printer-configs.git
   git push -u origin main
   ```

## Step 3: Verify

After pushing, refresh your GitHub repository page. You should see all your files!

## Quick Commands Reference

```powershell
# Check status
git status

# See what will be pushed
git log origin/main..main

# Push changes (after making edits)
git add .
git commit -m "Description of changes"
git push origin main
```

## Troubleshooting

### "Repository not found"
- Check the repository name and your username
- Make sure the repository exists on GitHub
- Verify you have access (if it's a private repo)

### "Authentication failed"
- For HTTPS: Make sure you're using a Personal Access Token, not your password
- For SSH: Make sure your SSH key is added to GitHub

### "Permission denied"
- Check that you have write access to the repository
- Verify your GitHub username is correct

## Next Steps After GitHub Setup

Once your code is on GitHub, you can:

1. **Set up Printer 1's Pi**:
   ```bash
   ssh pi@<printer1-ip>
   git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config
   cp ~/printer-config/scripts/sync-printer1.sh ~/sync-printer-config.sh
   chmod +x ~/sync-printer-config.sh
   ```

2. **Set up Printer 2's Pi**:
   ```bash
   ssh pi@<printer2-ip>
   git clone https://github.com/YOUR_USERNAME/printer-configs.git printer-config
   cp ~/printer-config/scripts/sync-printer2.sh ~/sync-printer-config.sh
   chmod +x ~/sync-printer-config.sh
   ```

See `QUICK_SYNC_GUIDE.md` for complete setup instructions!
