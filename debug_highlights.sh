echo "=== Highlight Diagnostic ==="
echo "1. Testing backend health:"
curl -s http://localhost:3001/health || echo "Backend not running"

echo -e "\n2. Testing Rasa status:"
curl -s http://localhost:5005/status || echo "Rasa not running"

echo -e "\n3. Testing actions server:"
curl -s http://localhost:5055/health || echo "Actions server not running"

echo -e "\n4. Testing highlight functionality:"
curl -s -X POST http://localhost:5005/webhooks/rest/webhook -H "Content-Type: application/json" -d "{\"sender\": \"test\", \"message\": \"scan apache\"}" --max-time 10 | grep highlight || echo "No highlights generated"

echo -e "\n5. Checking environment:"
echo "OPENAI_API_KEY present: $([ ! -z "$OPENAI_API_KEY" ] && echo "YES" || echo "NO")"
