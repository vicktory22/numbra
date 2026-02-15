#!/bin/bash
cd "$(dirname "$0")" || exit 1

echo "Running tests..."
echo ""

lua test_highlights.lua
result1=$?

lua test_colors.lua
result2=$?

echo ""
if [ $result1 -eq 0 ] && [ $result2 -eq 0 ]; then
  echo "All tests passed!"
  exit 0
else
  echo "Some tests failed!"
  exit 1
fi