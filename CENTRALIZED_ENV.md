# Centralized Environment Configuration

This project uses a **single `.env` file** at the project root for all environment configuration.

## Why Centralized?

- ✅ **Single source of truth** - One file to manage
- ✅ **No duplication** - Same values everywhere
- ✅ **Easier for team** - Less confusion about which file to edit
- ✅ **Simpler setup** - Just copy one file and you're done

## How It Works

### File Structure

```
ysecure/
├── .env                    ← SINGLE .env file (not in git)
├── env.example             ← Template (in git)
├── Backend/
│   ├── Server.js           ← Loads ../env
│   └── init-database.js    ← Loads ../.env
└── rasa-chatbot/
    └── actions/            ← Uses environment variables
```

### Environment Variable Flow

1. **Startup Script** (`start-react-unix.sh`)
   ```bash
   export $(grep -v '^#' .env | xargs)
   ```
   Exports all variables from root `.env` to the shell environment

2. **Backend Services** (`Backend/Server.js`, `Backend/init-database.js`)
   ```javascript
   require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
   ```
   Explicitly loads the root `.env` file

3. **Rasa Services** (Rasa server, Rasa actions)
   - Inherits environment variables exported by the startup script
   - Reads `OPENAI_API_KEY` and other vars from the environment

4. **Frontend** (React/Vite)
   - Uses `VITE_` prefixed variables from root `.env`
   - Vite automatically loads `.env` from project root

## Setup Instructions

### For New Developers

```bash
# 1. Clone the repository
git clone <repository-url>
cd ysecure

# 2. Copy the template
cp env.example .env

# 3. Edit .env and add your API key
nano .env

# 4. Done! Run the application
./start-react-unix.sh
```

### Configuration File Locations

**DO create:**
- ✅ `.env` at project root

**DON'T create:**
- ❌ `Backend/.env` (not needed anymore!)
- ❌ `rasa-chatbot/.env` (not needed!)

## Environment Variables

All variables go in the **root `.env` file**:

```env
# OpenAI (REQUIRED)
OPENAI_API_KEY=sk-your-key-here

# Database
POSTGRES_USER=rasa_user
POSTGRES_PASSWORD=rasa_123
POSTGRES_HOST=localhost
POSTGRES_DB=rasa_db

# Ports
BACKEND_PORT=3001
RASA_PORT=5005

# Frontend URLs
VITE_BACKEND_URL=http://localhost:3001
VITE_RASA_URL=http://localhost:5005
```

## Troubleshooting

### "Backend can't find environment variables"

**Check:** Make sure `.env` exists at project root
```bash
ls -la .env
```

**Fix:** If missing, create it:
```bash
cp env.example .env
# Then edit .env to add your API key
```

### "Old Backend/.env file exists"

**Check:**
```bash
ls -la Backend/.env
```

**Fix:** Remove it (we don't use it anymore):
```bash
rm Backend/.env
```

### "Variables not loaded"

**Verify Backend is configured correctly:**
```bash
grep "path.resolve(__dirname, '../.env')" Backend/Server.js
```

Should see:
```javascript
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
```

## Migration from Old Setup

If you had multiple `.env` files before:

```bash
# 1. Remove old Backend/.env
rm -f Backend/.env

# 2. Ensure root .env has all variables
cat .env  # Check it has OPENAI_API_KEY, database config, etc.

# 3. Pull latest code (Backend now loads root .env)
git pull origin main

# 4. Run the application
./start-react-unix.sh
```

## Benefits

### Before (Multiple .env files)
```
❌ .env
❌ Backend/.env
❌ Need to sync values between files
❌ Confusion about which file to edit
❌ Easy to have mismatched configurations
```

### After (Centralized .env)
```
✅ One .env file at root
✅ Single source of truth
✅ Edit once, works everywhere
✅ Clear and simple
✅ No duplicate configuration
```

## Technical Details

### Backend Loading Mechanism

The Backend uses an explicit path to load the root `.env`:

```javascript
// Backend/Server.js
const path = require('path');
require('dotenv').config({ path: path.resolve(__dirname, '../.env') });
```

This ensures it always loads from the project root, regardless of where the process is started from.

### Startup Script Mechanism

The startup script exports environment variables before starting services:

```bash
# Load and export variables
export $(grep -v '^#' .env | xargs)

# Now all child processes (Rasa, etc.) inherit these variables
cd rasa-chatbot
rasa run actions  # Has access to OPENAI_API_KEY
```

## Summary

**One rule:** Everything goes in `.env` at the project root!

No exceptions, no subdirectory `.env` files needed. Simple! 🎉
