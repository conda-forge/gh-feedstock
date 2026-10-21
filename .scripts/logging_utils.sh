#!/bin/bash

# Provide a unified interface for the different logging
# utilities CI providers offer. If unavailable, provide
# a compatible fallback (e.g. bare `echo xxxxxx`).

function startgroup {
    # Start a foldable group of log lines
    # Pass a single argument, quoted
    case ${CI:-} in
        azure )
            echo "##[group]$1";;
        github_actions )
            echo "::group::$1";;
        * )
            echo "$1";;
    esac
} 2> /dev/null

function endgroup {
    # End a foldable group of log lines
    # Pass a single argument, quoted

    case ${CI:-} in
        azure )
            echo "##[endgroup]";;
        github_actions )
            echo "::endgroup::";;
    esac
} 2> /dev/null
