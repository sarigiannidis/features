#!/bin/sh

set -e

. dev-container-features-test-lib

# Test Angular CLI installation
check "angular cli is installed" which ng
check "angular cli version" ng --version
check "angular cli version contains Angular CLI" sh -c 'ng --version | grep "Angular CLI"'

# Test Angular CLI help command
check "angular cli help works" sh -c 'ng help | grep "Available Commands"'

# Test Angular CLI can list available commands
check "angular cli can list commands" sh -c 'ng help | grep -E "(new|build|serve|test)"'

# Test that ng new command is available (without actually creating a project)
check "angular cli new command available" sh -c 'ng help new | grep "Creates a new workspace"'

# Test that basic Angular CLI functionality works
check "angular cli version output format" sh -c 'ng --version | grep -E "@angular/cli.*[0-9]+\.[0-9]+\.[0-9]+"'

# Report result
reportResults