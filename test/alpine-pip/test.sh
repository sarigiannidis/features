#!/bin/sh

set -e

. dev-container-features-test-lib

# Test pip installation and basic functionality
check "pip3 is installed" which pip3
check "pip3 version" pip3 --version
check "pip3 version contains pip" sh -c 'pip3 --version | grep "pip"'

# Test pip help command
check "pip3 help works" sh -c 'pip3 --help | grep "Usage:"'

# Test pip list command (should work even with no packages)
check "pip3 list works" pip3 list

# Test pip show for a basic package (pip itself)
check "pip3 show pip works" sh -c 'pip3 show pip | grep "Name: pip"'

# Test that pip can handle install command syntax (dry run)
check "pip3 install syntax check" sh -c 'pip3 install --help | grep "Install packages"'

# Check if pip is also available (some systems link pip3 to pip)
if command -v pip > /dev/null 2>&1; then
    check "pip version" pip --version
    check "pip version contains pip" sh -c 'pip --version | grep "pip"'
fi

# Report result
reportResults