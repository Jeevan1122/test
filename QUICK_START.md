# YottaSecure - Quick Start Guide

Get the chatbot running in under 5 minutes!

## Prerequisites Check

Run these commands to verify you have the required software:

```bash
# Check Node.js (need v16+)
node --version

# Check Python (need 3.8+)
python3 --version

# Check PostgreSQL
psql --version

# Check if Rasa is installed
rasa --version
```

Don't have these? See [SETUP_INSTRUCTIONS.md](./SETUP_INSTRUCTIONS.md) for installation steps.

## Quick Setup (3 Steps)

### 1. Configure Environment

```bash
# Copy the environment template (ONE file at project root)
cp env.example .env

# Edit .env and add your OpenAI API key
nano .env  # or use your preferred editor
```

**Required:** Add your OpenAI API key:
```
OPENAI_API_KEY=sk-your-actual-key-here
```

**Note:** We use a **single centralized `.env` file** at the project root. You don't need to create separate `.env` files in subdirectories!

Get your API key from: https://platform.openai.com/api-keys

### 2. Setup Database

```bash
# Make sure PostgreSQL is running
brew services start postgresql

# Create the database (only needed once)
createdb rasa_db
```

### 3. Start All Services

```bash
# Make the script executable (first time only)
chmod +x start-react-unix.sh

# Start everything!
./start-react-unix.sh
```

That's it! The script will:
- ✅ Validate your configuration
- ✅ Install dependencies if needed
- ✅ Create database tables automatically
- ✅ Start all services (Frontend, Backend, Rasa, Database)

## Access the Application

Once started, open your browser to:

🌐 **http://localhost:5173**

You should see the YottaSecure login page!

## Testing the Chatbot

1. **Login** with your Auth0 credentials
2. **Navigate** to the AI Security Assistant
3. **Try these commands:**
   - "Hello" - Get a personalized greeting
   - "Scan python" - Scan a file for vulnerabilities
   - "Show me high severity vulnerabilities" - Query scan results

## Troubleshooting

### "OPENAI_API_KEY not found"
- Make sure you edited `.env` and added a valid API key
- API keys start with `sk-`

### "Database connection error"
- PostgreSQL not running: `brew services start postgresql`
- Database doesn't exist: `createdb rasa_db`

### "Port already in use"
- Another service is using the port
- Find it: `lsof -i :3001` (or :5005, :5173)
- Kill it: `kill <PID>`

### Check Service Logs
```bash
# If something isn't working, check the logs:
tail -f logs/node.log        # Backend logs
tail -f logs/rasa.log         # Rasa chatbot logs
tail -f logs/rasa_actions.log # Rasa actions logs
tail -f logs/vite.log         # Frontend logs
```

## Stopping Services

Press `Ctrl+C` in the terminal where you ran the startup script.

All services will shut down gracefully.

## Next Steps

- Read [SETUP_INSTRUCTIONS.md](./SETUP_INSTRUCTIONS.md) for detailed setup
- Configure AWS S3 for scan result storage (optional)
- Set up Docker deployment (see [DOCKER_SETUP.md](./DOCKER_SETUP.md))
- Customize the chatbot in `rasa-chatbot/`

## Need Help?

1. Check service logs in the `logs/` directory
2. Visit the health endpoint: http://localhost:3001/health
3. Review [SETUP_INSTRUCTIONS.md](./SETUP_INSTRUCTIONS.md) for detailed troubleshooting

---

**Happy Hacking! 🔐**

