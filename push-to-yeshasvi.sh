#!/bin/bash
# Script to merge and push all changes to yeshasvi-postgres branch

set -e  # Exit on error

echo "============================================================"
echo "Merging and Pushing to yeshasvi-postgres branch"
echo "============================================================"
echo ""

# Make sure we're on the right branch
echo "✓ Confirming branch..."
git branch --show-current

# Configure git to use merge strategy
echo "✓ Configuring merge strategy..."
git config pull.rebase false

# Pull and merge remote changes
echo "✓ Pulling remote changes (you may need to enter passphrase)..."
git pull origin yeshasvi-postgres

# Check if merge was successful
if [ $? -eq 0 ]; then
    echo "✓ Merge successful!"
else
    echo "❌ Merge failed. Please resolve conflicts manually."
    exit 1
fi

# Push to remote
echo "✓ Pushing to yeshasvi-postgres (you may need to enter passphrase again)..."
git push origin yeshasvi-postgres

if [ $? -eq 0 ]; then
    echo ""
    echo "============================================================"
    echo "✅ SUCCESS! All changes pushed to yeshasvi-postgres"
    echo "============================================================"
    echo ""
    echo "Your colleagues can now pull from yeshasvi-postgres branch"
else
    echo "❌ Push failed. Check the error message above."
    exit 1
fi

