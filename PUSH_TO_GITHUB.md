# Push to GitHub - Quick Commands

Your repository is ready! Follow these steps:

## Step 1: Create Repository on GitHub

1. Go to: **https://github.com/new**
2. **Repository name**: `printer-configs`
3. **Description**: `CR-10S Printer Configurations - Klipper/MainsailOS`
4. **Visibility**: Choose **Private** (recommended)
5. **DO NOT** check "Initialize with README"
6. Click **Create repository**

## Step 2: Run These Commands

After creating the repository, run these commands in PowerShell (replace `YOUR_USERNAME` with your GitHub username):

```powershell
# Add the remote repository
git remote add origin https://github.com/YOUR_USERNAME/printer-configs.git

# Push to GitHub
git push -u origin main
```

## Step 3: Authentication

When prompted for **password**, use a **Personal Access Token**:

1. Go to: **GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)**
2. Click **"Generate new token (classic)"**
3. **Name**: `Printer Configs`
4. **Expiration**: Choose your preference (90 days, 1 year, etc.)
5. **Select scope**: Check `repo` (this gives full control of private repositories)
6. Click **"Generate token"**
7. **Copy the token** (you won't see it again!)
8. When git asks for password, paste this token

## Alternative: One-Line Setup

If you want to do it all at once, replace `YOUR_USERNAME` and run:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/printer-configs.git && git push -u origin main
```

## Verify Success

After pushing, go to your GitHub repository page. You should see all 20+ files!

## Next Steps

Once your code is on GitHub:

1. **Set up Printer 1's Pi** - See `QUICK_SYNC_GUIDE.md`
2. **Set up Printer 2's Pi** - See `QUICK_SYNC_GUIDE.md`

## Troubleshooting

### "Repository not found"
- Make sure you created the repository on GitHub first
- Check that the username and repository name are correct

### "Authentication failed"
- Make sure you're using a Personal Access Token, not your GitHub password
- Verify the token has `repo` scope

### "Permission denied"
- Check that the repository name matches exactly
- Verify your username is correct
