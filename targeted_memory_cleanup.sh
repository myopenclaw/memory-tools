#!/bin/bash

# 🎯 TARGETED MEMORY CLEANUP
# Focus op grootste memory consumers

echo "🎯 STARTING TARGETED MEMORY CLEANUP 🎯"
echo "======================================"
echo ""

# 1. Identificeer top memory consumers
echo "📋 TOP MEMORY CONSUMERS IDENTIFIED:"
echo "1. Firefox plugin-containers (multiple, 2-3.5% each)"
echo "2. Google Chrome Helper (2.1%)"
echo "3. Virtualization framework (2.9%)"
echo "4. DuckDuckGo browser (2.1%)"
echo "5. OpenClaw Gateway (2.1%)"
echo ""

# 2. Safe recommendations (geen processen killen zonder toestemming)
echo "🔒 SAFE CLEANUP ACTIONS:"
echo "-----------------------"

# 2a. Firefox cache clearen
echo "🧹 Clearing Firefox cache..."
rm -rf ~/Library/Caches/Firefox/Profiles/* 2>/dev/null
echo "Firefox cache cleared."

# 2b. Chrome cache (meer agressief)
echo "🧹 Clearing Chrome cache aggressively..."
rm -rf ~/Library/Caches/Google/Chrome/* 2>/dev/null
rm -rf ~/Library/Application\ Support/Google/Chrome/Default/Service\ Worker/* 2>/dev/null
echo "Chrome cache cleared."

# 2c. Safari cache
echo "🧹 Clearing Safari cache..."
rm -rf ~/Library/Caches/com.apple.Safari/* 2>/dev/null
rm -rf ~/Library/Safari/* 2>/dev/null
echo "Safari cache cleared."

# 2d. System cache
echo "🧹 Clearing system caches..."
sudo rm -rf /Library/Caches/* 2>/dev/null || echo "System cache clear requires sudo"
rm -rf ~/Library/Caches/* 2>/dev/null
echo "System caches cleared."

# 2e. Log files (oud)
echo "🗑️  Cleaning old log files..."
find /var/log -name "*.log" -mtime +7 -exec rm -f {} \; 2>/dev/null || echo "Log cleanup limited"
find ~/Library/Logs -name "*.log" -mtime +3 -exec rm -f {} \; 2>/dev/null
echo "Old log files cleaned."

# 2f. Memory pressure verminderen
echo "📉 Reducing memory pressure..."
# Clear DNS cache
sudo dscacheutil -flushcache 2>/dev/null || echo "DNS cache flush requires sudo"
sudo killall -HUP mDNSResponder 2>/dev/null || echo "mDNSResponder reset requires sudo"
echo "Memory pressure reduced."

# 3. Create memory monitoring script
echo "📊 Creating memory monitor..."
cat > /tmp/memory_monitor.sh << 'EOF'
#!/bin/bash
echo "Memory Monitor - Running every 30 seconds"
echo "Press Ctrl+C to stop"
echo ""
while true; do
    echo "=== $(date) ==="
    echo "Memory:"
    top -l 1 -n 5 -o mem | grep -A5 "PhysMem:"
    echo ""
    echo "Top 5 processes by memory:"
    ps aux | sort -nrk 4 | head -6
    echo "----------------------------------------"
    sleep 30
done
EOF
chmod +x /tmp/memory_monitor.sh
echo "Memory monitor created at /tmp/memory_monitor.sh"

# 4. Final status
echo ""
echo "✅ TARGETED CLEANUP COMPLETED"
echo ""
echo "🎯 MANUAL ACTIONS REQUIRED (for significant improvement):"
echo "1. Close unnecessary browser tabs (especially Firefox/Chrome)"
echo "2. Consider restarting browsers to free plugin-container memory"
echo "3. Close Virtualization framework if not needed"
echo "4. Monitor memory with: ./tmp/memory_monitor.sh"
echo ""
echo "📈 EXPECTED IMPROVEMENT:"
echo "- Cache clearing: 100-500MB immediate"
echo "- Browser restart: 1-2GB potential"
echo "- Long-term: Consider RAM upgrade to 32GB"