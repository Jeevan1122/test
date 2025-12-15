# Migration Guide - Environment Configuration Updates

This guide helps team members update their local setup after the recent environment configuration improvements.

## What Changed?

We've improved the setup process to make it easier for everyone to run the chatbot. Here's what's new:

### ✅ Improvements

1. **Proper .env Management**
   - `.env` files are now properly excluded from git
   - Each developer needs their own `.env` with their API keys
   - `env.example` provides a complete template

2. **Automatic Database Setup**
   - Database tables are created automatically on startup
   - No more manual SQL scripts needed

3. **Better Error Messages**
   - Clear validation on startup
   - Helpful troubleshooting tips
   - Health check endpoint shows service status

4. **Environment-Based Configuration**
   - Frontend URLs can be configured via environment variables
   - Easier to switch between development and production

5. **Comprehensive Documentation**
   - [QUICK_START.md](./QUICK_START.md) - Get running in 5 minutes
   - [SETUP_INSTRUCTIONS.md](./SETUP_INSTRUCTIONS.md) - Detailed guide
   - Better troubleshooting section

## Migration Steps

### For Fresh Clone (Recommended)

If you haven't cloned the repo yet, or want to start fresh:

```bash
# 1. Clone the repository
git clone <repository-url>
cd ysecure

# 2. Follow the Quick Start guide
cat QUICK_START.md

# 3. Create your .env
cp env.example .env

# 4. Add YOUR OpenAI API key to .env
nano .env  # or use your preferred editor

# 5. Run the application
./start-react-unix.sh
```

Done! Everything should work.

### For Existing Clone (Update)

If you already have the repo cloned:

```bash
# 1. Pull latest changes
git pull origin main

# 2. Your old .env might be in git tracking
# Check if you have a .env file
ls -la .env

# 3. If .env exists, save your keys somewhere temporarily
grep OPENAI_API_KEY .env > my-keys.txt

# 4. Remove any old .env files from git tracking
git rm --cached .env 2>/dev/null || true
git rm --cached Backend/.env 2>/dev/null || true

# 5. Remove the old Backend/.env if it exists (we now use ONE centralized .env)
rm -f Backend/.env

# 6. Create fresh .env from template (at project root only)
cp env.example .env

# 7. Add your API key back
nano .env  # paste your OPENAI_API_KEY

# 8. Install any new dependencies
npm install
cd Backend && npm install && cd ..

# 9. Run the application
./start-react-unix.sh
```

**Important Change:** We now use a **single centralized `.env` file** at the project root. No more `Backend/.env`!

## Common Issues After Migration

### "My OpenAI key stopped working"

**Issue:** You might be using someone else's key that was committed to git.

**Fix:** Get your own OpenAI API key:
1. Visit https://platform.openai.com/api-keys
2. Create a new key
3. Add it to your `.env` file:
   ```
   OPENAI_API_KEY=sk-your-new-key-here
   ```

### "Database connection errors"

**Issue:** PostgreSQL might not be running or database doesn't exist.

**Fix:**
```bash
# Start PostgreSQL
brew services start postgresql

# Create database (only needed once)
createdb rasa_db

# Restart the application
./start-react-unix.sh
```

The backend will automatically create all required tables!

### "Port already in use"

**Issue:** Old processes still running.

**Fix:**
```bash
# Find and kill processes
lsof -i :3001 | grep LISTEN  # Backend
lsof -i :5005 | grep LISTEN  # Rasa
lsof -i :5173 | grep LISTEN  # Frontend

# Kill them
kill -9 <PID>

# Or restart your computer (easiest)
```

### "Chatbot gives generic responses"

**Issue:** Rasa not loading your OpenAI key.

**Check:**
```bash
# 1. Verify key in .env
grep OPENAI_API_KEY .env

# 2. Check Rasa logs
tail -f logs/rasa_actions.log

# 3. Look for "OpenAI API key not set" errors
```

**Fix:** Make sure your `.env` file has the correct key and restart services.

## Verifying Your Setup

After migration, verify everything works:

### 1. Check Environment

```bash
# Should show your API key (obfuscated)
./start-react-unix.sh
# Look for: "✅ OpenAI API key configured"
```

### 2. Check Services

```bash
# Backend health
curl http://localhost:3001/health

# Should return JSON with status: "healthy"
```

### 3. Check Database

```bash
# Connect to database
psql -U rasa_user -d rasa_db

# List tables (should see messages, highlights, scan_results)
\dt

# Exit
\q
```

### 4. Test Chatbot

1. Open http://localhost:5173
2. Login with Auth0
3. Go to AI Security Assistant
4. Type "Hello"
5. Should get personalized greeting with your name

## What to Commit

### ✅ DO Commit:
- Source code changes
- Configuration updates
- `env.example` (template only)
- Documentation updates

### ❌ DON'T Commit:
- `.env` files (contains secrets!)
- `Backend/.env`
- Any files with API keys
- Local database files
- `node_modules/`

## Team Collaboration

### Sharing Configuration

**Wrong way:** 
```bash
# ❌ Don't do this!
git add .env
git commit -m "Add my API key"
```

**Right way:**
```bash
# ✅ Share via env.example
# Update env.example with new variables (without actual values)
git add env.example
git commit -m "Add new environment variable to template"

# Share actual keys via secure channels:
# - Password manager (1Password, LastPass)
# - Secure messaging (Signal, encrypted email)
# - In-person
```

### Getting Help

If you're stuck:

1. **Check logs:**
   ```bash
   tail -f logs/node.log
   tail -f logs/rasa_actions.log
   ```

2. **Run health checks:**
   ```bash
   curl http://localhost:3001/health
   ```

3. **Read documentation:**
   - [QUICK_START.md](./QUICK_START.md)
   - [SETUP_INSTRUCTIONS.md](./SETUP_INSTRUCTIONS.md)

4. **Ask the team:**
   - Share error messages (not API keys!)
   - Check if others have the same issue

## Summary

The new setup is actually simpler:

**Old way:**
1. Clone repo
2. Hope .env is committed
3. Use someone else's API key
4. Manually create database tables
5. Run into mysterious errors

**New way:**
1. Clone repo
2. Copy `env.example` to `.env`
3. Add YOUR API key
4. Run `./start-react-unix.sh`
5. Everything works! 🎉

---

**Questions?** Check [SETUP_INSTRUCTIONS.md](./SETUP_INSTRUCTIONS.md) or ask the team!

