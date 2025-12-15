# Clear Chat Feature Documentation

## Overview
Added comprehensive clear chat functionality for testing, demos, and cybersecurity compliance, allowing users to reset conversations and clear stored data at multiple levels.

## Features Added

### 🔄 Restart Button (Quick Reset)
- **Location**: Chat header (leftmost button)
- **Function**: Instantly clears the current chat UI and starts a fresh conversation
- **What it does**:
  - Clears message history from UI
  - Generates new conversation ID
  - Sends fresh greeting from bot
- **What it preserves**: Database storage (for quick testing)
- **Use case**: Rapid testing of conversation flows

### 🗑️ Clear My Data Button (User Reset)
- **Location**: Chat header (middle button)
- **Function**: Clears all conversation data for the current user only
- **What it does**:
  - Deletes all messages from database for current user
  - Deletes all highlights from database for current user
  - Clears UI message history
  - Generates new conversation ID
  - Sends fresh greeting from bot
- **Confirmation**: Single confirmation dialog
- **Use case**: Personal data cleanup, demo preparation

### 🚨 Clear Database Button (Security Reset)
- **Location**: Chat header (rightmost button, red color)
- **Function**: **SECURITY FEATURE** - Clears ALL data from the entire database for ALL users
- **What it does**:
  - Deletes ALL messages from ALL users
  - Deletes ALL highlights from ALL users
  - Clears UI message history
  - Generates new conversation ID
  - Sends fresh greeting from bot
- **Security confirmations**: 
  1. Initial security warning dialog
  2. Confirmation code prompt (`CLEAR_SECURITY_DATABASE_CONFIRMED`)
  3. Final confirmation with explicit warnings
- **Use cases**: 
  - **Security compliance** (GDPR, data retention policies)
  - **Incident response** (emergency data purging)
  - **Clean testing environments** (removing all test data)
  - **System maintenance** (periodic data cleanup)

## API Endpoints Added

### DELETE /api/rasa/chat
- **Purpose**: Clear all chat messages for a user
- **Parameters**: `user_id` (query parameter)
- **Returns**: Success message with count of deleted messages

### DELETE /api/rasa/highlight
- **Purpose**: Clear all highlights for a user
- **Parameters**: `user_id` (query parameter)
- **Returns**: Success message with count of deleted highlights

### DELETE /api/rasa/chat/all
- **Purpose**: Clear both messages AND highlights for a user (complete reset)
- **Parameters**: `user_id` (query parameter)
- **Returns**: Success message with counts of deleted messages and highlights
- **Features**: Uses database transaction for data integrity

### DELETE /api/rasa/database/clear
- **Purpose**: **SECURITY ENDPOINT** - Clear ALL data from the entire database
- **Parameters**: 
  - `confirmationCode`: Must be `CLEAR_SECURITY_DATABASE_CONFIRMED`
  - `clearType`: `"all"`, `"messages"`, `"highlights"`, or `"security"`
- **Returns**: Success message with detailed clearing results and timestamp
- **Security features**:
  - Requires exact confirmation code
  - Uses database transactions
  - Logs all security actions
  - Returns detailed audit information

### GET /api/rasa/database/status
- **Purpose**: Get database statistics for security monitoring
- **Parameters**: None
- **Returns**: Statistics including total messages, highlights, and unique users
- **Use case**: Security auditing and system monitoring

## Usage Scenarios

### For Testing
1. **Quick Restart**: Use 🔄 Restart button to quickly test conversation flows without affecting stored data
2. **Full Reset**: Use 🗑️ Clear All button to completely reset for fresh demo

### For Demos
1. **Demo Reset**: Use Clear My Data before starting a demo to ensure clean slate
2. **Multiple Scenarios**: Use Restart between different demo scenarios
3. **Full Environment Reset**: Use Clear Database for completely clean demo environment

### For Cybersecurity Compliance
1. **Data Retention Compliance**: Use Clear Database to meet data retention policy requirements
2. **GDPR Right to be Forgotten**: Use Clear My Data for individual user data removal
3. **Incident Response**: Use Clear Database during security incidents to purge sensitive data
4. **Audit Preparation**: Use Database Status endpoint to generate compliance reports
5. **Penetration Testing**: Use Clear Database to ensure clean testing environments

## UI Features
- **Visual Hierarchy**: Three distinct buttons with clear visual differentiation
- **Color Coding**: Database clear button is red to indicate danger
- **Loading States**: Buttons show "Clearing..." or are disabled during operations
- **Error Handling**: Shows alerts if clearing fails
- **Multi-level Confirmations**: Database clear has 3-step confirmation process
- **Tooltips**: Hover over buttons to see what each one does
- **Success Feedback**: Detailed success messages with statistics

## Security Features
- **User-specific clearing**: Personal data buttons only affect current user
- **Database-wide clearing**: Separate endpoint for system-wide data purging
- **Multi-step authentication**: Database clearing requires confirmation code
- **Transaction Safety**: All database operations use transactions to prevent partial failures
- **Audit Logging**: All security actions are logged with timestamps
- **Error Recovery**: Graceful error handling with detailed error messages
- **Access Control**: Database clearing requires specific confirmation code
- **Visual Warnings**: Red button color and warning emojis for dangerous operations
