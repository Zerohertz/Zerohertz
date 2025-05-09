END_DATE="2026-02-27"
CURRENT_DATE=$(TZ=Asia/Seoul date +%Y-%m-%d)

if [[ "$OSTYPE" == "darwin"* ]]; then
	DAYS_LEFT=$((($(date -j -f "%Y-%m-%d" "$END_DATE" +%s) - $(date -j -f "%Y-%m-%d" "$CURRENT_DATE" +%s)) / 86400))
else
	DAYS_LEFT=$((($(date -d "$END_DATE" +%s) - $(date -d "$CURRENT_DATE" +%s)) / 86400))
fi

CURRENT_DDAY=$(grep -o '"message": "D-[0-9]*"' data/jmy.json | grep -o '[0-9]*')

echo "Current D-day: D-$CURRENT_DDAY"
echo "Calculated D-day: D-$DAYS_LEFT (KST 기준)"

if [ "$DAYS_LEFT" != "$CURRENT_DDAY" ]; then
	echo "Updating D-day from $CURRENT_DDAY to $DAYS_LEFT"
	sed -i "s/\"message\": \"D-[0-9]*\"/\"message\": \"D-$DAYS_LEFT\"/" data/jmy.json
	git config --local user.email "github-actions[bot]@users.noreply.github.com"
	git config --local user.name "github-actions[bot]"
	git add data/jmy.json
	git commit -m ":sparkles: update: d-day counter"
	git push
else
	echo "D-day is already up-to-date"
fi
