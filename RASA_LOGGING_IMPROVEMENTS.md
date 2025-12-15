# Rasa Action Logging Improvements

## Overview

Comprehensive logging has been added to all Rasa custom actions to provide complete visibility into action execution, OpenAI API calls, and debugging information.

## Problem Solved

**Before**: No visibility into what was happening inside Rasa actions
- Could not see if actions were triggering
- Could not see OpenAI API calls
- Could not debug environment issues
- Could not identify where failures occurred

**After**: Complete transparency with detailed logging
- Every action trigger is logged
- Every OpenAI API call is logged with status
- Environment variable issues are logged
- All errors are logged with context
- Progress through long operations is logged

## What Was Added

### 1. OpenAI Helper Functions

**File**: `rasa-chatbot/actions/actions.py`

Both `_openai_chat_json()` and `_openai_chat_text()` now log:
- When API key is missing or invalid
- Every API request with model name
- Retry attempts with attempt numbers
- Rate limiting (429 errors) with retry timing
- Successful responses with response size
- All errors with full context

**Example log output**:
```
INFO - Calling OpenAI API (model: gpt-4o-mini) for JSON response
DEBUG - OpenAI request attempt 1/3
INFO - OpenAI API call successful, received valid JSON response
```

### 2. ActionScanFile

**File**: `rasa-chatbot/actions/actions.py`

The main vulnerability scanning action now logs:
- Action trigger with visual separator (`===`)
- All scan parameters (file, CVE filter, severity, package)
- Command being executed
- Scan progress messages
- JSON parsing success/failure
- File save location
- Vulnerability count found
- Summary generation
- Response sent to user
- All errors with full context

**Example log output**:
```
============================================================
ActionScanFile triggered
============================================================
Scan parameters:
  - File: python
  - CVE filter: None
  - Severity filter: None
  - Package filter: None
Executing Trivy scan command: bash .../ys.sh python
Running Trivy scan (this may take a few seconds)...
Trivy scan command completed successfully
Scan output parsed successfully as JSON
Scan results saved to: .../trivy-result.json
Scan found 10 vulnerabilities
Generating vulnerability summary...
Sending scan results to user (450 chars)
Scan action completed successfully
============================================================
```

### 3. ActionQueryVulnerability

**File**: `rasa-chatbot/actions/actions.py`

The vulnerability query action now logs:
- Action trigger
- All query parameters (CVE, package, severity)
- File path being read
- Total vulnerability count
- Query completion
- All errors

**Example log output**:
```
INFO - ActionQueryVulnerability triggered
INFO - Query params - CVE: CVE-2024-1234, Package: None, Severity: CRITICAL
DEBUG - Reading scan results from: .../trivy-result.json
INFO - Found 10 total vulnerabilities in scan data
INFO - Query completed, sending response to user
```

### 4. ActionCallOpenAPI

**File**: `rasa-chatbot/actions/actions.py`

The OpenAI direct query action now logs:
- Action trigger
- User question (first 100 chars)
- API key configuration status
- Response receipt
- All errors

**Example log output**:
```
INFO - ActionCallOpenAPI triggered
INFO - User question: What is a CVE?...
INFO - Calling OpenAI API (model: gpt-4o-mini) for text response
INFO - OpenAI response received, sending to user
```

### 5. ActionAnalyzeHighlight

**File**: `rasa-chatbot/actions/actions.py`

The highlight analysis action now logs:
- Action trigger with visual separator
- Message being analyzed
- Security content detection status
- API key availability
- Skip reasons (short messages, greetings)
- OpenAI call with models being tried
- Analysis results (category, score, highlight flag)
- Highlight creation success
- Rate limiting and fallback behavior

**Example log output**:
```
============================================================
ActionAnalyzeHighlight triggered for message: 'python'
Security content detected: False
Proceeding with highlight analysis...
Calling OpenAI for highlight analysis (trying models: ['gpt-4o', 'gpt-4o-mini'])
Calling OpenAI API (model: gpt-4o) for JSON response
OpenAI API call successful, received valid JSON response
Highlight analysis result - Category: Info, Score: 2, Highlight: True
✅ Highlight created: [Info] File scan requested...
============================================================
```

## Log Levels Used

- **`logger.info()`**: Important events (action triggers, completions, status)
- **`logger.warning()`**: Recoverable issues (rate limiting, missing optional data)
- **`logger.error()`**: Errors that prevent operation (API failures, missing keys)
- **`logger.debug()`**: Verbose details (file paths, retry attempts)

## Benefits

### 1. **Debugging Colleague Issues**

When colleagues report problems, you can now:
1. Ask for their `logs/rasa_actions.log` file
2. See exactly which actions triggered
3. Identify missing environment variables
4. See where OpenAI calls failed
5. Debug without reproducing locally

### 2. **Environment Validation**

Immediately see if:
- OpenAI API key is configured
- OpenAI API key is valid
- Rate limits are being hit
- Database connections fail
- File permissions are wrong

### 3. **Performance Monitoring**

Track:
- Which actions are being triggered
- How often OpenAI is called
- Scan durations (via timestamps)
- Error frequency

### 4. **Development and Testing**

During development:
- Verify actions trigger correctly
- See OpenAI request/response flow
- Test error handling paths
- Validate data flow

## Testing the Logging

### Quick Test

1. Start the application:
   ```bash
   ./start-react-unix.sh
   ```

2. In another terminal, tail the logs:
   ```bash
   tail -f logs/rasa_actions.log
   ```

3. In the chat interface, try:
   - "hi" → See greeting action
   - "python" → See scan + highlight actions
   - "show me critical vulnerabilities" → See query action

### What to Look For

✅ **Expected behavior**:
- Clear action start/end markers
- Parameter values logged
- OpenAI calls visible
- Success messages
- Clean error messages

❌ **Problems to watch for**:
- No logs appearing → Check Rasa action server is running
- "API key not set" errors → Check `.env` file
- Rate limiting (429) errors → OpenAI quota issue
- File not found errors → Check scan data exists

## Troubleshooting Guide for Colleagues

### Issue: No logs in rasa_actions.log

**Possible causes**:
1. Rasa action server not running
2. Wrong log file location
3. Log level set too high

**Solution**:
- Check `start-react-unix.sh` is running
- Verify `logs/rasa_actions.log` path
- Check Rasa logging configuration

### Issue: "OpenAI API key not set" in logs

**Possible causes**:
1. `.env` file missing
2. `OPENAI_API_KEY` not in `.env`
3. `.env` not being loaded by Rasa

**Solution**:
- Verify `.env` exists at project root
- Check `OPENAI_API_KEY=sk-...` in `.env`
- Restart all services

### Issue: Actions trigger but no OpenAI calls

**Possible causes**:
1. Message too short (skipped)
2. No security keywords detected
3. OpenAI call failing silently

**Solution**:
- Look for "Skipping highlight analysis" messages
- Check for "OpenAI API call failed" errors
- Verify API key is valid

### Issue: Scan action not triggering

**Possible causes**:
1. Intent not recognized
2. File slot not extracted
3. NLU model issue

**Solution**:
- Check Rasa logs (not action logs)
- Look for intent classification
- Verify NLU training data

## File Modified

**`rasa-chatbot/actions/actions.py`**
- Added ~60 new logging statements
- No functionality changes
- Backward compatible
- No performance impact

## Related Issues

This logging addition addresses:
- Colleague setup issues (can now diagnose from logs)
- "Silent failure" debugging
- OpenAI integration visibility
- Environment validation

## Next Steps

1. ✅ Logging implemented
2. ✅ Tested locally
3. ⏳ Push to GitHub
4. ⏳ Have colleagues test
5. ⏳ Collect logs for any issues

---

**Date**: November 5, 2025  
**Impact**: High - Critical debugging capability added  
**Breaking Changes**: None

