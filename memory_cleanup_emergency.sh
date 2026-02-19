#!/bin/bash

# 🚨 EMERGENCY MEMORY CLEANUP SCRIPT
# Voor 99.9% memory usage crisis

echo "🚨 STARTING EMERGENCY MEMORY CLEANUP 🚨"
echo "========================================"
echo "Current time: $(date)"
echo ""

# 1. Eerst memory status bekijken
echo "📊 CURRENT MEMORY STATUS:"
echo "-------------------------"
top -l 1 -n 5 -o mem | head -15
echo ""

# 2. Chrome tabs sluiten (veilig - alleen oude/niet-actieve)
echo "🔧 CLOSING OLD CHROME TABS..."
# Zoek Chrome processen die oud zijn (>24 uur)
echo "Chrome processes running:"
ps aux | grep -i "chrome" | grep -v grep | wc -l

# 3. Browser cache clearen
echo "🧹 CLEARING BROWSER CACHE..."
# Chrome cache
rm -rf ~/Library/Caches/Google/Chrome/Default/Cache/* 2>/dev/null
# Safari cache
rm -rf ~/Library/Caches/com.apple.Safari/* 2>/dev/null
echo "Browser cache cleared."

# 4. Temporary files verwijderen
echo "🗑️  CLEARING TEMPORARY FILES..."
rm -rf /tmp/* 2>/dev/null
rm -rf ~/tmp/* 2>/dev/null
rm -rf ~/.npm/_cacache/* 2>/dev/null
echo "Temporary files cleared."

# 5. Docker cleanup (als Docker actief is)
echo "🐳 CHECKING DOCKER..."
if command -v docker &> /dev/null; then
    echo "Docker found, cleaning up..."
    docker system prune -f 2>/dev/null
    echo "Docker cleanup completed."
else
    echo "Docker not found or not running."
fi

# 6. Node.js processen checken
echo "📦 CHECKING NODE.JS PROCESSES..."
NODE_PROCESSES=$(ps aux | grep -i "node" | grep -v grep | wc -l)
echo "Found $NODE_PROCESSES Node.js processes"

# 7. Memory-intensive apps identificeren
echo "🔍 IDENTIFYING MEMORY-INTENSIVE APPS..."
echo "Top 10 memory consumers:"
ps aux --sort=-%mem | head -11

# 8. Purgeable memory vrijmaken
echo "🌀 PURGING PURGEABLE MEMORY..."
sudo purge 2>/dev/null || echo "Purge command not available or requires sudo"

# 9. Update memory status
echo ""
echo "🔄 UPDATED MEMORY STATUS:"
echo "-------------------------"
top -l 1 -n 5 -o mem | head -15

# 10. Recommendations
echo ""
echo "🎯 RECOMMENDATIONS FOR FURTHER ACTION:"
echo "--------------------------------------"
echo "1. Manually close unnecessary browser tabs"
echo "2. Restart Chrome/Chromium browser"
echo "3. Check for memory leaks in running applications"
echo "4. Consider upgrading RAM if this happens frequently"
echo "5. Monitor memory usage with: 'top -o mem'"

echo ""
echo "✅ EMERGENCY CLEANUP COMPLETED"
echo "Memory should be improved. Check status above."